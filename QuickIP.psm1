Import-Module Pansies

<#
 .Synopsis
  Sets a static IP address for interface.

 .Parameter Interface
  Net interface name.
  Get it by `Get-NetIPAddress -AddressFamily IPv4 | Select-Object -Property InterfaceAlias,IPAddress`.

 .Parameter IPAddress
  IP address.

 .Example
  Set-QuickIP -i "Ethernet" -ip 192.168.0.32
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
    $IPAddress
  )

  $ipParams = @{
    InterfaceAlias = $Interface
    AddressFamily  = "IPv4"
    IPAddress      = $IPAddress
    PrefixLength   = 24
  }

  New-NetIPAddress @ipParams | Out-Null

  Write-Host "Succesfully configured!" -ForegroundColor green
}

<#
 .Synopsis
  Resets IP of interface to DHCP.

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

  $IPAddress = (Get-NetIPAddress -InterfaceAlias $Interface -AddressFamily IPv4).IPAddress

  Remove-NetIPAddress -IPAddress $IPAddress -Confirm:$false | Out-Null
  Set-NetIPInterface -InterfaceAlias $Interface -Dhcp Enabled | Out-Null
  Restart-NetAdapter -InterfaceAlias $Interface | Out-Null
  
  Write-Host "Succesfully resetted!" -ForegroundColor green
}