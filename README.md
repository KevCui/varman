varman
======

Varman is a script to generate global variables (in json file) used by [postman](https://www.getpostman.com/) or [newman](https://github.com/postmanlab://github.com/postmanlabs/newman) from yaml file.

## How to use?

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

## Where can I get yaml file?

### 1. Write yaml file from scratch

:pencil:

### 2. Generate yaml file from existing postman collection

```
cat <collection.json> | grep -oh "{{\w*}}" | sort | uniq | sed -e 's/{{//;s/}}/: ""/'g > <output>.yaml
```

### 3. Generate yaml file from existing postman global/environment json

```
cat <environment>.json | jq -r '.values[] | "\(.key): \"\(.value)\""' > <output>.yaml
```
