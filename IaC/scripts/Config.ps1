Param(
    [string] [Parameter(Mandatory=$true)] $ResourceGroupName,
    [string] [Parameter(Mandatory=$true)] $appprefix,
    [string] [Parameter(Mandatory=$true)] $databaseusername,
    [string] [Parameter(Mandatory=$true)] $databasepassword
)


# App NSG
$port=8080
$rulename="allowAppPort$port"
$nsgname="$appprefix-app"

# Get the NSG resource
$nsg = Get-AzNetworkSecurityGroup -Name $nsgname -ResourceGroupName $ResourceGroupName

$existingRule = Get-AzNetworkSecurityRuleConfig -NetworkSecurityGroup $nsg | Where-Object {$_.Name -eq $rulename}

if($existingRule -eq $null) 
{ 
    # Add the inbound security rule.
    $nsg | Add-AzNetworkSecurityRuleConfig -Name $rulename -Description "Allow app port" -Access Allow `
        -Protocol * -Direction Inbound -Priority 100 -SourceAddressPrefix "*" -SourcePortRange * `
        -DestinationAddressPrefix * -DestinationPortRange $port

    # Update the NSG.
    $nsg | Set-AzNetworkSecurityGroup
}


# Data NSG

$port=3306
$nsgname="$appprefix-data"

# Get my public IP
$myIp = Invoke-RestMethod -Method Get -Uri "https://api.ipify.org"
$rulename="allow3306To$myIp"

$nsg = Get-AzNetworkSecurityGroup -Name $nsgname -ResourceGroupName $ResourceGroupName

$existingRule = Get-AzNetworkSecurityRuleConfig -NetworkSecurityGroup $nsg | Where-Object {$_.Name -eq $rulename}

if($existingRule -eq $null)
{
    Write-Host 'Creating new inbound security rule'
    
    # Find existing max priority.
    $maxPriority = 100;
    foreach ($rule in (Get-AzNetworkSecurityRuleConfig -NetworkSecurityGroup $nsg))
    {
        if(($rule.Priority -lt 4096) -and ($rule.Priority -ge $maxPriority))
        {
            $maxPriority = $rule.Priority;
        }
    }

    # Add new rule after all the prior ones.
    $maxPriority++

    # Add the inbound security rule.
    $nsg | Add-AzNetworkSecurityRuleConfig -Name $rulename -Description "Allow app port" -Access Allow `
        -Protocol * -Direction Inbound -Priority $maxPriority -SourceAddressPrefix "$myIp" -SourcePortRange * `
        -DestinationAddressPrefix * -DestinationPortRange $port

    # Update the NSG.
    $nsg | Set-AzNetworkSecurityGroup
}

$nic = Get-AzNetworkInterface -Name $appprefix-data-nic -ResourceGroupName $ResourceGroupName
$privateIp = $nic.IpConfigurations | select-object -ExpandProperty PrivateIpAddress
$publicIp = (Get-AzPublicIpAddress -ResourceGroupName $ResourceGroupName -Name $appprefix-data-ip).IpAddress

Write-Host "##vso[task.setvariable variable=dataprivateip;]$privateIp"
Write-Host "##vso[task.setvariable variable=datapublicip;]$publicIp"

# Write-Host "vm command start"
# Invoke-AzVMRunCommand -ResourceGroupName $ResourceGroupName -Name $appprefix-app -CommandId 'RunPowerShellScript' -ScriptPath '$(System.DefaultWorkingDirectory)\_Coupons-CI-BuildnUTs\drop\IaC\scripts\UpdateEnvVars.ps1' -Parameter @{datasourceUrl = "jdbc:mysql://$privateIp:3306/hotel_coupon?verifyServerCertificate=false'&'useSSL=false'&'requireSSL=false"; datasourceUsername = $databaseusername; datasourcePassword = $databasepassword }
# Write-Host "vm command done"

$publicIpApp = (Get-AzPublicIpAddress -ResourceGroupName $ResourceGroupName -Name $appprefix-app-ip).IpAddress
Write-Host "$publicIpApp"
Write-Host "##vso[task.setvariable variable=apppublicip;]$publicIpApp"