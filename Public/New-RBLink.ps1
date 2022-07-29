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
Function New-RBLink{
	[CmdletBinding()]
	Param([Parameter(Mandatory=$false)]
		  [string]
		  $RBWSId = $global:RBWSId,
          [Parameter(Mandatory=$false)]
		  [string]
          $RBKey = $global:RBKey,
          [Parameter(Mandatory=$true)]
		  [string]
          $Destination,
          [Parameter(Mandatory=$false)]
		  [string]
          $Slashtag,
          [Parameter(Mandatory=$false)]
		  [string]
          $Title,
          [Parameter(Mandatory=$false)]
		  [string]
          $Domain)
	
	begin{
        $Header = @{
            "Accept"        = "application/json"
            "Content-Type"  = "application/json"
            "apikey"        = $RBKey
        }
        if($RBWSId){
            $Header.add("workspace",$RBWSId)
        }
    
        $apiurl = 'https://api.rebrandly.com/v1/links'

        $body = @{"destination"="$Destination"}
        if($Domain){
            $body += @{'domain'=@{'fullName'=$Domain}}
        }
        if($Slashtag){
            $body.add("slashtag","$Slashtag")
        }
        if($Title){
            $body.add("title","$Title")
        }
        Write-Verbose ($body | ConvertTo-Json)
    }
	process{
		try{
			$r = Invoke-WebRequest -Method Post -Uri $apiurl -Headers $Header -Body ($body | ConvertTo-Json)
            Write-Verbose $r

            if($r.StatusCode -eq "200" -AND $r.StatusDescription -eq "OK"){
                $r | ConvertFrom-Json
                return $true
            } else {
                $r
                return $false
            }
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