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

# Variables. Change Accordingly
#$workflowMoid = '62540eac696f6e2d31dae861'
$workflowMoid = $args[0]

if($workflowMoid) {
    # Get the MoRef of the Workflow to rollback
    $WorkflowInfo = Get-IntersightWorkflowWorkflowInfo -Moid $workflowMoid | Get-IntersightMoMoRef
    # Creates the Rollback Workflow
    $rbc = New-IntersightWorkflowRollbackWorkflow -Action "Create" -PrimaryWorkflow $WorkflowInfo
    # Start the Rollback Workflow
    $rbs = New-IntersightWorkflowRollbackWorkflow -Action "Start" -ContinueOnTaskFailure $true -PrimaryWorkflow $WorkflowInfo -SelectedTasks @()

    # Display Moid and Status of the request
    $rbc | Format-Table -Property Moid,Status
    $rbs | Format-Table -Property Moid,Status

}else {
    write-host('Please specify a Moid for the workflow to rollback')
    write-host('')
    write-host('Example:')
    write-host('ico_wf_rollback_by_moid.ps1 62540eac696f6e2d31dae861')
}