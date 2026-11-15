
$ErrorActionPreference = "Stop"

# Identifica a raiz do projeto (dois níveis acima do script)
$ProjectDir = (Resolve-Path (Join-Path $PSScriptRoot "../..")).Path

Set-Location $ProjectDir

Write-Host "Diretorio do projeto: $ProjectDir"
Write-Host "Configurando ambiente virtual..."

# Cria ambiente virtual na raiz
if (-Not (Test-Path ".venv")) {
    py -3.10 -m venv .venv
} else {
    Write-Host "Ambiente virtual ja existe."
}

$Python = Join-Path $ProjectDir ".venv/Scripts/python.exe"

# Atualiza pip
& $Python -m pip install --upgrade pip

# Instala dependências
if (Test-Path "requirements.txt") {
    & $Python -m pip install -r requirements.txt
}

# Instala Jupyter e kernel
& $Python -m pip install ipykernel

# Registra kernel
$ProjectName = Split-Path $ProjectDir -Leaf

& $Python -m ipykernel install --user `
    --name="ecp-records" `
    --display-name="Python ($ProjectName)"

Write-Host ""
Write-Host "Ambiente configurado com sucesso!"
Write-Host "Ativacao: .\.venv\Scripts\Activate.ps1"
Write-Host "Jupyter: jupyter notebook"
