#!/bin/sh

# This script will convert all *.html files in ./issues from
# a WINDOWS-1252 encoding to a UTF-8 encoding. The iconv args
# appear to be backwards, but this is the correct order given:
#   - The files are interpreted as UTF-8 by the OS
#   - The files are written as UTF-8 by the OS

# @var holds the string identifying a path to a temporary directory
tmpdir=
echo '' >> convert.log


# Take care of any necessary cleanup tasks
cleanup () {
  if [ -n "$tmpdir" ] ; then
    rm -rf "$tmpdir";
  fi

  if [ -n "$1" ] ; then
    kill -$1 $$;
  fi
}


# Create temporary dirs/files
tmpdir=$(mktemp -d)
cat <<EOF > "$tmpdir/tidy.config"
uppercase-tags: no
uppercase-attributes: no
clean: yes
logical-emphasis: yes
drop-empty-paras: yes
indent: yes
output-xhtml: yes
show-warnings: yes
EOF

# Handle signals
trap 'cleanup' EXIT
trap 'cleanup HUP' HUP
trap 'cleanup TERM' TERM
trap 'cleanup INT' INT

# Make named pipe containing original file paths
mkfifo -m 600 "$tmpdir/_files"

find . -path "./issues*" -name "*.html" -type f -print > "$tmpdir/_files" &
echo "$(gdate +"%Y.%m.%d.:%T:%N"):[INFO]:Finding *.html files to convert..." >> convert.log

# Iterate through original file paths, converting to WINDOWS-1252 and tidying them
echo "$(gdate +"%Y.%m.%d.:%T:%N"):[INFO]:Converting *.html files.." >> convert.log
while IFS= read -r line; do
  _sed="$line.sed"
  _iconv_cp="$line.cp"
  _iconv_utf="$line.utf"
  _tidy="$line.tidy"

  echo "$(gdate +"%Y.%m.%d.:%T:%N"):[ICONV]:$line" >> convert.log

  export LANG="C"

  cat "$line" | \
    sed 's/\xc3\x84\xc2\x81/\x5e\x48\x49\x5f/g' | \
    sed 's/\xc3\xa1\xc2\xb8\xc2\x8d/0x5e\x48\x50\x5f/g' | \
    sed 's/\xc3\xa1\xc2\xb8\xc2\xa5/0x5e\x48\x51\x5f/g' | \
    sed 's/\xc3\x84\xc2\xab/0x5e\x48\x52\x5f/g' | \
    sed 's/\xc3\x83\xc2\xb1/0x5e\x48\x53\x5f/g' | \
    sed 's/\xc3\xa1\xc2\xb9\xe2\x80\xa1/0x5e\x48\x54\x5f/g' | \
    sed 's/\xc3\xa1\xc2\xb9\xe2\x80\xba/0x5e\x48\x56\x5f/g' | \
    sed 's/\xc3\xa1\xc2\xb9\xc2\xa3/0x5e\x48\x57\x5f/g' | \
    sed 's/\xc3\x85\xe2\x80\xba/0x5e\x49\x48\x5f/g' | \
    sed 's/\xc3\xa1\xc2\xb9\xc2\xad/0x5e\x49\x49\x5f/g' | \
    sed 's/\xc3\x85\xc2\xab/0x5e\x49\x50\x5f/g' > "$_sed"


  export LANG="en_US.UTF-8"

  cat "$_sed" | \
    sed 's/â€œ/\&ldquo\;/g' | \
    sed 's/â€/\&rdquo\;/g' | \
    sed 's/â€™/\&rsquo\;/g' | \
    sed 's/?/\&quest\;/g' | \
    iconv -f UTF-8 -t WINDOWS-1252//IGNORE -- 2>> convert.log 1> "$_iconv_cp"

  iconv -f WINDOWS-1252 -t UTF-8//IGNORE "$_iconv_cp" 2>>convert.log 1> "$_iconv_utf"

  echo "$(gdate +"%Y.%m.%d.:%T:%N"):[TIDY]:$line" >> convert.log
  tidy -config "$tmpdir/tidy.config" "$_iconv_utf" 2>> convert.log 1> "$_tidy"

  cat "$_tidy" | \
    sed 's/\^01\_/ā/g' | \
    sed 's/\^02\_/ḍ/g' | \
    sed 's/\^03\_/ḥ/g' | \
    sed 's/\^04\_/ī/g' | \
    sed 's/\^05\_/ṃ/g' | \
    sed 's/\^06\_/ṇ/g' | \
    sed 's/\^08\_/ṛ/g' | \
    sed 's/\^09\_/ṣ/g' | \
    sed 's/\^10\_/ś/g' | \
    sed 's/\^11\_/ṭ/g' | \
    sed 's/\^12\_/ū/g' | \
    sed 's/\&ldquo\;/“/g' | \
    sed 's/\&rdquo\;/”/g' | \
    sed 's/\&rsquo\;/’/g' | \
    sed 's/\&quest\;/?/g' > "$line.new"

  echo "\n" >> convert.log

done < "$tmpdir/_files"
#“ ” ‘ ’

# Reload $files with those ending in '.html.new'
echo "$(gdate +"%Y.%m.%d.:%T:%N"):[INFO]:Finding *html.new files..." >> convert.log
find . -path "./issues*" -name "*.html.new" -type f -print > "$tmpdir/_files" &

# Iterate through *.new file paths and move them to their original filename
echo "$(gdate +"%Y.%m.%d.:%T:%N"):[INFO]:Moving *html.new files to original locations..." >> convert.log
while IFS= read -r line; do
  # All file paths must end with '.tidy'
  old="${line%.new}"
  echo "$(gdate +"%Y.%m.%d.:%T:%N"):[COPY]:$line \n    -> $old" >> convert.log

  #mv "$line" ".$old"
done < "$tmpdir/_files"

#echo "$(gdate +"%Y.%m.%d.:%T:%N"):[INFO]:Removing *.sed files..." >> convert.log
#find . -path "./issues*" -name "*.html.sed" -type f -delete

#echo "$(gdate +"%Y.%m.%d.:%T:%N"):[INFO]:Removing *.cp files..." >> convert.log
#find . -path "./issues*" -name "*.html.cp" -type f -delete

#echo "$(gdate +"%Y.%m.%d.:%T:%N"):[INFO]:Removing *.utf files..." >> convert.log
#find . -path "./issues*" -name "*.html.utf" -type f -delete

# TEMP: remove converted files for testing
#echo "$(gdate +"%Y.%m.%d.:%T:%N"):[INFO]:Removing *.tidy files..." >> convert.log
#find . -path "./issues*" -name "*.html.tidy" -type f -delete

# Cleanup
rm "$tmpdir/_files"
rm "$tmpdir/tidy.config"
rm -rd "$tmpdir"

exit
