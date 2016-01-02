configuration NLBConfig
{
    [CmdletBinding()]
    Param
    (
        
        $Credentials
    )

Import-DscResource -ModuleName NLB

    node $AllNodes.Where{$_.Role -eq "NLBServer"}.NodeName
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
    node $AllNodes.Where{$_.Role -eq "WebServer"}.NodeName
    {
        NLBCreateCluster CreateNLB
        {

        ClusterName = 'ClusterofBacon'
        InterfaceName = 'Ethernet'
        ClusterPrimaryIP = '192.168.0.198'
        SubnetMask = '255.255.255.0'
        OperationMode = 'IgmpMultiCast'
                  
        }
    
    
    }
}
$ConfigurationData = @{
    AllNodes = @(
        
        @{  NodeName = "NLB1"
            Role = "NLBServer"
         },
         @{  NodeName = "DC1"
            Role = "WebServer"
         }
    )
}
NLBConfig -ConfigurationData $ConfigurationData -outputpath C:\DSC -Verbose -Credentials (Get-Credential -Message "Credentials are required for adding nodes to NLB CLusters")
Start-DscConfiguration C:\DSC -verbose -wait -force
