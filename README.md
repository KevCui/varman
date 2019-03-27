varman
======

Varman is a script to generate global variables used by [postman](https://www.getpostman.com/) or [newman](https://github.com/postmanlabs/newman) from yaml file. Using YAML format to maintain global variables is easier and human-friendly. Sometimes, it gives you confidence to quickly change variables before execution without messing up json format. :wink:

## How to use?

### Usage

```
Usage:
  ./varman.sh -i <input.yaml> -o <output.json>

Options
  -i:            Input yaml file
  -o:            Output json file
  -h --help:     Display this help message
```

### Example

Generate `test.json` from `input.yaml`:

```
~$ ./varman.sh -i test/input.yaml -o test.json
```

Use generated `test.json` in newman execution:

```
~$ newman run <collection.json> -g test.json --export-globals test.json
```

## How can I initialize yaml file?

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
