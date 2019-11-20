#!/bin/sh

# This script will convert all *.html files in ./issues from
# a WINDOWS-1252 encoding to a UTF-8 encoding. The iconv args
# appear to be backwards, but this is the correct order given:
#   - The files are interpreted as UTF-8 by the OS
#   - The files are written as UTF-8 by the OS

# @var holds the string identifying a path to a temporary directory
tmpdir=
echo '' > convert.log
echo '' > .iconv.stderr
echo '' > .tidy.stderr

# Take care of any necessary cleanup tasks
cleanup () {
  if [ -n "$tmpdir" ] ; then
    rm -rf "$tmpdir";
  fi

  if [ -n "$1" ] ; then
    kill -$1 $$;
  fi
}

# Handle signals
tmpdir=$(mktemp -d)
trap 'cleanup' EXIT
trap 'cleanup HUP' HUP
trap 'cleanup TERM' TERM
trap 'cleanup INT' INT

# Make named pipe containing original file paths
echo "Finding files to convert..." >> convert.log
mkfifo -m 600 "$tmpdir/findOriginals"
find . -path "./issues*" -name "*.html" -type f -print > "$tmpdir/findOriginals" &

# Iterate through original file paths, converting to WINDOWS-1252 and tidying them
echo "Converting files.." >> convert.log
while IFS= read -r line; do
  # All file paths must have exactly 3 '.' characters
  new="$line.new"
  echo "Fixing: $line -> $new" >> convert.log
  iconv -f UTF-8 -t WINDOWS-1252 "$line" 2>>.iconv.stderr | \
    tidy --output-xhtml true - 2>>.tidy.stderr > "$new"
done < "$tmpdir/findOriginals"

# Make named pipe containing newly converted file paths
echo "Finding new files..." >> convert.log
mkfifo -m 600 "$tmpdir/findNew"
find . -path "./issues*" -name "*.html.new" -type f -print > "$tmpdir/findNew" &

# Iterate through new file paths and move them to their original filename
echo "Moving new files to original locations..." >> convert.log
while IFS= read -r line; do
  # All file paths must have exactly 3 '.' characters
  old="$(cut -d '.' -f 2,3)"
  echo "Moving $line -> .$old" >> convert.log
  mv "$line" ".$old"
done < "$tmpdir/findNew"
