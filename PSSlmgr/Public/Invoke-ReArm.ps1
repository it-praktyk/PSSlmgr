Function Invoke-ReArm {

    [CmdletBinding(
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
        [String]$ApplicationID,
        [Parameter(Mandatory=$false)]
        [Alias('MachineName')]
        [String]$ComputerName="localhost",
        [Parameter(Mandatory=$false)]
        [ValidateNotNull()]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential = [System.Management.Automation.PSCredential]::Empty,
        [Parameter(Mandatory=$true,ParameterSetName='AnsibleMode')]
        [Switch]$AnsibleMode,
        [Parameter(Mandatory=$true,ParameterSetName='AnsibleMode')]
        [ValidateSet('Windows','Application','SKU')]
        [String]$ReArmScope
    )

    #This retrieve strings hard-coded in the slmgr.vbs tool
    $Messages = Import-MessageString

    $Result = New-Object -TypeName psobject

    if ( -not $(Test-RunningAsElevated) ) {

        [String]$MessageText = $Messages.L_MsgError_5

        Throw $MessageText

    }

    Switch ( $PSCmdlet.ParameterSetName ) {

        'RearmWindows' {
            $ReArmScopeInternal = 'Windows'
        }
        'RearmApplication' {
            $ReArmScopeInternal = 'Application'
        }
        'RearmSKU' {
            $ReArmScopeInternal = 'SKU'
        }
        'AnsibleMode' {
            $ReArmScopeInternal = $ReArmScope
        }

    }

    if ( $ReArmScopeInternal -eq 'Windows' ) {

        [String]$MessageText = "Performing operation: {0}" -f $Messages.L_optReArmWindowsUsage

        if ( $PSCmdlet.ShouldProcess("$MessageText")) {

            Try {

                $ReArmResponse = Invoke-CimMethod -ComputerName $ComputerName -Query 'select Version from SoftwareLicensingService' -MethodName ReArmWindows

                [String]$MessageText = $Messages.L_MsgRearm_2

                $Result | Add-Member -MemberType NoteProperty -Name Message -Value $MessageText

                $Result | Add-Member -MemberType NoteProperty -Name RestartRequired $true

            }
            Catch {

                $Result | Add-Member -MemberType NoteProperty -Name Message -Value $ReArmResponse

                $Result | Add-Member -MemberType NoteProperty -Name RestartRequired $false

            }

        }

    }
    else{

        [String]$MessageText = "Rearming of an application and/or SKU is not implemented yet"

    }

    if ( $PSCmdlet.ParameterSetName -eq 'AnsibleMode' ) {

        $Result

    }
    else {

        $Result.Message | Out-Host

    }


}