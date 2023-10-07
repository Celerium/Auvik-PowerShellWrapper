function Import-AuvikModuleSettings {
<#
    .SYNOPSIS
        Imports the Auvik BaseURI, API, & JSON configuration information to the current session.

    .DESCRIPTION
        The Import-AuvikModuleSettings cmdlet imports the Auvik BaseURI, API, & JSON configuration
        information stored in the Auvik configuration file to the users current session.

        By default the configuration file is stored in the following location:
            $env:USERPROFILE\AuvikAPI

    .PARAMETER AuvikConfPath
        Define the location to store the Auvik configuration file.

        By default the configuration file is stored in the following location:
            $env:USERPROFILE\AuvikAPI

    .PARAMETER AuvikConfFile
        Define the name of the Auvik configuration file.

        By default the configuration file is named:
            config.psd1

    .EXAMPLE
        Import-AuvikModuleSettings

        Validates that the configuration file created with the Export-AuvikModuleSettings cmdlet exists
        then imports the stored data into the current users session.

        The default location of the Auvik configuration file is:
            $env:USERPROFILE\AuvikAPI\config.psd1

    .EXAMPLE
        Import-AuvikModuleSettings -AuvikConfPath C:\AuvikAPI -AuvikConfFile MyConfig.psd1

        Validates that the configuration file created with the Export-AuvikModuleSettings cmdlet exists
        then imports the stored data into the current users session.

        The location of the Auvik configuration file in this example is:
            C:\AuvikAPI\MyConfig.psd1

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/Auvik-PowerShellWrapper/site/Internal/Import-AuvikModuleSettings.html
#>

    [CmdletBinding(DefaultParameterSetName = 'set')]
    Param (
        [Parameter(ParameterSetName = 'set')]
        [string]$AuvikConfPath = $(Join-Path -Path $home -ChildPath $(if ($IsWindows -or $PSEdition -eq 'Desktop'){"AuvikAPI"}else{".AuvikAPI"}) ),

        [Parameter(ParameterSetName = 'set')]
        [string]$AuvikConfFile = 'config.psd1'
    )

    begin {
        $AuvikConfig = Join-Path -Path $AuvikConfPath -ChildPath $AuvikConfFile
    }

    process {

        if ( Test-Path $AuvikConfig ) {
            $tmp_config = Import-LocalizedData -BaseDirectory $AuvikConfPath -FileName $AuvikConfFile

            # Send to function to strip potentially superfluous slash (/)
            Add-AuvikBaseURI $tmp_config.Auvik_Base_URI

            $tmp_config.auvik_ApiKey = ConvertTo-SecureString $tmp_config.auvik_ApiKey

            Set-Variable -Name "auvik_UserName" -Value $tmp_config.auvik_UserName -Option ReadOnly -Scope global -Force

            Set-Variable -Name "auvik_ApiKey" -Value $tmp_config.auvik_ApiKey -Option ReadOnly -Scope global -Force

            Set-Variable -Name "Auvik_JSON_Conversion_Depth" -Value $tmp_config.Auvik_JSON_Conversion_Depth -Scope global -Force

            Write-Verbose "AuvikAPI Module configuration loaded successfully from [ $AuvikConfig ]"

            # Clean things up
            Remove-Variable "tmp_config"
        }
        else {
            Write-Verbose "No configuration file found at [ $AuvikConfig ] run Add-AuvikAPIKey to get started."

            Add-AuvikBaseURI

            Set-Variable -Name "Auvik_Base_URI" -Value $(Get-AuvikBaseURI) -Option ReadOnly -Scope global -Force
            Set-Variable -Name "Auvik_JSON_Conversion_Depth" -Value 100 -Scope global -Force
        }

    }

    end {}

}