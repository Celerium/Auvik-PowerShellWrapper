---
external help file: AuvikAPI-help.xml
grand_parent: inventory
Module Name: AuvikAPI
online version: https://celerium.github.io/Auvik-PowerShellWrapper/site/inventory/Get-AuvikConfiguration.html
parent: GET
schema: 2.0.0
title: Get-AuvikConfiguration
---

# Get-AuvikConfiguration

## SYNOPSIS
Get Auvik history of device configurations

## SYNTAX

### indexByMultiConfigGeneral (Default)
```powershell
Get-AuvikConfiguration [-tenants <String[]>] [-filter_deviceId <String>] [-filter_backupTimeAfter <DateTime>]
 [-filter_backupTimeBefore <DateTime>] [-filter_isRunning] [-page_first <Int64>] [-page_after <String>]
 [-page_last <Int64>] [-page_before <String>] [-allPages] [<CommonParameters>]
```

### indexBySingleConfigGeneral
```powershell
Get-AuvikConfiguration -id <String> [<CommonParameters>]
```

## DESCRIPTION
The Get-AuvikConfiguration cmdlet allows you to view a history of
device configurations and other related information discovered by Auvik.

## EXAMPLES

### EXAMPLE 1
```powershell
Get-AuvikConfiguration
```

Pulls general information about the first 100 configurations
Auvik has discovered

### EXAMPLE 2
```powershell
Get-AuvikConfiguration -id 123456789
```

Pulls general information for the defined configuration
Auvik has discovered

### EXAMPLE 3
```powershell
Get-AuvikConfiguration -page_first 1000 -allPages
```

Pulls general information for all configurations found by Auvik.

## PARAMETERS

### -id
ID of entity note\audit

```yaml
Type: String
Parameter Sets: indexBySingleConfigGeneral
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
Parameter Sets: indexByMultiConfigGeneral
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -filter_deviceId
Filter by device ID

```yaml
Type: String
Parameter Sets: indexByMultiConfigGeneral
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -filter_backupTimeAfter
Filter by date and time, filtering out configurations backed up before value

```yaml
Type: DateTime
Parameter Sets: indexByMultiConfigGeneral
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -filter_backupTimeBefore
Filter by date and time, filtering out configurations backed up after value.

```yaml
Type: DateTime
Parameter Sets: indexByMultiConfigGeneral
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -filter_isRunning
Filter for configurations that are currently running, or filter
for all configurations which are not currently running.

As of 2023-10, this does not appear to function correctly on this endpoint

```yaml
Type: SwitchParameter
Parameter Sets: indexByMultiConfigGeneral
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
Parameter Sets: indexByMultiConfigGeneral
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
Parameter Sets: indexByMultiConfigGeneral
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
Parameter Sets: indexByMultiConfigGeneral
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
Parameter Sets: indexByMultiConfigGeneral
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
Parameter Sets: indexByMultiConfigGeneral
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

[https://celerium.github.io/Auvik-PowerShellWrapper/site/inventory/Get-AuvikConfiguration.html](https://celerium.github.io/Auvik-PowerShellWrapper/site/inventory/Get-AuvikConfiguration.html)

