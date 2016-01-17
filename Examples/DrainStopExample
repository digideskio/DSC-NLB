configuration NLBTest
{

Import-DscResource -ModuleName NLB
Import-DscResource -ModuleName xWindowsUpdate
Import-DscResource –ModuleName 'PSDesiredStateConfiguration'

    node $AllNodes.Where{$_.Role -eq "ClusterNode1"}.NodeName
    {
        NLBStopNode StopNodeForUpdates
        {
        
            Interfacename = 'Load'
            Drain = $True
        
        }
        xMicrosoftUpdate Updates
        {

        DependsOn = '[NLBStopNode]StopNodeForUpdates'
        Ensure = 'Present'
                
        }
        NLBStartNode StartNodeAfterUpdates
        {
        
        DependsOn = '[xMicrosoftUpdate]Updates'
        Interfacename = 'Load'
              
        }

    }

    node $AllNodes.Where{$_.Role -eq "ClusterNode2"}.NodeName
    {

        WaitForAny WaitforOtherNode
        {
            ResourceName = '[NLBStartNode]StartNodeAfterUpdates'
            RetryIntervalSec = 10
            RetryCount = 20
            NodeName = 'DC1'
        
        }

        NLBStopNode StopNodeForUpdates
        {
        
            Interfacename = 'Load'
            Drain = $True
            DependsOn = '[WaitForAny]WaitforOtherNode'
        
        }
        xMicrosoftUpdate Updates
        {

        DependsOn = '[NLBStopNode]StopNodeForUpdates'
        Ensure = 'Absent'
                
        }
        NLBStartNode StartNodeAfterUpdates
        {
        
        DependsOn = '[xMicrosoftUpdate]Updates'
        Interfacename = 'Load'
              
        }

    }
}
$ConfigurationData = @{
    AllNodes = @(
        @{
            NodeName = "DC1"
            Role = "ClusterNode1"
            
            },
        @{
            NodeName = "Member1"
            Role = "ClusterNode2"
            
            }
    )
}
NLBTest -ConfigurationData $ConfigurationData -outputpath C:\DSC -Verbose
Start-DscConfiguration C:\DSC -verbose -wait -force
