<#
    .SYNOPSIS
    Get list of all links in your Rebrandly account.

    .DESCRIPTION
    Pull list of all shortcuts and return an array.

    .EXAMPLE
    Get-RBLinks

    .PARAMETER RBWSId Optional
    If you have multiple Workspaces, you can specify that Id here. The script looks for $global:RBWSId

    .PARAMETER RBKey Required
    You'll need an API key. The script looks for $global:RBKey
    
    .OUTPUTS
    An Array with the following info

    id          : XXXXX
    title       : Link short
    slashtag    : short
    destination : https://mysite.com
    createdAt   : 7/29/2022 7:51:33 PM
    updatedAt   : 7/29/2022 7:51:33 PM
    expiredAt   :
    status      : active
    tags        : {}
    clicks      : 0
    isPublic    : False
    shortUrl    : rebrand.ly/short
    domainId    : XXXXX
    domainName  : rebrand.ly
    domain      : @{id=XXXXX; ref=/domains/XXXXX; fullName=rebrand.ly; sharing=; active=True}
    https       : True
    favourite   : False
    creator     : @{id=XXXXX; fullName=Your Name; avatarUrl=https://s.gravatar.com/avatar/XXXXX?size=80&d=retro&rating=g}
    integrated  : False

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
        Write-Verbose ($Header.GetEnumerator() | Where {"apikey","workspace" -notcontains $_.Name} | ConvertTo-Json)

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