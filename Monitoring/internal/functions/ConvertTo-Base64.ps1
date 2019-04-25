function ConvertTo-Base64
{
<#
	.SYNOPSIS
		Converts text to base 64 encoded string.
	
	.DESCRIPTION
		Converts text to base 64 encoded string.
	
	.PARAMETER Text
		The text to convert.
	
	.EXAMPLE
		PS C:\> 'Example' | ConvertTo-Base64
	
		Converts the string 'Example' into its base64 representation.
#>
	[OutputType([System.String])]
	[CmdletBinding()]
	param (
		[Parameter(ValueFromPipeline = $true, Mandatory = $true)]
		[string[]]
		$Text
	)
	
	process
	{
		foreach ($entry in $Text)
		{
			[System.Convert]::ToBase64String(([Text.Encoding]::UTF8.GetBytes($entry)))
		}
	}
}