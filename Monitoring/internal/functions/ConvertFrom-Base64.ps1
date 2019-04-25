function ConvertFrom-Base64
{
<#
	.SYNOPSIS
		Converts a base64 encoded string back into its original form.
	
	.DESCRIPTION
		Converts a base64 encoded string back into its original form.
	
	.PARAMETER Text
		The base64 encoded string to convert
	
	.EXAMPLE
		PS C:\> 'RXhhbXBsZQ==' | ConvertFrom-Base64
	
		Converts the encoded 'RXhhbXBsZQ==' string into its human readable form ('Example')
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
			[Text.Encoding]::UTF8.GetString(([System.Convert]::FromBase64String($entry)))
		}
	}
}