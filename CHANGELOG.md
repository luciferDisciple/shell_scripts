# Changelog

## video2gif 1.1.0 - 2023-04-14

### Added
- `--framerate` option
- `--height` option

## overlaysubs 1.1.0 - 2023-02-23
- Height of the GIF was not being set to 480 pixels, as it was
  promised in the help text, instead it was the WIDTH that was
  always set to 480 pixels.

### Added
- `--start-at` and `--end-at` options: include only a part of the input video in
  the output

## logcmd 2.1.0 - 2023-02-18

### Added
- `--quiet` option: print nothing to stdout, write only to LOGFILE

## logcmd 2.0.0 - 2023-02-18

### Added
- pass multiple COMMAND arguments
