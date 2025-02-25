# PowerShell Skript zum Aktualisieren der hosts-Datei von GitHub

# URL zur hosts-Datei (ersetze dies mit der gewünschten URL)
$hostsURL = "https://raw.githubusercontent.com/666hwll/BlockDomains/master/ips"

# Zielpfad der hosts-Datei unter Windows
$hostsPath = "C:\Windows\System32\drivers\etc\hosts"

# Temporäre Datei zum Herunterladen der neuen hosts-Datei
$tempHosts = "$env:TEMP\hosts"

# Prüfen, ob das Skript mit Admin-Rechten läuft
function Test-Admin {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

if (-not (Test-Admin)) {
    Write-Host "Dieses Skript muss als Administrator ausgeführt werden!" -ForegroundColor Red
    Start-Sleep -Seconds 5
    exit
}

# Herunterladen der neuen hosts-Datei
Write-Host "Lade die aktuelle hosts-Datei von GitHub herunter..." -ForegroundColor Cyan
try {
    Invoke-WebRequest -Uri $hostsURL -OutFile $tempHosts -ErrorAction Stop
    Write-Host "Download erfolgreich!" -ForegroundColor Green
} catch {
    Write-Host "Fehler beim Herunterladen der hosts-Datei." -ForegroundColor Red
    exit
}

# Hosts-Datei ersetzen
Write-Host "Ersetze die aktuelle hosts-Datei..." -ForegroundColor Yellow
try {
    # Sicherung der alten hosts-Datei
    Copy-Item -Path $hostsPath -Destination "$hostsPath.bak" -Force

    # Neue Datei verschieben
    Move-Item -Path $tempHosts -Destination $hostsPath -Force

    Write-Host "Die hosts-Datei wurde erfolgreich aktualisiert!" -ForegroundColor Green
} catch {
    Write-Host "Fehler beim Ersetzen der hosts-Datei." -ForegroundColor Red
    exit
}

# Windows-DNS-Cache leeren
Write-Host "Leere den DNS-Cache..." -ForegroundColor Cyan
ipconfig /flushdns
Write-Host "Fertig!" -ForegroundColor Green
