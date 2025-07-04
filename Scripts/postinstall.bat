@echo off

:: Ajouter au début du script
echo %date% %time% - Début installation > C:\install.log

echo Démarrage du script post-install...

:: Attendre que le réseau soit prêt (optionnel, utile si winget échoue parfois)
timeout /t 30 /nobreak >nul

:: Installer les applis GLOBALES (pour tous les utilisateurs)

echo Installation d'Okular (global)...
winget install --id=KDE.Okular -e --accept-source-agreements --accept-package-agreements --scope machine

echo Installation de Flameshot (global)...
winget install --id=Flameshot.Flameshot -e --accept-source-agreements --accept-package-agreements --scope machine

echo Installation de LibreOffice (global)...
winget install --id=LibreOffice.LibreOffice -e --accept-source-agreements --accept-package-agreements --scope machine

echo Installation de VLC (global)...
winget install --id=VideoLAN.VLC -e --accept-source-agreements --accept-package-agreements --scope machine

echo Installation de Firefox (global)...
winget install --id=Mozilla.Firefox -e --accept-source-agreements --accept-package-agreements --scope machine

echo Installation de GPU-Z (global)...
winget install --id=TechPowerUp.GPU-Z -e --accept-source-agreements --accept-package-agreements --scope machine

echo Installation d'AnyDesk (global)...
winget install --id=AnyDesk.AnyDesk -e --accept-source-agreements --accept-package-agreements --scope machine

echo Installation de NanaZip (global)...
winget install --id=M2Team.NanaZip -e --accept-source-agreements --accept-package-agreements --scope machine

echo Installation de WhoCrashed (global)...
winget install --id=Resplendence.WhoCrashed -e --accept-source-agreements --accept-package-agreements --scope machine

echo Installation de ScreenToGif (global)...
winget install --id=NickeManarin.ScreenToGif -e --accept-source-agreements --accept-package-agreements --scope machine

echo Installation de Powershell 7 (global)...
winget install --id=Microsoft.PowerShell -e --accept-source-agreements --accept-package-agreements --scope machine

echo Installation de Steam (global)...
winget install --id=Valve.Steam -e --accept-source-agreements --accept-package-agreements --scope machine

echo Installation de VScode (global)...
winget install --id=Microsoft.VisualStudioCode  -e --accept-source-agreements --accept-package-agreements --scope machine

echo Installation de Steam (global)...
winget install --id=Valve.Steam -e --accept-source-agreements --accept-package-agreements --scope machine




:: Supprimer les applis inutiles (via PowerShell avec gestion d'erreurs)

echo Suppression des applications préinstallées...
echo %date% %time% - Suppression apps inutiles >> C:\install.log

powershell -Command "try { Get-AppxPackage *Bing* | Remove-AppxPackage -ErrorAction SilentlyContinue } catch { Write-Host 'Bing déjà supprimé' }"
powershell -Command "try { Get-AppxPackage *Xbox* | Remove-AppxPackage -ErrorAction SilentlyContinue } catch { Write-Host 'Xbox déjà supprimé' }"
powershell -Command "try { Get-AppxPackage *CandyCrush* | Remove-AppxPackage -ErrorAction SilentlyContinue } catch { Write-Host 'CandyCrush déjà supprimé' }"
powershell -Command "try { Get-AppxPackage *StickyNotes* | Remove-AppxPackage -ErrorAction SilentlyContinue } catch { Write-Host 'StickyNotes déjà supprimé' }"
powershell -Command "try { Get-AppxPackage *Teams* | Remove-AppxPackage -ErrorAction SilentlyContinue } catch { Write-Host 'Teams déjà supprimé' }"
powershell -Command "try { Get-AppxPackage *Outlook* | Remove-AppxPackage -ErrorAction SilentlyContinue } catch { Write-Host 'Outlook déjà supprimé' }"

:: Importer les fichiers .reg du dossier Scripts
echo Importation des fichiers .reg dans le registre...
reg import "%~dp0Add_Edit_in_Notepad_context_menu_for_all_users.reg"
reg import "%~dp0Add_Edit_in_Notepad_context_menu_for_current_user.reg"
reg import "%~dp0Add_Edit_or_Run_with_to_PS1_context_menu.reg"
reg import "%~dp0Add_Open_in_Windows_Terminal_as_administrator.reg"
reg import "%~dp0Add_PS1_Run_as_administrator.reg"
reg import "%~dp0cmd.reg"
reg import "%~dp0NotepadClassic.reg"
reg import "%~dp0Restaurer_Visionneuse_photo_windows.reg"

:: Exécuter le script PowerShell
powershell -ExecutionPolicy Bypass -File "%~dp0dateheure.ps1"

echo Copie des exécutables depuis C:\Scripts vers System32...
xcopy /y /q "%~dp0*.exe" "C:\Windows\System32\"

:: Créer dossier PortableApps si absent
if not exist "C:\PortableApps" (
    mkdir "C:\PortableApps"
)

:: Copier tout le contenu du dossier Applications vers PortableApps
xcopy /E /I /Y "I:\ISO\tiny11\Scripts\Applications\*" "C:\PortableApps\"

:: Copier les applications dans le menu démarrer
echo Création des raccourcis dans le menu Démarrer commun...
powershell -Command ^
$WshShell = New-Object -ComObject WScript.Shell; ^
$apps = @( ^
    @{Name='CrystalDiskInfo'; Path='C:\PortableApps\CrystalDiskInfo9_2_3\DiskInfo64.exe'}, ^
    @{Name='DiskGenius'; Path='C:\PortableApps\DiskGeniusPortable\DiskGeniusPortable.exe'}, ^
    @{Name='R-Studio'; Path='C:\PortableApps\R-Studio\RStudio64.exe'}, ^
    @{Name='Victoria'; Path='C:\PortableApps\Victoria537\Victoria537\Victoria.exe'}, ^
    @{Name='NIUBI'; Path='C:\PortableApps\NIUBI Partition Editor\npe.exe'} ^
); ^
foreach ($app in $apps) { ^
    $ShortcutPath = "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\" + $app.Name + ".lnk"; ^
    $Shortcut = $WshShell.CreateShortcut($ShortcutPath); ^
    $Shortcut.TargetPath = $app.Path; ^
    $Shortcut.WorkingDirectory = (Split-Path $app.Path); ^
    $Shortcut.Save(); ^
}


:: Créer le dossier wallpapers dans Pictures s'il n'existe pas
if not exist "%USERPROFILE%\Pictures\wallpapers" (
    mkdir "%USERPROFILE%\Pictures\wallpapers"
)

:: Copier les fichiers
echo Copie des fonds d'écran dans le dossier Images...
xcopy /E /I /Y "I:\ISO\tiny11\Scripts\wallpapers\*" "%USERPROFILE%\Pictures\wallpapers\"

:: Supprimer la tâche planifiée

echo Suppression de la tâche planifiée...
schtasks /delete /tn "PostInstall" /f >nul 2>&1

:: Finaliser le log
echo %date% %time% - Script terminé >> C:\install.log

:: Supprimer ce script pour ne pas se relancer
del "%~f0"

:: Supprimer le dossier Scripts
rmdir /s /q "C:\Scripts"

echo Script post-install terminé.
exit
