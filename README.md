# Lucifer Disciple's Shell Scripts

* [flac2mp3](#flac2mp3): Transcode .flac files into .mp3. Keep tags.
* [gitignore](#gitignore): Get .gitignore for a language/framework from github/gitignore.
* [logcmd](#logcmd): Execute shell command. Save transcript.
* [overlaysubs](#overlaysubs): Add subtitles onto the video stream.

## flac2mp3

```
$ flac2mp3 -h
usage: flac2mp3 [-h] [-V] FLAC [FLAC...]

Transcode flac FILEs into mp3 files while preserving the tags. Audio in the
output files will have the average bitrate of 190kb/s.

positional arguments:
  FLAC          path to an audio file in flac format

optional arguments:
  -h, --help     show this help and exit
  -V, --version  output version information and exit
$
```

## gitignore

```
$ gitignore -h
usage: gitignore [-h] [--list] [-V] LANG

Put a .gitignore file in the current working directory for a specific
language or runtime environment, obtained from
https://github.com/github/gitignore.git

positional arguments:
  LANG         language or framework name that you want to get a
               .gitignore for

optional arguments:
  -h, --help     show this help message and exit
  --list        print valid values for LANG argument and exit
  -V, --version  output version information and exit
$
```

## logcmd

```
$ logcmd -h
usage: logcmd [-h] [-V] COMMAND LOGFILE

Execute a COMMAND and save output to a LOGFILE.  Prompt and executed command are
also recorded in the LOGFILE.

positional arguments:
  COMMAND       shell command, whose output will be captured
  LOGFILE       path to the file, where shell session will be
                appended to

optional arguments:
  -h, --help     display this help and exit
  -V, --version  output version information and exit
$
```

## overlaysubs

```
$ overlaysubs -h
usage: overlaysubs [-h] [-V] INPUT_FILE SUBS_FILE OUTPUT_FILE

Add rendered subtitles directly onto the video stream of a video file.

positional arguments:
  INPUT_FILE    source video file
  SUBS_FILE     file with subtitles for source video file
  OUTPUT_FILE   name of a file, where the result will be written to

optional arguments:
  -h, --help     show this help and exit
  -V, --version  output version information and exit
$
```
