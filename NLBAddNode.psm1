function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [parameter(Mandatory = $true)]
        [System.String]
        $NewNodeName,

        [parameter(Mandatory = $true)]
        [System.String]
        $NewNodeInterface,

        [parameter(Mandatory = $true)]
        [System.String]
        $ClusterName
    )


    $returnValue = @{
    NewNodeName = $NewNodeName
    NewNodeInterface = $NewNodeInterface
    ClusterName = $ClusterName
    }

    $returnValue
    
}


function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [parameter(Mandatory = $true)]
        [System.String]
        $NewNodeName,

        [parameter(Mandatory = $true)]
        [System.String]
        $NewNodeInterface,

        [parameter(Mandatory = $true)]
        [System.String]
        $ClusterName
    )

Write-Verbose "Adding Node: $NewNodeName with NodeInterface: $NewNodeInterface to $ClusterName"
Get-NlbCluster | Where {$_.Name -eq "$ClusterName"} | Add-NlbClusterNode -NewNodeName $NewNodeName -NewNodeInterface $NewNodeInterface -Force | Out-Null

}


function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [parameter(Mandatory = $true)]
        [System.String]
        $NewNodeName,

        [parameter(Mandatory = $true)]
        [System.String]
        $NewNodeInterface,

        [parameter(Mandatory = $true)]
        [System.String]
        $ClusterName
    )

$ErrorActionPreference = 'Stop'

if (Get-NlbClusterNodeNetworkInterface -HostName $Newnodename -ErrorAction SilentlyContinue | Where-Object {$_.Cluster -eq $ClusterName}){

Write-Verbose "The Node $NewNodeName already exists for $Clustername."
return $true 
} else {
Write-Verbose "Cluster Node $NewNodeName does NOT exist as a node in the Cluster - Moving to SET"
return $false
}

}


Export-ModuleMember -Function *-TargetResource

