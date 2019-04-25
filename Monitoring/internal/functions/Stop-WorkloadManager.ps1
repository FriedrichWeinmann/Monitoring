function Stop-WorkloadManager
{
<#
	.SYNOPSIS
		Cleans up all leftovers from the worker agents.
	
	.DESCRIPTION
		Cleans up all leftovers from the worker agents.
	
	.EXAMPLE
		PS C:\> Stop-WorkloadManager
	
		Cleans up all leftovers from the worker agents.
#>
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
	[CmdletBinding()]
	Param (
	
	)
	
	process
	{
		if ($script:runspacePool -and -not $script:runspacePool.IsDisposed)
		{
			$script:runspacePool.Dispose()
		}
	}
}
