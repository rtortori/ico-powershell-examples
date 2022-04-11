# Uncomment the following script and provide the below information to set up Intersight environment.
<#
    $intersightEnv = @{
    BasePath = "https://intersight.com"
    ApiKeyId = "xxxxxxxxxxxxxxxxxx/xxxxxxxxxxxxxxxx/xxxxxxxxxxxxxxxxxx"
    ApiKeyFilePath = "C:\Users\admin\Downloads\ProductionSecretKey.txt" 
    HttpSigningHeader =  @("(request-target)", "Host", "Date", "Digest")
}

Set-IntersightConfiguration @intersightEnv
#>

# Variables. Change accordingly
$workflow_name = 'Deploy a Virtual Machine'
$orgName = 'default'
#

# Sample Payload used by Intersight API. This is just for reference. Do not remove the comment
# We need to extract the value of the 'Input' Key and replace the $inputPayload content
<#

{
    "Name": "Deploy a Virtual Machine",
    "AssociatedObject":
    {
        "ObjectType": "organization.Organization",
        "Moid": "5ddee8bb6972652d31030baf"
    },
    "Action": "Start",
    "Input":
    {
        "Vcenter":
        {
            "Moid": "60a033446f72612d33e9f5df",
            "ObjectType": "asset.DeviceRegistration"
        },
        "Datacenter": "/RMLAB",
        "Cluster": "/RMLAB/host/Goldrake",
        "Datastore": "/RMLAB/datastore/Hyperflex1",
        "Folder": "/RMLAB/vm/rtortori",
        "Template": "/RMLAB/vm/rtortori/ubuntu-template-hx",
        "Name": "my-virtual-machine",
        "Network": "192.168.130"
    },
    "WorkflowDefinition":
    {
        "Moid": "6192e224696f6e2d3124372e",
        "ObjectType": "workflow.WorkflowDefinition"
    }
}



#>


# This is the content of the 'Input' key in the Payload sent via API to execute this workflow.
# This is just a sample, replace with your workflow inputs
$inputPayload = @'
{
    "Vcenter": {
        "Moid": "60a033446f72612d33e9f5df",
        "ObjectType": "asset.DeviceRegistration"
    },
    "Datacenter": "/RMLAB",
    "Cluster": "/RMLAB/host/Goldrake",
    "Datastore": "/RMLAB/datastore/Hyperflex1",
    "Folder": "/RMLAB/vm/rtortori",
    "Template": "/RMLAB/vm/rtortori/ubuntu-template-hx",
    "Name": "test-ico-pssdk2",
    "Network": "192.168.130"
}
'@

# We convert the payload string into an object
$inputDef = ConvertFrom-Json -InputObject $inputPayload -AsHashtable

# Getting the Workflow Definition based on the Workflow Display Name (Label)
$workflowDef = Get-IntersightWorkflowWorkflowDefinition -Label $workflow_name
$workflowDefRef = $workflowDef | Get-IntersightMoMoRef

# Getting the Managed Object Reference (MoRef) for the specified organization
$orgRef = Get-IntersightOrganizationOrganization -Name $orgName | Get-IntersightMoMoRef

# Create a new dictionary object that will be used by the 'AdditionalProperties' parameter when triggering the workflow execution 
$inputObj = New-Object System.Collections.Generic.Dictionary"[String,Object]"
$inputObj.Add("Input",$inputDef)

# Execute the workflow (create a request, that is a WorkflowInfo)
$wfExec = New-IntersightWorkflowWorkflowInfo -Name "Deploy a virtual machine" `
                                            -AssociatedObject $orgRef -Action Start `
                                            -AdditionalProperties $inputObj -WorkflowDefinition $workflowDefRef

# Display Name of the request, Moid and user
$wfExec | Format-Table -Property Name,Moid,Email