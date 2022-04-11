# Intersight Cloud Orchestrator 
## Powershell Examples

This repository contains sample Powershell code for Intersight Cloud Orchestrator (ICO)<br>

<b>DISCLAIMER: This is NOT an official Cisco repository and comes with NO WARRANTY AND/OR SUPPORT<br>
Please check LICENSE-CISCO for additional details</b>
 
### Instructions
1. [Generate an API key and secret from Intersight](https://intersight.com/apidocs/introduction/security/%23generating-api-keys&sa=D&ust=1612024909729000&usg=AOvVaw362rkbFxqhX_Mo8w0xkDJG/#generating-api-keys)
2. Take note of the `API Key ID`, download and store the `Secret Key` in your filesystem
3. Refer to the `sample_configuration.ps1` file to understand how to use those credentials in your scripts
5. Install Intersight Powershell SDK: `PS> Install-Module -Name Intersight.PowerShell`

<hr>

### Examples

1.  Get all Workflows Definitions (as displayed in Intersight)

```
ICO > $filter="(Properties.ExternalMeta eq true) and (Name ne 'DeployHyperFlexSDWAN') and (DefaultVersion eq true)"
ICO > $wf = Get-IntersightWorkflowWorkflowDefinition -InlineCount allpages -Top 0 -Filter $filter
ICO > $wf

Count Results
----- -------                                                                                                                                                                                             
  522 {class WorkflowWorkflowDefinition {…                                                                                                                                                                

ICO > $wf.Results.Count
522

ICO > $wf.Results


ClassId               : WorkflowWorkflowDefinition
ObjectType            : WorkflowWorkflowDefinition
LicenseEntitlement    : Premier
DefaultVersion        : True
Description           : a test workflow to experiment with custom integrations
InputDefinition       : {class WorkflowBaseDataType {
                          class MoBaseComplexType {
                            ClassId: 0
                            ObjectType: 0
[...]
```

2. With table view (Sort based on CreateTime, in descending order).


```
ICO > $wf.Results | Sort-Object CreateTime -Descending | Format-Table -Property Label,Moid,CreateTime

Label                                              Moid                     CreateTime
-----                                              ----                     ----------
testwf12                                           624f59c2696f6e2d316e9464 04/07/2022 21:38:11
testwork1233                                       624ed76e696f6e2d316bc7b1 04/07/2022 12:22:06
Test Powershell Inspector                          624ec3b8696f6e2d316b95a0 04/07/2022 10:58:00
Powershell - MS Services                           624cb5ef696f6e2d31643927 04/05/2022 21:34:39
```

3. Get a specific Workflow Definition by Label (Native)


```
ICO > $wf = Get-IntersightWorkflowWorkflowDefinition -Label 'Deploy a Virtual Machine'       
ICO > $wf

ClassId               : WorkflowWorkflowDefinition
ObjectType            : WorkflowWorkflowDefinition
LicenseEntitlement    : Premier
DefaultVersion        : True
Description           : Deploys a Virtual Machine
InputDefinition       : {class WorkflowBaseDataType {
                          class MoBaseComplexType {
                            ClassId: 0
                            ObjectType: 0
                            AdditionalProperties: System.Collections.Generic.Dictionary`2[System.String,System.Object]
                          }
[...]
```

4. Get a specific Workflow Definition by Label (Query Filter)

```
ICO > $filter="Label eq 'Deploy a Virtual Machine'"
ICO > $wf = Get-IntersightWorkflowWorkflowDefinition -Filter $filter
ICO > $wf.Results | head -10

ClassId               : WorkflowWorkflowDefinition
ObjectType            : WorkflowWorkflowDefinition
LicenseEntitlement    : Premier
DefaultVersion        : True
Description           : Deploys a Virtual Machine
InputDefinition       : {class WorkflowBaseDataType {
                          class MoBaseComplexType {
                            ClassId: 0
                            ObjectType: 0
[...]
```

5. Get all Requests (except internals)

```
ICO > $requests = Get-IntersightWorkflowWorkflowInfo -InlineCount allpages -Top 0 -Filter "(Type ne 'ANSIBLE_MONITORING') and (Status ne 'TIMED_OUT') and (Status ne 'NotStarted') and (Internal ne true)"
ICO > $requests

Count Results
----- -------                                                                                                                                                                                 
  633 {class WorkflowWorkflowInfo {…                                                                                                                                                          

ICO > $requests.Results

ClassId                        : WorkflowWorkflowInfo
ObjectType                     : WorkflowWorkflowInfo
Action                         : None
LastAction                     : Start
PauseReason                    : None
WaitReason                     : None
WorkflowMetaType               : UserDefined
CleanupTime                    : 01/01/0001 00:00:00
Email                          : user@cisco.com
EndTime                        : 01/01/0001 00:00:00
FailedWorkflowCleanupDuration  : 2160
Input                          : {}
InstId                         : 7eaf57d1-5e16-4308-9021-4f09341ce4c2
Internal                       : False
Message                        : {class WorkflowMessage {
                                   class MoBaseComplexType {
                                     ClassId: 0
                                     ObjectType: 0
                                     AdditionalProperties: System.Collections.Generic.Dictionary`2[System.String,System.Object]
                                   }
[...]                                   
```

6. Get Request by MOID

```
ICO > $requests = Get-IntersightWorkflowWorkflowInfo -Moid 6252aa45696f6e2d31d8e8db                                                                                                                       
ICO > $requests

ClassId                        : WorkflowWorkflowInfo
ObjectType                     : WorkflowWorkflowInfo
Action                         : None
LastAction                     : Start
PauseReason                    : None
WaitReason                     : None
WorkflowMetaType               : UserDefined
CleanupTime                    : 30/06/2022 17:35:08
Email                          : user@cisco.com
EndTime                        : 01/04/2022 17:35:08
FailedWorkflowCleanupDuration  : 2160
Input                          : {Cluster, Datacenter, Datastore, Folder…}
InstId                         : 907dcc83-0411-449f-b710-294e9233287c
Internal                       : False
Message                        : {}
MetaVersion                    : 0
```

7. Execute a Workflow (Example Script: `./ico_wf_execution_by_name.ps1`, replace with your workflow values

```
ICO > ./ico_wf_execution_by_name.ps1

Name                     Moid                     Email
----                     ----                     -----
Deploy a virtual machine 6254166b696f6e2d31db1e93 user@cisco.com
```

8. Rollback a Workflow (Pass the Moid of the workflow request to rollback)

```
ICO > ./ico_wf_rollback_by_moid.ps1 6254166b696f6e2d31db1e93

Moid                      Status
----                      ------
625416ec726f6e2d312e72ea Created


Moid                      Status
----                      ------
625416ec726f6e2d312e72ea Running
```