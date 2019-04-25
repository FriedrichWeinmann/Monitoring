Register-MonConnection -Capability ldap -ConnectionScript {
	param (
		$TargetName
	)
	# Nothing - it's a dummy connection
	@{ }
} -DisconnectionScript {
	param (
		$Connections,
		
		$TargetName
	)
	# Nothing - it's a dummy connection
}