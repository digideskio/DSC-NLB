configuration NLBTest
{
    [CmdletBinding()]
    Param
    (
        $Credentials
    )

Import-DscResource -ModuleName NLB

    node $AllNodes.Where{$_.Role -eq "Machine1"}.NodeName
    {
        NLBCreateCluster CreateNLB
        {

        ClusterName = 'ClusterofSandwiches'
        InterfaceName = 'Ethernet 2'
        ClusterPrimaryIP = '192.168.0.230'
        SubnetMask = '255.255.255.0'
        OperationMode = 'Unicast'
                  
        }
        NLBAddNode AddDC1
        {
        
        NewNodeName = 'DC1'
        NewNodeInterface = 'Ethernet 2'
        ClusterName = 'ClusterofSandwiches'
        PsDscRunAsCredential = $Credentials    
        
        }

    }
}
$ConfigurationData = @{
    AllNodes = @(
        @{
            NodeName = "DC1"
            Role = "Machine"

            },
        @{  NodeName = "NLB1"
            Role = "Machine1"

            }
    )
}
NLBTest -ConfigurationData $ConfigurationData -outputpath C:\DSC -Verbose -Credentials (Get-Credential -Message "Credentials are required for adding nodes to NLB CLusters")
Start-DscConfiguration C:\DSC -verbose -wait -force
