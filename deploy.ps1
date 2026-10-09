<#
Publica cambios de este repo: git commit + push a GitHub, en un solo paso.
Vercel (invitacionmx-generador) esta conectado a GitHub, asi que el deploy
se dispara solo despues del push - no hace falta correr "vercel --prod".

Uso:
  .\deploy.ps1 "mensaje del cambio"
#>
param(
    [Parameter(Mandatory = $true)]
    [string]$Mensaje
)

$ErrorActionPreference = "Stop"
Set-Location $PSScriptRoot

git add -A
$hayCambios = git status --porcelain
if ($hayCambios) {
    git commit -m $Mensaje
    git push
    Write-Host "Subido a GitHub. Vercel desplegara solo en unos segundos (invitacionmx-generador)." -ForegroundColor Green
} else {
    Write-Host "No hay cambios nuevos para comitear." -ForegroundColor Yellow
}
