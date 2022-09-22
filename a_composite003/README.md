# Sign GitHub Action

## Overview

This GitHub action signs one or more files using the Relativity certificate.

## Inputs

1. `SigningAppRegistrationId`: Registration ID of the service principal used to sign the app. It must have access to the build-tools-shared-kv keyvault (Get and List Certificate management operations, and Verify and Sign Cryptographic Operations)
2. `SigningAppRegistrationSecretKey`: Secret key of the service principal
3. `SigningAppRegistrationTenantId`: ID of the Azure AD tenant that contains the service principal
4. `FilesToSignPath`: Path to a txt file containing a list of files to sign. Each line of this file should be a path relative to the root of the repo. The file types must be supported by AzureSignTool. If this is omitted, the action will sign all DLL, MSI and EXE files in Artifacts.

## GitHub Workflow Example

The following workflow example logs into Azure, retrieves the signing app info from a keyvault and then signs the files listed in filelist.txt, which exists at the root of the repo. Filelist.txt contains a path to a file to sign on each line:

.\files\example.exe
.\files\example.dll
.\files\example.msi

```yaml
name: Sign Action
on:
  push:
    branches:
      - '*'
jobs:
  sign:
    name: sign
    runs-on: windows-latest
    steps:
    - name: Checkout
      uses: actions/checkout@v2
    - name: Login to Azure
      uses: Azure/login@v1
      with:
        creds: ${{ secrets.my_service_principal }}
    - name: Get file signing certificate secrets from key vault
        uses: Azure/get-keyvault-secrets@v1
        id: kv
        with:
            keyvault: 'mykeyvault'
            secrets: SigningAppRegistrationId, SigningAppRegistrationSecretKey, SigningAppRegistrationTenantId
    - name: 'sign files'
      uses: relativityone/build-extension/sign@main
      with:
        SigningAppRegistrationId: ${{ steps.kv.outputs.SigningAppRegistrationId }}
        SigningAppRegistrationSecretKey: ${{ steps.kv.outputs.SigningAppRegistrationSecretKey }}
        SigningAppRegistrationTenantId: ${{ steps.kv.outputs.SigningAppRegistrationTenantId }}
        FilesToSignPath: 'filelist.txt'
```

## Maintainers

This task is maintained by the [Engineering Systems](mailto:help-esys@relativity.com) team. Please submit a ticket if you have questions, issues, or suggestions with this task.