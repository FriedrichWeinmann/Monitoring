Register-MonConnection -Capability WinRM -ConnectionScript {
	param (
		$TargetName
	)
	
	@{
		'WinRM_PS' = (New-PSSession -ComputerName $TargetName)
		'WinRM_CIM' = (New-CimSession -ComputerName $TargetName)
	}
} -DisconnectionScript {
	param (
		$Connections,
		
		$TargetName
	)
	
	if ($Connections.WinRM_PS) { $Connections.WinRM_PS | Remove-PSSession }
	if ($Connections.WinRM_CIM) { $Connections.WinRM_CIM | Remove-CimSession }
}