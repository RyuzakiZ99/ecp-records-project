# ECP Records

## Projeto

Projeto de análise de dados musicais utilizando informações sobre as músicas mais populares do Spotify em 2023.

**Fonte dos dados:** [Top Spotify Songs 2023 – Kaggle](https://www.kaggle.com/datasets/nelgiriyewithana/top-spotify-songs-2023)

**Documentação:**
- [Proposição inicial](./docs/proposition.md)
- [Roteiro do projeto](./docs/roadmap.md)
- [Dicionário de dados](./docs/data.md)


## Configuração do ambiente

O projeto utiliza um ambiente virtual Python (`.venv`) para isolar suas dependências.

É necessário ter o Python 3.10 instalado.

### Windows (PowerShell)

Na raiz do projeto, execute:

```powershell
.\scripts\windows\setup_env.ps1
```

Para ativar o ambiente posteriormente:

```powershell
.\.venv\Scripts\Activate.ps1
```

### Linux

Na raiz do projeto, execute:

```bash
chmod +x scripts/linux/setup_env.sh
./scripts/linux/setup_env.sh
```

Para ativar o ambiente posteriormente:

```bash
source .venv/bin/activate
```

## Executando os notebooks

Após configurar e ativar o ambiente, execute:

```bash
jupyter notebook
```

Selecione o kernel `Python (ECP-Records)` ao abrir um notebook.

## Dependências

As bibliotecas e suas respectivas versões estão especificadas em [`requirements.txt`](./requirements.txt).

Para instalar as dependências manualmente:

```bash
pip install -r requirements.txt
```

