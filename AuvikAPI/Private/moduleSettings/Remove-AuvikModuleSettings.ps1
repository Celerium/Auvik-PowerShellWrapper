function Remove-AuvikModuleSettings {
<#
    .SYNOPSIS
        Removes the stored Auvik configuration folder.

    .DESCRIPTION
        The Remove-AuvikModuleSettings cmdlet removes the Auvik folder and its files.
        This cmdlet also has the option to remove sensitive Auvik variables as well.

        By default configuration files are stored in the following location and will be removed:
            $env:USERPROFILE\AuvikAPI

    .PARAMETER AuvikConfPath
        Define the location of the Auvik configuration folder.

        By default the configuration folder is located at:
            $env:USERPROFILE\AuvikAPI

    .PARAMETER andVariables
        Define if sensitive Auvik variables should be removed as well.

        By default the variables are not removed.

    .EXAMPLE
        Remove-AuvikModuleSettings

        Checks to see if the default configuration folder exists and removes it if it does.

        The default location of the Auvik configuration folder is:
            $env:USERPROFILE\AuvikAPI

    .EXAMPLE
        Remove-AuvikModuleSettings -AuvikConfPath C:\AuvikAPI -andVariables

        Checks to see if the defined configuration folder exists and removes it if it does.
        If sensitive Auvik variables exist then they are removed as well.

        The location of the Auvik configuration folder in this example is:
            C:\AuvikAPI

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/Auvik-PowerShellWrapper/site/Internal/Remove-AuvikModuleSettings.html
#>

    [CmdletBinding(SupportsShouldProcess, DefaultParameterSetName = 'set')]
    Param (
        [Parameter(ParameterSetName = 'set')]
        [string]$AuvikConfPath = $(Join-Path -Path $home -ChildPath $(if ($IsWindows -or $PSEdition -eq 'Desktop'){"AuvikAPI"}else{".AuvikAPI"}) ),

        [Parameter(ParameterSetName = 'set')]
        [switch]$andVariables
    )

    begin {}

    process {

        if (Test-Path $AuvikConfPath) {

            Remove-Item -Path $AuvikConfPath -Recurse -Force -WhatIf:$WhatIfPreference

            If ($andVariables) {
                Remove-AuvikAPIKey
                Remove-AuvikBaseURI
            }

            if (!(Test-Path $AuvikConfPath)) {
                Write-Output "The AuvikAPI configuration folder has been removed successfully from [ $AuvikConfPath ]"
            }
            else {
                Write-Error "The AuvikAPI configuration folder could not be removed from [ $AuvikConfPath ]"
            }

        }
        else {
            Write-Warning "No configuration folder found at [ $AuvikConfPath ]"
        }

    }

    end {}

}