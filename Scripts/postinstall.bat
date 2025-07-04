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


:: Supprimer les applis inutiles (via PowerShell avec gestion d'erreurs)

echo Suppression des applications préinstallées...
echo %date% %time% - Suppression apps inutiles >> C:\install.log

powershell -Command "try { Get-AppxPackage *Bing* | Remove-AppxPackage -ErrorAction SilentlyContinue } catch { Write-Host 'Bing déjà supprimé' }"
powershell -Command "try { Get-AppxPackage *Xbox* | Remove-AppxPackage -ErrorAction SilentlyContinue } catch { Write-Host 'Xbox déjà supprimé' }"
powershell -Command "try { Get-AppxPackage *CandyCrush* | Remove-AppxPackage -ErrorAction SilentlyContinue } catch { Write-Host 'CandyCrush déjà supprimé' }"
powershell -Command "try { Get-AppxPackage *StickyNotes* | Remove-AppxPackage -ErrorAction SilentlyContinue } catch { Write-Host 'StickyNotes déjà supprimé' }"
powershell -Command "try { Get-AppxPackage *Teams* | Remove-AppxPackage -ErrorAction SilentlyContinue } catch { Write-Host 'Teams déjà supprimé' }"
powershell -Command "try { Get-AppxPackage *Outlook* | Remove-AppxPackage -ErrorAction SilentlyContinue } catch { Write-Host 'Outlook déjà supprimé' }"

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
