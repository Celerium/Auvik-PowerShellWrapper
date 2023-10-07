---
external help file: AuvikAPI-help.xml
grand_parent: poolers
Module Name: AuvikAPI
online version: https://celerium.github.io/Auvik-PowerShellWrapper/site/poolers/Get-AuvikSNMPPollerDevice.html
parent: GET
schema: 2.0.0
title: Get-AuvikSNMPPollerDevice
---

# Get-AuvikSNMPPollerDevice

## SYNOPSIS
Provides details about all the devices associated to a
specific SNMP Poller Setting.

## SYNTAX

```powershell
Get-AuvikSNMPPollerDevice -snmpPollerSettingId <String> -tenants <String[]> [-filter_onlineStatus <String>]
 [-filter_modifiedAfter <DateTime>] [-filter_notSeenSince <DateTime>] [-filter_deviceType <String>]
 [-filter_makeModel <String>] [-filter_vendorName <String>] [-page_first <Int64>] [-page_after <String>]
 [-page_last <Int64>] [-page_before <String>] [-allPages] [<CommonParameters>]
```

## DESCRIPTION
The Get-AuvikSNMPPollerDevice cmdlet provides details about all
the devices associated to a specific SNMP Poller Setting.

## EXAMPLES

### EXAMPLE 1
```powershell
Get-AuvikSNMPPollerDevice -snmpPollerSettingId MTk5NTAyNzg2ODc3 -tenants 123456789
```

Provides details about the first 100 devices associated to the defined
SNMP Poller id

### EXAMPLE 2
```powershell
Get-AuvikSNMPPollerDevice -snmpPollerSettingId MTk5NTAyNzg2ODc3 -tenants 123456789 -page_first 1000 -allPages
```

Provides details about all the devices associated to the defined
SNMP Poller id

## PARAMETERS

### -snmpPollerSettingId
ID of the SNMP Poller Setting that the devices apply to

```yaml
Type: String
Parameter Sets: (All)
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
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -filter_onlineStatus
Filter by the device's online status

Allowed values:
    "online", "offline", "unreachable", "testing", "unknown", "dormant", "notPresent", "lowerLayerDown"

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

### -filter_modifiedAfter
Filter by date and time, only returning entities modified after provided value

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -filter_notSeenSince
Filter by the last seen online time, returning entities not
seen online after the provided value.

```yaml
Type: DateTime
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
    "unknown", "switch", "l3Switch", "router", "accessPoint", "firewall", "workstation",
    "server", "storage", "printer", "copier", "hypervisor", "multimedia", "phone", "tablet",
    "handheld", "virtualAppliance", "bridge", "controller", "hub", "modem", "ups", "module",
    "loadBalancer", "camera", "telecommunications", "packetProcessor", "chassis", "airConditioner",
    "virtualMachine", "pdu", "ipPhone", "backhaul", "internetOfThings", "voipSwitch", "stack",
    "backupDevice", "timeClock", "lightingDevice", "audioVisual", "securityAppliance", "utm",
    "alarm", "buildingManagement", "ipmi", "thinAccessPoint", "thinClient"

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

### -filter_makeModel
Filter by the device's make and model

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

### -filter_vendorName
Filter by the device's vendor/manufacturer

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

[https://celerium.github.io/Auvik-PowerShellWrapper/site/pollers/Get-AuvikSNMPPollerDevice.html](https://celerium.github.io/Auvik-PowerShellWrapper/site/pollers/Get-AuvikSNMPPollerDevice.html)

