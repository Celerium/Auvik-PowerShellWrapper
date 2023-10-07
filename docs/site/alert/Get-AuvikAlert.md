---
external help file: AuvikAPI-help.xml
grand_parent: alert
Module Name: AuvikAPI
online version: https://celerium.github.io/Auvik-PowerShellWrapper/site/alert/Get-AuvikAlert.html
parent: GET
schema: 2.0.0
title: Get-AuvikAlert
---

# Get-AuvikAlert

## SYNOPSIS
Get Auvik alert events that have been triggered by your Auvik collector(s).

## SYNTAX

### indexByMultiAlertGeneral (Default)
```powershell
Get-AuvikAlert [-tenants <String[]>] [-filter_alertDefinitionId <String>] [-filter_severity <String>]
 [-filter_status <String>] [-filter_entityId <String>] [-filter_dismissed] [-filter_dispatched]
 [-filter_detectedTimeAfter <DateTime>] [-filter_detectedTimeBefore <DateTime>] [-page_first <Int64>]
 [-page_after <String>] [-page_last <Int64>] [-page_before <String>] [-allPages] [<CommonParameters>]
```

### indexBySingleAlertGeneral
```powershell
Get-AuvikAlert -id <String> [<CommonParameters>]
```

## DESCRIPTION
The Get-AuvikAlert cmdlet allows you to view the alert events
that has been triggered by your Auvik collector(s).

## EXAMPLES

### EXAMPLE 1
```powershell
Get-AuvikAlert
```

Pulls general information about the first 100 alerts
Auvik has discovered

### EXAMPLE 2
```powershell
Get-AuvikAlert -id 123456789
```

Pulls general information for the defined alert
Auvik has discovered

### EXAMPLE 3
```powershell
Get-AuvikAlert -page_first 1000 -allPages
```

Pulls general information for all alerts found by Auvik.

## PARAMETERS

### -id
ID of alert

```yaml
Type: String
Parameter Sets: indexBySingleAlertGeneral
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
Parameter Sets: indexByMultiAlertGeneral
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -filter_alertDefinitionId
Filter by alert definition ID

```yaml
Type: String
Parameter Sets: indexByMultiAlertGeneral
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -filter_severity
Filter by alert severity

Allowed values:
    "unknown", "emergency", "critical", "warning", "info"

```yaml
Type: String
Parameter Sets: indexByMultiAlertGeneral
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -filter_status
Filter by the status of the alert

Allowed values:
    "created", "resolved", "paused", "unpaused"

```yaml
Type: String
Parameter Sets: indexByMultiAlertGeneral
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -filter_entityId
Filter by the related entity ID

```yaml
Type: String
Parameter Sets: indexByMultiAlertGeneral
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -filter_dismissed
Filter by the dismissed status

As of 2023-10 this parameter does not appear to work

```yaml
Type: SwitchParameter
Parameter Sets: indexByMultiAlertGeneral
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -filter_dispatched
Filter by dispatched status

As of 2023-10 this parameter does not appear to work

```yaml
Type: SwitchParameter
Parameter Sets: indexByMultiAlertGeneral
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -filter_detectedTimeAfter
Filter by the time which is greater than the given timestamp

```yaml
Type: DateTime
Parameter Sets: indexByMultiAlertGeneral
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -filter_detectedTimeBefore
Filter by the time which is less than or equal to the given timestamp

```yaml
Type: DateTime
Parameter Sets: indexByMultiAlertGeneral
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -page_first
For paginated responses, the first N elements will be returned
Used in combination with page\[after\]

Default Value: 100

```yaml
Type: Int64
Parameter Sets: indexByMultiAlertGeneral
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
Parameter Sets: indexByMultiAlertGeneral
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
Parameter Sets: indexByMultiAlertGeneral
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
Parameter Sets: indexByMultiAlertGeneral
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
Parameter Sets: indexByMultiAlertGeneral
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

[https://celerium.github.io/Auvik-PowerShellWrapper/site/alert/Get-AuvikAlert.html](https://celerium.github.io/Auvik-PowerShellWrapper/site/alert/Get-AuvikAlert.html)

