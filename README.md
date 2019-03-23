varman
======

Varman is a script to generate global variables (in json file) used by [postman](https://www.getpostman.com/) or [newman](https://github.com/postmanlab://github.com/postmanlabs/newman) from yaml file.

## How to use

### Usage

```
Usage:
  ./varman.sh -i <input.yaml> -o <output.json>

Options
  -i:            Input json file
  -o:            Output json file
  -h --help:     Display this help message
```

### Example

Generate `test.json` from `input.yaml`:

```
~$ ./varman.sh -i test/input.yaml -o test.json
```
