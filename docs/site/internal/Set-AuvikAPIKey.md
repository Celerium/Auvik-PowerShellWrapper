---
external help file: AuvikAPI-help.xml
grand_parent: internal
Module Name: AuvikAPI
online version: https://celerium.github.io/Auvik-PowerShellWrapper/site/internal/Set-AuvikAPIKey.html
parent: POST
schema: 2.0.0
title: Set-AuvikAPIKey
---

# Set-AuvikAPIKey

## SYNOPSIS
Sets the API public & secret keys used to authenticate API calls.

## SYNTAX

## DESCRIPTION
The Add-AuvikAPIKey cmdlet sets the API public & secret keys which are used to
authenticate all API calls made to Auvik.

Once the API public & secret keys are defined, the secret key is encrypted using SecureString.

The Auvik API public & secret keys are generated via the Auvik portal at Admin \> Integrations

## EXAMPLES

### EXAMPLE 1
```powershell
Add-AuvikAPIKey
```

Prompts to enter in the API public key and secret key.

### EXAMPLE 2
```powershell
Add-AuvikAPIKey -Api_UserName '12345'
```

The Auvik API will use the string entered into the \[ -Api_UserName \] parameter as the
public key & will then prompt to enter in the secret key.

### EXAMPLE 3
```
'12345' | Add-AuvikAPIKey
```

The Auvik API will use the string entered as the secret key & will prompt to enter in the public key.

## PARAMETERS

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
N\A

## RELATED LINKS

[https://celerium.github.io/Auvik-PowerShellWrapper/site/Internal/Add-AuvikAPIKey.html](https://celerium.github.io/Auvik-PowerShellWrapper/site/Internal/Add-AuvikAPIKey.html)

