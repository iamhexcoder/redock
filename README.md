# Redock

Convert an Apollo project to a standard WordPress project quickly and easily

## Usage
This bash script can be ran inside of any Apollo directory. Just run `bash redock.sh`, and you're off to the races.

Redock creates a new folder at the same level as the base Apollo directory. It copies the name of the base directory and appends a suffix (default is `_wp`, see flags below)

## Issues

### Flags
`-s` suffix: string to append to the end of the new project directory name. Defaults to `_wp`.