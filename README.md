# QuickIP-PS

![Screenshot of work](.github/screenshot.png)

Tiny Powershell module for quick IP setting/resetting.

## Installing

```powershell
Install-Module QuickIP -Scope CurrentUser -AllowClobber
```

## Usage

> Don't forget to import module =)
>
> ```powershell
> Import-Module QuickIP
> ```

### `Set-QuickIP`

```
NAME
    Set-QuickIP

SYNOPSIS
    Sets a static IP address for interface.


SYNTAX
    Set-QuickIP [-Interface] <String> [-IPAddress] <IPAddress> [-DontConfigDNS] [<CommonParameters>]


DESCRIPTION


PARAMETERS
    -Interface <String>
        Net interface name.
        Get it by `Get-NetIPAddress -AddressFamily IPv4 | Select-Object -Property InterfaceAlias,IPAddress`.

        Required?                    true
        Position?                    1
        Default value
        Accept pipeline input?       false
        Accept wildcard characters?  false

    -IPAddress <IPAddress>
        New IP address.

        Required?                    true
        Position?                    2
        Default value
        Accept pipeline input?       false
        Accept wildcard characters?  false

    -DontConfigDNS [<SwitchParameter>]
        If set, dont use current DNS in new settings.
        Useful if your goal is connecting 2 PCs with a wire to create a dumb LAN without access to Internet.
        Dont use if your goal is set static IP without loss access to Internet.

        Required?                    false
        Position?                    named
        Default value                False
        Accept pipeline input?       false
        Accept wildcard characters?  false

    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see
        about_CommonParameters (https://go.microsoft.com/fwlink/?LinkID=113216).

INPUTS

OUTPUTS

    -------------------------- EXAMPLE 1 --------------------------

    PS > # Sets IP and save previous DNS settings
    Set-QuickIP -i "Ethernet" -ip 192.168.0.32






    -------------------------- EXAMPLE 2 --------------------------

    PS > # Sets IP and disable DNS config
    Set-QuickIP -i "Ethernet" -ip 192.168.0.32 -DontConfigDNS







RELATED LINKS

```

### `Reset-QuickIP`

```
NAME
    Reset-QuickIP

SYNOPSIS
    Resets settings of interface to default (DHCP + automatic DNS configuration).


SYNTAX
    Reset-QuickIP [-Interface] <String> [<CommonParameters>]


DESCRIPTION


PARAMETERS
    -Interface <String>
        Net interface name.
        Get it by `Get-NetIPAddress -AddressFamily IPv4 | Select-Object -Property InterfaceAlias,IPAddress`.

        Required?                    true
        Position?                    1
        Default value
        Accept pipeline input?       false
        Accept wildcard characters?  false

    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see
        about_CommonParameters (https://go.microsoft.com/fwlink/?LinkID=113216).

INPUTS

OUTPUTS

    -------------------------- EXAMPLE 1 --------------------------

    PS > Reset-QuickIP -i "Ethernet"







RELATED LINKS

```
