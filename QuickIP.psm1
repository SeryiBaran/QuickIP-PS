<#
 .Synopsis
  Sets a static IP address for interface.

 .Parameter Interface
  Net interface name.
  Get it by `Get-NetIPAddress -AddressFamily IPv4 | Select-Object -Property InterfaceAlias,IPAddress`.

 .Parameter IPAddress
  New IP address.

 .Parameter DontConfigDNS
  If set, dont use current DNS in new settings.
  Useful if your goal is connecting 2 PCs with a wire to create a dumb LAN without access to Internet.
  Dont use if your goal is set static IP without loss access to Internet.

 .Example
  # Sets IP and save previous DNS settings
  Set-QuickIP -i "Ethernet" -ip 192.168.0.32

 .Example
  # Sets IP and disable DNS config
  Set-QuickIP -i "Ethernet" -ip 192.168.0.32 -DontConfigDNS
#>
function Set-QuickIP {
  [CmdletBinding()]
  param(
    [parameter(Mandatory = $true)]
    [alias("i")]
    [string]
    $Interface,

    [parameter(Mandatory = $true)]
    [alias("ip")]
    [ipaddress]
    $IPAddress,

    [switch]
    [alias("NoDns")]
    $DontConfigDNS = $False
  )

  try {
    $ipParams = @{
      InterfaceAlias = $Interface
      AddressFamily  = "IPv4"
      IPAddress      = $IPAddress
      PrefixLength   = 24
    }
    if (-not $DontConfigDNS) {
      $CurrentDNSServers = ((Get-NetIPConfiguration -InterfaceAlias Ethernet).DNSServer | Where-Object { $_.AddressFamily -eq 2 }).ServerAddresses
      $ipParams.DefaultGateway = (Get-NetIPConfiguration -InterfaceAlias Ethernet).IPv4DefaultGateway.NextHop
    }

    New-NetIPAddress @ipParams -ErrorAction Stop | Out-Null
    if (-not $DontConfigDNS) {
      Set-DnsClientServerAddress -InterfaceAlias $Interface -ServerAddresses $CurrentDNSServers -ErrorAction Stop | Out-Null
    }
    Restart-NetAdapter -InterfaceAlias $Interface -ErrorAction Stop | Out-Null
  }
  catch {
    Write-Error "Oh, error occurred:"
    Write-Error $_
    break
  }

  Write-Host "Succesfully configured!" -ForegroundColor green
}

<#
 .Synopsis
  Resets settings of interface to default (DHCP + automatic DNS configuration).

 .Parameter Interface
  Net interface name.
  Get it by `Get-NetIPAddress -AddressFamily IPv4 | Select-Object -Property InterfaceAlias,IPAddress`.

 .Example
  Reset-QuickIP -i "Ethernet"
#>
function Reset-QuickIP {
  [CmdletBinding()]
  param(
    [parameter(Mandatory = $true)]
    [alias("i")]
    [string]
    $Interface
  )

  try {
    $IPAddress = (Get-NetIPAddress -InterfaceAlias $Interface -AddressFamily IPv4).IPAddress
    $CurrentGateway = (Get-NetIPConfiguration -InterfaceAlias Ethernet).IPv4DefaultGateway.NextHop

    Remove-NetIPAddress -IPAddress $IPAddress -Confirm:$false -ErrorAction Stop | Out-Null
    Set-NetIPInterface -InterfaceAlias $Interface -Dhcp Enabled -ErrorAction Stop | Out-Null
    if ($CurrentGateway) {
      Remove-NetRoute -InterfaceAlias $Interface -NextHop $CurrentGateway -Confirm:$false -ErrorAction Stop | Out-Null
    }
    Set-DnsClientServerAddress -InterfaceAlias $Interface -ResetServerAddresses -ErrorAction Stop | Out-Null
    Restart-NetAdapter -InterfaceAlias $Interface -ErrorAction Stop | Out-Null
  }
  catch {
    Write-Error "Oh, error occurred:"
    Write-Error $_
    break
  }
  
  Write-Host "Succesfully resetted!" -ForegroundColor green
}
