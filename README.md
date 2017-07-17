# Redock

Convert an [Apollo](https://github.com/j2made/apollo) project to a standard WordPress project quickly and easily.

Works with [Apollo v0.6.0](https://github.com/j2made/apollo/tree/0.6.0) and up.

## Usage

This bash script can be ran inside of any Apollo directory. Just run `bash redock.sh`, and you're off to the races.

Redock creates a new folder at the same level as the base Apollo directory. It copies the name of the base directory and appends a suffix (default is `_wp`, see flags below)

## Issues

File away: https://github.com/j2made/redock/issues

### Flags
`-s` suffix: string to append to the end of the new project directory name. Defaults to `_wp`.