<## Get-EmpID

This returns the employee ID given the name of the employee.

#>

param(
  [Parameter(Mandatory=$False)]
  [string]$Name,
  [Parameter(Mandatory=$False)]
  [string]$FirstName,
  [Parameter(Mandatory=$False)]
  [string]$LastName
  )

# Check for name completion
while ($Name -eq $null) {
  $Name = Read-Host -Prompt "I need a name, please."
  }
  
