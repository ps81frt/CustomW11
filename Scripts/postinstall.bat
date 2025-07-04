@echo off
echo Démarrage du script post-install...

:: Attendre que le réseau soit prêt (optionnel, utile si winget échoue parfois)
timeout /t 10 /nobreak >nul

:: Installer les applis avec winget (exemple)
winget install --id=Okular.Okular -e --accept-source-agreements --accept-package-agreements
winget install --id=Flameshot.Flameshot -e --accept-source-agreements --accept-package-agreements
winget install --id=LibreOffice.LibreOffice -e --accept-source-agreements --accept-package-agreements
winget install --id=VideoLAN.VLC -e --accept-source-agreements --accept-package-agreements
winget install --id=Mozilla.Firefox -e --accept-source-agreements --accept-package-agreements
winget install --id=Nanazip.Nanazip -e --accept-source-agreements --accept-package-agreements
winget install --id=WhoCrashed -e --accept-source-agreements --accept-package-agreements
winget install --id=TechPowerUp.GPU-Z -e --accept-source-agreements --accept-package-agreements
winget install --id=AnyDesk.AnyDesk -e --accept-source-agreements --accept-package-agreements
winget install --id=Screentogif.Screentogif -e --accept-source-agreements --accept-package-agreements

:: Supprimer les applis inutiles (exemple via PowerShell)
powershell -Command "Get-AppxPackage *Bing* | Remove-AppxPackage"
powershell -Command "Get-AppxPackage *Xbox* | Remove-AppxPackage"
powershell -Command "Get-AppxPackage *CandyCrush* | Remove-AppxPackage"

:: Suppression du pense-bête (Sticky Notes)
powershell -Command "Get-AppxPackage *StickyNotes* | Remove-AppxPackage"

:: Supprimer la tâche planifiée
schtasks /delete /tn "PostInstall" /f

:: Supprimer ce script pour ne pas se relancer
del "%~f0"

echo Script post-install terminé.
exit
