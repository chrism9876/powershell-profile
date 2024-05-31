##Key Handlers

  Set-PSReadLineKeyHandler -Chord 'Ctrl+w' -Function BackwardDeleteWord

##Admin tools
  
  $isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
  if($isAdmin){

   $tools = @(

       [pscustomobject]@{Description='Active Directory Users & Computers';Name='ad';exePath="$env:SystemRoot\system32\dsa.msc"}

       [pscustomobject]@{Description='Group Policy Management';Name='gpm';exePath="$env:SystemRoot\system32\gpmc.msc"}

       [pscustomobject]@{Description='Configuration Manager Console';Name='sccm';exePath="${env:ProgramFiles(x86)}\Microsoft Endpoint Manager\AdminConsole\bin\Microsoft.ConfigurationManagement.exe"}

       [pscustomobject]@{Description='PDQ Deploy Console';Name='pdqd';exePath="${env:ProgramFiles(x86)}\Admin Arsenal\PDQ Deploy\PDQDeployConsole.exe"}

       [pscustomobject]@{Description='PDQ Inventory Console';Name='pdqi';exePath="${env:ProgramFiles(x86)}\Admin Arsenal\PDQ Inventory\PDQInventoryConsole.exe"}

   )
   # Fuction Builder
   foreach($tool in $tools){
   $name=$tool.Name
   $exepath=$tool.exePath
   $funcBuild="function $name {start-process `"$exepath`"}"
   $funcBuild | iex
   }


  }else{

    # Fuction Builder
   foreach($tool in $tools){
   $name=$tool.Name
   $funcBuild="function $name {write-warning `"Admin needed`"}"
   $funcBuild | iex
   }
  }
function Get-Tools{
 Param
    (

        [Parameter(Mandatory=$false, Position=0, ParameterSetName='exe')]
        [switch] $exe=$false
      )
      if($exe){
    $tools | Select-Object -Property Name,Description,exePath
    }else{
    $tools | Select-Object -Property Name,Description
    }

}
## Custom Fuctions

  function ip{

    Get-NetIPAddress -AddressFamily IPv4 | Where-Object {
      $_.IPAddress -like "10.*.*.*" -or $_.IPAddress -match "(172\.1[6-9]\.\d+\.\d+)|(172\.2[0-9]\.\d+\.\d+)|(172\.3[0-1]\.\d+\.\d+)" -or $_.IPAddress -like "192.168.*.*"
    }| select-object IPAddress, InterfaceAlias

  }

  function get-pword{
    Param
      (
         
        [Parameter(Mandatory=$false, Position=0, ParameterSetName='Strong')]
        [switch] $Strong=$false
      )

    if($Strong -eq $true){
      (iwr https://www.dinopass.com/password/strong).Content
    }else{
      (iwr https://www.dinopass.com/password/simple).Content
    }

  }

##OH-MY-POSH
  if(!(test-path "$HOME\AppData\Local\Programs\oh-my-posh\bin\oh-my-posh.exe")){
    Set-ExecutionPolicy Bypass -Scope Process -Force; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://ohmyposh.dev/install.ps1'))
  }

  oh-my-posh.exe init pwsh | Invoke-Expression

  import-module -name Terminal-Icons
