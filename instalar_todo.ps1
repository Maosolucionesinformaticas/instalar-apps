# ==========================================
# SCRIPT DE CONFIGURACIÓN MAESTRA (PRO) BY MAO
# ==========================================

# 1. LISTA DE APLICACIONES
$apps = @(
    "Microsoft.Office",
    "Google.Chrome",
    "VideoLAN.VLC",
    "7zip.7zip",
    "RARLab.WinRAR",
    "Adobe.Acrobat.Reader.64bit",
    "AnyDesk.AnyDesk"
)

# 2. LISTA DE BLOATWARE (Basura preinstalada)
$bloatware = @(
    "BingNews", "ZuneVideo", "ZuneMusic", "SkypeApp",
    "Office.OneNote", "WindowsFeedbackHub", "SolitaireCollection"
)

Write-Host "--- FASE 1: ELIMINANDO BLOATWARE ---" -ForegroundColor Magenta
foreach ($package in $bloatware) {
    Get-AppxPackage $package | Remove-AppxPackage -ErrorAction SilentlyContinue
}

Write-Host "`n--- FASE 2: INSTALANDO PROGRAMAS ---" -ForegroundColor Cyan
foreach ($app in $apps) {
    Write-Host "Instalando $app..."
    # --accept-package-agreements es clave para WinRAR ya que tiene licencia trial
    winget install --id $app --silent --accept-package-agreements --accept-source-agreements
}

Write-Host "`n--- FASE 3: PRIVACIDAD Y RENDIMIENTO ---" -ForegroundColor Yellow
Write-Host "Desactivando Telemetría y Publicidad de Windows..."

# Desactivar Telemetría
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "AllowTelemetry" -Type DWord -Value 0

# Desactivar anuncios en el menú Inicio y Sugerencias
$registryPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"
Set-ItemProperty -Path $registryPath -Name "SystemPaneSuggestionsEnabled" -Value 0
Set-ItemProperty -Path $registryPath -Name "SubscribedContent-338388Enabled" -Value 0
Set-ItemProperty -Path $registryPath -Name "SubscribedContent-338389Enabled" -Value 0

# Desactivar el "ID de publicidad"
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" -Name "Enabled" -Value 0

Write-Host "`n--- FASE 4: LIMPIEZA FINAL ---" -ForegroundColor Green
$tempFolders = @($env:TEMP, "C:\Windows\Temp")
foreach ($folder in $tempFolders) {
    Remove-Item "$folder\*" -Recurse -Force -ErrorAction SilentlyContinue
}
ipconfig /flushdns | Out-Null

Write-Host "`n--- FASE 5: ACTUALIZACIONES DE WINDOWS ---" -ForegroundColor Cyan
Write-Host "Buscando e instalando actualizaciones pendientes... Esto puede tardar."

# Instala el módulo de actualización si no existe
if (!(Get-Module -ListAvailable PSWindowsUpdate)) {
    Install-Module PSWindowsUpdate -Force -Confirm:$false -SkipPublisherCheck
}

# Comando para descargar e instalar todo de forma silenciosa
Get-WindowsUpdate -Install -AcceptAll -AutoReboot
Write-Host "`n--- ¡PC CONFIGURADA Y OPTIMIZADA POR MAO SOLUCIONES INFORMATICAS! ---" -ForegroundColor White -BackgroundColor Blue
Write-Host "Se recomienda reiniciar para aplicar todos los cambios."
Pause
