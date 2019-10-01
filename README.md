### Mirror repo

This action allows to mirror your github repository easily.

### Usage

To use that plugin you have to:
* setup ssh access to your origin and mirror repo
* configure this action for every push to origin repo

#### Notes

* After initial action setup it will probably will take from 5 to 10 minutes for GitHub to recognize the action. During this in your action you will see block with yellow circle and text `(Unnamed workflow)` in project Actions sections  
* In `Settings -> Actions` **Enable local & third party Actions for this repository** should be enabled to allow execution of this action 

#### Ssh key setup
 
This block provides description how to setup ssh access for repos. If you already have such access or you are experienced user and know how to setup them by yourself skip this section :)
To use this plugin you have to generate (or use existing) **2** ssh key pairs - one for your origin repo and one for mirror, and properly configure them. 
 
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
* Add your private key to secrets (which are located under `Repo -> Settings -> Secrets`) with name `ORIGIN_SSH_KEY` (example)
* Generate new ssh key for mirror
* Configure public ssh key in your mirror (every provider is different)
* Add your private ssh key to secrets (which are located under `Repo -> Settings -> Secrets`) with name `MIRROR_SSH_KEY` (example)

### Github action config

To set up this action you have to create file `.github/workflows/workflow.yml` with content beneath. And that's it - repository mirroring is set up completely

```yaml
name: Mirror repository

# indicates that action will be started every push
on: [push] 

jobs:
  build:
    # indicates that action will be executed in ubuntu container
    runs-on: ubuntu-latest
    # configures steps that should be done on every execution 
    steps: 
        # random name you want
      - name: Mirror 
        # this indicates that this mirror action should be used
        uses: syzygypl/mirror-action@master 
        # pass job parameters
        with:
          # private ssh key of origin repo should taken from privates (see ssh key setup step)
          originSshKey: ${{ secrets.MIRROR_SSH_KEY }}
          # private ssh key of mirror repo should taken from privates (see ssh key setup step)
          mirrorSshKey: ${{ secrets.ORIGIN_SSH_KEY }}
          # mirror repo git url with pattern (ssh://)?(user@)?(domain)(:port)?(/|:)?(path).git 
          mirrorRepoUrl: 'git@github.com:syzygypl/mirror-action-mirror.git'
```

Same without descriptions:

```yaml
name: Mirror repository

on: [push] 

jobs:
  build:
    runs-on: ubuntu-latest
    steps: 
      - name: Mirror 
        uses: syzygypl/mirror-action@master 
        with:
          originSshKey: ${{ secrets.MIRROR_SSH_KEY }}
          mirrorSshKey: ${{ secrets.ORIGIN_SSH_KEY }}
          mirrorRepoUrl: 'git@github.com:syzygypl/mirror-action-mirror.git'
```
