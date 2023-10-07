#Region '.\Private\apiCalls\ConvertTo-AuvikQueryString.ps1' 0
function ConvertTo-AuvikQueryString {
<#
    .SYNOPSIS
        Converts uri filter parameters

    .DESCRIPTION
        The Invoke-AuvikRequest cmdlet converts & formats uri filter parameters
        from a function which are later used to make the full resource uri for
        an API call

        This is an internal helper function the ties in directly with the
        Invoke-AuvikRequest & any public functions that define parameters

    .PARAMETER uri_Filter
        Hashtable of values to combine a functions parameters with
        the resource_Uri parameter.

        This allows for the full uri query to occur

    .PARAMETER resource_Uri
        Defines the short resource uri (url) to use when creating the API call

    .EXAMPLE
        ConvertTo-AuvikQueryString -uri_Filter $uri_Filter -resource_Uri '/account'

        Example: (From public function)
            $uri_Filter = @{}

            ForEach ( $Key in $PSBoundParameters.GetEnumerator() ){
                if( $excludedParameters -contains $Key.Key ){$null}
                else{ $uri_Filter += @{ $Key.Key = $Key.Value } }
            }

            1x key = https://auvikapi.us1.my.auvik.com/v1/account?accountId=12345
            2x key = https://auvikapi.us1.my.auvik.com/v1/account?accountId=12345&details=True

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/Auvik-PowerShellWrapper/site/Internal/ConvertTo-AuvikQueryString.html

#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
    [hashtable]$uri_Filter,

    [Parameter(Mandatory = $true)]
    [String]$resource_Uri
)

    begin {}

    process {

        if (-not $uri_Filter) {
            return ""
        }

        $excludedParameters =   'Debug', 'ErrorAction', 'ErrorVariable', 'InformationAction', 'InformationVariable',
                                'OutBuffer', 'OutVariable', 'PipelineVariable', 'Verbose', 'WarningAction', 'WarningVariable',
                                'allPages', 'details', 'detailsExtended', 'detailsGeneral', 'audits', 'notes'

        $convertParameters = 'fields_', 'filter_', 'page_'

        $query_Parameters = [System.Web.HttpUtility]::ParseQueryString([String]::Empty)

        ForEach ( $Key in $uri_Filter.GetEnumerator() ){

            $new_KeyName = $null
            foreach ( $convertParameter in $convertParameters ){

                if ( $Key.Key -like "$convertParameter*" ) {
                    $split_KeyName  = $Key.Key -split '_'
                    $new_KeyName    = "$($split_KeyName[0])[$($split_KeyName[1])]"
                }

            }


            if ( $excludedParameters -contains $Key.Key ){ $null }
            elseif ( $Key.Value.GetType().IsArray ){

                Write-Verbose "[ $($MyInvocation.MyCommand.Name) ] - [ $($Key.Key) ] is an array parameter"

                foreach ($Value in $Key.Value) {
                    if ($new_KeyName){  $query_Parameters.Add($new_KeyName, $Value) }
                    else{               $query_Parameters.Add($Key.Key, $Value)     }
                }

            }
            elseif ( $Key.Value.GetType().FullName -eq 'System.DateTime' ){

                Write-Verbose "[ $($MyInvocation.MyCommand.Name) ] - [ $($Key.Key) ] is a dateTime parameter"

                if ($Key.Key -like "*fromDate*" -or $Key.Key -like "*thruDate*" ){
                    $universalTime = ($Key.Value).ToUniversalTime().ToString('yyyy-MM-dd')
                }
                else{
                    $universalTime = ($Key.Value).ToUniversalTime().ToString('yyyy-MM-ddTHH:mm:ss.fffZ')
                }

                Write-Verbose "[ $($MyInvocation.MyCommand.Name) ] - Converting [ $($Key.Value) ] to [ $universalTime ]"
                if ($new_KeyName){  $query_Parameters.Add($new_KeyName, $universalTime) }
                else{               $query_Parameters.Add($Key.Key, $universalTime) }

            }
            else{

                if ($new_KeyName){  $query_Parameters.Add($new_KeyName, $Key.Value) }
                else{               $query_Parameters.Add($Key.Key, $Key.Value)     }

            }

        }

        # Build the request and load it with the query string.
        $uri_Request        = [System.UriBuilder]($Auvik_Base_URI + $resource_Uri)
        $uri_Request.Query  = $query_Parameters.ToString()

        return $uri_Request

    }

    end {}

}
#EndRegion '.\Private\apiCalls\ConvertTo-AuvikQueryString.ps1' 130
#Region '.\Private\apiCalls\Get-AuvikMetaData.ps1' 0
function Get-AuvikMetaData {
<#
    .SYNOPSIS
        Gets various Api metadata values

    .DESCRIPTION
        The Get-AuvikMetaData cmdlet gets various Api metadata values from an
        Invoke-WebRequest to assist in various troubleshooting scenarios such
        as rate-limiting.

    .PARAMETER base_uri
        Define the base URI for the Auvik API connection using Auvik's URI or a custom URI.

        The default base URI is https://auvikapi.us1.my.auvik.com/v1

    .EXAMPLE
        Get-AuvikMetaData

        Gets various Api metadata values from an Invoke-WebRequest to assist
        in various troubleshooting scenarios such as rate-limiting.

        The default full base uri test path is:
            https://auvikapi.us1.my.auvik.com/v1

    .EXAMPLE
        Get-AuvikMetaData -base_uri http://myapi.gateway.example.com

        Gets various Api metadata values from an Invoke-WebRequest to assist
        in various troubleshooting scenarios such as rate-limiting.

        The full base uri test path in this example is:
            http://myapi.gateway.example.com/device

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/Auvik-PowerShellWrapper/site/Internal/Get-AuvikMetaData.html
#>

    [CmdletBinding()]
    Param (
        [parameter(Mandatory = $false, ValueFromPipeline = $true)]
        [string]$base_uri = $Auvik_Base_URI
    )

    begin { $resource_uri = "/authentication/verify" }

    process {

        try {

            $Api_Token = Get-AuvikAPIKey -plainText
            $Api_Token_base64 = [Convert]::ToBase64String( [Text.Encoding]::ASCII.GetBytes( ("{0}:{1}" -f ($Api_Token).userName,($Api_Token).apiKey) ) )

            $Auvik_Headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
            $Auvik_Headers.Add("Content-Type", 'application/json')
            $Auvik_Headers.Add('Authorization', 'Basic {0}'-f $Api_Token_base64)

            $rest_output = Invoke-WebRequest -method Get -uri ($base_uri + $resource_uri) -headers $Auvik_Headers -ErrorAction Stop
        }
        catch {

            [PSCustomObject]@{
                Method = $_.Exception.Response.Method
                StatusCode = $_.Exception.Response.StatusCode.value__
                StatusDescription = $_.Exception.Response.StatusDescription
                Message = $_.Exception.Message
                URI = $($Auvik_Base_URI + $resource_uri)
            }

        }
        finally {
            Remove-Variable -Name Auvik_Headers -Force
        }

        if ($rest_output){
            $data = @{}
            $data = $rest_output

            [PSCustomObject]@{
                ResponseUri             = $data.BaseResponse.ResponseUri.AbsoluteUri
                ResponsePort            = $data.BaseResponse.ResponseUri.Port
                StatusCode              = $data.StatusCode
                StatusDescription       = $data.StatusDescription
                'Content-Type'          = $data.headers.'Content-Type'
                'X-Request-Id'          = $data.headers.'X-Request-Id'
                'X-API-Limit-Remaining' = $data.headers.'X-API-Limit-Remaining'
                'X-API-Limit-Resets'    = $data.headers.'X-API-Limit-Resets'
                'X-API-Limit-Cost'      = $data.headers.'X-API-Limit-Cost'
                raw                     = $data
            }
        }

    }

    end {}
}
#EndRegion '.\Private\apiCalls\Get-AuvikMetaData.ps1' 99
#Region '.\Private\apiCalls\Invoke-AuvikRequest.ps1' 0
function Invoke-AuvikRequest {
<#
    .SYNOPSIS
        Makes an API request

    .DESCRIPTION
        The Invoke-AuvikRequest cmdlet invokes an API request to Auvik API.

        This is an internal function that is used by all public functions

        As of 2023-08 the Auvik v1 API only supports GET requests

    .PARAMETER method
        Defines the type of API method to use

        Allowed values:
        'GET'

    .PARAMETER resource_Uri
        Defines the resource uri (url) to use when creating the API call

    .PARAMETER uri_Filter
        Used with the internal function [ ConvertTo-AuvikQueryString ] to combine
        a functions parameters with the resource_Uri parameter.

        This allows for the full uri query to occur

        The full resource path is made with the following data
        $Auvik_Base_URI + $resource_Uri + ConvertTo-AuvikQueryString

    .PARAMETER data
        Place holder parameter to use when other methods are supported
        by the Auvik v1 API

    .PARAMETER allPages
        Returns all items from an endpoint

        When using this parameter there is no need to use either the page or perPage
        parameters

    .EXAMPLE
        Invoke-AuvikRequest -method GET -resource_Uri '/account' -uri_Filter $uri_Filter

        Invoke a rest method against the defined resource using any of the provided parameters

        Example:
            Name                           Value
            ----                           -----
            Method                         GET
            Uri                            https://auvikapi.us1.my.auvik.com/v1/account?accountId=12345&details=True
            Headers                        {Authorization = Bearer 123456789}
            Body


    .NOTES
        N\A

    .LINK
        https://celerium.github.io/Auvik-PowerShellWrapper/site/Internal/Invoke-AuvikRequest.html

#>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [ValidateSet('GET', 'POST')]
        [String]$method = 'GET',

        [Parameter(Mandatory = $true)]
        [String]$resource_Uri,

        [Parameter(Mandatory = $false)]
        [Hashtable]$uri_Filter = $null,

        [Parameter(Mandatory = $false)]
        [Hashtable]$data = $null,

        [Parameter(Mandatory = $false)]
        [Switch]$allPages

    )

    begin {}

    process {

        # Load Web assembly when needed as PowerShell Core has the assembly preloaded
        if ( !("System.Web.HttpUtility" -as [Type]) ) {
            Add-Type -Assembly System.Web
        }

        $query_string = ConvertTo-AuvikQueryString -uri_Filter $uri_Filter -resource_Uri $resource_Uri

        Set-Variable -Name 'Auvik_queryString' -Value $query_string -Scope Global -Force

        if ($null -eq $data) {
            $body = $null
        } else {
            $body = @{'data'= $data} | ConvertTo-Json -Depth $Auvik_JSON_Conversion_Depth
        }

        try {
            $Api_Token = Get-AuvikAPIKey -PlainText
            $Api_Token_base64 = [Convert]::ToBase64String( [Text.Encoding]::ASCII.GetBytes( ("{0}:{1}" -f ($Api_Token).userName,($Api_Token).apiKey) ) )

            $parameters = [ordered] @{
                "Method"    = $method
                "Uri"       = $query_string.Uri
                "Headers"   = @{ 'Authorization' = 'Basic {0}'-f $Api_Token_base64 }
                "Body"      = $body
            }

                if ( $method -ne 'GET' ) {
                    $parameters['ContentType'] = 'application/vnd.api+json; charset=utf-8'
                }

            Set-Variable -Name 'Auvik_invokeParameters' -Value $parameters -Scope Global -Force

            if ($allPages){

                Write-Verbose "[ $($MyInvocation.MyCommand.Name) ] - Gathering all items from [ $( $parameters.uri.LocalPath ) ] "

                $page_number = 1
                $all_responseData = [System.Collections.Generic.List[object]]::new()

                do {

                    $current_page = Invoke-RestMethod @parameters -ErrorAction Stop

                    Write-Verbose "[ $page_number ] of [ $($current_page.meta.totalPages) ] pages"

                        foreach ($item in $current_page.data){
                            $all_responseData.add($item)
                        }

                    $parameters.Remove('Uri') > $null
                    $parameters.Add('Uri',$current_page.links.next)

                    $page_number++

                } while ( $null -ne $current_page.links.next <#-and $current_page.meta.totalPages -ne 0#> )

            }
            else{
                Write-Verbose "[ $($MyInvocation.MyCommand.Name) ] - Gathering items from [ $( $parameters.uri.LocalPath ) ] "

                $api_response = Invoke-RestMethod @parameters -ErrorAction Stop
            }

        }
        catch {

            $exceptionError = $_.Exception.Message
            Write-Warning 'The [ Auvik_invokeParameters, Auvik_queryString, & Auvik_<CmdletName>Parameters ] variables can provide extra details'

            switch -Wildcard ($exceptionError) {
                '*308*' { Write-Error "Invoke-AuvikRequest : Permanent Redirect, check assigned region" }
                '*404*' { Write-Error "Invoke-AuvikRequest : Uri not found - [ $resource_Uri ]" }
                '*429*' { Write-Error 'Invoke-AuvikRequest : API rate limited' }
                '*504*' { Write-Error "Invoke-AuvikRequest : Gateway Timeout" }
                default { Write-Error $_ }
            }

        }
        finally {

            $Auth = $Auvik_invokeParameters['headers']['Authorization']
            $Auvik_invokeParameters['headers']['Authorization'] = $Auth.Substring( 0, [Math]::Min($Auth.Length, 9) ) + '*******'

        }


        if($allPages){

            #Making output consistent
            if( [string]::IsNullOrEmpty($all_responseData.data) ){
                $api_response = $null
            }
            else{
                $api_response = [PSCustomObject]@{
                    data    = $all_responseData
                    links   = $null
                    meta    = $null
                }
            }

            return $api_response

        }
        else{ return $api_response }

    }

    end {}

}
#EndRegion '.\Private\apiCalls\Invoke-AuvikRequest.ps1' 197
#Region '.\Private\apiKeys\Add-AuvikAPIKey.ps1' 0
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
#EndRegion '.\Private\apiKeys\Add-AuvikAPIKey.ps1' 76
#Region '.\Private\apiKeys\Get-AuvikAPIKey.ps1' 0
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
#EndRegion '.\Private\apiKeys\Get-AuvikAPIKey.ps1' 81
#Region '.\Private\apiKeys\Remove-AuvikAPIKey.ps1' 0
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
#EndRegion '.\Private\apiKeys\Remove-AuvikAPIKey.ps1' 43
#Region '.\Private\baseUri\Add-AuvikBaseURI.ps1' 0
function Add-AuvikBaseURI {
<#
    .SYNOPSIS
        Sets the base URI for the Auvik API connection.

    .DESCRIPTION
        The Add-AuvikBaseURI cmdlet sets the base URI which is later used
        to construct the full URI for all API calls.

    .PARAMETER base_uri
        Define the base URI for the Auvik API connection using Auvik's URI or a custom URI.

    .PARAMETER data_center
        Auvik's URI connection point that can be one of the predefined data centers.

        https://support.auvik.com/hc/en-us/articles/360033412992

        Accepted Values:
        'au1', 'ca1', 'eu1', 'eu2', 'us1', 'us2', 'us3', 'us4'

        Example:
            us3 = https://auvikapi.us3.my.auvik.com/v1

    .EXAMPLE
        Add-AuvikBaseURI

        The base URI will use https://auvikapi.us1.my.auvik.com/v1 which is Auvik's default URI.

    .EXAMPLE
        Add-AuvikBaseURI -data_center US

        The base URI will use https://auvikapi.us1.my.auvik.com/v1 which is Auvik's US URI.

    .EXAMPLE
        Add-AuvikBaseURI -base_uri http://myapi.gateway.example.com

        A custom API gateway of http://myapi.gateway.example.com will be used for all API calls to Auvik's API.

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/Auvik-PowerShellWrapper/site/Internal/Add-AuvikBaseURI.html
#>

    [cmdletbinding()]
    [alias('Set-AuvikBaseURI')]
    Param (
        [Parameter(Mandatory = $false , ValueFromPipeline = $true)]
        [string]$base_uri = 'https://auvikapi.us1.my.auvik.com/v1',

        [Parameter(Mandatory = $false)]
        [ValidateSet( 'au1', 'ca1', 'eu1', 'eu2', 'us1', 'us2', 'us3', 'us4' )]
        [String]$data_center
    )

    begin {}

    process {

        # Trim superfluous forward slash from address (if applicable)
        if ($base_uri[$base_uri.Length-1] -eq "/") {
            $base_uri = $base_uri.Substring(0,$base_uri.Length-1)
        }

        if ($data_center){
            $base_uri = "https://auvikapi.$data_center.my.auvik.com/v1"
        }

        Set-Variable -Name "Auvik_Base_URI" -Value $base_uri -Option ReadOnly -Scope global -Force

    }

    end {}

}
#EndRegion '.\Private\baseUri\Add-AuvikBaseURI.ps1' 77
#Region '.\Private\baseUri\Get-AuvikBaseURI.ps1' 0
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
#EndRegion '.\Private\baseUri\Get-AuvikBaseURI.ps1' 38
#Region '.\Private\baseUri\Remove-AuvikBaseURI.ps1' 0
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
#EndRegion '.\Private\baseUri\Remove-AuvikBaseURI.ps1' 38
#Region '.\Private\moduleSettings\Export-AuvikModuleSettings.ps1' 0
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
#EndRegion '.\Private\moduleSettings\Export-AuvikModuleSettings.ps1' 94
#Region '.\Private\moduleSettings\Get-AuvikModuleSettings.ps1' 0
function Get-AuvikModuleSettings {
<#
    .SYNOPSIS
        Gets the saved Auvik configuration settings

    .DESCRIPTION
        The Get-AuvikModuleSettings cmdlet gets the saved Auvik configuration settings
        from the local system.

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

    .PARAMETER openConfFile
        Opens the Auvik configuration file

    .EXAMPLE
        Get-AuvikModuleSettings

        Gets the contents of the configuration file that was created with the
        Export-AuvikModuleSettings

        The default location of the Auvik configuration file is:
            $env:USERPROFILE\AuvikAPI\config.psd1

    .EXAMPLE
        Get-AuvikModuleSettings -AuvikConfPath C:\AuvikAPI -AuvikConfFile MyConfig.psd1 -openConfFile

        Opens the configuration file from the defined location in the default editor

        The location of the Auvik configuration file in this example is:
            C:\AuvikAPI\MyConfig.psd1

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/Auvik-PowerShellWrapper/site/Internal/Get-AuvikModuleSettings.html
#>

    [CmdletBinding(DefaultParameterSetName = 'index')]
    Param (
        [Parameter(Mandatory = $false, ParameterSetName = 'index')]
        [string]$AuvikConfPath = $(Join-Path -Path $home -ChildPath $(if ($IsWindows -or $PSEdition -eq 'Desktop'){"AuvikAPI"}else{".AuvikAPI"}) ),

        [Parameter(Mandatory = $false, ParameterSetName = 'index')]
        [String]$AuvikConfFile = 'config.psd1',

        [Parameter(Mandatory = $false, ParameterSetName = 'show')]
        [Switch]$openConfFile
    )

    begin {
        $AuvikConfig = Join-Path -Path $AuvikConfPath -ChildPath $AuvikConfFile
    }

    process {

        if ( Test-Path -Path $AuvikConfig ){

            if($openConfFile){
                Invoke-Item -Path $AuvikConfig
            }
            else{
                Import-LocalizedData -BaseDirectory $AuvikConfPath -FileName $AuvikConfFile
            }

        }
        else{
            Write-Verbose "No configuration file found at [ $AuvikConfig ]"
        }

    }

    end {}

}
#EndRegion '.\Private\moduleSettings\Get-AuvikModuleSettings.ps1' 89
#Region '.\Private\moduleSettings\Import-AuvikModuleSettings.ps1' 0
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
#EndRegion '.\Private\moduleSettings\Import-AuvikModuleSettings.ps1' 98
#Region '.\Private\moduleSettings\Initialize-AuvikModuleSettings.ps1' 0
#Used to auto load either baseline settings or saved configurations when the module is imported
Import-AuvikModuleSettings -Verbose:$false
#EndRegion '.\Private\moduleSettings\Initialize-AuvikModuleSettings.ps1' 3
#Region '.\Private\moduleSettings\Remove-AuvikModuleSettings.ps1' 0
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
#EndRegion '.\Private\moduleSettings\Remove-AuvikModuleSettings.ps1' 87
#Region '.\Public\alert\Clear-AuvikAlert.ps1' 0
function Clear-AuvikAlert {
<#
    .SYNOPSIS
        Clear an Auvik alert

    .DESCRIPTION
        The Clear-AuvikAlert cmdlet allows you to dismiss an
        alert that Auvik has triggered.

    .PARAMETER id
        ID of alert

    .EXAMPLE
        Clear-AuvikAlert -id 123456789

        Clears the defined alert

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/Auvik-PowerShellWrapper/site/alert/Clear-AuvikAlert.html
#>

    [CmdletBinding(DefaultParameterSetName = 'clearByAlert' )]
    Param (
        [Parameter( Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = 'clearByAlert' )]
        [ValidateNotNullOrEmpty()]
        [string]$id
    )

    begin {

        switch ( $($PSCmdlet.ParameterSetName) ) {
            'clearByAlert' { $resource_uri = "/alert/dismiss/$id" }
        }

    }

    process {

        Write-Verbose "[ $($MyInvocation.MyCommand.Name) ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        #Region     [ Adjust parameters ]

            if( $PSBoundParameters.ContainsKey('id') ) {
                $PSBoundParameters.Remove('id') > $null
            }

        #EndRegion  [ Adjust  parameters ]

        Set-Variable -Name 'Auvik_alertClearParameters' -Value $PSBoundParameters -Scope Global -Force

        Invoke-AuvikRequest -method POST -resource_Uri $resource_Uri -uri_Filter $PSBoundParameters

    }

    end {}

}
#EndRegion '.\Public\alert\Clear-AuvikAlert.ps1' 61
#Region '.\Public\alert\Get-AuvikAlert.ps1' 0
function Get-AuvikAlert {
<#
    .SYNOPSIS
        Get Auvik alert events that have been triggered by your Auvik collector(s).

    .DESCRIPTION
        The Get-AuvikAlert cmdlet allows you to view the alert events
        that has been triggered by your Auvik collector(s).

    .PARAMETER id
        ID of alert

    .PARAMETER tenants
        Comma delimited list of tenant IDs to request info from

    .PARAMETER filter_alertDefinitionId
        Filter by alert definition ID

    .PARAMETER filter_severity
        Filter by alert severity

        Allowed values:
            "unknown", "emergency", "critical", "warning", "info"

    .PARAMETER filter_status
        Filter by the status of the alert

        Allowed values:
            "created", "resolved", "paused", "unpaused"

    .PARAMETER filter_entityId
        Filter by the related entity ID

    .PARAMETER filter_dismissed
        Filter by the dismissed status

        As of 2023-10 this parameter does not appear to work

    .PARAMETER filter_dispatched
        Filter by dispatched status

        As of 2023-10 this parameter does not appear to work

    .PARAMETER filter_detectedTimeAfter
        Filter by the time which is greater than the given timestamp

    .PARAMETER filter_detectedTimeBefore
        Filter by the time which is less than or equal to the given timestamp

    .PARAMETER page_first
        For paginated responses, the first N elements will be returned
        Used in combination with page[after]

        Default Value: 100

    .PARAMETER page_after
        Cursor after which elements will be returned as a page
        The page size is provided by page[first]

    .PARAMETER page_last
        For paginated responses, the last N services will be returned
        Used in combination with page[before]

        Default Value: 100

    .PARAMETER page_before
        Cursor before which elements will be returned as a page
        The page size is provided by page[last]

    .PARAMETER allPages
        Returns all items from an endpoint

        Highly recommended to only use with filters to reduce API errors\timeouts

    .EXAMPLE
        Get-AuvikAlert

        Pulls general information about the first 100 alerts
        Auvik has discovered

    .EXAMPLE
        Get-AuvikAlert -id 123456789

        Pulls general information for the defined alert
        Auvik has discovered

    .EXAMPLE
        Get-AuvikAlert -page_first 1000 -allPages

        Pulls general information for all alerts found by Auvik.

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/Auvik-PowerShellWrapper/site/alert/Get-AuvikAlert.html
#>

    [CmdletBinding(DefaultParameterSetName = 'indexByMultiAlertGeneral' )]
    Param (
        [Parameter( Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = 'indexBySingleAlertGeneral' )]
        [ValidateNotNullOrEmpty()]
        [string]$id,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiAlertGeneral' )]
        [ValidateNotNullOrEmpty()]
        [string[]]$tenants,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiAlertGeneral' )]
        [ValidateNotNullOrEmpty()]
        [string]$filter_alertDefinitionId,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiAlertGeneral' )]
        [ValidateSet( "unknown", "emergency", "critical", "warning", "info" )]
        [string]$filter_severity,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiAlertGeneral' )]
        [ValidateSet( "created", "resolved", "paused", "unpaused" )]
        [string]$filter_status,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiAlertGeneral' )]
        [ValidateNotNullOrEmpty()]
        [string]$filter_entityId,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiAlertGeneral' )]
        [switch]$filter_dismissed,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiAlertGeneral' )]
        [switch]$filter_dispatched,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiAlertGeneral' )]
        [ValidateNotNullOrEmpty()]
        [DateTime]$filter_detectedTimeAfter,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiAlertGeneral' )]
        [ValidateNotNullOrEmpty()]
        [DateTime]$filter_detectedTimeBefore,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiAlertGeneral' )]
        [ValidateRange(1, [int64]::MaxValue)]
        [int64]$page_first,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiAlertGeneral' )]
        [ValidateNotNullOrEmpty()]
        [string]$page_after,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiAlertGeneral' )]
        [ValidateRange(1, [int64]::MaxValue)]
        [int64]$page_last,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiAlertGeneral' )]
        [ValidateNotNullOrEmpty()]
        [string]$page_before,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiAlertGeneral' )]
        [switch]$allPages
    )

    begin {

        switch ( $($PSCmdlet.ParameterSetName) ) {
            'indexByMultiAlertGeneral'     { $resource_uri = "/alert/history/info" }
            'indexBySingleAlertGeneral'    { $resource_uri = "/alert/history/info/$id" }

        }

    }

    process {

        Write-Verbose "[ $($MyInvocation.MyCommand.Name) ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        #Region     [ Adjust parameters ]

            if( $PSBoundParameters.ContainsKey('id') ) {
                $PSBoundParameters.Remove('id') > $null
            }

        #EndRegion  [ Adjust  parameters ]

        Set-Variable -Name 'Auvik_alertParameters' -Value $PSBoundParameters -Scope Global -Force

        Invoke-AuvikRequest -method GET -resource_Uri $resource_Uri -uri_Filter $PSBoundParameters -allPages:$allPages

    }

    end {}

}
#EndRegion '.\Public\alert\Get-AuvikAlert.ps1' 190
#Region '.\Public\billing\Get-AuvikBilling.ps1' 0
function Get-AuvikBilling {
<#
    .SYNOPSIS
        Get Auvik billing information

    .DESCRIPTION
        The Get-AuvikBilling cmdlet gets billing information
        to help calculate your invoices

        The dataTime value are converted to UTC, however for these endpoints
        you will only need to defined yyyy-MM-dd

    .PARAMETER filter_fromDate
        Date from which you want to query

        Example: filter[fromDate]=2019-06-01

    .PARAMETER filter_thruDate
        Date to which you want to query

        Example: filter[thruDate]=2019-06-30

    .PARAMETER tenants
        Comma delimited list of tenant IDs to request info from.

        Example: tenants=199762235015168516,199762235015168004

    .PARAMETER id
        ID of device

    .EXAMPLE
        Get-AuvikBilling -filter_fromDate 2023-09-01 -filter_thruDate 2023-09-30

        Pulls a summary of a client's (and client's children if a multi-client)
        usage for the given time range.

    .EXAMPLE
        Get-AuvikBilling -filter_fromDate 2023-09-01 -filter_thruDate 2023-09-30 -tenants 12345,98765

        Pulls a summary of the defined client's (and client's children if a multi-client)
        usage for the given time range.

    .EXAMPLE
        Get-AuvikBilling -filter_fromDate 2023-09-01 -filter_thruDate 2023-09-30 -id 123456789

        Pulls a summary of the define device id's usage for the given time range.

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/Auvik-PowerShellWrapper/site/billing/Get-AuvikBilling.html
#>

    [CmdletBinding(DefaultParameterSetName = 'indexByClient')]
    Param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [DateTime]$filter_fromDate,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [DateTime]$filter_thruDate,

        [Parameter(Mandatory = $false, ValueFromPipeline = $true, ParameterSetName = 'indexByClient')]
        [ValidateNotNullOrEmpty()]
        [string[]]$tenants,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = 'indexByDevice')]
        [ValidateNotNullOrEmpty()]
        [string]$id
    )

    begin {

        switch ( $($PSCmdlet.ParameterSetName) ) {
            'indexByClient' { $resource_uri = "/billing/usage/client" }
            'indexByDevice' { $resource_uri = "/billing/usage/device/$id" }
        }

    }

    process {

        Write-Verbose "[ $($MyInvocation.MyCommand.Name) ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        #Region     [ Remove path parameters ]

        if( $PSBoundParameters.ContainsKey('id') ) {
            $PSBoundParameters.Remove('id') > $null
        }

        #EndRegion  [ Remove path parameters ]

        Set-Variable -Name 'Auvik_billingParameters' -Value $PSBoundParameters -Scope Global -Force

        Invoke-AuvikRequest -method GET -resource_Uri $resource_Uri -uri_Filter $PSBoundParameters

    }

    end {}

}
#EndRegion '.\Public\billing\Get-AuvikBilling.ps1' 104
#Region '.\Public\clientManagement\Get-AuvikTenant.ps1' 0
function Get-AuvikTenant {
<#
    .SYNOPSIS
        Get Auvik tenant information

    .DESCRIPTION
        The Get-AuvikTenant cmdlet get Auvik general or detailed
        tenant information associated to your Auvik user account

    .PARAMETER tenantDomainPrefix
        Domain prefix of your main Auvik account (tenant).

    .PARAMETER filter_availableTenants
        Filter whether or not a tenant is available,
        i.e. data can be gotten from them via the API.

    .PARAMETER id
        ID of tenant

    .EXAMPLE
        Get-AuvikTenant

        Pulls general information about multiple multi-clients and
        clients associated with your Auvik user account.

    .EXAMPLE
        Get-AuvikTenant -tenantDomainPrefix CeleriumMSP

        Pulls detailed information about multiple multi-clients and
        clients associated with your main Auvik account.

    .EXAMPLE
        Get-AuvikTenant -tenantDomainPrefix CeleriumMSP -id 123456789

        Pulls detailed information about a single tenant from
        your main Auvik account.

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/Auvik-PowerShellWrapper/site/clientManagement/Get-AuvikTenant.html
#>

    [CmdletBinding(DefaultParameterSetName = 'indexMultiTenant')]
    Param (
        [Parameter(Mandatory = $true, ParameterSetName = 'indexMultiTenantDetails')]
        [Parameter(Mandatory = $true, ParameterSetName = 'indexSingleTenantDetails')]
        [ValidateNotNullOrEmpty()]
        [string]$tenantDomainPrefix,

        [Parameter(Mandatory = $false, ParameterSetName = 'indexMultiTenantDetails')]
        [switch]$filter_availableTenants,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = 'indexSingleTenantDetails')]
        [ValidateNotNullOrEmpty()]
        [string]$id
    )

    begin {

        switch ( $($PSCmdlet.ParameterSetName) ) {
            'indexMultiTenant'          { $resource_uri = "/tenants" }
            'indexMultiTenantDetails'   { $resource_uri = "/tenants/detail" }
            'indexSingleTenantDetails'  { $resource_uri = "/tenants/detail/$id" }
        }

    }

    process {

        Write-Verbose "[ $($MyInvocation.MyCommand.Name) ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        #Region     [ Remove path parameters ]

        if( $PSBoundParameters.ContainsKey('id') ) {
            $PSBoundParameters.Remove('id') > $null
        }

        #EndRegion  [ Remove path parameters ]

        Set-Variable -Name 'Auvik_tenantParameters' -Value $PSBoundParameters -Scope Global -Force

        Invoke-AuvikRequest -method GET -resource_Uri $resource_Uri -uri_Filter $PSBoundParameters

    }

    end {}

}
#EndRegion '.\Public\clientManagement\Get-AuvikTenant.ps1' 91
#Region '.\Public\inventory\Get-AuvikComponent.ps1' 0
function Get-AuvikComponent {
<#
    .SYNOPSIS
        Get Auvik components and other related information

    .DESCRIPTION
        The Get-AuvikComponent cmdlet allows you to view an inventory of
        components and other related information discovered by Auvik.

    .PARAMETER id
        ID of component

    .PARAMETER tenants
        Comma delimited list of tenant IDs to request info from

    .PARAMETER filter_modifiedAfter
        Filter by date and time, only returning entities modified after provided value

    .PARAMETER filter_deviceId
        Filter by the component's parent device's ID

    .PARAMETER filter_deviceName
        Filter by the component's parent device's name

    .PARAMETER filter_currentStatus
        Filter by the component's current status

        Allowed values:
            "ok", "degraded", "failed"

    .PARAMETER page_first
        For paginated responses, the first N elements will be returned
        Used in combination with page[after]

        Default Value: 100

    .PARAMETER page_after
        Cursor after which elements will be returned as a page
        The page size is provided by page[first]

    .PARAMETER page_last
        For paginated responses, the last N services will be returned
        Used in combination with page[before]

        Default Value: 100

    .PARAMETER page_before
        Cursor before which elements will be returned as a page
        The page size is provided by page[last]

    .PARAMETER allPages
        Returns all items from an endpoint

        Highly recommended to only use with filters to reduce API errors\timeouts

    .EXAMPLE
        Get-AuvikComponent

        Pulls general information about the first 100 components
        Auvik has discovered

    .EXAMPLE
        Get-AuvikComponent -id 123456789

        Pulls general information for the defined component
        Auvik has discovered

    .EXAMPLE
        Get-AuvikComponent -page_first 1000 -allPages

        Pulls general information for all components found by Auvik.

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/Auvik-PowerShellWrapper/site/inventory/Get-AuvikComponent.html
#>

    [CmdletBinding(DefaultParameterSetName = 'indexByMultiComponentGeneral' )]
    Param (
        [Parameter( Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = 'indexBySingleComponentGeneral' )]
        [ValidateNotNullOrEmpty()]
        [string]$id,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiComponentGeneral' )]
        [ValidateNotNullOrEmpty()]
        [string[]]$tenants,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiComponentGeneral' )]
        [ValidateNotNullOrEmpty()]
        [DateTime]$filter_modifiedAfter,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiComponentGeneral' )]
        [ValidateNotNullOrEmpty()]
        [string]$filter_deviceId,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiComponentGeneral' )]
        [ValidateNotNullOrEmpty()]
        [string]$filter_deviceName,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiComponentGeneral' )]
        [ValidateSet( "ok", "degraded", "failed" )]
        [string]$filter_currentStatus,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiComponentGeneral' )]
        [ValidateRange(1, [int64]::MaxValue)]
        [int64]$page_first,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiComponentGeneral' )]
        [ValidateNotNullOrEmpty()]
        [string]$page_after,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiComponentGeneral' )]
        [ValidateRange(1, [int64]::MaxValue)]
        [int64]$page_last,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiComponentGeneral' )]
        [ValidateNotNullOrEmpty()]
        [string]$page_before,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiComponentGeneral' )]
        [switch]$allPages
    )

    begin {

        switch ( $($PSCmdlet.ParameterSetName) ) {
            'indexByMultiComponentGeneral'  { $resource_uri = "/inventory/component/info" }
            'indexBySingleComponentGeneral' { $resource_uri = "/inventory/component/info/$id" }
        }

    }

    process {

        Write-Verbose "[ $($MyInvocation.MyCommand.Name) ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        #Region     [ Adjust parameters ]

            if( $PSBoundParameters.ContainsKey('id') ) {
                $PSBoundParameters.Remove('id') > $null
            }

        #EndRegion  [ Adjust  parameters ]

        Set-Variable -Name 'Auvik_componentParameters' -Value $PSBoundParameters -Scope Global -Force

        Invoke-AuvikRequest -method GET -resource_Uri $resource_Uri -uri_Filter $PSBoundParameters -allPages:$allPages

    }

    end {}

}
#EndRegion '.\Public\inventory\Get-AuvikComponent.ps1' 156
#Region '.\Public\inventory\Get-AuvikConfiguration.ps1' 0
function Get-AuvikConfiguration {
<#
    .SYNOPSIS
        Get Auvik history of device configurations

    .DESCRIPTION
        The Get-AuvikConfiguration cmdlet allows you to view a history of
        device configurations and other related information discovered by Auvik.

    .PARAMETER id
        ID of entity note\audit

    .PARAMETER tenants
        Comma delimited list of tenant IDs to request info from

    .PARAMETER filter_deviceId
        Filter by device ID

    .PARAMETER filter_backupTimeAfter
        Filter by date and time, filtering out configurations backed up before value

    .PARAMETER filter_backupTimeBefore
        Filter by date and time, filtering out configurations backed up after value.

    .PARAMETER filter_isRunning
        Filter for configurations that are currently running, or filter
        for all configurations which are not currently running.

        As of 2023-10, this does not appear to function correctly on this endpoint

    .PARAMETER page_first
        For paginated responses, the first N elements will be returned
        Used in combination with page[after]

        Default Value: 100

    .PARAMETER page_after
        Cursor after which elements will be returned as a page
        The page size is provided by page[first]

    .PARAMETER page_last
        For paginated responses, the last N services will be returned
        Used in combination with page[before]

        Default Value: 100

    .PARAMETER page_before
        Cursor before which elements will be returned as a page
        The page size is provided by page[last]

    .PARAMETER allPages
        Returns all items from an endpoint

        Highly recommended to only use with filters to reduce API errors\timeouts

    .EXAMPLE
        Get-AuvikConfiguration

        Pulls general information about the first 100 configurations
        Auvik has discovered

    .EXAMPLE
        Get-AuvikConfiguration -id 123456789

        Pulls general information for the defined configuration
        Auvik has discovered

    .EXAMPLE
        Get-AuvikConfiguration -page_first 1000 -allPages

        Pulls general information for all configurations found by Auvik.

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/Auvik-PowerShellWrapper/site/inventory/Get-AuvikConfiguration.html
#>

    [CmdletBinding(DefaultParameterSetName = 'indexByMultiConfigGeneral' )]
    Param (
        [Parameter( Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = 'indexBySingleConfigGeneral' )]
        [ValidateNotNullOrEmpty()]
        [string]$id,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiConfigGeneral' )]
        [ValidateNotNullOrEmpty()]
        [string[]]$tenants,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiConfigGeneral' )]
        [ValidateNotNullOrEmpty()]
        [string]$filter_deviceId,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiConfigGeneral' )]
        [ValidateNotNullOrEmpty()]
        [DateTime]$filter_backupTimeAfter,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiConfigGeneral' )]
        [ValidateNotNullOrEmpty()]
        [DateTime]$filter_backupTimeBefore,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiConfigGeneral' )]
        [switch]$filter_isRunning,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiConfigGeneral' )]
        [ValidateRange(1, [int64]::MaxValue)]
        [int64]$page_first,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiConfigGeneral' )]
        [ValidateNotNullOrEmpty()]
        [string]$page_after,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiConfigGeneral' )]
        [ValidateRange(1, [int64]::MaxValue)]
        [int64]$page_last,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiConfigGeneral' )]
        [ValidateNotNullOrEmpty()]
        [string]$page_before,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiConfigGeneral' )]
        [switch]$allPages
    )

    begin {

        switch ( $($PSCmdlet.ParameterSetName) ) {
            'indexByMultiConfigGeneral'     { $resource_uri = "/inventory/configuration" }
            'indexBySingleConfigGeneral'    { $resource_uri = "/inventory/configuration/$id" }

        }

    }

    process {

        Write-Verbose "[ $($MyInvocation.MyCommand.Name) ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        #Region     [ Adjust parameters ]

            if( $PSBoundParameters.ContainsKey('id') ) {
                $PSBoundParameters.Remove('id') > $null
            }

        #EndRegion  [ Adjust  parameters ]

        Set-Variable -Name 'Auvik_configurationParameters' -Value $PSBoundParameters -Scope Global -Force

        Invoke-AuvikRequest -method GET -resource_Uri $resource_Uri -uri_Filter $PSBoundParameters -allPages:$allPages

    }

    end {}

}
#EndRegion '.\Public\inventory\Get-AuvikConfiguration.ps1' 156
#Region '.\Public\inventory\Get-AuvikDevice.ps1' 0
function Get-AuvikDevice {
<#
    .SYNOPSIS
        Get Auvik devices and other related information

    .DESCRIPTION
        The Get-AuvikDevice cmdlet allows you to view an inventory of
        devices and other related information discovered by Auvik.

        Use the [ -details, -detailsExtended, & -detailsGeneral  ] parameters
        when wanting to target specific information.

        See Get-Help Get-AuvikDevice -Full for more information on associated parameters

        This function combines 6 endpoints together within the Device API.

        Read Multiple Devices' Info:
            Pulls detail about multiple devices discovered on your client's network.
        Read a Single Device's Info:
            Pulls detail about a specific device discovered on your client's network.

        Read Multiple Devices' Details:
            Pulls details about multiple devices not already included in the Device Info API.
        Read a Single Device's Details:
            Pulls details about a specific device not already included in the Device Info API.

        Read Multiple Device's Extended Details:
            Pulls extended information about multiple devices not already included in the Device Info API.
        Read a Single Device's Extended Details:
            Pulls extended information about a specific device not already included in the Device Info API.

    .PARAMETER id
        ID of device

    .PARAMETER tenants
        Comma delimited list of tenant IDs to request info from

    .PARAMETER filter_networks
        Filter by IDs of networks this device is on

    .PARAMETER filter_manageStatus
        Filter by managed status

    .PARAMETER filter_discoverySNMP
        Filter by the device's SNMP discovery status

        Allowed values:
            "disabled", "determining", "notSupported", "notAuthorized", "authorizing", "authorized", "privileged"

    .PARAMETER filter_discoveryWMI
        Filter by the device's WMI discovery status

        Allowed values:
            "disabled", "determining", "notSupported", "notAuthorized", "authorizing", "authorized", "privileged"

    .PARAMETER filter_discoveryLogin
        Filter by the device's Login discovery status

        Allowed values:
            "disabled", "determining", "notSupported", "notAuthorized", "authorizing", "authorized", "privileged"

    .PARAMETER filter_discoveryVMware
        Filter by the device's VMware discovery status

        Allowed values:
            "disabled", "determining", "notSupported", "notAuthorized", "authorizing", "authorized", "privileged"

    .PARAMETER filter_trafficInsightsStatus
        Filter by the device's VMware discovery status

        Allowed values:
            "notDetected", "detected", "notApproved", "approved", "linking", "linkingFailed", "forwarding"

    .PARAMETER filter_deviceType
        Filter by device type

        Allowed values:
            "accessPoint", "airConditioner", "alarm", "audioVisual", "backhaul", "backupDevice",
            "bridge", "buildingManagement", "camera", "chassis", "controller", "copier", "firewall",
            "handheld", "hub", "hypervisor", "internetOfThings", "ipmi", "ipPhone", "l3Switch",
            "lightingDevice", "loadBalancer", "modem", "module", "multimedia", "packetProcessor",
            "pdu", "phone", "printer", "router", "securityAppliance", "server", "stack", "storage",
            "switch", "tablet", "telecommunications", "thinAccessPoint", "thinClient", "timeClock",
            "unknown", "ups", "utm", "virtualAppliance", "virtualMachine", "voipSwitch", "workstation"

    .PARAMETER filter_makeModel
        Filter by the device's make and model

    .PARAMETER filter_vendorName
        Filter by the device's vendor/manufacturer

    .PARAMETER filter_onlineStatus
        Filter by the device's online status

        Allowed values:
        "online", "offline", "unreachable", "testing", "unknown", "dormant", "notPresent", "lowerLayerDown"

    .PARAMETER filter_modifiedAfter
        Filter by date and time, only returning entities modified after provided value

    .PARAMETER filter_notSeenSince
        Filter by the last seen online time, returning entities not seen online after the provided value

    .PARAMETER include
        Use to include the full resource objects of the list device relationships

        Example: include=deviceDetail

    .PARAMETER fields_deviceDetail
        Use to limit the attributes that will be returned in the included detail object to
        only what is specified by this query parameter

        Requires include=deviceDetail

    .PARAMETER details
        Target the details endpoint

        /inventory/device/detail & /inventory/device/detail/{id}

    .PARAMETER detailsExtended
        Target the extended details endpoint

        /inventory/device/detail/extended & /inventory/device/detail/extended/{id}

    .PARAMETER detailsGeneral
        Target the general details endpoint

        Only needed when limiting general search by id, to give the parameter
        set a unique value.

        /inventory/device/info & /inventory/device/info

    .PARAMETER page_first
        For paginated responses, the first N elements will be returned
        Used in combination with page[after]

        Default Value: 100

    .PARAMETER page_after
        Cursor after which elements will be returned as a page
        The page size is provided by page[first]

    .PARAMETER page_last
        For paginated responses, the last N services will be returned
        Used in combination with page[before]

        Default Value: 100

    .PARAMETER page_before
        Cursor before which elements will be returned as a page
        The page size is provided by page[last]

    .PARAMETER allPages
        Returns all items from an endpoint

        Highly recommended to only use with filters to reduce API errors\timeouts

    .EXAMPLE
        Get-AuvikDevice

        Pulls general information about the first 100 devices
        Auvik has discovered

    .EXAMPLE
        Get-AuvikDevice -id 123456789 -detailsGeneral

        Pulls general information for the defined device
        Auvik has discovered

    .EXAMPLE
        Get-AuvikDevice -details

        Pulls detailed information about the first 100 devices
        Auvik has discovered

    .EXAMPLE
        Get-AuvikDevice -id 123456789 -details

        Pulls details information for the defined device
        Auvik has discovered

    .EXAMPLE
        Get-AuvikDevice -detailsExtended

        Pulls extended detail information about the first 100 devices
        Auvik has discovered

    .EXAMPLE
        Get-AuvikDevice -id 123456789 -detailsExtended

        Pulls extended detail information for the defined device
        Auvik has discovered

    .EXAMPLE
        Get-AuvikDevice -page_first 1000 -allPages

        Pulls general information for all devices found by Auvik.

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/Auvik-PowerShellWrapper/site/inventory/Get-AuvikDevice.html
#>

    [CmdletBinding(DefaultParameterSetName = 'indexByMultiDeviceGeneral' )]
    Param (
        [Parameter( Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = 'indexBySingleDeviceGeneral' )]
        [Parameter( Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = 'indexBySingleDeviceDetail' )]
        [Parameter( Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = 'indexBySingleDeviceExtDetail' )]
        [ValidateNotNullOrEmpty()]
        [string]$id,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiDeviceGeneral' )]
        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiDeviceDetail' )]
        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiDeviceExtDetail' )]
        [ValidateNotNullOrEmpty()]
        [string[]]$tenants,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiDeviceGeneral' )]
        [ValidateNotNullOrEmpty()]
        [string]$filter_networks,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiDeviceDetail' )]
        [switch]$filter_manageStatus,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiDeviceDetail' )]
        [ValidateSet( "disabled", "determining", "notSupported", "notAuthorized", "authorizing", "authorized", "privileged" )]
        [string]$filter_discoverySNMP,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiDeviceDetail' )]
        [ValidateSet( "disabled", "determining", "notSupported", "notAuthorized", "authorizing", "authorized", "privileged" )]
        [string]$filter_discoveryWMI,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiDeviceDetail' )]
        [ValidateSet( "disabled", "determining", "notSupported", "notAuthorized", "authorizing", "authorized", "privileged" )]
        [string]$filter_discoveryLogin,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiDeviceDetail' )]
        [ValidateSet( "disabled", "determining", "notSupported", "notAuthorized", "authorizing", "authorized", "privileged" )]
        [string]$filter_discoveryVMware,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiDeviceDetail' )]
        [ValidateSet( "notDetected", "detected", "notApproved", "approved", "linking", "linkingFailed", "forwarding" )]
        [string]$filter_trafficInsightsStatus,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiDeviceGeneral' )]
        [Parameter( Mandatory = $true , ParameterSetName = 'indexByMultiDeviceExtDetail' )]
        [ValidateSet(   "accessPoint", "airConditioner", "alarm", "audioVisual", "backhaul", "backupDevice",
                        "bridge", "buildingManagement", "camera", "chassis", "controller", "copier", "firewall",
                        "handheld", "hub", "hypervisor", "internetOfThings", "ipmi", "ipPhone", "l3Switch",
                        "lightingDevice", "loadBalancer", "modem", "module", "multimedia", "packetProcessor",
                        "pdu", "phone", "printer", "router", "securityAppliance", "server", "stack", "storage",
                        "switch", "tablet", "telecommunications", "thinAccessPoint", "thinClient", "timeClock",
                        "unknown", "ups", "utm", "virtualAppliance", "virtualMachine", "voipSwitch", "workstation"
        )]
        [string]$filter_deviceType,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiDeviceGeneral' )]
        [ValidateNotNullOrEmpty()]
        [string]$filter_makeModel,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiDeviceGeneral' )]
        [ValidateNotNullOrEmpty()]
        [string]$filter_vendorName,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiDeviceGeneral' )]
        [ValidateSet( "online", "offline", "unreachable", "testing", "unknown", "dormant", "notPresent", "lowerLayerDown" )]
        [string]$filter_onlineStatus,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiDeviceGeneral' )]
        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiDeviceExtDetail' )]
        [ValidateNotNullOrEmpty()]
        [DateTime]$filter_modifiedAfter,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiDeviceGeneral' )]
        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiDeviceExtDetail' )]
        [ValidateNotNullOrEmpty()]
        [DateTime]$filter_notSeenSince,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiDeviceGeneral' )]
        [Parameter( Mandatory = $false, ParameterSetName = 'indexBySingleDeviceGeneral' )]
        [ValidateNotNullOrEmpty()]
        [string]$include,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiDeviceGeneral' )]
        [Parameter( Mandatory = $false, ParameterSetName = 'indexBySingleDeviceGeneral' )]
        [ValidateSet( "discoveryStatus", "components", "connectedDevices", "configurations", "manageStatus", "interfaces" )]
        [string]$fields_deviceDetail,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiDeviceDetail' )]
        [Parameter( Mandatory = $false, ParameterSetName = 'indexBySingleDeviceDetail' )]
        [switch]$details,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiDeviceExtDetail' )]
        [Parameter( Mandatory = $false, ParameterSetName = 'indexBySingleDeviceExtDetail' )]
        [switch]$detailsExtended,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiDeviceGeneral' )]
        [Parameter( Mandatory = $false, ParameterSetName = 'indexBySingleDeviceGeneral' )]
        [switch]$detailsGeneral,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiDeviceGeneral' )]
        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiDeviceDetail' )]
        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiDeviceExtDetail' )]
        [ValidateRange(1, [int64]::MaxValue)]
        [int64]$page_first,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiDeviceGeneral' )]
        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiDeviceDetail' )]
        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiDeviceExtDetail' )]
        [ValidateNotNullOrEmpty()]
        [string]$page_after,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiDeviceGeneral' )]
        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiDeviceDetail' )]
        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiDeviceExtDetail' )]
        [ValidateRange(1, [int64]::MaxValue)]
        [int64]$page_last,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiDeviceGeneral' )]
        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiDeviceDetail' )]
        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiDeviceExtDetail' )]
        [ValidateNotNullOrEmpty()]
        [string]$page_before,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiDeviceGeneral' )]
        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiDeviceDetail' )]
        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiDeviceExtDetail' )]
        [switch]$allPages
    )

    begin {

        switch ( $($PSCmdlet.ParameterSetName) ) {
            'indexByMultiDeviceGeneral'     { $resource_uri = "/inventory/device/info" }
            'indexBySingleDeviceGeneral'    { $resource_uri = "/inventory/device/info/$id" }

            'indexByMultiDeviceDetail'      { $resource_uri = "/inventory/device/detail" }
            'indexBySingleDeviceDetail'     { $resource_uri = "/inventory/device/detail/$id" }

            'indexByMultiDeviceExtDetail'   { $resource_uri = "/inventory/device/detail/extended" }
            'indexBySingleDeviceExtDetail'  { $resource_uri = "/inventory/device/detail/extended/$id" }
        }

    }

    process {

        Write-Verbose "[ $($MyInvocation.MyCommand.Name) ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        #Region     [ Adjust parameters ]

            if( $PSBoundParameters.ContainsKey('id') ) {
                $PSBoundParameters.Remove('id') > $null
            }

        #EndRegion  [ Adjust  parameters ]

        Set-Variable -Name 'Auvik_deviceParameters' -Value $PSBoundParameters -Scope Global -Force

        Invoke-AuvikRequest -method GET -resource_Uri $resource_Uri -uri_Filter $PSBoundParameters -allPages:$allPages

    }

    end {}

}
#EndRegion '.\Public\inventory\Get-AuvikDevice.ps1' 369
#Region '.\Public\inventory\Get-AuvikDeviceLifecycle.ps1' 0
function Get-AuvikDeviceLifecycle {
    <#
        .SYNOPSIS
            Get Auvik devices and other related information

        .DESCRIPTION
            The Get-AuvikDeviceLifecycle cmdlet allows you to view an inventory of
            devices and other related information discovered by Auvik.

        .PARAMETER id
            ID of device

        .PARAMETER tenants
            Comma delimited list of tenant IDs to request info from

        .PARAMETER filter_salesAvailability
            Filter by sales availability

            Allowed values:
                "covered", "available", "expired", "securityOnly", "unpublished", "empty"

        .PARAMETER filter_softwareMaintenanceStatus
            Filter by software maintenance status

            Allowed values:
                "covered", "available", "expired", "securityOnly", "unpublished", "empty"

        .PARAMETER filter_securitySoftwareMaintenanceStatus
            Filter by security software maintenance status

            Allowed values:
                "covered", "available", "expired", "securityOnly", "unpublished", "empty"

        .PARAMETER filter_lastSupportStatus
            Filter by last support status

            Allowed values:
                "covered", "available", "expired", "securityOnly", "unpublished", "empty"

        .PARAMETER page_first
            For paginated responses, the first N elements will be returned
            Used in combination with page[after]

            Default Value: 100

        .PARAMETER page_after
            Cursor after which elements will be returned as a page
            The page size is provided by page[first]

        .PARAMETER page_last
            For paginated responses, the last N services will be returned
            Used in combination with page[before]

            Default Value: 100

        .PARAMETER page_before
            Cursor before which elements will be returned as a page
            The page size is provided by page[last]

        .PARAMETER allPages
            Returns all items from an endpoint

            Highly recommended to only use with filters to reduce API errors\timeouts

        .EXAMPLE
            Get-AuvikDeviceLifecycle

            Pulls general lifecycle information about the first 100 devices
            Auvik has discovered

        .EXAMPLE
            Get-AuvikDeviceLifecycle -id 123456789

            Pulls general lifecycle information for the defined device
            Auvik has discovered


        .EXAMPLE
            Get-AuvikDeviceLifecycle -page_first 1000 -allPages

            Pulls general lifecycle information for all devices found by Auvik.

        .NOTES
        N\A

        .LINK
            https://celerium.github.io/Auvik-PowerShellWrapper/site/inventory/Get-AuvikDeviceLifecycle.html
    #>

        [CmdletBinding(DefaultParameterSetName = 'indexByMultiDevice' )]
        Param (
            [Parameter( Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = 'indexBySingleDevice' )]
            [ValidateNotNullOrEmpty()]
            [string]$id,

            [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiDevice' )]
            [ValidateNotNullOrEmpty()]
            [string[]]$tenants,

            [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiDevice' )]
            [ValidateSet( "covered", "available", "expired", "securityOnly", "unpublished", "empty" )]
            [string]$filter_salesAvailability,

            [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiDevice' )]
            [ValidateSet( "covered", "available", "expired", "securityOnly", "unpublished", "empty" )]
            [string]$filter_softwareMaintenanceStatus,

            [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiDevice' )]
            [ValidateSet( "covered", "available", "expired", "securityOnly", "unpublished", "empty" )]
            [string]$filter_securitySoftwareMaintenanceStatus,

            [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiDevice' )]
            [ValidateSet( "covered", "available", "expired", "securityOnly", "unpublished", "empty" )]
            [string]$filter_lastSupportStatus,

            [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiDevice' )]
            [ValidateRange(1, [int64]::MaxValue)]
            [int64]$page_first,

            [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiDevice' )]
            [ValidateNotNullOrEmpty()]
            [string]$page_after,

            [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiDevice' )]
            [ValidateRange(1, [int64]::MaxValue)]
            [int64]$page_last,

            [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiDevice' )]
            [ValidateNotNullOrEmpty()]
            [string]$page_before,

            [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiDevice' )]
            [switch]$allPages
        )

        begin {

            switch ( $($PSCmdlet.ParameterSetName) ) {
                'indexByMultiDevice'    { $resource_uri = "/inventory/device/lifecycle" }
                'indexBySingleDevice'   { $resource_uri = "/inventory/device/lifecycle/$id" }
            }

        }

        process {

            Write-Verbose "[ $($MyInvocation.MyCommand.Name) ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

            #Region     [ Adjust parameters ]

                if( $PSBoundParameters.ContainsKey('id') ) {
                    $PSBoundParameters.Remove('id') > $null
                }

            #EndRegion  [ Adjust  parameters ]

            Set-Variable -Name 'Auvik_deviceLifecycleParameters' -Value $PSBoundParameters -Scope Global -Force

            Invoke-AuvikRequest -method GET -resource_Uri $resource_Uri -uri_Filter $PSBoundParameters -allPages:$allPages

        }

        end {}

    }
#EndRegion '.\Public\inventory\Get-AuvikDeviceLifecycle.ps1' 166
#Region '.\Public\inventory\Get-AuvikDeviceWarranty.ps1' 0
function Get-AuvikDeviceWarranty {
    <#
        .SYNOPSIS
            Get Auvik devices and other related information

        .DESCRIPTION
            The Get-AuvikDeviceWarranty cmdlet allows you to view an inventory of
            devices and other related information discovered by Auvik.

        .PARAMETER id
            ID of device

        .PARAMETER tenants
            Comma delimited list of tenant IDs to request info from

        .PARAMETER filter_coveredUnderWarranty
            Filter by warranty coverage status

        .PARAMETER filter_coveredUnderService
            Filter by service coverage status

        .PARAMETER page_first
            For paginated responses, the first N elements will be returned
            Used in combination with page[after]

            Default Value: 100

        .PARAMETER page_after
            Cursor after which elements will be returned as a page
            The page size is provided by page[first]

        .PARAMETER page_last
            For paginated responses, the last N services will be returned
            Used in combination with page[before]

            Default Value: 100

        .PARAMETER page_before
            Cursor before which elements will be returned as a page
            The page size is provided by page[last]

        .PARAMETER allPages
            Returns all items from an endpoint

            Highly recommended to only use with filters to reduce API errors\timeouts

        .EXAMPLE
            Get-AuvikDeviceWarranty

            Pulls general warranty information about the first 100 devices
            Auvik has discovered

        .EXAMPLE
            Get-AuvikDeviceWarranty -id 123456789

            Pulls general warranty information for the defined device
            Auvik has discovered


        .EXAMPLE
            Get-AuvikDeviceWarranty -page_first 1000 -allPages

            Pulls general warranty information for all devices found by Auvik.

        .NOTES
        N\A

        .LINK
            https://celerium.github.io/Auvik-PowerShellWrapper/site/inventory/Get-AuvikDeviceWarranty.html
    #>

        [CmdletBinding(DefaultParameterSetName = 'indexByMultiDevice' )]
        Param (
            [Parameter( Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = 'indexBySingleDevice' )]
            [ValidateNotNullOrEmpty()]
            [string]$id,

            [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiDevice' )]
            [ValidateNotNullOrEmpty()]
            [string[]]$tenants,

            [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiDevice' )]
            [switch]$filter_coveredUnderWarranty,

            [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiDevice' )]
            [switch]$filter_coveredUnderService,

            [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiDevice' )]
            [ValidateRange(1, [int64]::MaxValue)]
            [int64]$page_first,

            [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiDevice' )]
            [ValidateNotNullOrEmpty()]
            [string]$page_after,

            [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiDevice' )]
            [ValidateRange(1, [int64]::MaxValue)]
            [int64]$page_last,

            [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiDevice' )]
            [ValidateNotNullOrEmpty()]
            [string]$page_before,

            [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiDevice' )]
            [switch]$allPages
        )

        begin {

            switch ( $($PSCmdlet.ParameterSetName) ) {
                'indexByMultiDevice'    { $resource_uri = "/inventory/device/warranty" }
                'indexBySingleDevice'   { $resource_uri = "/inventory/device/warranty/$id" }
            }

        }

        process {

            Write-Verbose "[ $($MyInvocation.MyCommand.Name) ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

            #Region     [ Adjust parameters ]

                if( $PSBoundParameters.ContainsKey('id') ) {
                    $PSBoundParameters.Remove('id') > $null
                }

            #EndRegion  [ Adjust  parameters ]

            Set-Variable -Name 'Auvik_deviceWarrantyParameters' -Value $PSBoundParameters -Scope Global -Force

            Invoke-AuvikRequest -method GET -resource_Uri $resource_Uri -uri_Filter $PSBoundParameters -allPages:$allPages

        }

        end {}

    }
#EndRegion '.\Public\inventory\Get-AuvikDeviceWarranty.ps1' 138
#Region '.\Public\inventory\Get-AuvikEntity.ps1' 0
function Get-AuvikEntity {
<#
    .SYNOPSIS
        Get Auvik notes and audit trails associated with the entities

    .DESCRIPTION
        The Get-AuvikEntity cmdlet allows you to view notes and audit trails associated
        with the entities (devices, networks, and interfaces) that have been discovered
        by Auvik.

        Use the [ -audits & -notes  ] parameters when wanting to target
        specific information.

        See Get-Help Get-AuvikEntity -Full for more information on associated parameters

    .PARAMETER id
        ID of entity note\audit

    .PARAMETER tenants
        Comma delimited list of tenant IDs to request info from

    .PARAMETER filter_entityId
        Filter by the entity's ID

    .PARAMETER filter_user
        Filter by user name associated to the audit

    .PARAMETER filter_category
        Filter by the audit's category

        Allowed values:
            "unknown", "tunnel", "terminal", "remoteBrowser"

    .PARAMETER filter_entityType
        Filter by the entity's type

        Allowed values:
            "root", "device", "network", "interface"

    .PARAMETER filter_entityName
        Filter by the entity's name

    .PARAMETER filter_lastModifiedBy
        Filter by the user the note was last modified by

    .PARAMETER filter_status
        Filter by the audit's status

        Allowed values:
            "unknown", "initiated", "created", "closed", "failed"

    .PARAMETER filter_modifiedAfter
        Filter by date and time, only returning entities modified after provided value

    .PARAMETER audits
        Target the audit endpoint

        /inventory/entity/audit & /inventory/entity/audit/{id}

    .PARAMETER notes
        Target the note endpoint

        /inventory/entity/note & /inventory/entity/note/{id}

    .PARAMETER page_first
        For paginated responses, the first N elements will be returned
        Used in combination with page[after]

        Default Value: 100

    .PARAMETER page_after
        Cursor after which elements will be returned as a page
        The page size is provided by page[first]

    .PARAMETER page_last
        For paginated responses, the last N services will be returned
        Used in combination with page[before]

        Default Value: 100

    .PARAMETER page_before
        Cursor before which elements will be returned as a page
        The page size is provided by page[last]

    .PARAMETER allPages
        Returns all items from an endpoint

        Highly recommended to only use with filters to reduce API errors\timeouts

    .EXAMPLE
        Get-AuvikEntity

        Pulls general information about the first 100 notes
        Auvik has discovered

    .EXAMPLE
        Get-AuvikEntity -id 123456789 -audits

        Pulls general information for the defined audit
        Auvik has discovered

    .EXAMPLE
        Get-AuvikEntity -id 123456789 -notes

        Pulls general information for the defined note
        Auvik has discovered

    .EXAMPLE
        Get-AuvikEntity -page_first 1000 -allPages

        Pulls general information for all note entities found by Auvik.

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/Auvik-PowerShellWrapper/site/inventory/Get-AuvikEntity.html
#>

    [CmdletBinding(DefaultParameterSetName = 'indexByMultiEntityNotes' )]
    Param (
        [Parameter( Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = 'indexBySingleEntityNotes' )]
        [Parameter( Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = 'indexBySingleEntityAudits' )]
        [ValidateNotNullOrEmpty()]
        [string]$id,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiEntityNotes' )]
        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiEntityAudits' )]
        [ValidateNotNullOrEmpty()]
        [string[]]$tenants,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiEntityNotes' )]
        [ValidateNotNullOrEmpty()]
        [string]$filter_entityId,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiEntityAudits' )]
        [ValidateNotNullOrEmpty()]
        [string]$filter_user,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiEntityAudits' )]
        [ValidateSet( "unknown", "tunnel", "terminal", "remoteBrowser" )]
        [string]$filter_category,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiEntityNotes' )]
        [ValidateSet( "root", "device", "network", "interface" )]
        [string]$filter_entityType,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiEntityNotes' )]
        [ValidateNotNullOrEmpty()]
        [string]$filter_entityName,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiEntityNotes' )]
        [ValidateNotNullOrEmpty()]
        [string]$filter_lastModifiedBy,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiEntityAudits' )]
        [ValidateSet( "unknown", "initiated", "created", "closed", "failed" )]
        [string]$filter_status,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiEntityNotes' )]
        [ValidateNotNullOrEmpty()]
        [DateTime]$filter_modifiedAfter,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexBySingleEntityAudits' )]
        [switch]$audits,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexBySingleEntityNotes' )]
        [switch]$notes,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiEntityNotes' )]
        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiEntityAudits' )]
        [ValidateRange(1, [int64]::MaxValue)]
        [int64]$page_first,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiEntityNotes' )]
        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiEntityAudits' )]
        [ValidateNotNullOrEmpty()]
        [string]$page_after,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiEntityNotes' )]
        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiEntityAudits' )]
        [ValidateRange(1, [int64]::MaxValue)]
        [int64]$page_last,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiEntityNotes' )]
        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiEntityAudits' )]
        [ValidateNotNullOrEmpty()]
        [string]$page_before,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiEntityNotes' )]
        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiEntityAudits' )]
        [switch]$allPages
    )

    begin {

        switch ( $($PSCmdlet.ParameterSetName) ) {
            'indexByMultiEntityNotes'   { $resource_uri = "/inventory/entity/note" }
            'indexBySingleEntityNotes'  { $resource_uri = "/inventory/entity/note/$id" }

            'indexByMultiEntityAudits'  { $resource_uri = "/inventory/entity/audit" }
            'indexBySingleEntityAudits' { $resource_uri = "/inventory/entity/audit/$id" }
        }

    }

    process {

        Write-Verbose "[ $($MyInvocation.MyCommand.Name) ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        #Region     [ Adjust parameters ]

            if( $PSBoundParameters.ContainsKey('id') ) {
                $PSBoundParameters.Remove('id') > $null
            }

        #EndRegion  [ Adjust  parameters ]

        Set-Variable -Name 'Auvik_networkParameters' -Value $PSBoundParameters -Scope Global -Force

        Invoke-AuvikRequest -method GET -resource_Uri $resource_Uri -uri_Filter $PSBoundParameters -allPages:$allPages

    }

    end {}

}
#EndRegion '.\Public\inventory\Get-AuvikEntity.ps1' 228
#Region '.\Public\inventory\Get-AuvikInterface.ps1' 0
function Get-AuvikInterface {
<#
    .SYNOPSIS
        Get Auvik interfaces and other related information

    .DESCRIPTION
        The Get-AuvikInterface cmdlet allows you to view an inventory of
        interfaces and other related information discovered by Auvik.

    .PARAMETER id
        ID of interface

    .PARAMETER tenants
        Comma delimited list of tenant IDs to request info from

    .PARAMETER filter_interfaceType
        Filter by interface type

        Allowed values:
            "ethernet", "wifi", "bluetooth", "cdma", "coax", "cpu", "distributedVirtualSwitch",
            "firewire", "gsm", "ieee8023AdLag", "inferredWired", "inferredWireless", "interface",
            "linkAggregation", "loopback", "modem", "wimax", "optical", "other", "parallel", "ppp",
            "radiomac", "rs232", "tunnel", "unknown", "usb", "virtualBridge", "virtualNic",
            "virtualSwitch", "vlan"

    .PARAMETER filter_parentDevice
        Filter by the entity's parent device ID

    .PARAMETER filter_adminStatus
        Filter by the interface's admin status

    .PARAMETER filter_operationalStatus
        Filter by the interface's operational status

        Allowed values:
            "online", "offline", "unreachable", "testing", "unknown", "dormant", "notPresent", "lowerLayerDown"

    .PARAMETER filter_modifiedAfter
        Filter by date and time, only returning entities modified after provided value

    .PARAMETER page_first
        For paginated responses, the first N elements will be returned
        Used in combination with page[after]

        Default Value: 100

    .PARAMETER page_after
        Cursor after which elements will be returned as a page
        The page size is provided by page[first]

    .PARAMETER page_last
        For paginated responses, the last N services will be returned
        Used in combination with page[before]

        Default Value: 100

    .PARAMETER page_before
        Cursor before which elements will be returned as a page
        The page size is provided by page[last]

    .PARAMETER allPages
        Returns all items from an endpoint

        Highly recommended to only use with filters to reduce API errors\timeouts

    .EXAMPLE
        Get-AuvikInterface

        Pulls general information about the first 100 interfaces
        Auvik has discovered

    .EXAMPLE
        Get-AuvikInterface -id 123456789

        Pulls general information for the defined interface
        Auvik has discovered

    .EXAMPLE
        Get-AuvikInterface -page_first 1000 -allPages

        Pulls general information for all interfaces found by Auvik.

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/Auvik-PowerShellWrapper/site/inventory/Get-AuvikInterface.html
#>

    [CmdletBinding(DefaultParameterSetName = 'indexByMultiInterfaceGeneral' )]
    Param (
        [Parameter( Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = 'indexBySingleInterfaceGeneral' )]
        [ValidateNotNullOrEmpty()]
        [string]$id,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiInterfaceGeneral' )]
        [ValidateNotNullOrEmpty()]
        [string[]]$tenants,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiInterfaceGeneral' )]
        [ValidateSet(   "ethernet", "wifi", "bluetooth", "cdma", "coax", "cpu", "distributedVirtualSwitch",
                        "firewire", "gsm", "ieee8023AdLag", "inferredWired", "inferredWireless", "interface",
                        "linkAggregation", "loopback", "modem", "wimax", "optical", "other", "parallel", "ppp",
                        "radiomac", "rs232", "tunnel", "unknown", "usb", "virtualBridge", "virtualNic",
                        "virtualSwitch", "vlan"
        )]
        [string]$filter_interfaceType,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiInterfaceGeneral' )]
        [ValidateNotNullOrEmpty()]
        [string]$filter_parentDevice,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiInterfaceGeneral' )]
        [switch]$filter_adminStatus,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiInterfaceGeneral' )]
        [ValidateSet( "online", "offline", "unreachable", "testing", "unknown", "dormant", "notPresent", "lowerLayerDown" )]
        [string]$filter_operationalStatus,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiInterfaceGeneral' )]
        [ValidateNotNullOrEmpty()]
        [DateTime]$filter_modifiedAfter,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiInterfaceGeneral' )]
        [ValidateRange(1, [int64]::MaxValue)]
        [int64]$page_first,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiInterfaceGeneral' )]
        [ValidateNotNullOrEmpty()]
        [string]$page_after,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiInterfaceGeneral' )]
        [ValidateRange(1, [int64]::MaxValue)]
        [int64]$page_last,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiInterfaceGeneral' )]
        [ValidateNotNullOrEmpty()]
        [string]$page_before,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiInterfaceGeneral' )]
        [switch]$allPages
    )

    begin {

        switch ( $($PSCmdlet.ParameterSetName) ) {
            'indexByMultiInterfaceGeneral'  { $resource_uri = "/inventory/interface/info" }
            'indexBySingleInterfaceGeneral' { $resource_uri = "/inventory/interface/info/$id" }
        }

    }

    process {

        Write-Verbose "[ $($MyInvocation.MyCommand.Name) ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        #Region     [ Adjust parameters ]

            if( $PSBoundParameters.ContainsKey('id') ) {
                $PSBoundParameters.Remove('id') > $null
            }

        #EndRegion  [ Adjust  parameters ]

        Set-Variable -Name 'Auvik_interfaceParameters' -Value $PSBoundParameters -Scope Global -Force

        Invoke-AuvikRequest -method GET -resource_Uri $resource_Uri -uri_Filter $PSBoundParameters -allPages:$allPages

    }

    end {}

}
#EndRegion '.\Public\inventory\Get-AuvikInterface.ps1' 174
#Region '.\Public\inventory\Get-AuvikNetwork.ps1' 0
function Get-AuvikNetwork {
<#
    .SYNOPSIS
        Get Auvik networks and other related information

    .DESCRIPTION
        The Get-AuvikNetwork cmdlet allows you to view an inventory of
        networks and other related information discovered by Auvik.

        Use the [ -details & -detailsGeneral  ] parameters when wanting to target
        specific information. See Get-Help Get-AuvikNetwork -Full for
        more information on associated parameters

    .PARAMETER id
        ID of network

    .PARAMETER tenants
        Comma delimited list of tenant IDs to request info from

    .PARAMETER filter_networkType
        Filter by network type

        Allowed values:
            "routed", "vlan", "wifi", "loopback", "network", "layer2", "internet"

    .PARAMETER filter_scanStatus
        Filter by the network's scan status

        Allowed values:
            "true", "false", "notAllowed", "unknown"

    .PARAMETER filter_devices
        Filter by IDs of devices on this network

        Filter by multiple values by providing a comma delimited list

    .PARAMETER filter_modifiedAfter
        Filter by date and time, only returning entities modified after provided value

    .PARAMETER filter_scope
        Filter by the network's scope

        Allowed values:
            "private", "public"

    .PARAMETER include
        Use to include the full resource objects of the list device relationships

        Example: include=deviceDetail

    .PARAMETER fields_networkDetail
        Use to limit the attributes that will be returned in the included detail
        object to only what is specified by this query parameter.

        Allowed values:
            "scope", "primaryCollector", "secondaryCollectors", "collectorSelection", "excludedIpAddresses"

        Requires include=networkDetail

    .PARAMETER details
        Target the details endpoint

        /inventory/network/info & /inventory/network/info/{id}

    .PARAMETER detailsGeneral
        Target the general details endpoint

        /inventory/network/detail & /inventory/network/detail/{id}

    .PARAMETER page_first
        For paginated responses, the first N elements will be returned
        Used in combination with page[after]

        Default Value: 100

    .PARAMETER page_after
        Cursor after which elements will be returned as a page
        The page size is provided by page[first]

    .PARAMETER page_last
        For paginated responses, the last N services will be returned
        Used in combination with page[before]

        Default Value: 100

    .PARAMETER page_before
        Cursor before which elements will be returned as a page
        The page size is provided by page[last]

    .PARAMETER allPages
        Returns all items from an endpoint

        Highly recommended to only use with filters to reduce API errors\timeouts

    .EXAMPLE
        Get-AuvikNetwork

        Pulls general information about the first 100 networks
        Auvik has discovered

    .EXAMPLE
        Get-AuvikNetwork -id 123456789 -detailsGeneral

        Pulls general information for the defined network
        Auvik has discovered

    .EXAMPLE
        Get-AuvikNetwork -details

        Pulls detailed information about the first 100 networks
        Auvik has discovered

    .EXAMPLE
        Get-AuvikNetwork -id 123456789 -details

        Pulls details information for the defined network
        Auvik has discovered

    .EXAMPLE
        Get-AuvikNetwork -page_first 1000 -allPages

        Pulls general information for all networks found by Auvik.

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/Auvik-PowerShellWrapper/site/inventory/Get-AuvikNetwork.html
#>

    [CmdletBinding(DefaultParameterSetName = 'indexByMultiNetworkGeneral' )]
    Param (
        [Parameter( Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = 'indexBySingleNetworkGeneral' )]
        [Parameter( Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = 'indexBySingleNetworkDetail' )]
        [ValidateNotNullOrEmpty()]
        [string]$id,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiNetworkGeneral' )]
        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiNetworkDetail' )]
        [ValidateNotNullOrEmpty()]
        [string[]]$tenants,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiNetworkGeneral' )]
        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiNetworkDetail' )]
        [ValidateSet( "routed", "vlan", "wifi", "loopback", "network", "layer2", "internet" )]
        [string]$filter_networkType,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiNetworkGeneral' )]
        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiNetworkDetail' )]
        [ValidateSet( "true", "false", "notAllowed", "unknown" )]
        [string]$filter_scanStatus,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiNetworkGeneral' )]
        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiNetworkDetail' )]
        [ValidateNotNullOrEmpty()]
        [string[]]$filter_devices,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiNetworkGeneral' )]
        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiNetworkDetail' )]
        [ValidateNotNullOrEmpty()]
        [DateTime]$filter_modifiedAfter,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiNetworkDetail' )]
        [ValidateSet( "private", "public" )]
        [string]$filter_scope,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiNetworkGeneral' )]
        [Parameter( Mandatory = $false, ParameterSetName = 'indexBySingleNetworkGeneral' )]
        [ValidateNotNullOrEmpty()]
        [string]$include,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiNetworkGeneral' )]
        [Parameter( Mandatory = $false, ParameterSetName = 'indexBySingleNetworkGeneral' )]
        [ValidateSet( "scope", "primaryCollector", "secondaryCollectors", "collectorSelection", "excludedIpAddresses" )]
        [string]$fields_networkDetail,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexBySingleNetworkDetail' )]
        [switch]$details,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexBySingleNetworkGeneral' )]
        [switch]$detailsGeneral,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiNetworkGeneral' )]
        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiNetworkDetail' )]
        [ValidateRange(1, [int64]::MaxValue)]
        [int64]$page_first,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiNetworkGeneral' )]
        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiNetworkDetail' )]
        [ValidateNotNullOrEmpty()]
        [string]$page_after,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiNetworkGeneral' )]
        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiNetworkDetail' )]
        [ValidateRange(1, [int64]::MaxValue)]
        [int64]$page_last,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiNetworkGeneral' )]
        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiNetworkDetail' )]
        [ValidateNotNullOrEmpty()]
        [string]$page_before,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiNetworkGeneral' )]
        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiNetworkDetail' )]
        [switch]$allPages
    )

    begin {

        switch ( $($PSCmdlet.ParameterSetName) ) {
            'indexByMultiNetworkGeneral'    { $resource_uri = "/inventory/network/info" }
            'indexBySingleNetworkGeneral'   { $resource_uri = "/inventory/network/info/$id" }

            'indexByMultiNetworkDetail'     { $resource_uri = "/inventory/network/detail" }
            'indexBySingleNetworkDetail'    { $resource_uri = "/inventory/network/detail/$id" }
        }

    }

    process {

        Write-Verbose "[ $($MyInvocation.MyCommand.Name) ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        #Region     [ Adjust parameters ]

            if( $PSBoundParameters.ContainsKey('id') ) {
                $PSBoundParameters.Remove('id') > $null
            }

        #EndRegion  [ Adjust  parameters ]

        Set-Variable -Name 'Auvik_networkParameters' -Value $PSBoundParameters -Scope Global -Force

        Invoke-AuvikRequest -method GET -resource_Uri $resource_Uri -uri_Filter $PSBoundParameters -allPages:$allPages

    }

    end {}

}
#EndRegion '.\Public\inventory\Get-AuvikNetwork.ps1' 241
#Region '.\Public\other\Get-AuvikCredential.ps1' 0
function Get-AuvikCredential {
<#
    .SYNOPSIS
        Verify that your credentials are correct before making a call to an endpoint.

    .DESCRIPTION
        The Get-AuvikCredential cmdlet Verifies that your
        credentials are correct before making a call to an endpoint.

    .EXAMPLE
        Get-AuvikCredential

        Pulls general information about multiple multi-clients and
        clients associated with your Auvik user account.

    .EXAMPLE
        Get-AuvikCredential

        Verify that your credentials are correct
        before making a call to an endpoint.

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/Auvik-PowerShellWrapper/site/other/Get-AuvikCredential.html
#>

    [CmdletBinding()]
    [alias('Test-AuvikAPIKey')]
    Param ()

    begin {

        $resource_uri = "/authentication/verify"

    }

    process {

        Write-Verbose "[ $($MyInvocation.MyCommand.Name) ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        $return = Invoke-AuvikRequest -method GET -resource_Uri $resource_Uri -uri_Filter $PSBoundParameters -ErrorVariable restError

        if ( [string]::IsNullOrEmpty($return) -and [bool]$restError -eq $false ){
            $true
        }
        else{
            $false
        }

    }

    end {}

}
#EndRegion '.\Public\other\Get-AuvikCredential.ps1' 57
#Region '.\Public\pollers\Get-AuvikSNMPPollerDevice.ps1' 0
function Get-AuvikSNMPPollerDevice {
<#
    .SYNOPSIS
        Provides details about all the devices associated to a
        specific SNMP Poller Setting.

    .DESCRIPTION
        The Get-AuvikSNMPPollerDevice cmdlet provides details about all
        the devices associated to a specific SNMP Poller Setting.

    .PARAMETER snmpPollerSettingId
        ID of the SNMP Poller Setting that the devices apply to

    .PARAMETER tenants
        Comma delimited list of tenant IDs to request info from

    .PARAMETER filter_onlineStatus
        Filter by the device's online status

        Allowed values:
            "online", "offline", "unreachable", "testing", "unknown", "dormant", "notPresent", "lowerLayerDown"

    .PARAMETER filter_modifiedAfter
        Filter by date and time, only returning entities modified after provided value

    .PARAMETER filter_notSeenSince
        Filter by the last seen online time, returning entities not
        seen online after the provided value.

    .PARAMETER filter_deviceType
        Filter by device type

        Allowed values:
            "unknown", "switch", "l3Switch", "router", "accessPoint", "firewall", "workstation",
            "server", "storage", "printer", "copier", "hypervisor", "multimedia", "phone", "tablet",
            "handheld", "virtualAppliance", "bridge", "controller", "hub", "modem", "ups", "module",
            "loadBalancer", "camera", "telecommunications", "packetProcessor", "chassis", "airConditioner",
            "virtualMachine", "pdu", "ipPhone", "backhaul", "internetOfThings", "voipSwitch", "stack",
            "backupDevice", "timeClock", "lightingDevice", "audioVisual", "securityAppliance", "utm",
            "alarm", "buildingManagement", "ipmi", "thinAccessPoint", "thinClient"

    .PARAMETER filter_makeModel
        Filter by the device's make and model

    .PARAMETER filter_vendorName
        Filter by the device's vendor/manufacturer

    .PARAMETER page_first
        For paginated responses, the first N elements will be returned
        Used in combination with page[after]

        Default Value: 100

    .PARAMETER page_after
        Cursor after which elements will be returned as a page
        The page size is provided by page[first]

    .PARAMETER page_last
        For paginated responses, the last N services will be returned
        Used in combination with page[before]

        Default Value: 100

    .PARAMETER page_before
        Cursor before which elements will be returned as a page
        The page size is provided by page[last]

    .PARAMETER allPages
        Returns all items from an endpoint

        Highly recommended to only use with filters to reduce API errors\timeouts

    .EXAMPLE
        Get-AuvikSNMPPollerDevice -snmpPollerSettingId MTk5NTAyNzg2ODc3 -tenants 123456789

        Provides details about the first 100 devices associated to the defined
        SNMP Poller id


    .EXAMPLE
        Get-AuvikSNMPPollerDevice -snmpPollerSettingId MTk5NTAyNzg2ODc3 -tenants 123456789 -page_first 1000 -allPages

        Provides details about all the devices associated to the defined
        SNMP Poller id

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/Auvik-PowerShellWrapper/site/pollers/Get-AuvikSNMPPollerDevice.html
#>

    [CmdletBinding(DefaultParameterSetName = 'indexBySNMPDevice' )]
    Param (
        [Parameter( Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = 'indexBySNMPDevice' )]
        [ValidateNotNullOrEmpty()]
        [string]$snmpPollerSettingId,

        [Parameter( Mandatory = $true, ParameterSetName = 'indexBySNMPDevice' )]
        [ValidateNotNullOrEmpty()]
        [string[]]$tenants,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexBySNMPDevice' )]
        [ValidateSet( "online", "offline", "unreachable", "testing", "unknown", "dormant", "notPresent", "lowerLayerDown" )]
        [string]$filter_onlineStatus,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexBySNMPDevice' )]
        [ValidateNotNullOrEmpty()]
        [DateTime]$filter_modifiedAfter,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexBySNMPDevice' )]
        [ValidateNotNullOrEmpty()]
        [DateTime]$filter_notSeenSince,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexBySNMPDevice' )]
        [ValidateSet(   "unknown", "switch", "l3Switch", "router", "accessPoint", "firewall", "workstation",
                        "server", "storage", "printer", "copier", "hypervisor", "multimedia", "phone", "tablet",
                        "handheld", "virtualAppliance", "bridge", "controller", "hub", "modem", "ups", "module",
                        "loadBalancer", "camera", "telecommunications", "packetProcessor", "chassis", "airConditioner",
                        "virtualMachine", "pdu", "ipPhone", "backhaul", "internetOfThings", "voipSwitch", "stack",
                        "backupDevice", "timeClock", "lightingDevice", "audioVisual", "securityAppliance", "utm",
                        "alarm", "buildingManagement", "ipmi", "thinAccessPoint", "thinClient"
        )]
        [string]$filter_deviceType,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexBySNMPDevice' )]
        [ValidateNotNullOrEmpty()]
        [string]$filter_makeModel,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexBySNMPDevice' )]
        [ValidateNotNullOrEmpty()]
        [string]$filter_vendorName,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexBySNMPDevice' )]
        [ValidateRange(1, [int64]::MaxValue)]
        [int64]$page_first,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexBySNMPDevice' )]
        [ValidateNotNullOrEmpty()]
        [string]$page_after,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexBySNMPDevice' )]
        [ValidateRange(1, [int64]::MaxValue)]
        [int64]$page_last,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexBySNMPDevice' )]
        [ValidateNotNullOrEmpty()]
        [string]$page_before,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexBySNMPDevice' )]
        [switch]$allPages
    )

    begin {

        switch ( $($PSCmdlet.ParameterSetName) ) {
            'indexBySNMPDevice'     { $resource_uri = "/settings/snmppoller/$snmpPollerSettingId/devices" }

        }

    }

    process {

        Write-Verbose "[ $($MyInvocation.MyCommand.Name) ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        #Region     [ Adjust parameters ]

            if( $PSBoundParameters.ContainsKey('snmpPollerSettingId') ) {
                $PSBoundParameters.Remove('snmpPollerSettingId') > $null
            }

        #EndRegion  [ Adjust  parameters ]

        Set-Variable -Name 'Auvik_snmpDeviceParameters' -Value $PSBoundParameters -Scope Global -Force

        Invoke-AuvikRequest -method GET -resource_Uri $resource_Uri -uri_Filter $PSBoundParameters -allPages:$allPages

    }

    end {}

}
#EndRegion '.\Public\pollers\Get-AuvikSNMPPollerDevice.ps1' 184
#Region '.\Public\pollers\Get-AuvikSNMPPollerSetting.ps1' 0
function Get-AuvikSNMPPollerSetting {
<#
    .SYNOPSIS
        Provides details about one or more SNMP Poller Settings.

    .DESCRIPTION
        The Get-AuvikSNMPPollerSetting cmdlet provides details about
        one or more SNMP Poller Settings.

    .PARAMETER snmpPollerSettingId
        ID of the SNMP Poller Setting to retrieve

    .PARAMETER tenants
        Comma delimited list of tenant IDs to request info from

    .PARAMETER filter_deviceId
        Filter by device ID

    .PARAMETER filter_useAs
        Filter by oid type

        Allowed values:
            "serialNo", "poller"

    .PARAMETER filter_deviceType
        Filter by device type

        Allowed values:
            "unknown", "switch", "l3Switch", "router", "accessPoint", "firewall", "workstation",
            "server", "storage", "printer", "copier", "hypervisor", "multimedia", "phone", "tablet",
            "handheld", "virtualAppliance", "bridge", "controller", "hub", "modem", "ups", "module",
            "loadBalancer", "camera", "telecommunications", "packetProcessor", "chassis", "airConditioner",
            "virtualMachine", "pdu", "ipPhone", "backhaul", "internetOfThings", "voipSwitch", "stack",
            "backupDevice", "timeClock", "lightingDevice", "audioVisual", "securityAppliance", "utm",
            "alarm", "buildingManagement", "ipmi", "thinAccessPoint", "thinClient"

    .PARAMETER filter_makeModel
        Filter by the device's make and model

    .PARAMETER filter_vendorName
        Filter by the device's vendor/manufacturer

    .PARAMETER filter_oid
        Filter by OID

    .PARAMETER filter_name
        Filter by the name of the SNMP poller setting

    .PARAMETER page_first
        For paginated responses, the first N elements will be returned
        Used in combination with page[after]

        Default Value: 100

    .PARAMETER page_after
        Cursor after which elements will be returned as a page
        The page size is provided by page[first]

    .PARAMETER page_last
        For paginated responses, the last N services will be returned
        Used in combination with page[before]

        Default Value: 100

    .PARAMETER page_before
        Cursor before which elements will be returned as a page
        The page size is provided by page[last]

    .PARAMETER allPages
        Returns all items from an endpoint

        Highly recommended to only use with filters to reduce API errors\timeouts

    .EXAMPLE
        Get-AuvikSNMPPollerSetting -tenants 123456789

        Provides details about the first 100 SNMP Poller Settings
        associated to the defined tenant

    .EXAMPLE
        Get-AuvikSNMPPollerSetting -tenants 123456789 -page_first 1000 -allPages

        Provides details about all the SNMP Poller Settings
        associated to the defined tenant

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/Auvik-PowerShellWrapper/site/pollers/Get-AuvikSNMPPollerSetting.html
#>

    [CmdletBinding(DefaultParameterSetName = 'indexByMultiSNMPGeneral' )]
    Param (
        [Parameter( Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = 'indexBySingleSNMPGeneral' )]
        [ValidateNotNullOrEmpty()]
        [string]$snmpPollerSettingId,

        [Parameter( Mandatory = $true, ParameterSetName = 'indexByMultiSNMPGeneral' )]
        [ValidateNotNullOrEmpty()]
        [string[]]$tenants,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiSNMPGeneral' )]
        [ValidateNotNullOrEmpty()]
        [string]$filter_deviceId,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiSNMPGeneral' )]
        [ValidateSet( "serialNo", "poller")]
        [string]$filter_useAs,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiSNMPGeneral' )]
        [ValidateSet(   "unknown", "switch", "l3Switch", "router", "accessPoint", "firewall", "workstation",
                        "server", "storage", "printer", "copier", "hypervisor", "multimedia", "phone", "tablet",
                        "handheld", "virtualAppliance", "bridge", "controller", "hub", "modem", "ups", "module",
                        "loadBalancer", "camera", "telecommunications", "packetProcessor", "chassis", "airConditioner",
                        "virtualMachine", "pdu", "ipPhone", "backhaul", "internetOfThings", "voipSwitch", "stack",
                        "backupDevice", "timeClock", "lightingDevice", "audioVisual", "securityAppliance", "utm",
                        "alarm", "buildingManagement", "ipmi", "thinAccessPoint", "thinClient"
        )]
        [string]$filter_deviceType,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiSNMPGeneral' )]
        [ValidateNotNullOrEmpty()]
        [string]$filter_makeModel,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiSNMPGeneral' )]
        [ValidateNotNullOrEmpty()]
        [string]$filter_vendorName,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiSNMPGeneral' )]
        [ValidateNotNullOrEmpty()]
        [string]$filter_oid,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiSNMPGeneral' )]
        [ValidateNotNullOrEmpty()]
        [string]$filter_name,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiSNMPGeneral' )]
        [ValidateRange(1, [int64]::MaxValue)]
        [int64]$page_first,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiSNMPGeneral' )]
        [ValidateNotNullOrEmpty()]
        [string]$page_after,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiSNMPGeneral' )]
        [ValidateRange(1, [int64]::MaxValue)]
        [int64]$page_last,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiSNMPGeneral' )]
        [ValidateNotNullOrEmpty()]
        [string]$page_before,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiSNMPGeneral' )]
        [switch]$allPages
    )

    begin {

        switch ( $($PSCmdlet.ParameterSetName) ) {
            'indexByMultiSNMPGeneral'   { $resource_uri = "/settings/snmppoller" }
            'indexBySingleSNMPGeneral'  { $resource_uri = "/settings/snmppoller/$snmpPollerSettingId" }

        }

    }

    process {

        Write-Verbose "[ $($MyInvocation.MyCommand.Name) ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        #Region     [ Adjust parameters ]

            if( $PSBoundParameters.ContainsKey('snmpPollerSettingId') ) {
                $PSBoundParameters.Remove('snmpPollerSettingId') > $null
            }

        #EndRegion  [ Adjust  parameters ]

        Set-Variable -Name 'Auvik_snmpSettingsParameters' -Value $PSBoundParameters -Scope Global -Force

        Invoke-AuvikRequest -method GET -resource_Uri $resource_Uri -uri_Filter $PSBoundParameters -allPages:$allPages

    }

    end {}

}
#EndRegion '.\Public\pollers\Get-AuvikSNMPPollerSetting.ps1' 189
#Region '.\Public\pollers\Get-AuvikSNMPPolllerHistory.ps1' 0
function Get-AuvikSNMPPolllerHistory {
<#
    .SYNOPSIS
        Get Auvik historical values of SNMP Poller settings

    .DESCRIPTION
        The Get-AuvikSNMPPolllerHistory cmdlet allows you to view
        historical values of SNMP Poller settings

        There are two endpoints available in the SNMP Poller History API.

        Read String SNMP Poller Setting History:
            Provides historical values of String SNMP Poller Settings.
        Read Numeric SNMP Poller Setting History:
            Provides historical values of Numeric SNMP Poller Settings.

    .PARAMETER tenants
        Comma delimited list of tenant IDs to request info from

    .PARAMETER filter_fromTime
        Timestamp from which you want to query

    .PARAMETER filter_thruTime
        Timestamp to which you want to query (defaults to current time)

    .PARAMETER filter_compact
        Whether to show compact view of the results or not.

        Compact view only shows changes in value.
        If compact view is false, dateTime range can be a maximum of 24h

    .PARAMETER filter_interval
        Statistics reporting interval

        Allowed values:
            "minute", "hour", "day"

    .PARAMETER filter_deviceId
        Filter by device ID

    .PARAMETER filter_snmpPollerSettingId
        Comma delimited list of SNMP poller setting IDs to request info from.

        Note this is internal snmpPollerSettingId.
        The user can get the list of IDs for a specific poller using the
        GET /settings/snmppoller endpoint.

    .PARAMETER page_first
        For paginated responses, the first N elements will be returned
        Used in combination with page[after]

        Default Value: 100

    .PARAMETER page_after
        Cursor after which elements will be returned as a page
        The page size is provided by page[first]

    .PARAMETER page_last
        For paginated responses, the last N services will be returned
        Used in combination with page[before]

        Default Value: 100

    .PARAMETER page_before
        Cursor before which elements will be returned as a page
        The page size is provided by page[last]

    .PARAMETER allPages
        Returns all items from an endpoint

        Highly recommended to only use with filters to reduce API errors\timeouts

    .EXAMPLE
        Get-AuvikSNMPPolllerHistory -filter_fromTime 2023-10-01 -tenants 123456789

        Pulls general information about the first 100 historical SNMP
        string poller settings

    .EXAMPLE
        Get-AuvikSNMPPolllerHistory -filter_fromTime 2023-10-01 -tenants 123456789 -filter_interval day

        Pulls general information about the first 100 historical SNMP
        numerical poller settings

    .EXAMPLE
        Get-AuvikSNMPPolllerHistory -filter_fromTime 2023-10-01 -tenants 123456789 -page_first 1000 -allPages

        Pulls general information about all historical SNMP
        string poller settings

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/Auvik-PowerShellWrapper/site/poolers/Get-AuvikSNMPPolllerHistory.html
#>

    [CmdletBinding(DefaultParameterSetName = 'indexByStringSNMP' )]
    Param (
        [Parameter( Mandatory = $true, ParameterSetName = 'indexByStringSNMP' )]
        [Parameter( Mandatory = $true, ParameterSetName = 'indexByNumericSNMP' )]
        [ValidateNotNullOrEmpty()]
        [string[]]$tenants,

        [Parameter( Mandatory = $true, ParameterSetName = 'indexByStringSNMP' )]
        [Parameter( Mandatory = $true, ParameterSetName = 'indexByNumericSNMP' )]
        [ValidateNotNullOrEmpty()]
        [DateTime]$filter_fromTime,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByStringSNMP' )]
        [Parameter( Mandatory = $false, ParameterSetName = 'indexByNumericSNMP' )]
        [ValidateNotNullOrEmpty()]
        [DateTime]$filter_thruTime,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByStringSNMP' )]
        [switch]$filter_compact,

        [Parameter( Mandatory = $true, ParameterSetName = 'indexByNumericSNMP' )]
        [ValidateSet( "minute", "hour", "day")]
        [string]$filter_interval,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByStringSNMP' )]
        [Parameter( Mandatory = $false, ParameterSetName = 'indexByNumericSNMP' )]
        [ValidateNotNullOrEmpty()]
        [string]$filter_deviceId,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByStringSNMP' )]
        [Parameter( Mandatory = $false, ParameterSetName = 'indexByNumericSNMP' )]
        [ValidateNotNullOrEmpty()]
        [string[]]$filter_snmpPollerSettingId,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByStringSNMP' )]
        [Parameter( Mandatory = $false, ParameterSetName = 'indexByNumericSNMP' )]
        [ValidateRange(1, [int64]::MaxValue)]
        [int64]$page_first,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByStringSNMP' )]
        [Parameter( Mandatory = $false, ParameterSetName = 'indexByNumericSNMP' )]
        [ValidateNotNullOrEmpty()]
        [string]$page_after,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByStringSNMP' )]
        [Parameter( Mandatory = $false, ParameterSetName = 'indexByNumericSNMP' )]
        [ValidateRange(1, [int64]::MaxValue)]
        [int64]$page_last,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByStringSNMP' )]
        [Parameter( Mandatory = $false, ParameterSetName = 'indexByNumericSNMP' )]
        [ValidateNotNullOrEmpty()]
        [string]$page_before,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByStringSNMP' )]
        [Parameter( Mandatory = $false, ParameterSetName = 'indexByNumericSNMP' )]
        [switch]$allPages
    )

    begin {

        switch ( $($PSCmdlet.ParameterSetName) ) {
            'indexByStringSNMP'     { $resource_uri = "/stat/snmppoller/string" }
            'indexByNumericSNMP'    { $resource_uri = "/stat/snmppoller/int" }

        }

    }

    process {

        Write-Verbose "[ $($MyInvocation.MyCommand.Name) ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        Set-Variable -Name 'Auvik_snmpHistoryParameters' -Value $PSBoundParameters -Scope Global -Force

        Invoke-AuvikRequest -method GET -resource_Uri $resource_Uri -uri_Filter $PSBoundParameters -allPages:$allPages

    }

    end {}

}
#EndRegion '.\Public\pollers\Get-AuvikSNMPPolllerHistory.ps1' 180
#Region '.\Public\statistics\Get-AuvikComponentStatistics.ps1' 0
function Get-AuvikComponentStatistics {
<#
    .SYNOPSIS
        Provides historical statistics for components
        such as CPUs, disks, fans and memory

    .DESCRIPTION
        The Get-AuvikComponentStatistics cmdlet provides historical
        statistics for components such as CPUs, disks, fans and memory

        Make sure to read the documentation when defining componentType & statId,
        as only certain statId's work with certain componentTypes

        https://auvikapi.us1.my.auvik.com/docs#operation/readInterfaceStatistics

    .PARAMETER componentType
        Component type of statistic to return

        Allowed values:
            "cpu", "cpuCore", "disk", "fan", "memory", "powerSupply", "systemBoard"

    .PARAMETER statId
        ID of statistic to return

        Allowed values:
            "capacity", "counters", "idle", "latency", "power", "queueLatency",
            "rate", "readiness", "ready", "speed", "swap", "swapRate", "temperature",
            "totalLatency", "utilization"

    .PARAMETER tenants
        Comma delimited list of tenant IDs to request info from

    .PARAMETER filter_fromTime
        Timestamp from which you want to query

    .PARAMETER filter_thruTime
        Timestamp to which you want to query (defaults to current time)

    .PARAMETER filter_interval
        Statistics reporting interval

        Allowed values:
            "minute", "hour", "day"

    .PARAMETER filter_componentId
        Filter by component ID

    .PARAMETER filter_parentDevice
        Filter by the entity's parent device ID

    .PARAMETER page_first
        For paginated responses, the first N elements will be returned
        Used in combination with page[after]

        Default Value: 100

    .PARAMETER page_after
        Cursor after which elements will be returned as a page
        The page size is provided by page[first]

    .PARAMETER page_last
        For paginated responses, the last N services will be returned
        Used in combination with page[before]

        Default Value: 100

    .PARAMETER page_before
        Cursor before which elements will be returned as a page
        The page size is provided by page[last]

    .PARAMETER allPages
        Returns all items from an endpoint

        Highly recommended to only use with filters to reduce API errors\timeouts

    .EXAMPLE
        Get-AuvikComponentStatistics -componentType cpu -statId latency -filter_fromTime 2023-10-03 -filter_interval day

        Provides the first 100 historical statistics for CPU components

    .EXAMPLE
        Get-AuvikComponentStatistics -componentType cpu -statId latency -filter_fromTime 2023-10-03 -filter_interval day -page_first 1000 -allPages

        Provides all historical statistics for CPU components

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/Auvik-PowerShellWrapper/site/statistics/Get-AuvikComponentStatistics.html
#>

    [CmdletBinding(DefaultParameterSetName = 'indexByStatistics' )]
    Param (
        [Parameter( Mandatory = $true, ParameterSetName = 'indexByStatistics' )]
        [ValidateSet( "cpu", "cpuCore", "disk", "fan", "memory", "powerSupply", "systemBoard" )]
        [string]$componentType,

        [Parameter( Mandatory = $true, ParameterSetName = 'indexByStatistics' )]
        [ValidateSet(   "capacity", "counters", "idle", "latency", "power", "queueLatency",
                        "rate", "readiness", "ready", "speed", "swap", "swapRate", "temperature",
                        "totalLatency", "utilization"
        )]
        [string]$statId,

        [Parameter( Mandatory = $false, ValueFromPipeline = $true, ParameterSetName = 'indexByStatistics' )]
        [ValidateNotNullOrEmpty()]
        [string[]]$tenants,

        [Parameter( Mandatory = $true, ParameterSetName = 'indexByStatistics' )]
        [ValidateNotNullOrEmpty()]
        [DateTime]$filter_fromTime,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByStatistics' )]
        [ValidateNotNullOrEmpty()]
        [DateTime]$filter_thruTime,

        [Parameter( Mandatory = $true, ParameterSetName = 'indexByStatistics' )]
        [ValidateSet( "minute", "hour", "day" )]
        [string]$filter_interval,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByStatistics' )]
        [ValidateNotNullOrEmpty()]
        [string]$filter_componentId,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByStatistics' )]
        [ValidateNotNullOrEmpty()]
        [string]$filter_parentDevice,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByStatistics' )]
        [ValidateRange(1, [int64]::MaxValue)]
        [int64]$page_first,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByStatistics' )]
        [ValidateNotNullOrEmpty()]
        [string]$page_after,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByStatistics' )]
        [ValidateRange(1, [int64]::MaxValue)]
        [int64]$page_last,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByStatistics' )]
        [ValidateNotNullOrEmpty()]
        [string]$page_before,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByStatistics' )]
        [switch]$allPages
    )

    begin {

        switch ( $($PSCmdlet.ParameterSetName) ) {
            'indexByStatistics' { $resource_uri = "/stat/component/$componentType/$statId" }
        }

    }

    process {

        Write-Verbose "[ $($MyInvocation.MyCommand.Name) ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        #Region     [ Adjust parameters ]

            #Add default PSBoundParameters
            if( -not $PSBoundParameters.ContainsKey('filter_thruTime') ) { $PSBoundParameters.filter_thruTime = Get-Date }

            if( $PSBoundParameters.ContainsKey('componentType') ) {
                $PSBoundParameters.Remove('componentType') > $null
            }

            if( $PSBoundParameters.ContainsKey('statId') ) {
                $PSBoundParameters.Remove('statId') > $null
            }

        #EndRegion  [ Adjust  parameters ]

        Set-Variable -Name 'Auvik_componentStatsParameters' -Value $PSBoundParameters -Scope Global -Force

        Invoke-AuvikRequest -method GET -resource_Uri $resource_Uri -uri_Filter $PSBoundParameters -allPages:$allPages

    }

    end {}

}
#EndRegion '.\Public\statistics\Get-AuvikComponentStatistics.ps1' 186
#Region '.\Public\statistics\Get-AuvikDeviceAvailabilityStatistics.ps1' 0
function Get-AuvikDeviceAvailabilityStatistics {
<#
    .SYNOPSIS
        Provides historical device uptime and outage statistics.

    .DESCRIPTION
        The Get-AuvikDeviceAvailabilityStatistics cmdlet provides
        historical device uptime and outage statistics.

    .PARAMETER statId
        ID of statistic to return

        Allowed values:
            "uptime", "outage"

    .PARAMETER tenants
        Comma delimited list of tenant IDs to request info from

    .PARAMETER filter_fromTime
        Timestamp from which you want to query

    .PARAMETER filter_thruTime
        Timestamp to which you want to query (defaults to current time)

    .PARAMETER filter_interval
        Statistics reporting interval

        Allowed values:
            "minute", "hour", "day"

    .PARAMETER filter_deviceType
        Filter by device type

        Allowed values:
            "unknown", "switch", "l3Switch", "router", "accessPoint", "firewall",
            "workstation", "server", "storage", "printer", "copier", "hypervisor",
            "multimedia", "phone", "tablet", "handheld", "virtualAppliance", "bridge",
            "controller", "hub", "modem", "ups", "module", "loadBalancer", "camera",
            "telecommunications", "packetProcessor", "chassis", "airConditioner",
            "virtualMachine", "pdu", "ipPhone", "backhaul", "internetOfThings",
            "voipSwitch", "stack", "backupDevice", "timeClock", "lightingDevice",
            "audioVisual", "securityAppliance", "utm", "alarm", "buildingManagement",
            "ipmi", "thinAccessPoint", "thinClient"

    .PARAMETER filter_deviceId
        Filter by device ID

    .PARAMETER page_first
        For paginated responses, the first N elements will be returned
        Used in combination with page[after]

        Default Value: 100

    .PARAMETER page_after
        Cursor after which elements will be returned as a page
        The page size is provided by page[first]

    .PARAMETER page_last
        For paginated responses, the last N services will be returned
        Used in combination with page[before]

        Default Value: 100

    .PARAMETER page_before
        Cursor before which elements will be returned as a page
        The page size is provided by page[last]

    .PARAMETER allPages
        Returns all items from an endpoint

        Highly recommended to only use with filters to reduce API errors\timeouts

    .EXAMPLE
        Get-AuvikDeviceAvailabilityStatistics -statId uptime -filter_fromTime 2023-10-03 -filter_interval day

        Provides the first 100 historical device uptime and outage statistics.

    .EXAMPLE
        Get-AuvikDeviceAvailabilityStatistics -statId uptime -filter_fromTime 2023-10-03 -filter_interval day -page_first 1000 -allPages

        Provides all historical device uptime and outage statistics.

    .NOTES
        N\A


    .LINK
        https://celerium.github.io/Auvik-PowerShellWrapper/site/statistics/Get-AuvikDeviceAvailabilityStatistics.html
#>

    [CmdletBinding(DefaultParameterSetName = 'indexByStatistics' )]
    Param (
        [Parameter( Mandatory = $true, ParameterSetName = 'indexByStatistics' )]
        [ValidateSet( "uptime", "outage" )]
        [string]$statId,

        [Parameter( Mandatory = $false, ValueFromPipeline = $true, ParameterSetName = 'indexByStatistics' )]
        [ValidateNotNullOrEmpty()]
        [string[]]$tenants,

        [Parameter( Mandatory = $true, ParameterSetName = 'indexByStatistics' )]
        [ValidateNotNullOrEmpty()]
        [DateTime]$filter_fromTime,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByStatistics' )]
        [ValidateNotNullOrEmpty()]
        [DateTime]$filter_thruTime,

        [Parameter( Mandatory = $true, ParameterSetName = 'indexByStatistics' )]
        [ValidateSet( "minute", "hour", "day" )]
        [string]$filter_interval,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByStatistics' )]
        [ValidateSet(   "unknown", "switch", "l3Switch", "router", "accessPoint", "firewall",
                        "workstation", "server", "storage", "printer", "copier", "hypervisor",
                        "multimedia", "phone", "tablet", "handheld", "virtualAppliance", "bridge",
                        "controller", "hub", "modem", "ups", "module", "loadBalancer", "camera",
                        "telecommunications", "packetProcessor", "chassis", "airConditioner",
                        "virtualMachine", "pdu", "ipPhone", "backhaul", "internetOfThings",
                        "voipSwitch", "stack", "backupDevice", "timeClock", "lightingDevice",
                        "audioVisual", "securityAppliance", "utm", "alarm", "buildingManagement",
                        "ipmi", "thinAccessPoint", "thinClient"
        )]
        [string]$filter_deviceType,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByStatistics' )]
        [ValidateNotNullOrEmpty()]
        [string]$filter_deviceId,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByStatistics' )]
        [ValidateRange(1, [int64]::MaxValue)]
        [int64]$page_first,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByStatistics' )]
        [ValidateNotNullOrEmpty()]
        [string]$page_after,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByStatistics' )]
        [ValidateRange(1, [int64]::MaxValue)]
        [int64]$page_last,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByStatistics' )]
        [ValidateNotNullOrEmpty()]
        [string]$page_before,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByStatistics' )]
        [switch]$allPages
    )

    begin {

        switch ( $($PSCmdlet.ParameterSetName) ) {
            'indexByStatistics' { $resource_uri = "/stat/deviceAvailability/$statId" }

        }

    }

    process {

        Write-Verbose "[ $($MyInvocation.MyCommand.Name) ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        #Region     [ Adjust parameters ]

            #Add default PSBoundParameters
            if( -not $PSBoundParameters.ContainsKey('filter_thruTime') ) { $PSBoundParameters.filter_thruTime = Get-Date }

            if( $PSBoundParameters.ContainsKey('statId') ) {
                $PSBoundParameters.Remove('statId') > $null
            }

        #EndRegion  [ Adjust  parameters ]

        Set-Variable -Name 'Auvik_deviceAvailabilityStatsParameters' -Value $PSBoundParameters -Scope Global -Force

        Invoke-AuvikRequest -method GET -resource_Uri $resource_Uri -uri_Filter $PSBoundParameters -allPages:$allPages

    }

    end {}

}
#EndRegion '.\Public\statistics\Get-AuvikDeviceAvailabilityStatistics.ps1' 183
#Region '.\Public\statistics\Get-AuvikDeviceStatistics.ps1' 0
function Get-AuvikDeviceStatistics {
<#
    .SYNOPSIS
        Provides historical device statistics such as
        bandwidth, CPU utilization and memory utilization.

    .DESCRIPTION
        The Get-AuvikDeviceStatistics cmdlet  provides historical device statistics such as
        bandwidth, CPU utilization and memory utilization.

    .PARAMETER statId
        ID of statistic to return

        Allowed values:
            "bandwidth", "cpuUtilization", "memoryUtilization", "storageUtilization", "packetUnicast", "packetMulticast", "packetBroadcast"

    .PARAMETER tenants
        Comma delimited list of tenant IDs to request info from

    .PARAMETER filter_fromTime
        Timestamp from which you want to query

    .PARAMETER filter_thruTime
        Timestamp to which you want to query (defaults to current time)

    .PARAMETER filter_interval
        Statistics reporting interval

        Allowed values:
            "minute", "hour", "day"

    .PARAMETER filter_deviceType
        Filter by device type

        Allowed values:
            "unknown", "switch", "l3Switch", "router", "accessPoint", "firewall",
            "workstation", "server", "storage", "printer", "copier", "hypervisor",
            "multimedia", "phone", "tablet", "handheld", "virtualAppliance", "bridge",
            "controller", "hub", "modem", "ups", "module", "loadBalancer", "camera",
            "telecommunications", "packetProcessor", "chassis", "airConditioner",
            "virtualMachine", "pdu", "ipPhone", "backhaul", "internetOfThings",
            "voipSwitch", "stack", "backupDevice", "timeClock", "lightingDevice",
            "audioVisual", "securityAppliance", "utm", "alarm", "buildingManagement",
            "ipmi", "thinAccessPoint", "thinClient"

    .PARAMETER filter_deviceId
        Filter by device ID

    .PARAMETER page_first
        For paginated responses, the first N elements will be returned
        Used in combination with page[after]

        Default Value: 100

    .PARAMETER page_after
        Cursor after which elements will be returned as a page
        The page size is provided by page[first]

    .PARAMETER page_last
        For paginated responses, the last N services will be returned
        Used in combination with page[before]

        Default Value: 100

    .PARAMETER page_before
        Cursor before which elements will be returned as a page
        The page size is provided by page[last]

    .PARAMETER allPages
        Returns all items from an endpoint

        Highly recommended to only use with filters to reduce API errors\timeouts

    .EXAMPLE
        Get-AuvikDeviceStatistics -statId bandwidth -filter_fromTime 2023-10-03 -filter_interval day

        Provides the first 100 historical device statistics from the
        defined date at the defined interval

    .EXAMPLE
        Get-AuvikDeviceStatistics -statId bandwidth -filter_fromTime 2023-10-03 -filter_interval day -page_first 1000 -allPages

        Provides all historical device statistics from the
        defined date at the defined interval

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/Auvik-PowerShellWrapper/site/statistics/Get-AuvikDeviceStatistics.html
#>

    [CmdletBinding(DefaultParameterSetName = 'indexByStatistics' )]
    Param (
        [Parameter( Mandatory = $true, ParameterSetName = 'indexByStatistics' )]
        [ValidateSet( "bandwidth", "cpuUtilization", "memoryUtilization", "storageUtilization", "packetUnicast", "packetMulticast", "packetBroadcast" )]
        [string]$statId,

        [Parameter( Mandatory = $false, ValueFromPipeline = $true, ParameterSetName = 'indexByStatistics' )]
        [ValidateNotNullOrEmpty()]
        [string[]]$tenants,

        [Parameter( Mandatory = $true, ParameterSetName = 'indexByStatistics' )]
        [ValidateNotNullOrEmpty()]
        [DateTime]$filter_fromTime,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByStatistics' )]
        [ValidateNotNullOrEmpty()]
        [DateTime]$filter_thruTime,

        [Parameter( Mandatory = $true, ParameterSetName = 'indexByStatistics' )]
        [ValidateSet( "minute", "hour", "day" )]
        [string]$filter_interval,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByStatistics' )]
        [ValidateSet(   "unknown", "switch", "l3Switch", "router", "accessPoint", "firewall",
                        "workstation", "server", "storage", "printer", "copier", "hypervisor",
                        "multimedia", "phone", "tablet", "handheld", "virtualAppliance", "bridge",
                        "controller", "hub", "modem", "ups", "module", "loadBalancer", "camera",
                        "telecommunications", "packetProcessor", "chassis", "airConditioner",
                        "virtualMachine", "pdu", "ipPhone", "backhaul", "internetOfThings",
                        "voipSwitch", "stack", "backupDevice", "timeClock", "lightingDevice",
                        "audioVisual", "securityAppliance", "utm", "alarm", "buildingManagement",
                        "ipmi", "thinAccessPoint", "thinClient"
        )]
        [string]$filter_deviceType,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByStatistics' )]
        [ValidateNotNullOrEmpty()]
        [string]$filter_deviceId,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByStatistics' )]
        [ValidateRange(1, [int64]::MaxValue)]
        [int64]$page_first,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByStatistics' )]
        [ValidateNotNullOrEmpty()]
        [string]$page_after,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByStatistics' )]
        [ValidateRange(1, [int64]::MaxValue)]
        [int64]$page_last,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByStatistics' )]
        [ValidateNotNullOrEmpty()]
        [string]$page_before,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByStatistics' )]
        [switch]$allPages
    )

    begin {

        switch ( $($PSCmdlet.ParameterSetName) ) {
            'indexByStatistics' { $resource_uri = "/stat/device/$statId" }

        }

    }

    process {

        Write-Verbose "[ $($MyInvocation.MyCommand.Name) ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        #Region     [ Adjust parameters ]

            #Add default PSBoundParameters
            if( -not $PSBoundParameters.ContainsKey('filter_thruTime') ) { $PSBoundParameters.filter_thruTime = Get-Date }

            if( $PSBoundParameters.ContainsKey('statId') ) {
                $PSBoundParameters.Remove('statId') > $null
            }

        #EndRegion  [ Adjust  parameters ]

        Set-Variable -Name 'Auvik_deviceStatsParameters' -Value $PSBoundParameters -Scope Global -Force

        Invoke-AuvikRequest -method GET -resource_Uri $resource_Uri -uri_Filter $PSBoundParameters -allPages:$allPages

    }

    end {}

}
#EndRegion '.\Public\statistics\Get-AuvikDeviceStatistics.ps1' 185
#Region '.\Public\statistics\Get-AuvikInterfaceStatistics.ps1' 0
function Get-AuvikInterfaceStatistics {
<#
    .SYNOPSIS
        Provides historical interface statistics such
        as bandwidth and packet loss.

    .DESCRIPTION
        The Get-AuvikInterfaceStatistics cmdlet provides historical
        interface statistics such as bandwidth and packet loss.

    .PARAMETER statId
        ID of statistic to return

        Allowed values:
            "bandwidth", "utilization", "packetLoss", "packetDiscard", "packetMulticast", "packetUnicast", "packetBroadcast"

    .PARAMETER tenants
        Comma delimited list of tenant IDs to request info from

    .PARAMETER filter_fromTime
        Timestamp from which you want to query

    .PARAMETER filter_thruTime
        Timestamp to which you want to query (defaults to current time)

    .PARAMETER filter_interval
        Statistics reporting interval

        Allowed values:
            "minute", "hour", "day"

    .PARAMETER filter_interfaceType
        Filter by interface type

        Allowed values:
            "ethernet", "wifi", "bluetooth", "cdma", "coax", "cpu", "distributedVirtualSwitch",
            "firewire", "gsm", "ieee8023AdLag", "inferredWired", "inferredWireless", "interface",
            "linkAggregation", "loopback", "modem", "wimax", "optical", "other", "parallel", "ppp",
            "radiomac", "rs232", "tunnel", "unknown", "usb", "virtualBridge", "virtualNic",
            "virtualSwitch", "vlan"

    .PARAMETER filter_interfaceId
        Filter by interface ID

    .PARAMETER filter_parentDevice
        Filter by the entity's parent device ID

    .PARAMETER page_first
        For paginated responses, the first N elements will be returned
        Used in combination with page[after]

        Default Value: 100

    .PARAMETER page_after
        Cursor after which elements will be returned as a page
        The page size is provided by page[first]

    .PARAMETER page_last
        For paginated responses, the last N services will be returned
        Used in combination with page[before]

        Default Value: 100

    .PARAMETER page_before
        Cursor before which elements will be returned as a page
        The page size is provided by page[last]

    .PARAMETER allPages
        Returns all items from an endpoint

        Highly recommended to only use with filters to reduce API errors\timeouts

    .EXAMPLE
        Get-AuvikInterfaceStatistics -statId bandwidth -filter_fromTime 2023-10-03 -filter_interval day

        Provides the first 100 historical interface statistics such
        as bandwidth and packet loss.

    .EXAMPLE
        Get-AuvikInterfaceStatistics -statId bandwidth -filter_fromTime 2023-10-03 -filter_interval day -page_first 1000 -allPages

        Provides all historical interface statistics such
        as bandwidth and packet loss.

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/Auvik-PowerShellWrapper/site/statistics/Get-AuvikInterfaceStatistics.html
#>

    [CmdletBinding(DefaultParameterSetName = 'indexByStatistics' )]
    Param (
        [Parameter( Mandatory = $true, ParameterSetName = 'indexByStatistics' )]
        [ValidateSet( "bandwidth", "utilization", "packetLoss", "packetDiscard", "packetMulticast", "packetUnicast", "packetBroadcast" )]
        [string]$statId,

        [Parameter( Mandatory = $false, ValueFromPipeline = $true, ParameterSetName = 'indexByStatistics' )]
        [ValidateNotNullOrEmpty()]
        [string[]]$tenants,

        [Parameter( Mandatory = $true, ParameterSetName = 'indexByStatistics' )]
        [ValidateNotNullOrEmpty()]
        [DateTime]$filter_fromTime,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByStatistics' )]
        [ValidateNotNullOrEmpty()]
        [DateTime]$filter_thruTime,

        [Parameter( Mandatory = $true, ParameterSetName = 'indexByStatistics' )]
        [ValidateSet( "minute", "hour", "day" )]
        [string]$filter_interval,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByStatistics' )]
        [ValidateSet(   "ethernet", "wifi", "bluetooth", "cdma", "coax", "cpu", "distributedVirtualSwitch",
                        "firewire", "gsm", "ieee8023AdLag", "inferredWired", "inferredWireless", "interface",
                        "linkAggregation", "loopback", "modem", "wimax", "optical", "other", "parallel", "ppp",
                        "radiomac", "rs232", "tunnel", "unknown", "usb", "virtualBridge", "virtualNic",
                        "virtualSwitch", "vlan"
        )]
        [string]$filter_interfaceType,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByStatistics' )]
        [ValidateNotNullOrEmpty()]
        [string]$filter_interfaceId,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByStatistics' )]
        [ValidateNotNullOrEmpty()]
        [string]$filter_parentDevice,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByStatistics' )]
        [ValidateRange(1, [int64]::MaxValue)]
        [int64]$page_first,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByStatistics' )]
        [ValidateNotNullOrEmpty()]
        [string]$page_after,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByStatistics' )]
        [ValidateRange(1, [int64]::MaxValue)]
        [int64]$page_last,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByStatistics' )]
        [ValidateNotNullOrEmpty()]
        [string]$page_before,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByStatistics' )]
        [switch]$allPages
    )

    begin {

        switch ( $($PSCmdlet.ParameterSetName) ) {
            'indexByStatistics' { $resource_uri = "/stat/interface/$statId" }

        }

    }

    process {

        Write-Verbose "[ $($MyInvocation.MyCommand.Name) ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        #Region     [ Adjust parameters ]

            #Add default PSBoundParameters
            if( -not $PSBoundParameters.ContainsKey('filter_thruTime') ) { $PSBoundParameters.filter_thruTime = Get-Date }

            if( $PSBoundParameters.ContainsKey('statId') ) {
                $PSBoundParameters.Remove('statId') > $null
            }

        #EndRegion  [ Adjust  parameters ]

        Set-Variable -Name 'Auvik_interfaceStatsParameters' -Value $PSBoundParameters -Scope Global -Force

        Invoke-AuvikRequest -method GET -resource_Uri $resource_Uri -uri_Filter $PSBoundParameters -allPages:$allPages

    }

    end {}

}
#EndRegion '.\Public\statistics\Get-AuvikInterfaceStatistics.ps1' 184
#Region '.\Public\statistics\Get-AuvikOIDStatistics.ps1' 0
function Get-AuvikOIDStatistics {
<#
    .SYNOPSIS
        Provides the current value for numeric SNMP Pollers.

    .DESCRIPTION
        The Get-AuvikOIDStatistics cmdlet provides the current
        value for numeric SNMP Pollers.

    .PARAMETER statId
        ID of statistic to return

        Allowed values:
            "deviceMonitor"

    .PARAMETER tenants
        Comma delimited list of tenant IDs to request info from

    .PARAMETER filter_deviceId
        Filter by device ID

    .PARAMETER filter_deviceType
        Filter by device type

        Allowed values:
            "unknown", "switch", "l3Switch", "router", "accessPoint", "firewall",
            "workstation", "server", "storage", "printer", "copier", "hypervisor",
            "multimedia", "phone", "tablet", "handheld", "virtualAppliance", "bridge",
            "controller", "hub", "modem", "ups", "module", "loadBalancer", "camera",
            "telecommunications", "packetProcessor", "chassis", "airConditioner",
            "virtualMachine", "pdu", "ipPhone", "backhaul", "internetOfThings",
            "voipSwitch", "stack", "backupDevice", "timeClock", "lightingDevice",
            "audioVisual", "securityAppliance", "utm", "alarm", "buildingManagement",
            "ipmi", "thinAccessPoint", "thinClient"

    .PARAMETER filter_oid
        Filter by OID

    .PARAMETER page_first
        For paginated responses, the first N elements will be returned
        Used in combination with page[after]

        Default Value: 100

    .PARAMETER page_after
        Cursor after which elements will be returned as a page
        The page size is provided by page[first]

    .PARAMETER page_last
        For paginated responses, the last N services will be returned
        Used in combination with page[before]

        Default Value: 100

    .PARAMETER page_before
        Cursor before which elements will be returned as a page
        The page size is provided by page[last]

    .PARAMETER allPages
        Returns all items from an endpoint

        Highly recommended to only use with filters to reduce API errors\timeouts

    .EXAMPLE
        Get-AuvikOIDStatistics -statId deviceMonitor

        Provides the first 100 values for numeric SNMP Pollers.

    .EXAMPLE
        Get-AuvikOIDStatistics -statId deviceMonitor -page_first 1000 -allPages

        Provides all values for numeric SNMP Pollers.

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/Auvik-PowerShellWrapper/site/statistics/Get-AuvikOIDStatistics.html
#>

    [CmdletBinding(DefaultParameterSetName = 'indexByStatistics' )]
    Param (
        [Parameter( Mandatory = $true, ParameterSetName = 'indexByStatistics' )]
        [ValidateSet("deviceMonitor" )]
        [string]$statId,

        [Parameter( Mandatory = $false, ValueFromPipeline = $true, ParameterSetName = 'indexByStatistics' )]
        [ValidateNotNullOrEmpty()]
        [string[]]$tenants,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByStatistics' )]
        [ValidateNotNullOrEmpty()]
        [string]$filter_deviceId,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByStatistics' )]
        [ValidateSet(   "unknown", "switch", "l3Switch", "router", "accessPoint", "firewall",
                        "workstation", "server", "storage", "printer", "copier", "hypervisor",
                        "multimedia", "phone", "tablet", "handheld", "virtualAppliance", "bridge",
                        "controller", "hub", "modem", "ups", "module", "loadBalancer", "camera",
                        "telecommunications", "packetProcessor", "chassis", "airConditioner",
                        "virtualMachine", "pdu", "ipPhone", "backhaul", "internetOfThings",
                        "voipSwitch", "stack", "backupDevice", "timeClock", "lightingDevice",
                        "audioVisual", "securityAppliance", "utm", "alarm", "buildingManagement",
                        "ipmi", "thinAccessPoint", "thinClient"
        )]
        [string]$filter_deviceType,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByStatistics' )]
        [ValidateNotNullOrEmpty()]
        [string]$filter_oid,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByStatistics' )]
        [ValidateRange(1, [int64]::MaxValue)]
        [int64]$page_first,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByStatistics' )]
        [ValidateNotNullOrEmpty()]
        [string]$page_after,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByStatistics' )]
        [ValidateRange(1, [int64]::MaxValue)]
        [int64]$page_last,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByStatistics' )]
        [ValidateNotNullOrEmpty()]
        [string]$page_before,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByStatistics' )]
        [switch]$allPages
    )

    begin {

        switch ( $($PSCmdlet.ParameterSetName) ) {
            'indexByStatistics' { $resource_uri = "/stat/oid/$statId" }

        }

    }

    process {

        Write-Verbose "[ $($MyInvocation.MyCommand.Name) ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        #Region     [ Adjust parameters ]

            if( $PSBoundParameters.ContainsKey('statId') ) {
                $PSBoundParameters.Remove('statId') > $null
            }

        #EndRegion  [ Adjust  parameters ]

        Set-Variable -Name 'Auvik_oidStatsParameters' -Value $PSBoundParameters -Scope Global -Force

        Invoke-AuvikRequest -method GET -resource_Uri $resource_Uri -uri_Filter $PSBoundParameters -allPages:$allPages

    }

    end {}

}
#EndRegion '.\Public\statistics\Get-AuvikOIDStatistics.ps1' 162
#Region '.\Public\statistics\Get-AuvikServiceStatistics.ps1' 0
function Get-AuvikServiceStatistics {
<#
    .SYNOPSIS
        Provides historical cloud ping check statistics.

    .DESCRIPTION
        The Get-AuvikServiceStatistics cmdlet provides historical
        cloud ping check statistics.

    .PARAMETER statId
        ID of statistic to return

        Allowed values:
            "pingTime", "pingPacket"

    .PARAMETER tenants
        Comma delimited list of tenant IDs to request info from

    .PARAMETER filter_fromTime
        Timestamp from which you want to query

    .PARAMETER filter_thruTime
        Timestamp to which you want to query (defaults to current time)

    .PARAMETER filter_interval
        Statistics reporting interval

        Allowed values:
            "minute", "hour", "day"

    .PARAMETER filter_serviceId
        Filter by service ID

    .PARAMETER page_first
        For paginated responses, the first N elements will be returned
        Used in combination with page[after]

        Default Value: 100

    .PARAMETER page_after
        Cursor after which elements will be returned as a page
        The page size is provided by page[first]

    .PARAMETER page_last
        For paginated responses, the last N services will be returned
        Used in combination with page[before]

        Default Value: 100

    .PARAMETER page_before
        Cursor before which elements will be returned as a page
        The page size is provided by page[last]

    .PARAMETER allPages
        Returns all items from an endpoint

        Highly recommended to only use with filters to reduce API errors\timeouts

    .EXAMPLE
        Get-AuvikServiceStatistics -statId pingTime -filter_fromTime 2023-10-03 -filter_interval day

        Provides the first 100 historical cloud ping check statistics.

    .EXAMPLE
        Get-AuvikServiceStatistics -statId pingTime -filter_fromTime 2023-10-03 -filter_interval day -page_first 1000 -allPages

        Provides all historical cloud ping check statistics.

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/Auvik-PowerShellWrapper/site/statistics/Get-AuvikServiceStatistics.html
#>

    [CmdletBinding(DefaultParameterSetName = 'indexByStatistics' )]
    Param (
        [Parameter( Mandatory = $true, ParameterSetName = 'indexByStatistics' )]
        [ValidateSet( "pingTime", "pingPacket" )]
        [string]$statId,

        [Parameter( Mandatory = $false, ValueFromPipeline = $true, ParameterSetName = 'indexByStatistics' )]
        [ValidateNotNullOrEmpty()]
        [string[]]$tenants,

        [Parameter( Mandatory = $true, ParameterSetName = 'indexByStatistics' )]
        [ValidateNotNullOrEmpty()]
        [DateTime]$filter_fromTime,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByStatistics' )]
        [ValidateNotNullOrEmpty()]
        [DateTime]$filter_thruTime,

        [Parameter( Mandatory = $true, ParameterSetName = 'indexByStatistics' )]
        [ValidateSet( "minute", "hour", "day" )]
        [string]$filter_interval,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByStatistics' )]
        [ValidateNotNullOrEmpty()]
        [string]$filter_serviceId,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByStatistics' )]
        [ValidateRange(1, [int64]::MaxValue)]
        [int64]$page_first,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByStatistics' )]
        [ValidateNotNullOrEmpty()]
        [string]$page_after,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByStatistics' )]
        [ValidateRange(1, [int64]::MaxValue)]
        [int64]$page_last,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByStatistics' )]
        [ValidateNotNullOrEmpty()]
        [string]$page_before,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByStatistics' )]
        [switch]$allPages
    )

    begin {

        switch ( $($PSCmdlet.ParameterSetName) ) {
            'indexByStatistics' { $resource_uri = "/stat/service/$statId" }

        }

    }

    process {

        Write-Verbose "[ $($MyInvocation.MyCommand.Name) ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        #Region     [ Adjust parameters ]

            #Add default PSBoundParameters
            if( -not $PSBoundParameters.ContainsKey('filter_thruTime') ) { $PSBoundParameters.filter_thruTime = Get-Date }

            if( $PSBoundParameters.ContainsKey('statId') ) {
                $PSBoundParameters.Remove('statId') > $null
            }

        #EndRegion  [ Adjust  parameters ]

        Set-Variable -Name 'Auvik_deviceServiceStatsParameters' -Value $PSBoundParameters -Scope Global -Force

        Invoke-AuvikRequest -method GET -resource_Uri $resource_Uri -uri_Filter $PSBoundParameters -allPages:$allPages

    }

    end {}

}
#EndRegion '.\Public\statistics\Get-AuvikServiceStatistics.ps1' 155
