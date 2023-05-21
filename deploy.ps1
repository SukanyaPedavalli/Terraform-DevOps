Param(
    [String]$clientId,
    [String]$clientSecret,
    [String]$subscriptionId,
    [String]$tenantId,
    [String]$workspaceFolder,
    [switch]$apply
)

Function SetEnvVariables() {
    [System.Environment]::SetEnvironmentVariable("ARM_CLIENT_ID", $clientId, "Process")
    [System.Environment]::SetEnvironmentVariable("ARM_CLIENT_SECRET", $clientSecret, "Process")
    [System.Environment]::SetEnvironmentVariable("ARM_TENANT_ID", $tenantId, "Process")
    [System.Environment]::SetEnvironmentVariable("ARM_SUBSCRIPTION_ID", $subscriptionId, "Process")
}

Function RunTerraform()
{
    $tfVarsPath = "$workspaceFolder/tfvars/aks.auto.tfvars"
    $sshPublicKey = Get-Content "$env:USERPROFILE\.ssh\id_rsa.pub"
    Write-Host $tfVarsPath

    Set-Location ./terraform 
    if ($apply) {
        terraform apply -var-file="$tfVarsPath" -var ssh_public_key=$sshPublicKey
    } else {
        terraform validate
        terraform init
        terraform plan -var-file="$tfVarsPath" -var ssh_public_key=$sshPublicKey
    }
}

SetEnvVariables
RunTerraform