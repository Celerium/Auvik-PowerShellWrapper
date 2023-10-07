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
