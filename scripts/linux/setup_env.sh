
#!/bin/bash

set -e

# Identifica a raiz do projeto (dois níveis acima do script)
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

cd "$PROJECT_DIR"

echo "Diretorio do projeto: $PROJECT_DIR"
echo "Configurando ambiente virtual..."

# Cria ambiente virtual na raiz
if [ ! -d ".venv" ]; then
    python3.10 -m venv .venv
else
    echo "Ambiente virtual ja existe."
fi

# Ativa ambiente
source .venv/bin/activate

# Atualiza pip
python -m pip install --upgrade pip

# Instala dependências
if [ -f "requirements.txt" ]; then
    pip install -r requirements.txt
fi

# Instala Jupyter e kernel
pip install ipykernel

# Registra kernel
PROJECT_NAME="$(basename "$PROJECT_DIR")"

python -m ipykernel install --user \
    --name="ecp-records" \
    --display-name="Python ($PROJECT_NAME)"

echo ""
echo "Ambiente configurado com sucesso!"
echo "Ativacao: source .venv/bin/activate"
echo "Jupyter: jupyter notebook"
