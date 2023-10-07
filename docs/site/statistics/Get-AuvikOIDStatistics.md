---
external help file: AuvikAPI-help.xml
grand_parent: statistics
Module Name: AuvikAPI
online version: https://celerium.github.io/Auvik-PowerShellWrapper/site/statistics/Get-AuvikOIDStatistics.html
parent: GET
schema: 2.0.0
title: Get-AuvikOIDStatistics
---

# Get-AuvikOIDStatistics

## SYNOPSIS
Provides the current value for numeric SNMP Pollers.

## SYNTAX

```powershell
Get-AuvikOIDStatistics -statId <String> [-tenants <String[]>] [-filter_deviceId <String>]
 [-filter_deviceType <String>] [-filter_oid <String>] [-page_first <Int64>] [-page_after <String>]
 [-page_last <Int64>] [-page_before <String>] [-allPages] [<CommonParameters>]
```

## DESCRIPTION
The Get-AuvikOIDStatistics cmdlet provides the current
value for numeric SNMP Pollers.

## EXAMPLES

### EXAMPLE 1
```powershell
Get-AuvikOIDStatistics -statId deviceMonitor
```

Provides the first 100 values for numeric SNMP Pollers.

### EXAMPLE 2
```powershell
Get-AuvikOIDStatistics -statId deviceMonitor -page_first 1000 -allPages
```

Provides all values for numeric SNMP Pollers.

## PARAMETERS

### -statId
ID of statistic to return

Allowed values:
    "deviceMonitor"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -tenants
Comma delimited list of tenant IDs to request info from

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -filter_deviceId
Filter by device ID

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -filter_deviceType
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

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -filter_oid
Filter by OID

```yaml
Type: String
Parameter Sets: (All)
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
Parameter Sets: (All)
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
Parameter Sets: (All)
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
Parameter Sets: (All)
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
Parameter Sets: (All)
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
Parameter Sets: (All)
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

[https://celerium.github.io/Auvik-PowerShellWrapper/site/statistics/Get-AuvikOIDStatistics.html](https://celerium.github.io/Auvik-PowerShellWrapper/site/statistics/Get-AuvikOIDStatistics.html)

