function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [parameter(Mandatory = $true)]
        [System.String]
        $ClusterName,

        [parameter(Mandatory = $true)]
        [System.String]
        $ClusterPrimaryIP,

        [parameter(Mandatory = $true)]
        [System.String]
        $InterfaceName,

        [parameter(Mandatory = $true)]
        [System.String]
        $SubnetMask,

        [parameter(Mandatory = $false)]
        [System.String]
        [ValidateSet("Unicast","IgmpMultiCast","Multicast")] 
        $OperationMode
    )


    $returnValue = @{
    ClusterName = $ClusterName
    ClusterPrimaryIP = $ClusterPrimaryIP
    InterfaceName = $InterfaceName
    SubnetMask = $SubnetMask
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
        $ClusterName,

        [parameter(Mandatory = $true)]
        [System.String]
        $ClusterPrimaryIP,
       
        [parameter(Mandatory = $true)]
        [System.String]
        $InterfaceName,

        [parameter(Mandatory = $true)]
        [System.String]
        $SubnetMask,

        [parameter(Mandatory = $false)]
        [System.String]
        [ValidateSet("Unicast","IgmpMultiCast","Multicast")] 
        $OperationMode,

        [parameter(Mandatory = $false)]
        [System.String]
        $DedicatedIP,

        [parameter(Mandatory = $false)]
        [System.String]
        $DedicatedIPSubnetMask
    )

    Write-Verbose "Creating Cluster $Clustername with IP $ClusterPrimaryIP on $InterfaceName and $SubnetMask"
    New-NlbCluster @PSBoundParameters
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [parameter(Mandatory = $true)]
        [System.String]
        $ClusterName,

        [parameter(Mandatory = $true)]
        [System.String]
        $ClusterPrimaryIP,
       
        [parameter(Mandatory = $true)]
        [System.String]
        $InterfaceName,

        [parameter(Mandatory = $true)]
        [System.String]
        $SubnetMask,

        [parameter(Mandatory = $false)]
        [System.String]
        [ValidateSet("Unicast","IgmpMultiCast","Multicast")] 
        $OperationMode,

        [parameter(Mandatory = $false)]
        [System.String]
        $DedicatedIP,

        [parameter(Mandatory = $false)]
        [System.String]
        $DedicatedIPSubnetMask
    )
$ErrorActionPreference = 'Stop'

Write-Verbose "Checking to see if a cluster with the defined properties exists"
if (Get-NlbCluster -ErrorAction SilentlyContinue | Where-Object {$_.Name -eq $Clustername -and $_.IPAddress -eq "$ClusterPrimaryIP"}){

    Write-Verbose "A Cluster on this node is already configured with the desired properties"
    return $true
    } else { 
    Write-Verbose "Could not find a Cluster with the desired configuration, Creating Cluster."
    return $false
    }
}


Export-ModuleMember -Function *-TargetResource

