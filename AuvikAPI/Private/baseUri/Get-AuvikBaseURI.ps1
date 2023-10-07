function Get-AuvikBaseURI {
<#
    .SYNOPSIS
        Shows the Auvik base URI global variable.

    .DESCRIPTION
        The Get-AuvikBaseURI cmdlet shows the Auvik base URI global variable value.

    .EXAMPLE
        Get-AuvikBaseURI

        Shows the Auvik base URI global variable value.

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/Auvik-PowerShellWrapper/site/Internal/Get-AuvikBaseURI.html
#>

    [cmdletbinding()]
    Param ()

    begin {}

    process {

        switch ([bool]$Auvik_Base_URI) {
            $true   { $Auvik_Base_URI }
            $false  { Write-Warning "The Auvik base URI is not set. Run Add-AuvikBaseURI to set the base URI." }
        }

    }

    end {}

}