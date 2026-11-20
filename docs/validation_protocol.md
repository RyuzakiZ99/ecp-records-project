# Protocolo de validação (Etapa 3)

## Dados e alvo
- 952 músicas com `streams` válido (`usable_for_supervised`); alvo `log1p(streams)`.
- Conjuntos: A = atributos musicais; B = A + `release_period` + `artist_count`; C = B + `main_artist`.
- Fora de todos os modelos: `track_name`, playlists e charts.

## Divisões
- Semente 42; 5 folds x 3 repetições; mesmas divisões para todos os modelos e conjuntos. Índices em `reports/tables/cv_folds.json`.
- **Cenário 1 (música):** grupo = `song_group` (título + artistas normalizados). Versões duplicadas nunca ficam em treino e teste ao mesmo tempo.
- **Cenário 2 (artista):** a maior componente conexa do grafo de colaborações cobre 47.5% das músicas (292 componentes).
  Modo usado: **main_artist**. Como a componente é gigante, o agrupamento é só por `main_artist`: colaboradores podem aparecer no treino e no teste, então o cenário 2 é mais otimista do que um corte total por artista.

## Pré-processamento e hiperparâmetros
- Imputação, normalização e codificação dentro do `Pipeline`, ajustadas só no treino de cada fold.
- Ridge: alpha em 11 valores log-espaçados; árvore: `max_depth` 2-5 e `min_samples_leaf` 5-40. Busca por CV aninhada (`GroupKFold(3)` dentro do treino).

## Conjunto C e artistas novos
- Só artistas com pelo menos 3 músicas no treino são codificados; os demais e qualquer artista nunca visto caem em "outros".
- Fração média das músicas de teste com artista "desconhecido": música 60.6%, artista 100.0%.
  Esse número define quanto o conjunto C consegue de fato medir em cada cenário.

## Métricas
- MAE e R² em log, Spearman entre previsão e alvo, por fold; média ± desvio e ganho de MAE sobre o baseline (mediana do treino).
- Comparação pareada A vs B e B vs C com intervalo (`paired_comparison.csv`). Previsões fora da amostra em `predictions.csv`.

## Limitações
- C mede associação com a identidade do artista, **não** efeito causal da fama.
- `streams` é acumulado e a amostra são músicas já populares; pouco sinal preditivo é um resultado válido.
- Intervalos pareados tratam os folds como independentes, o que é aproximado.
