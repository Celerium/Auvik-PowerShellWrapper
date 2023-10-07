function Remove-AuvikBaseURI {
<#
    .SYNOPSIS
        Removes the Auvik base URI global variable.

    .DESCRIPTION
        The Remove-AuvikBaseURI cmdlet removes the Auvik base URI global variable.

    .EXAMPLE
        Remove-AuvikBaseURI

        Removes the Auvik base URI global variable.

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/Auvik-PowerShellWrapper/site/Internal/Remove-AuvikBaseURI.html
#>

    [cmdletbinding(SupportsShouldProcess)]
    Param ()

    begin {}

    process {

        switch ([bool]$Auvik_Base_URI) {
            $true   { Remove-Variable -Name "Auvik_Base_URI" -Scope global -Force }
            $false  { Write-Warning "The Auvik base URI variable is not set. Nothing to remove" }
        }

    }

    end {}

}