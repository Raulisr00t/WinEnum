#######################
#       LOCAL         #
#######################
$separator = "***********************************************"

$whoami = whoami
Write-Output "Current User: $whoami"
Write-Output $separator

$credentials = cmd /c "cmdkey /list"
Write-Host "[+] Saved credentials for user [+]"
Write-Output $credentials
Write-Output $separator

$privileges = whoami /priv
Write-Output $privileges
Write-Output $separator

$users = Get-LocalUser
Write-Output "Local Users:"
Write-Output $users
Write-Output $separator

$groups = Get-LocalGroup
Write-Output "Local Groups:"
Write-Output $groups
Write-Output $separator

$interfaces = Get-NetAdapter | Select-Object Name, InterfaceDescription, Status
Write-Host "[+] Interfaces for system [+]"
Write-Output $interfaces
Write-Output $separator

$domain = "google.com"
$connection = Test-Connection -ComputerName $domain -Count 4 -Verbose
try {
    if ($connection) {
        Write-Output "[+] This machine is connected to the network [+]"
    } else {
        Write-Output "[-] This machine is not connected to the network [-]"
    }
} catch {
    Write-Host "[!] Error: There was a problem with the network [!]"
}

try {
    Write-Output "[+] IP addresses for the interfaces [+]"
    foreach ($interface in $interfaces) {
        Write-Output "Interface: $($interface.Name) - Status: $($interface.Status)"
        $ip_addresses = Get-NetIPAddress -InterfaceAlias $interface.Name | Select-Object -Property IPAddress
        foreach ($ip in $ip_addresses) {
            if ($ip.IPAddress) {
                Write-Output "  IP Address: $($ip.IPAddress)"
            }
        }
    }
} catch {
    Write-Host "[!] Not found IP addresses [!]" -ForegroundColor Red
}
Write-Output $separator

Write-Host "[+] Listening active ports [+]"
Start-Sleep 2
$open_ports = netstat.exe -ano
$localAddresses = $open_ports | Select-String -Pattern '\d+\.\d+\.\d+\.\d+:\d+' -AllMatches | ForEach-Object { $_.Matches.Value }
$localAddresses
$ports = $open_ports | Select-Object Local
Write-Output $separator

Write-Host "[+] Console History [+]"
$path_history = $env:USERPROFILE + "\AppData\Roaming\Microsoft\Windows\Powershell\PSReadLine\ConsoleHost_history.txt"
$history = cat $path_history
if ($history){
    Write-Output $history
    }
Write-Output $separator
$services = Get-Service | Sort-Object -Property Name -Unique
$running_services = $services | Where-Object {$_.Status -eq "Running"} | Select-Object -Property Name, DisplayName, Status
Write-Host "ALL Services..."
Write-Output $services
Write-Host "Running Services..."
Write-Output $running_services
Write-Output $separator

$processes = Get-Process | Sort-Object -Property Name -Unique | Select-Object -Property Name, Path
foreach ($process in $processes) {
    if ($process.Path) {
        Write-Output $process
    }
}
Write-Output $separator

Write-Host "Tasks for system..."
$tasks = Get-ScheduledTask | Select-Object -Property Actions
foreach ($task in $tasks) {
    foreach ($action in $task.Actions) {
        if ($action.Execute) {
            Write-Output $action.Execute
        }
    }
}
Write-Output $separator

Write-Host "Installed apps and versions"
$apps = Get-WmiObject -Class Win32_Product | Select-Object -Property Name, Version
if ($apps.Count -eq 0) {
    Write-Output "[-] No Installed Apps [-]"
} else {
    Write-Output $apps
}
Write-Output $separator

Write-Host "[+] System Environment Variables [+]"
$envVariables = [System.Environment]::GetEnvironmentVariables()
foreach ($key in $envVariables.Keys) {
    Write-Output "${key}: $($envVariables[$key])"
}
Write-Output $separator

$answer = Read-Host "Do you want to save results? (Y/YES to confirm)"
if ($answer -eq "Y" -or $answer -eq "YES") {
    $file_name = Read-Host "Enter a filename"
    $path = Join-Path -Path $env:USERPROFILE -ChildPath $file_name
    $results = @(
        "Current User: $whoami",
        $credentials,
        $privileges,
        "Local Users:",
        $users,
        "Local Groups:",
        $groups,
        "ALL Services...",
        $services,
        "Running Services...",
        $running_services,
        "Installed apps and versions",
        $apps,
        "[+] System Environment Variables [+]"
    )
    foreach ($key in $envVariables.Keys) {
        $results += "${key}: $($envVariables[$key])"
    }
    $results | Out-File -FilePath $path
    Write-Host "Saved Successfully to $path"
} else {
    Write-Host "Process stopped by user!"
}
#######################
# Active Directory Info #
#######################

$domainControllers = Get-ADDomainController -Filter *
Write-Host $separator

$domainInfo = Get-ADDomain

$specificUsers = Get-ADUser -Filter { Enabled -eq $true -and MemberOf -ne $null } -Properties DisplayName, SamAccountName, EmailAddress | Select-Object -First 10
Write-Host $separator

$groupMemberships = foreach ($user in $specificUsers) {
    Get-ADUser $user.SamAccountName -Properties MemberOf | Select-Object -ExpandProperty MemberOf | Get-ADGroup | Select-Object Name, GroupScope, GroupCategory
}
Write-Host $separator

$lockedOutUsers = Search-ADAccount -LockedOut | Select-Object Name, SamAccountName, LockedOut

$inactiveUsers = Search-ADAccount -AccountInactive -TimeSpan 90.00:00:00 | Select-Object Name, SamAccountName, LastLogonDate

$expiredUsers = Search-ADAccount -AccountExpired | Select-Object Name, SamAccountName, AccountExpirationDate
Write-Host $separator

$gpos = Get-GPO -All
Write-Host $separator

Write-Host "Group Policy Objects:"
$gpos | Select-Object DisplayName, Id, CreationTime, ModificationTime
Write-Output $separator

$acl = Get-ObjectAcl -SamAccountName delegate -ResolveGUIDs | ? {$_.IdentityReference -eq "OFFENSE\spotless"}
$acl2 = Get-ObjectAcl -ResolveGUIDs | ? {$_.objectdn -eq "CN=Domain Admins,CN=Users,DC=offense,DC=local" -and $_.IdentityReference -eq "OFFENSE\spotless"}
$acl3 = Get-ObjectAcl -ResolveGUIDs | ? {$_.IdentityReference -eq "OFFENSE\spotless"}
Write-Output $acl $acl2 $acl3| more
Write-Host $separator

$gpo_perm = Get-NetGPO | %{Get-ObjectAcl -ResolveGUIDs -Name $_.Name} | ? {$_.IdentityReference -eq "OFFENSE\spotless"}
if ($gpo_perm){
    Write-Output $gpo_perm
    }
 Start-Sleep 2
 Write-Host $separator

