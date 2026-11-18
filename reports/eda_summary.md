# Síntese da análise exploratória

Base: 952 músicas com `streams` válido, 458 artistas principais. Incerteza por bootstrap de cluster (artista principal); p ajustados por Holm.

## Quais atributos mostram sinal
- Nenhum atributo musical tem Spearman com IC excluindo zero após Holm. Sinal preditivo fraco é um resultado válido.

Contexto com sinal: `released_year` (rho = -0.68), `artist_count` (rho = -0.16)

## O que muda ao isolar período ou retirar grandes artistas
- `danceability_%` (todas: -0.08): troca de sinal em periodo=2000-2017, periodo=2022. cai a menos da metade em periodo=2018-2021, periodo=2023.
- `acousticness_%` (todas: -0.06): troca de sinal em periodo=2023. 
- `liveness_%` (todas: -0.06): troca de sinal em periodo=2000-2017. cai a menos da metade em periodo=pre-2000, sem_top20_artistas.
- `speechiness_%` (todas: -0.11): troca de sinal em periodo=2000-2017, periodo=2023. cai a menos da metade em periodo=pre-2000.

## Viés de `streams` acumulado
- Spearman(`released_year`, log_streams) = -0.68.
- Atributos cujo IC ainda exclui zero depois de controlar o ano: nenhum.

## Categorias
- `key`: epsilon² = 0.000, p_holm = 0.903
- `mode`: epsilon² = 0.002, p_holm = 0.206
- `release_period`: epsilon² = 0.479, p_holm = 0.0015

## Concentração por artista
- Top 10 artistas = 22.9% das linhas; top 50 = 44.3%.

## Hipóteses do roadmap
- Mapear aqui as hipóteses 1 a 4 do `roadmap.md` contra as evidências acima (o notebook não lê o roadmap).

## Limitações
- A amostra são músicas já populares (seleção pelo alvo), então correlações tendem a ser atenuadas.
- `streams` é acumulado e depende da idade da música.
- p de testes por grupo (seção 6) permutam linhas e são otimistas; os ICs por cluster são a referência.
- Correlação não é causa.
