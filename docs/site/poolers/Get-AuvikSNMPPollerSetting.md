---
external help file: AuvikAPI-help.xml
grand_parent: poolers
Module Name: AuvikAPI
online version: https://celerium.github.io/Auvik-PowerShellWrapper/site/poolers/Get-AuvikSNMPPollerSetting.html
parent: GET
schema: 2.0.0
title: Get-AuvikSNMPPollerSetting
---

# Get-AuvikSNMPPollerSetting

## SYNOPSIS
Provides details about one or more SNMP Poller Settings.

## SYNTAX

### indexByMultiSNMPGeneral (Default)
```powershell
Get-AuvikSNMPPollerSetting -tenants <String[]> [-filter_deviceId <String>] [-filter_useAs <String>]
 [-filter_deviceType <String>] [-filter_makeModel <String>] [-filter_vendorName <String>]
 [-filter_oid <String>] [-filter_name <String>] [-page_first <Int64>] [-page_after <String>]
 [-page_last <Int64>] [-page_before <String>] [-allPages] [<CommonParameters>]
```

### indexBySingleSNMPGeneral
```powershell
Get-AuvikSNMPPollerSetting -snmpPollerSettingId <String> [<CommonParameters>]
```

## DESCRIPTION
The Get-AuvikSNMPPollerSetting cmdlet provides details about
one or more SNMP Poller Settings.

## EXAMPLES

### EXAMPLE 1
```powershell
Get-AuvikSNMPPollerSetting -tenants 123456789
```

Provides details about the first 100 SNMP Poller Settings
associated to the defined tenant

### EXAMPLE 2
```powershell
Get-AuvikSNMPPollerSetting -tenants 123456789 -page_first 1000 -allPages
```

Provides details about all the SNMP Poller Settings
associated to the defined tenant

## PARAMETERS

### -snmpPollerSettingId
ID of the SNMP Poller Setting to retrieve

```yaml
Type: String
Parameter Sets: indexBySingleSNMPGeneral
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
Parameter Sets: indexByMultiSNMPGeneral
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -filter_deviceId
Filter by device ID

```yaml
Type: String
Parameter Sets: indexByMultiSNMPGeneral
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -filter_useAs
Filter by oid type

Allowed values:
    "serialNo", "poller"

```yaml
Type: String
Parameter Sets: indexByMultiSNMPGeneral
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
Parameter Sets: indexByMultiSNMPGeneral
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
Parameter Sets: indexByMultiSNMPGeneral
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
Parameter Sets: indexByMultiSNMPGeneral
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
Parameter Sets: indexByMultiSNMPGeneral
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -filter_name
Filter by the name of the SNMP poller setting

```yaml
Type: String
Parameter Sets: indexByMultiSNMPGeneral
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
Parameter Sets: indexByMultiSNMPGeneral
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
Parameter Sets: indexByMultiSNMPGeneral
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
Parameter Sets: indexByMultiSNMPGeneral
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
Parameter Sets: indexByMultiSNMPGeneral
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
Parameter Sets: indexByMultiSNMPGeneral
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

[https://celerium.github.io/Auvik-PowerShellWrapper/site/pollers/Get-AuvikSNMPPollerSetting.html](https://celerium.github.io/Auvik-PowerShellWrapper/site/pollers/Get-AuvikSNMPPollerSetting.html)

