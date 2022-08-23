# Azure Container Registry Build Action
This GitHub action will create Docker image and push it to ACR 

# Action Inputs

| Input | Description | Required | Example |
|-------|-------------|----------| ------- |
| app_source_directory | Path to dir with Dockerfile | :heavy_check_mark: | `./composite002/docker_manifest` |
| app_image_tag | Image version | :heavy_check_mark: | `v1.0.2` |
| app_image_name | Path to dir with Dockerfile | :heavy_check_mark: | `imagename` |
| registry_repository | ACR reposiroty (image directory/folder) | :heavy_check_mark: | `sampleapp` |
| registry_login_server | ACR URL: Add to Secrets | :heavy_check_mark: | `acrname.azurecr.io` |
| registry_username | Azure App ID: Add to Secrets | :heavy_check_mark: | xxxx3e89-xxxx-46cf-xxxx-xxxxa1ddxxxx |
| registry_password | Azure App Secret: Add to Secrets | :heavy_check_mark: | `*****************` |

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
    # ACTION: Checkout repo. Tested on v3
    - name: 'Checkout GitHub Action'
      uses: actions/checkout@v3
    # ACTION: Build Docker Image and push to ACR
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
# Secrets the action uses
Add these secrtes to Settings -> Security -> Action -> Repository secrets

    ${{ secrets.REGISTRY_LOGIN_SERVER }} - ACR URl, Ex: acrname.azurecr.io
    ${{ secrets.REGISTRY_USERNAME }} - Azure App ID, Ex: xxxx3e89-xxxx-46cf-xxxx-xxxxa1ddxxxx 
    ${{ secrets.REGISTRY_PASSWORD }} - Azure App Secret, Ex: *****************

