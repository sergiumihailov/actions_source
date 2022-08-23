# Azure Container Registry Build Action
THis GitHub action will create Docker image and push it to ACR 

## Action Inputs
| Input | Description | Required | Default |
|-------|-------------|----------| ------- |
| app_source_directory | Path to dir with Dockerfile | :heavy_check_mark: | |
| registry_login_server | ACR URL. Ex: acrname.azurecr.io| :heavy_check_mark: | |
| registry_username | Azure App ID| :heavy_check_mark: | |
| registry_password | Azure App Secret| :heavy_check_mark: | `./Dockerfile` |
| Platform | The platform where build/task is run, Eg, 'windows' and 'linux'. When it's used in build commands, it also can be specified in 'os/arch/variant' format for the resulting image. Eg, linux/arm/v7. The 'arch' and 'variant' parts are optional. | | `linux` |
| Build Args | JSON specifying key=value pairs as as Docker build arguments | | |
| Secret Build Args | Secrets in JSON specifying key=value pairs as as Docker build arguments | | |
| Service Principal Client ID | A service principal client ID with permission to use ACR build | :heavy_check_mark: | |
| Service Principal Client Secret | A service principal client secret with permission to use ACR build | :heavy_check_mark: | |

# An example of how to use this action in workflow
1. Create directory where you are planning to store Dockerfile and other image related files 
2. Add Docker related files to new directory (in example: "./composite002/docker_manifest")
3. Add new step to your workflow:

```yaml
name: Linux_Container_Workflow
on:
  push:
    branches:
    - 'DEVOPS_*'

jobs:
  build-and-push:
    runs-on: ubuntu-latest
    outputs:
      image_tag:  ${{ steps.image_tag.outputs.image_tag_output }}
    steps:
    # ACTION: Checkout repo
    - name: 'Checkout GitHub Action'
      uses: actions/checkout@v3
    # ACTION: Build Docker Image
    - name: 'Build Docker Image'
      uses: sergiumihailov/actions_source/a_composite002@v2.0.5
      with:
        # INPUTS:           
        app_source_directory: ./composite002/docker_manifest             # Dockerfile location
        app_image_tag: '1.0.1'                                           # Image tag
        app_image_name: 'testimage'                                      # Image name
        registry_repository: 'sampleapp'                                 # ACR reposiroty (Image directory)
        registry_login_server: ${{ secrets.REGISTRY_LOGIN_SERVER }}      # ACR URL. Ex: acrname.azurecr.io
        registry_username: ${{ secrets.REGISTRY_USERNAME }}              # Azure App ID
        registry_password: ${{ secrets.REGISTRY_PASSWORD }}              # Azure App Secret
```
# Required input and output arguments
# Optional input and output arguments
# Secrets the action uses
Add these secrtes to Settings -> Security -> Action -> Repository secrets

    ${{ secrets.REGISTRY_LOGIN_SERVER }} - ACR URl Ex: acrname.azurecr.io
    ${{ secrets.REGISTRY_USERNAME }} - Azure App ID
    ${{ secrets.REGISTRY_PASSWORD }} - Azure App Secret 

