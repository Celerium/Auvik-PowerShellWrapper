function Add-AuvikAPIKey {
<#
    .SYNOPSIS
        Sets the API public & secret keys used to authenticate API calls.

    .DESCRIPTION
        The Add-AuvikAPIKey cmdlet sets the API public & secret keys which are used to
        authenticate all API calls made to Auvik.

        Once the API public & secret keys are defined, the secret key is encrypted using SecureString.

        The Auvik API public & secret keys are generated via the Auvik portal at Admin > Integrations

    .PARAMETER Api_UserName
        Defines your API username

    .PARAMETER Api_Key
        Defines your API secret key.

    .EXAMPLE
        Add-AuvikAPIKey

        Prompts to enter in the API public key and secret key.

    .EXAMPLE
        Add-AuvikAPIKey -Api_UserName '12345'

        The Auvik API will use the string entered into the [ -Api_UserName ] parameter as the
        public key & will then prompt to enter in the secret key.

    .EXAMPLE
        '12345' | Add-AuvikAPIKey

        The Auvik API will use the string entered as the secret key & will prompt to enter in the public key.

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/Auvik-PowerShellWrapper/site/Internal/Add-AuvikAPIKey.html
#>

    [cmdletbinding()]
    [alias('Set-AuvikAPIKey')]
    Param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Api_UserName,

        [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Api_Key
    )

    begin {}

    process {

        if ($Api_Key) {
            $x_api_key = ConvertTo-SecureString $Api_Key -AsPlainText -Force

            Set-Variable -Name "auvik_UserName" -Value $Api_UserName -Option ReadOnly -Scope global -Force
            Set-Variable -Name "auvik_ApiKey" -Value $x_api_key -Option ReadOnly -Scope global -Force
        }
        else {
            $x_api_key = Read-Host -Prompt 'Please enter your API key' -AsSecureString

            Set-Variable -Name "auvik_UserName" -Value $Api_UserName -Option ReadOnly -Scope global -Force
            Set-Variable -Name "auvik_ApiKey" -Value $x_api_key -Option ReadOnly -Scope global -Force
        }

    }

    end {}
}
