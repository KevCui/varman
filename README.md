# varman ![CI](https://github.com/KevCui/varman/workflows/CI/badge.svg)

Varman is a script to generate global variables used by [postman](https://www.getpostman.com/) or [newman](https://github.com/postmanlabs/newman) from yaml file. Using YAML format to maintain global variables is easier and human-friendly. Sometimes, it gives you confidence to quickly change variables before execution without messing up json format. :wink:

## Table of Contents

- [How to use?](#how-to-use)
  - [Usage](#usage)
  - [Example](#example)
- [How can I initialize yaml file?](#how-can-i-initialize-yaml-file)
  - [1. Write yaml file from scratch](#1-write-yaml-file-from-scratch)
  - [2. Generate yaml file from existing postman collection](#2-generate-yaml-file-from-existing-postman-collection)
  - [3. Generate yaml file from existing postman global/environment json](#3-generate-yaml-file-from-existing-postman-globalenvironment-json)
- [How to run tests](#how-to-run-tests)

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

```bash
~$ ./varman.sh -i test/input.yaml -o test.json
```

Use generated `test.json` in newman execution:

```bash
~$ newman run <collection.json> -g test.json --export-globals test.json
```

## How can I initialize yaml file?

### 1. Write yaml file from scratch

:pencil:

### 2. Generate yaml file from existing postman collection

```bash
~$ cat <collection.json> | grep -oh "{{\w*}}" | sort | uniq | sed -e 's/{{//;s/}}/: ""/'g > <output>.yaml
```

### 3. Generate yaml file from existing postman global/environment json

```bash
~$ cat <environment>.json | jq -r '.values[] | "\(.key): \"\(.value)\""' > <output>.yaml
```

## How to run tests

```bash
~$ bats test/varman.bats
```
