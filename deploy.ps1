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
    $tfVarsPath = "$workspaceFolder/tfvars/auto.tfvars"
    Write-Host $tfVarsPath

    Set-Location ./terraform 
    if ($apply) {
        terraform apply -var-file="$tfVarsPath"
    } else {
        terraform validate
        terraform init
        terraform plan -var-file="$tfVarsPath"
    }
}

SetEnvVariables
RunTerraform