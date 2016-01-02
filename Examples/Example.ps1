configuration NLBConfig
{
    [CmdletBinding()]
    Param
    (
        [psCredential]
        $Credentials
    )

Import-DscResource -ModuleName NLB

    node $AllNodes.Where{$_.Role -eq "NLBServer1"}.NodeName
    {
        NLBCreateCluster CreateNLB
        {

            ClusterName = 'ClusterofBugz'
            InterfaceName = 'Load Balance'
            ClusterPrimaryIP = '192.168.0.254'
            SubnetMask = '255.255.255.0'
            OperationMode = 'IgmpMultiCast'
                  
        }

        NLBAddNode AddDC1
        {
        
            NewNodeName = 'DC1'
            NewNodeInterface = 'Load Balance'
            ClusterName = 'ClusterofBugz'
            PsDscRunAsCredential = $Credentials
            DependsOn = '[NLBCreateCluster]CreateNLB'
        
        }

        NLBAddNode AddNLB1
        {
        

            NewNodeName = 'NLB1'
            NewNodeInterface = 'Load Balance'
            ClusterName = 'ClusterofBugz'
            PsDscRunAsCredential = $Credentials
            DependsOn = '[NLBAddNode]AddDC1'        


        }

    }

}
$ConfigurationData = @{
    AllNodes = @(
        
        @{  NodeName = "NLB2"
            Role = "NLBServer1"
         }

    )
}
NLBConfig -ConfigurationData $ConfigurationData -outputpath C:\DSC -Verbose -Credentials (Get-Credential -Message "Credentials are required for adding nodes to NLB CLusters")
Start-DscConfiguration C:\DSC -verbose -wait -force
