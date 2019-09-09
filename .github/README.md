### Mirror repo

This action allows to mirror your github repository easily.

### Usage

At first create file `.git/workflows/workflow.yml` with following content:
```yaml
name: Mirror repository

on: [push]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Mirror
        uses: syzygypl/mirror-action@master
```
 
