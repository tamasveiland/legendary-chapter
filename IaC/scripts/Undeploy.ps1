Param(
    [string] [Parameter(Mandatory=$true)] $ResourceGroupName,
    [string] [Parameter(Mandatory=$true)] $WebVmName,
    [string] [Parameter(Mandatory=$true)] $DataVmName,
    [string] [Parameter(Mandatory=$true)] $JumpboxVmName,
    [string] [Parameter(Mandatory=$true)] $JumpboxVmScalesetName
)

Function removeVM($resourceGroupName, $vmName) 
{ 
    $vm = (Get-AzVM | Where-Object{$_.Name -eq $vmName})
    if($vm -ne $null)
    {
        $osDiskName = $vm.StorageProfile.OsDisk.Name

        $nicId = $vm.NetworkProfile.NetworkInterfaces[0].Id.ToString()
        $nicName = $nicId.Substring($nicId.LastIndexOf('/')+1)

        $nic = Get-AzNetworkInterface -ResourceGroupName $resourceGroupName -Name $nicName
        $ipId = $nic.IpConfigurations[0].PublicIpAddress.Id.ToString();
        $ipName = $ipId.Substring($ipId.LastIndexOf('/')+1)
        
        $ipConfig = Get-AzNetworkInterfaceIpConfig -NetworkInterface $nic

        $subnetId = $nic.IpConfigurations[0].Subnet.Id.ToString()
        $vnetName = $subnetId.Split('/')[8]
        $subnetName = $subnetId.Substring($subnetId.LastIndexOf('/')+1)

        $vnet = Get-AzVirtualNetwork -ResourceGroupName $resourceGroupName -Name $vnetName
        $subnet = Get-AzVirtualNetworkSubnetConfig -Name $subnetName -VirtualNetwork $vnet
        $nsgId = $subnet.NetworkSecurityGroup.Id.ToString()
        $nsgName = $nsgId.Substring($nsgId.LastIndexOf('/')+1)
        
        Write-Host 'Deleting VM:' $vmName
        Remove-AzVM -ResourceGroupName $resourceGroupName -Name $vmName -Force

        Write-Host 'Deleting Disk:' $osDiskName
        Remove-AzDisk -DiskName $osDiskName -ResourceGroupName $resourceGroupName -Force

        Write-Host 'Deleting NIC:' $nicName
        Remove-AzNetworkInterface -ResourceGroupName $resourceGroupName -Name $nicName -Force

        Write-Host 'Deleting IP:' $ipName
        Remove-AzPublicIpAddress -ResourceGroupName $resourceGroupName -Name $ipName -Force

        Write-Host 'Deleting IPConfiguration:' $ipConfig.Name
        Remove-AzNetworkInterfaceIpConfig -Name $ipConfig.Name -NetworkInterface $nic

        Write-Host 'Deleting Subnet:' $subnetName
        Remove-AzVirtualNetworkSubnetConfig -Name $subnetName -VirtualNetwork $vnet

        Write-Host 'Deleting VNet:' $vnetName
        Remove-AzVirtualNetwork -ResourceGroupName $resourceGroupName -Name $vnetName -Force

        Write-Host 'Deleting NSG:' $nsgName
        Remove-AzNetworkSecurityGroup -ResourceGroupName $resourceGroupName -Name $nsgName -Force
    }
} 

Write-Host 'Deleting VM Scaleset:' $JumpboxVmScalesetName
Remove-AzVmss -ResourceGroupName $ResourceGroupName -VMScaleSetName $JumpboxVmScalesetName -Force

removeVM -resourceGroupName $ResourceGroupName -vmName $WebVmName
removeVM -resourceGroupName $ResourceGroupName -vmName $DataVmName
removeVM -resourceGroupName $ResourceGroupName -vmName $JumpboxVmName

