---
external help file: AuvikAPI-help.xml
grand_parent: inventory
Module Name: AuvikAPI
online version: https://celerium.github.io/Auvik-PowerShellWrapper/site/inventory/Get-AuvikEntity.html
parent: GET
schema: 2.0.0
title: Get-AuvikEntity
---

# Get-AuvikEntity

## SYNOPSIS
Get Auvik notes and audit trails associated with the entities

## SYNTAX

### indexByMultiEntityNotes (Default)
```powershell
Get-AuvikEntity [-tenants <String[]>] [-filter_entityId <String>] [-filter_entityType <String>]
 [-filter_entityName <String>] [-filter_lastModifiedBy <String>] [-filter_modifiedAfter <DateTime>]
 [-page_first <Int64>] [-page_after <String>] [-page_last <Int64>] [-page_before <String>] [-allPages]
 [<CommonParameters>]
```

### indexBySingleEntityAudits
```powershell
Get-AuvikEntity -id <String> [-audits] [<CommonParameters>]
```

### indexBySingleEntityNotes
```powershell
Get-AuvikEntity -id <String> [-notes] [<CommonParameters>]
```

### indexByMultiEntityAudits
```powershell
Get-AuvikEntity [-tenants <String[]>] [-filter_user <String>] [-filter_category <String>]
 [-filter_status <String>] [-page_first <Int64>] [-page_after <String>] [-page_last <Int64>]
 [-page_before <String>] [-allPages] [<CommonParameters>]
```

## DESCRIPTION
The Get-AuvikEntity cmdlet allows you to view notes and audit trails associated
with the entities (devices, networks, and interfaces) that have been discovered
by Auvik.

Use the \[ -audits & -notes  \] parameters when wanting to target
specific information.

See Get-Help Get-AuvikEntity -Full for more information on associated parameters

## EXAMPLES

### EXAMPLE 1
```powershell
Get-AuvikEntity
```

Pulls general information about the first 100 notes
Auvik has discovered

### EXAMPLE 2
```powershell
Get-AuvikEntity -id 123456789 -audits
```

Pulls general information for the defined audit
Auvik has discovered

### EXAMPLE 3
```powershell
Get-AuvikEntity -id 123456789 -notes
```

Pulls general information for the defined note
Auvik has discovered

### EXAMPLE 4
```powershell
Get-AuvikEntity -page_first 1000 -allPages
```

Pulls general information for all note entities found by Auvik.

## PARAMETERS

### -id
ID of entity note\audit

```yaml
Type: String
Parameter Sets: indexBySingleEntityAudits, indexBySingleEntityNotes
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -tenants
Comma delimited list of tenant IDs to request info from

```yaml
Type: String[]
Parameter Sets: indexByMultiEntityNotes, indexByMultiEntityAudits
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -filter_entityId
Filter by the entity's ID

```yaml
Type: String
Parameter Sets: indexByMultiEntityNotes
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -filter_user
Filter by user name associated to the audit

```yaml
Type: String
Parameter Sets: indexByMultiEntityAudits
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -filter_category
Filter by the audit's category

Allowed values:
    "unknown", "tunnel", "terminal", "remoteBrowser"

```yaml
Type: String
Parameter Sets: indexByMultiEntityAudits
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -filter_entityType
Filter by the entity's type

Allowed values:
    "root", "device", "network", "interface"

```yaml
Type: String
Parameter Sets: indexByMultiEntityNotes
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -filter_entityName
Filter by the entity's name

```yaml
Type: String
Parameter Sets: indexByMultiEntityNotes
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -filter_lastModifiedBy
Filter by the user the note was last modified by

```yaml
Type: String
Parameter Sets: indexByMultiEntityNotes
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -filter_status
Filter by the audit's status

Allowed values:
    "unknown", "initiated", "created", "closed", "failed"

```yaml
Type: String
Parameter Sets: indexByMultiEntityAudits
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -filter_modifiedAfter
Filter by date and time, only returning entities modified after provided value

```yaml
Type: DateTime
Parameter Sets: indexByMultiEntityNotes
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -audits
Target the audit endpoint

/inventory/entity/audit & /inventory/entity/audit/{id}

```yaml
Type: SwitchParameter
Parameter Sets: indexBySingleEntityAudits
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -notes
Target the note endpoint

/inventory/entity/note & /inventory/entity/note/{id}

```yaml
Type: SwitchParameter
Parameter Sets: indexBySingleEntityNotes
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -page_first
For paginated responses, the first N elements will be returned
Used in combination with page\[after\]

Default Value: 100

```yaml
Type: Int64
Parameter Sets: indexByMultiEntityNotes, indexByMultiEntityAudits
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -page_after
Cursor after which elements will be returned as a page
The page size is provided by page\[first\]

```yaml
Type: String
Parameter Sets: indexByMultiEntityNotes, indexByMultiEntityAudits
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -page_last
For paginated responses, the last N services will be returned
Used in combination with page\[before\]

Default Value: 100

```yaml
Type: Int64
Parameter Sets: indexByMultiEntityNotes, indexByMultiEntityAudits
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -page_before
Cursor before which elements will be returned as a page
The page size is provided by page\[last\]

```yaml
Type: String
Parameter Sets: indexByMultiEntityNotes, indexByMultiEntityAudits
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -allPages
Returns all items from an endpoint

Highly recommended to only use with filters to reduce API errors\timeouts

```yaml
Type: SwitchParameter
Parameter Sets: indexByMultiEntityNotes, indexByMultiEntityAudits
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
N\A

## RELATED LINKS

[https://celerium.github.io/Auvik-PowerShellWrapper/site/inventory/Get-AuvikEntity.html](https://celerium.github.io/Auvik-PowerShellWrapper/site/inventory/Get-AuvikEntity.html)

