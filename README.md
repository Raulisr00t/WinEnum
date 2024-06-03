# System and Active Directory Information Script

## Description

This PowerShell script is designed to gather detailed information about the local machine and the Active Directory (AD) environment. It retrieves information such as user credentials, local users and groups, network interfaces, active ports, system services, running processes, scheduled tasks, installed applications, system environment variables, and Active Directory details. The script can also save the collected information to a file if the user chooses to do so.

## Prerequisites

- PowerShell 5.1 or later
- Necessary permissions to execute the script and access the required resources
- Active Directory module for PowerShell installed on the system

## Usage

1. **Run the Script:**
   To execute the script, open PowerShell with administrative privileges and run the script.

2. **Prompt for Saving Results:**
   After collecting all the information, the script will prompt you to save the results. Type `Y` or `YES` to confirm.

3. **Enter Filename:**
   If you choose to save the results, you will be prompted to enter a filename. The script will save the results in the specified file within the user's profile directory.

## Output

The script outputs information to the console and can optionally save the results to a file. The collected information includes:

### Local System Information

1. **Current User:**
   The username of the current user executing the script.

2. **Saved Credentials:**
   Lists saved credentials for the current user.

3. **User Privileges:**
   Displays the privileges of the current user.

4. **Local Users:**
   Lists all local users on the machine.

5. **Local Groups:**
   Lists all local groups on the machine.

6. **Network Interfaces:**
   Displays information about network interfaces including name, description, and status.

7. **Network Connection Test:**
   Tests connectivity to `google.com` and reports if the machine is connected to the network.

8. **IP Addresses:**
   Lists IP addresses for each network interface.

9. **Active Ports:**
   Lists active listening ports on the machine.

10. **Console History:**
    Displays the PowerShell console command history.

11. **System Services:**
    Lists all system services and highlights the running services.

12. **Running Processes:**
    Lists all running processes along with their paths.

13. **Scheduled Tasks:**
    Lists all scheduled tasks and their actions.

14. **Installed Applications:**
    Lists all installed applications and their versions.

15. **System Environment Variables:**
    Displays all system environment variables.

### Active Directory Information

1. **Domain Controllers:**
   Lists all domain controllers in the domain.

2. **Domain Information:**
   Displays information about the Active Directory domain.

3. **Specific Users:**
   Lists specific enabled users who are members of groups (limited to 10 users).

4. **Group Memberships:**
   Displays group memberships for specific users.

5. **Locked Out Users:**
   Lists all locked-out user accounts.

6. **Inactive Users:**
   Lists user accounts that have been inactive for 90 days.

7. **Expired Users:**
   Lists user accounts that have expired.

8. **Group Policy Objects:**
   Lists all Group Policy Objects (GPOs) in the domain.

9. **ACL Information:**
   Displays Access Control List (ACL) information for specific accounts and objects.

## Example

```powershell
PS C:\> .\WinEnum.ps1
