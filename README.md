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

#### Ssh key setup
 
To use this plugin you have to generate **2** ssh key pairs - one for your origin repo and one for mirror, and properly configure them.
 
You can generate new ssh key with command 
```bash
bash -c 'ssh-keygen -P "" -f $(mktemp -u)'
```

It will output something like:
```
Your identification has been saved in /var/folders/xk/rgz_ykrd6rvbvq6g96dbt4w40000gn/T/tmp.jnY5kBcT.
Your public key has been saved in /var/folders/xk/rgz_ykrd6rvbvq6g96dbt4w40000gn/T/tmp.jnY5kBcT.pub.
```
And the content of new private and public keys will be available under this paths 
**Don't forget to delete private key file after configuring** 

For complete setup you have to:
* Generate new ssh key for origin
* Add your public key to deployment keys (which are located under `Repo -> Settings -> Deploy Keys`)
* Add your private key to secrets (which are located under `Repo -> Settings -> Secrets`)
* Generate new ssh key for mirror
* Configure public ssh key in your mirror (every provider is different)
* Add your private ssh key to secrets (which are located under `Repo -> Settings -> Secrets`)

