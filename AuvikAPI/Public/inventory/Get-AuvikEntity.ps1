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
