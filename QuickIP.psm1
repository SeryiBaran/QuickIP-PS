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

  try {
    New-NetIPAddress @ipParams -ErrorAction Stop | Out-Null
  }
  catch {
    Write-Error "🚨 Oh, error occurred:"
    Write-Error $_
    break
  }

  Write-Host "✨ Succesfully configured!" -ForegroundColor green
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

  try {
    Remove-NetIPAddress -IPAddress $IPAddress -Confirm:$false -ErrorAction Stop | Out-Null
    Set-NetIPInterface -InterfaceAlias $Interface -Dhcp Enabled -ErrorAction Stop | Out-Null
    Restart-NetAdapter -InterfaceAlias $Interface -ErrorAction Stop | Out-Null
  }
  catch {
    Write-Error "🚨 Oh, error occurred:"
    Write-Error $_
    break
  }
  
  Write-Host "✨ Succesfully resetted!" -ForegroundColor green
}
