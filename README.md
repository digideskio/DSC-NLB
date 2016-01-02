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

