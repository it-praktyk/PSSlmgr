function Test-RunningAsElevated {
	[CmdletBinding()]
	[OutputType([bool])]
	Param ()

	$wid = [System.Security.Principal.WindowsIdentity]::GetCurrent()
	$prp = new-object System.Security.Principal.WindowsPrincipal($wid)
	$adm = [System.Security.Principal.WindowsBuiltInRole]::Administrator
	return $prp.IsInRole($adm)
}
