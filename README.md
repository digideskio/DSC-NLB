# DSC-NLB

The **NLB** DSC resources allow you to configure and manage Windows Network Load Balancers.


## Description

The **NLB** module contains the **NLBCreateCluster and NLBAddNode** DSC Resources.
These DSC Resources allow you to create a new NLB and add nodes to it.

## Resources

* **NLBCreateCluster** creates a new NLB Cluster
* **NLBAddNode** adds a node to a NLB CLuster

### **NLBCreateCluster**

* **ClusterName**: Specifies the name of the new cluster
* **ClusterPrimaryIP**: Specifies the primary cluster IP address for the new cluster.
* **SubnetMask**: Specifies the subnet mask for the new cluster primary IP address.
* **DedicatedIP**: Specifies the dedicated IP address to use for the node when creating the new cluster. If this parameter is omitted, the existing static IP address on the node will be used.
* **DedicatedIPSubnetMask**: Specifies the dedicated IP address subnet mask to use for the node when creating the new cluster. If this parameter is omitted, the existing static IP address subnet mask on the node will be used.
* **InterfaceName**: Specifies the interface to which NLB is bound. This is the interface of the cluster against which this cmdlet is run.
* **OperationMode**: Specifies the operation mode for the new cluster. If this parameter is omitted, the mode is unicast. The operation mode values are unicast, multicast, or igmpmulticast.

### NLBAddNode

* **NewNodeInterface**: Specifies the interface name on the new cluster node. 
* **NewNodeName**: Specifies the name of the new cluster node.
* **ClusterName**: Specifies the name of the cluster in which the node is joining.

## Versions

### 1.0.0.0

* Initial release with the following resources:
    * NLBCreateCluster, NLBAddNode


## Examples

```powershell
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
```
## Misc

During the execution of this module you may see the below warning. This may occur when adding a node to a NLB Cluster.
![Alt text](https://flynnbundy.files.wordpress.com/2016/01/nlb.png "Example")
