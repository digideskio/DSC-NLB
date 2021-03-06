function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [parameter(Mandatory = $true)]
        [System.String]
        $Interfacename
    )

    $returnValue = @{
    Interfacename = [System.String]$Interfacename
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
        $Interfacename,

        [System.Boolean]
        $Drain
    )
     
if ($PSBoundParameters.ContainsValue('Drain')){
    Write-Verbose "Drain Stopping $Interfacename"
    Get-NlbClusterNode -InterfaceName $Interfacename | Stop-NlbClusterNode -Drain
    }
else {
    Get-NlbClusterNode -InterfaceName $Interfacename | Stop-NlbClusterNode
}

}


function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [parameter(Mandatory = $true)]
        [System.String]
        $Interfacename,

        [System.Boolean]
        $Drain
    )

if (Get-NlbClusterNode -InterfaceName $Interfacename -ErrorAction SilentlyContinue | Where {$_.State -eq 'Stopped'}){

return $true
}
else{

return $false
}

}


Export-ModuleMember -Function *-TargetResource

