function Invoke-Sign
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string] $SigningAppRegistrationId,
        [Parameter(Mandatory=$true)]
        [string] $SigningAppRegistrationSecretKey,
        [Parameter(Mandatory=$true)]
        [string] $SigningAppRegistrationTenantId,
        [Parameter(Mandatory=$true)]
        [string] $FilesToSignPath
    )

    dotnet tool install --global azuresigntool

    Write-Host "Parsing file list at: $FilesToSignPath"
    If (!(Test-Path $FilesToSignPath)) {
        Throw "$FilesToSignPath not found"
    }

    If ((Get-Item $FilesToSignPath | select -ExpandProperty length) -eq 0) {
        Write-Verbose "No files to sign, skipping"
        break
    }

    $timestampServers = @("http://timestamp.digicert.com", "http://timestamp.sectigo.com", "http://tsa.starfieldtech.com")
    foreach ($server in $timestampServers)
    {
        & AzureSignTool sign -d 'Relativity' -du "http://www.relativity.com" -kvu "https://build-tools-shared-kv.vault.azure.net" -kvi "$SigningAppRegistrationId" -kvs "$SigningAppRegistrationSecretKey" -kvt "$SigningAppRegistrationTenantId" -kvc "RelativityCodeSigningCertificate" -ifl $FilesToSignPath -tr $server -mdop 3 -v
        if (!$?)
        {
            Write-Host "$server failed to time stamp."
            continue
        }
        Write-Host "Signing with $server was successful."
        break
    }

}