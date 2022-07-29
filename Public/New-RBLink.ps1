<#
    .SYNOPSIS
    Creates a new shortlink with rebrand.ly or a custom domain if specified.

    .DESCRIPTION
    Create a link and (optionally) apply a custom domain, slashtag, and/or title.

    .EXAMPLE
    Create a shortcut using rebrand.ly for mysite.com and title it "My Site", no slashtag.
     New-RBLink -Destination "https://mysite.com" -Title "my site"

    Create a shortcut using a custom domain for mysite.com, no title or slashtag.
     New-RBLink -Destination "https://mysite.com" -Domain "registered.domain"

    Create a shortcut using a custom domain for mysite.com with a slashtag, no title.
     New-RBLink -Destination "https://mysite.com" -Domain "registered.domain" -Slashtag "mysite"

    .PARAMETER RBWSId Optional
    If you have multiple Workspaces, you can specify that Id here. The script looks for $global:RBWSId.

    .PARAMETER RBKey Required
    You'll need an API key. The script looks for $global:RBKey.

    .PARAMETER Destination Required
    The full destination address you want to create a short url for.

    .PARAMETER Slashtag Optional
    If you want a vanity shortcut url (e.g. https://short.domain/mypage) include a slahstag.

    .PARAMETER Title Optional
    Provide a Title to organize in the UI

    .PARAMETER Domain Optional
    If you have a custom domain, include it here (e.g. "go.to")

    .OUTPUTS
    You'll have a return true/false. If it's false, you'll have a message. 
    If it's true you'll have and array like below.

    id          : XXXXX
    title       : Title
    slashtag    : go
    destination : https://feedly.com
    createdAt   : 7/29/2022 7:37:38 PM
    updatedAt   : 7/29/2022 7:37:38 PM
    expiredAt   :
    status      : active
    tags        : {}
    clicks      : 0
    isPublic    : False
    shortUrl    : rebrand.ly/go
    domainId    : XXXXX
    domainName  : rebrand.ly
    domain      : @{id=XXXXXX; ref=/domains/XXXXX; fullName=rebrand.ly;
                sharing=; active=True}
    https       : True
    favourite   : False
    creator     : @{id=XXXXXX; fullName=Your Name;
                avatarUrl=https://s.gravatar.com/avatar/XXXXXX?size=80&d=retro&rating=g}
    integrated  : False

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
        Write-Verbose ($Header.GetEnumerator() | Where {"apikey","workspace" -notcontains $_.Name} | ConvertTo-Json)

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