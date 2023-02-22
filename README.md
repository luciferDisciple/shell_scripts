# Lucifer Disciple's Shell Scripts

* [flac2mp3](#flac2mp3): Transcode .flac files into .mp3. Keep tags.
* [gitignore](#gitignore): Get .gitignore for a language/framework from github/gitignore.
* [logcmd](#logcmd): Execute shell command. Save transcript.
* [overlaysubs](#overlaysubs): Add subtitles onto the video stream.
* [install.sh](#installsh): Install selected scripts for the user.

## Installation

Install selected scripts:
```
$ ./install.sh gitignore flac2mp3.sh
```

Install all scripts:
```
$ ./install.sh all
```

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
usage: logcmd [-h] [-V] [-q] COMMAND [COMMAND...] LOGFILE

Execute a COMMAND and save output to a file. Command prompts and commands will
be written to the LOGFILE.

positional arguments:
  COMMAND       shell command, whose output will be captured
  LOGFILE       path to the file, where shell session will be
                appended to

optional arguments:
  -h, --help     display this help and exit
  -V, --version  output version information and exit
  -q, --quiet    print nothing to stdout, write only to LOGFILE
$ logcmd 'python -V' 'date --iso-8601=seconds' transcript.txt
[root@nexus /root]$ python3.11 -V
Python 3.11.2
[root@nexus /root]$ date --iso-8601=seconds
2023-02-18T22:12:27+01:00
$ nl -n log.txt
     1	[root@nexus /root]$ python3.11 -V
     2	Python 3.11.2
     3	[root@nexus /root]$ date --iso-8601=seconds
     4	2023-02-18T22:12:27+01:00
     5	[root@nexus /root]$ 
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

## install.sh

```
$ ./install.sh -h
usage: install.sh [-h] TARGET [TARGET...]
       install.sh [-h] all

Install selected scripts or all scripts for use by the current user
only. Executables will be placed in ~/.local/bin/.

positional arguments:
  TARGET         script's name

optional arguments:
  -h, --help     show this help and exit
  -V, --version  output version information and exit
$
```
