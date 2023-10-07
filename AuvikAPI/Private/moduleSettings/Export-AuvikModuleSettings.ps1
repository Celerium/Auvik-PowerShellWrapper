function Export-AuvikModuleSettings {
<#
    .SYNOPSIS
        Exports the Auvik BaseURI, API, & JSON configuration information to file.

    .DESCRIPTION
        The Export-AuvikModuleSettings cmdlet exports the Auvik BaseURI, API, & JSON configuration information to file.

        Making use of PowerShell's System.Security.SecureString type, exporting module settings encrypts your API key in a format
        that can only be unencrypted with the your Windows account as this encryption is tied to your user principal.
        This means that you cannot copy your configuration file to another computer or user account and expect it to work.

    .PARAMETER AuvikConfPath
        Define the location to store the Auvik configuration file.

        By default the configuration file is stored in the following location:
            $env:USERPROFILE\AuvikAPI

    .PARAMETER AuvikConfFile
        Define the name of the Auvik configuration file.

        By default the configuration file is named:
            config.psd1

    .EXAMPLE
        Export-AuvikModuleSettings

        Validates that the BaseURI, API, and JSON depth are set then exports their values
        to the current user's Auvik configuration file located at:
            $env:USERPROFILE\AuvikAPI\config.psd1

    .EXAMPLE
        Export-AuvikModuleSettings -AuvikConfPath C:\AuvikAPI -AuvikConfFile MyConfig.psd1

        Validates that the BaseURI, API, and JSON depth are set then exports their values
        to the current user's Auvik configuration file located at:
            C:\AuvikAPI\MyConfig.psd1

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/Auvik-PowerShellWrapper/site/Internal/Export-AuvikModuleSettings.html
#>

    [CmdletBinding(DefaultParameterSetName = 'set')]
    Param (
        [Parameter(ParameterSetName = 'set')]
        [string]$AuvikConfPath = $(Join-Path -Path $home -ChildPath $(if ($IsWindows -or $PSEdition -eq 'Desktop'){"AuvikAPI"}else{".AuvikAPI"}) ),

        [Parameter(ParameterSetName = 'set')]
        [string]$AuvikConfFile = 'config.psd1'
    )

    begin {}

    process {

        Write-Warning "Secrets are stored using Windows Data Protection API (DPAPI)"
        Write-Warning "DPAPI provides user context encryption in Windows but NOT in other operating systems like Linux or UNIX. It is recommended to use a more secure & cross-platform storage method"

        $AuvikConfig = Join-Path -Path $AuvikConfPath -ChildPath $AuvikConfFile

        # Confirm variables exist and are not null before exporting
        if ($Auvik_Base_URI -and $auvik_UserName -and $auvik_ApiKey -and $Auvik_JSON_Conversion_Depth) {
            $secureString = $auvik_ApiKey | ConvertFrom-SecureString

            if ($IsWindows -or $PSEdition -eq 'Desktop') {
                New-Item -Path $AuvikConfPath -ItemType Directory -Force | ForEach-Object { $_.Attributes = $_.Attributes -bor "Hidden" }
            }
            else{
                New-Item -Path $AuvikConfPath -ItemType Directory -Force
            }
@"
    @{
        Auvik_Base_URI = '$Auvik_Base_URI'
        auvik_UserName = '$auvik_UserName'
        auvik_ApiKey = '$secureString'
        Auvik_JSON_Conversion_Depth = '$Auvik_JSON_Conversion_Depth'
    }
"@ | Out-File -FilePath $AuvikConfig -Force
        }
        else {
            Write-Error "Failed to export Auvik Module settings to [ $AuvikConfig ]"
            Write-Error $_
            exit 1
        }

    }

    end {}

}