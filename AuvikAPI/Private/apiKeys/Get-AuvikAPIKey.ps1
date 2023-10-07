function Get-AuvikAPIKey {
<#
    .SYNOPSIS
        Gets the Auvik API public & secret key global variables.

    .DESCRIPTION
        The Get-AuvikAPIKey cmdlet gets the Auvik API public & secret key
        global variables and returns them as an object.

    .PARAMETER plainText
        Decrypt and return the API key in plain text.

    .EXAMPLE
        Get-AuvikAPIKey

        Gets the Auvik API public & secret key global variables and returns them as an object
        with the secret key as a SecureString.

    .EXAMPLE
        Get-AuvikAPIKey -plainText

        Gets the Auvik API public & secret key global variables and returns them as an object
        with the secret key as plain text.


    .NOTES
        N\A

    .LINK
        https://celerium.github.io/Auvik-PowerShellWrapper/site/Internal/Get-AuvikAPIKey.html
#>

    [cmdletbinding()]
    Param (
        [Parameter(Mandatory = $false)]
        [Switch]$plainText
    )

    begin {}

    process {

        try {

            if ($auvik_ApiKey){

                if ($plainText){
                    $Api_Key = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($auvik_ApiKey)

                    [PSCustomObject]@{
                        userName = $auvik_UserName
                        apiKey = ( [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($Api_Key) ).ToString()
                    }
                }
                else {
                    [PSCustomObject]@{
                        userName = $auvik_UserName
                        apiKey = $auvik_ApiKey
                    }
                }

            }
            else { Write-Warning "The Auvik API [ secret ] key is not set. Run Add-AuvikAPIKey to set the API key." }

        }
        catch {
            Write-Error $_
        }
        finally {
            if ($Api_Key) {
                [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($Api_Key)
            }
        }


    }

    end {}

}
