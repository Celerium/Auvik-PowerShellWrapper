function Remove-AuvikAPIKey {
<#
    .SYNOPSIS
        Removes the Auvik API public & secret key global variables.

    .DESCRIPTION
        The Remove-AuvikAPIKey cmdlet removes the Auvik API public & secret key global variables.

    .EXAMPLE
        Remove-AuvikAPIKey

        Removes the Auvik API public & secret key global variables.

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/Auvik-PowerShellWrapper/site/Internal/Remove-AuvikAPIKey.html
#>

    [cmdletbinding(SupportsShouldProcess)]
    Param ()

    begin {}

    process {

        switch ([bool]$auvik_UserName) {
            $true   { Remove-Variable -Name "auvik_UserName" -Scope global -Force }
            $false  { Write-Warning "The Auvik API [ public ] key is not set. Nothing to remove" }
        }

        switch ([bool]$auvik_ApiKey) {
            $true   { Remove-Variable -Name "auvik_ApiKey" -Scope global -Force }
            $false  { Write-Warning "The Auvik API [ secret ] key is not set. Nothing to remove" }
        }

    }

    end {}

}