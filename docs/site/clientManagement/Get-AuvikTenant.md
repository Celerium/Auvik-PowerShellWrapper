---
external help file: AuvikAPI-help.xml
grand_parent: clientManagement
Module Name: AuvikAPI
online version: https://celerium.github.io/Auvik-PowerShellWrapper/site/clientManagement/Get-AuvikTenant.html
parent: GET
schema: 2.0.0
title: Get-AuvikTenant
---

# Get-AuvikTenant

## SYNOPSIS
Get Auvik tenant information

## SYNTAX

### indexMultiTenant (Default)
```powershell
Get-AuvikTenant [<CommonParameters>]
```

### indexSingleTenantDetails
```powershell
Get-AuvikTenant -tenantDomainPrefix <String> -id <String> [<CommonParameters>]
```

### indexMultiTenantDetails
```powershell
Get-AuvikTenant -tenantDomainPrefix <String> [-filter_availableTenants] [<CommonParameters>]
```

## DESCRIPTION
The Get-AuvikTenant cmdlet get Auvik general or detailed
tenant information associated to your Auvik user account

## EXAMPLES

### EXAMPLE 1
```powershell
Get-AuvikTenant
```

Pulls general information about multiple multi-clients and
clients associated with your Auvik user account.

### EXAMPLE 2
```powershell
Get-AuvikTenant -tenantDomainPrefix CeleriumMSP
```

Pulls detailed information about multiple multi-clients and
clients associated with your main Auvik account.

### EXAMPLE 3
```powershell
Get-AuvikTenant -tenantDomainPrefix CeleriumMSP -id 123456789
```

Pulls detailed information about a single tenant from
your main Auvik account.

## PARAMETERS

### -tenantDomainPrefix
Domain prefix of your main Auvik account (tenant).

```yaml
Type: String
Parameter Sets: indexSingleTenantDetails, indexMultiTenantDetails
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -filter_availableTenants
Filter whether or not a tenant is available,
i.e.
data can be gotten from them via the API.

```yaml
Type: SwitchParameter
Parameter Sets: indexMultiTenantDetails
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -id
ID of tenant

```yaml
Type: String
Parameter Sets: indexSingleTenantDetails
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
N\A

## RELATED LINKS

[https://celerium.github.io/Auvik-PowerShellWrapper/site/clientManagement/Get-AuvikTenant.html](https://celerium.github.io/Auvik-PowerShellWrapper/site/clientManagement/Get-AuvikTenant.html)

