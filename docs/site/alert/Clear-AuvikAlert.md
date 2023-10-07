---
external help file: AuvikAPI-help.xml
grand_parent: alert
Module Name: AuvikAPI
online version: https://celerium.github.io/Auvik-PowerShellWrapper/site/alert/Clear-AuvikAlert.html
parent: POST
schema: 2.0.0
title: Clear-AuvikAlert
---

# Clear-AuvikAlert

## SYNOPSIS
Clear an Auvik alert

## SYNTAX

```powershell
Clear-AuvikAlert -id <String> [<CommonParameters>]
```

## DESCRIPTION
The Clear-AuvikAlert cmdlet allows you to dismiss an
alert that Auvik has triggered.

## EXAMPLES

### EXAMPLE 1
```powershell
Clear-AuvikAlert -id 123456789
```

Clears the defined alert

## PARAMETERS

### -id
ID of alert

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
N\A

## RELATED LINKS

[https://celerium.github.io/Auvik-PowerShellWrapper/site/alert/Clear-AuvikAlert.html](https://celerium.github.io/Auvik-PowerShellWrapper/site/alert/Clear-AuvikAlert.html)

