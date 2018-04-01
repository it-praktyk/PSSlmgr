Function Invoke-Rearm {

    [CmdletBinding(
        DefaultParameterSetName='RearmWindows',
        SupportsShouldProcess=$true,
        ConfirmImpact='High'
    )]
    Param(
        [Parameter(Mandatory=$true,ParameterSetName='RearmWindows')]
        [Switch]$Windows,
        [Parameter(Mandatory=$true,ParameterSetName='RearmAppplication')]
        [Switch]$Application,
        [Parameter(Mandatory=$true,ParameterSetName='RearmSKU')]
        [Switch]$SKU,
        [Parameter(Mandatory=$false)]
        [Alias('MachineName')]
        $ComputerName="localhost",
        [Parameter(Mandatory=$false)]
        [ValidateNotNull()]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential = [System.Management.Automation.PSCredential]::Empty,
        [Parameter(Mandatory=$false)]
        [Switch]$AnsibleMode
    )

    #This retrieve strings hard-coded in the slmgr.vbs tool
    $Messages = Import-MessageString

    if ( -not $(Test-RunningAsElevated) ) {
        
        [String]$MessageText = $Messages.L_MsgError_5

        Throw $MessageText

    }

    if ( $PSCmdlet.ParameterSetName -eq 'RearmWindows' ) {

        [String]$MessageString = "Performing operation: {0}" -f $Messages.L_optReArmWindowsUsage

        if ( $PSCmdlet.ShouldProcess("$MessageString")) {

            $ReArmResponse = Invoke-CimMethod -Query 'select Version from SoftwareLicensingService' -MethodName ReArmWindows

            Return $ReArmResponse

        }

    }
    else{

        [String]$MessageText = "Rearming of an application and/or SKU is not implemented yet"

    }


}