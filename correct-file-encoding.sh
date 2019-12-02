#!/bin/sh

# This script will convert all *.html files in ./issues from
# a WINDOWS-1252 encoding to a UTF-8 encoding. The iconv args
# appear to be backwards, but this is the correct order given:
#   - The files are interpreted as UTF-8 by the OS
#   - The files are written as UTF-8 by the OS

# @var holds the string identifying a path to a temporary directory
tmpdir=
echo '' > convert.log

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
echo "$(gdate +"%Y.%m.%d.:%T:%N"):[INFO]:Finding *.html files to convert..." > "$tmpdir/_log" &
mkfifo -m 600 "$tmpdir/_files"
mkfifo -m 600 "$tmpdir/_inFlight"
mkfifo -m 600 "$tmpdir/_log"
find . -path "./issues*" -name "*.html" -type f -print > "$tmpdir/_files" &

# Iterate through original file paths, converting to WINDOWS-1252 and tidying them
echo "$(gdate +"%Y.%m.%d.:%T:%N"):[INFO]:Converting *.html files.." > "$tmpdir/_log" &
while IFS= read -r line; do
  _iconv="$line.iconv"
  _tidy="$line.tidy"
  #echo "$(gdate +"%Y.%m.%d.:%T:%N"):[FIX]:$line" >> convert.log
  echo "$(gdate +"%Y.%m.%d.:%T:%N"):[ICONV]:$line" > "$tmpdir/_log" &
  iconv -f UTF-8 -t WINDOWS-1252 "$line" 2>"$tmpdir/_log" > "$tmpdir/_inFlight" &
  echo "$(gdate +"%Y.%m.%d.:%T:%N"):[TIDY]:$line" > "$tmpdir/_log" &
  tidy --quiet --show-warnings true --show-errors true --output-xhtml true "$tmpdir/_inFlight" 2>"$tmpdir/_log" > "$_tidy" &
  echo "\n" > "$tmpdir/_log" &
done < "$tmpdir/_files"

# Reload $files with those ending in '.html.new'
echo "$(gdate +"%Y.%m.%d.:%T:%N"):[INFO]:Finding *.tidy files..." > "$tmpdir/_log" &
find . -path "./issues*" -name "*.html.tidy" -type f -print > "$tmpdir/_files" &

# Iterate through *.tidy file paths and move them to their original filename
echo "$(gdate +"%Y.%m.%d.:%T:%N"):[INFO]:Moving *.tidy files to original locations..." > "$tmpdir/_log" &
while IFS= read -r line; do
  # All file paths must end with '.tidy'
  old="${line%.tidy}"
  echo "$(gdate +"%Y.%m.%d.:%T:%N"):[COPY]:$line \n    -> $old" > "$tmpdir/_log" &

  #mv "$line" ".$old"
done < "$tmpdir/_files"

echo "$(gdate +"%Y.%m.%d.:%T:%N"):[INFO]:Removing *.iconv files..." > "$tmpdir/_log" &
find . -path "./issues*" -name "*.html.iconv" -type f -delete

echo "$(gdate +"%Y.%m.%d.:%T:%N"):[INFO]:Removing *.tidy files..." > "$tmpdir/_log" &
find . -path "./issues*" -name "*.html.tidy" -type f -delete
