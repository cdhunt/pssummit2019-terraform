


Properties {
    # Required env vars for CI
    $reqTestVars = @(
        'Env:\TF_TESTING_TENANT_ID'
        'Env:\TF_TESTING_SUBSCRIPTION_ID'
        'Env:\TF_TESTING_CLIENT_ID'
        'Env:\TF_TESTING_CLIENT_SECRET'
    )
    Assert ((Get-Item $reqTestVars).Count -eq 4) 'Require Terraform variables are not present!!!'

    # Generate a semi-random unique prefix for testing
    # and persist it between psake runs.
    # TFDestroy task will remove the state file and force
    # a new prefix to be generated
    if (Get-ChildItem -Path . -Filter 'psake.state') {
        $prefix = Get-Content -Path ./psake.state
        "Using existing prefix [$prefix]"
    } else {
        # Random 9 character alpha string
        $prefix = ( -join (( 0x61..0x7A) | Get-Random -Count 9).ForEach( { [char]$_ }))
        $prefix > psake.state
        "Using new prefix [$prefix]"
    }
    $env:TF_VAR_resource_group_name = "tf_$prefix"
    $env:TF_VAR_prefix = $prefix

    # These values can be overriden by passing psake properties
    # through the build script
    # ./build.ps1 -task test -properties @{location = 'westus2'}
    $tf_var_location        = 'eastus'
    $terraformVersion       = '0.11.11'
    $chocoTerraformPackages = @(
        'terraform-provider-octopusdeploy'
        'terraform-provider-restapi'
    )
}

FormatTaskName {
    param($taskName)
    Write-Host "`nTask: " -ForegroundColor Cyan -NoNewline
    Write-Host ($taskName.ToUpper() + ' ' + ('='*40)) -ForegroundColor Blue
}

Task Clean {
    Get-ChildItem -Path . -Filter *.plan -File     | Remove-Item -Filter *.plan
    Get-ChildItem -Path . -Filter *.tfstate* -File | Remove-Item -Filter *.tfstate*
    Get-ChildItem -Path . -Filter psake.state      | Remove-Item -Filter psake.state
}

Task Init {
    # Populate TF vars with values defined in the 'properties' block
    (Get-Variable -Name tf_var_*).Foreach({
        $n = $_.Name -Replace ('^tf_var_', 'TF_VAR_')
        Set-Item -Path env:$n -Value $_.Value
    })

    # TF Azure provider environment variables
    $env:ARM_TENANT_ID       = $env:TF_TESTING_TENANT_ID
    $env:ARM_SUBSCRIPTION_ID = $env:TF_TESTING_SUBSCRIPTION_ID
    $env:ARM_CLIENT_ID       = $env:TF_TESTING_CLIENT_ID
    $env:ARM_CLIENT_SECRET   = $env:TF_TESTING_CLIENT_SECRET

    # Install Chocolatey / Terraform if necessary
    if (-not (Get-Command -Name choco.exe -ErrorAction SilentlyContinue)) {
        'Installing Chocolatey...'
        Invoke-Expression -Command ([System.Net.WebClient]::new().DownloadString('https://chocolatey.org/install.ps1'))
    }
    if (-not (Get-Command -Name Terraform.exe -ErrorAction SilentlyContinue)) {
        'Installing Terraform via Chocolatey...'
        Exec { choco.exe install terraform --version=$terraformVersion --no-progress --limit-output --yes }
    }
}

Task TFInit -depends Init {
    Exec { terraform.exe init -input=false -no-color }
}

Task TFValidate -depends TFInit {
    Exec { terraform.exe validate -no-color }
}

Task TFPlan -depends TFValidate {
    Exec { terraform.exe plan -out terraform.plan -input=false -no-color }
}

Task TFApply -depends TFPlan {
    Exec { terraform.exe apply -input=false -auto-approve -no-color terraform.plan }
}

Task TFDestroy -depends TFInit {
    Exec { terraform.exe destroy -auto-approve -no-color }
    Get-ChildItem -Path . -Filter *.plan -File | Remove-Item -Filter *.plan
    Get-ChildItem -Path . -Filter *.tfstate* -File | Remove-Item -Filter *.tfstate*
    Get-ChildItem -Path . -Filter psake.state | Remove-Item -Filter psake.state

    "Removing resource group [$env:TF_VAR_resource_group_name]"
    Remove-AzResourceGroup -Name $env:TF_VAR_resource_group_name -Force
}

Task TFTest -depends TFApply {
    # Let the TF run bake for a few seconds
    # We've seen the ARM API not return resources immedietly
    # and this will FAIL the pester tests
    Start-Sleep -Seconds 10

    # Login to Azure
    $azParams = @{
        Tenant           = $env:ARM_TENANT_ID
        SubscriptionId   = $env:ARM_SUBSCRIPTION_ID
        ServicePrincipal = $true
        Credential       = [pscredential]::new($env:ARM_CLIENT_ID, ($env:ARM_CLIENT_SECRET | ConvertTo-SecureString -AsPlainText -Force))
        WarningAction    = 'SilentlyContinue'
    }
    "Logging into subscription [$env:ARM_SUBSCRIPTION_ID]"
    Connect-AzAccount @azParams > $null

    # Pass Pester a hashtable of all TF variables
    $pesterTestParams = @{}
    (Get-Item -Path env:tf_var_*).Foreach( {
        $pesterTestParams.Add($_.Name, $_.Value)
    })

    $pesterParams = @{
        Script     = @{
            Path       = './tests'
            Parameters = @{
                Parameters = $pesterTestParams
            }
        }
        OutputFile = './testResults.xml'
        PassThru   = $true
    }
    $results = Invoke-Pester @pesterParams
    if ($results.FailedCount -ne 0) {
        throw '1 or more Terraform tests failed!!!'
    }
} -postaction {
    'Destroying resources under test...'
    exec { terraform.exe destroy -auto-approve -no-color}
    Get-ChildItem -Path . -Filter *.plan -File     | Remove-Item -Filter *.plan
    Get-ChildItem -Path . -Filter *.tfstate* -File | Remove-Item -Filter *.tfstate*
    Get-ChildItem -Path . -Filter psake.state      | Remove-Item -Filter psake.state
}

Task Test -depends TFTest { }
