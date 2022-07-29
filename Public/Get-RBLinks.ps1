<#
    .SYNOPSIS

    .DESCRIPTION

    .EXAMPLE

    .PARAMETER
    
    .OUTPUTS

    .NOTES

    .LINK
    https://developers.rebrandly.com/docs/api-custom-url-shortener
#>
Function Get-RBLinks{
	[CmdletBinding()]
	Param([Parameter(Mandatory=$false)]
		  [string]
		  $RBWSId = $global:RBWSId,
          [Parameter(Mandatory=$false)]
		  [string]
          $RBKey = $global:RBKey)
	
	begin{
        $Header = @{
            "Content-Type"  = "application/json"
            "apikey"        = $RBKey
        }
        if($RBWSId){
            $Header.add("workspace",$RBWSId)
        }

        $apiurl = 'https://api.rebrandly.com/v1/links'
    }
	process{
		try{
			$r = Invoke-WebRequest -Uri $apiurl -Headers $Header
            $r.content | ConvertFrom-Json
		}
		catch{
			$ErrorMessage = $_.Exception.Message
			$FailedItem = $_.Exception.ItemName
			
			Write-Output "$FailedItem - $ErrorMessage : $r"
			Return $False
		}
		finally{}
	}
	end{}
}