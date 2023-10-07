---
external help file: AuvikAPI-help.xml
grand_parent: internal
Module Name: AuvikAPI
online version: https://celerium.github.io/Auvik-PowerShellWrapper/site/internal/Get-AuvikAPIKey.html
parent: GET
schema: 2.0.0
title: Get-AuvikAPIKey
---

# Get-AuvikAPIKey

## SYNOPSIS
Gets the Auvik API public & secret key global variables.

## SYNTAX

```powershell
Get-AuvikAPIKey [-plainText] [<CommonParameters>]
```

## DESCRIPTION
The Get-AuvikAPIKey cmdlet gets the Auvik API public & secret key
global variables and returns them as an object.

## EXAMPLES

### EXAMPLE 1
```powershell
Get-AuvikAPIKey
```

Gets the Auvik API public & secret key global variables and returns them as an object
with the secret key as a SecureString.

### EXAMPLE 2
```powershell
Get-AuvikAPIKey -plainText
```

Gets the Auvik API public & secret key global variables and returns them as an object
with the secret key as plain text.

## PARAMETERS

### -plainText
Decrypt and return the API key in plain text.

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

[https://celerium.github.io/Auvik-PowerShellWrapper/site/Internal/Get-AuvikAPIKey.html](https://celerium.github.io/Auvik-PowerShellWrapper/site/Internal/Get-AuvikAPIKey.html)

