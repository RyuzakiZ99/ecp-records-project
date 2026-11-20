# Síntese da interpretabilidade (Etapa 4, itens 1 a 3)

Modelos: Ridge e árvore rasa no conjunto B, reproduzidos do notebook 03 (maior diferença de previsão = 3.6e-15); 952 músicas. Permutação nos folds de teste; SHAP dos modelos finais e dos modelos de fold.

## Regras da árvore
- Árvore final: raiz `release_period = 2023`, 8 folhas, previsões entre 67 e 944 milhões de streams; 6 folhas dependem de algum atributo musical; IQR mediano de log1p(streams) dentro das folhas = 0.99 (amplitude entre folhas = 2.64).
- Folds (musica): raiz mais comum `release_period = 2023` (93% das árvores); atributos musicais em pelo menos metade das árvores: danceability_%, valence_%; Spearman médio entre previsões de pares de árvores = 0.98.
- Folds (artista): raiz mais comum `release_period = 2023` (87% das árvores); atributos musicais em pelo menos metade das árvores: danceability_%, valence_%, energy_%; Spearman médio entre previsões de pares de árvores = 0.96.

## Ridge B
- Maior coeficiente musical: `danceability_%` = +0.089 por DP (≈+9.3% de streams), mesmo sinal em 100% dos folds; coeficientes de `release_period` entre -1.25 e +0.91.

## Importância por permutação (folds de teste)
- Razão = aumento do MAE ao permutar o grupo / ganho do modelo sobre o baseline. Acima de 1, com o grupo embaralhado o modelo erra mais que o baseline.
- arvore B / musica: contexto +0.458 de MAE (1.8× o ganho); atributos musicais +0.016 (0.06×).
- ridge B / musica: contexto +0.447 de MAE (1.7× o ganho); atributos musicais +0.006 (0.02×).
- arvore B / artista: contexto +0.439 de MAE (1.7× o ganho); atributos musicais +0.014 (0.06×).
- ridge B / artista: contexto +0.447 de MAE (1.7× o ganho); atributos musicais +0.007 (0.03×).
- arvore C / musica: permutar `main_artist` aumenta o MAE em +0.009.
- ridge C / musica: permutar `main_artist` aumenta o MAE em +0.030.

## SHAP
- Maior média de |SHAP| nos modelos finais: árvore `release_period`, ridge `release_period`.
- Fração da atribuição vinda de atributos musicais: modelos finais árvore 17% e ridge 28%; nos folds, arvore/musica 13 ± 4%; ridge/musica 30 ± 3%; arvore/artista 15 ± 4%; ridge/artista 30 ± 3%.
- Mover a previsão não é o mesmo que reduzir o erro: na ridge final, os atributos musicais respondem por 28% da atribuição SHAP, mas permutá-los aumenta o MAE em só 0.02× o ganho sobre o baseline (cenário música).
- Spearman médio entre rankings de folds: arvore/musica 0.70; ridge/musica 0.78; arvore/artista 0.66; ridge/artista 0.79.
- Concordância SHAP × permutação (Spearman): arvore/musica 0.61; ridge/musica 0.62; arvore/artista 0.63; ridge/artista 0.59; árvore × ridge: musica 0.17; artista 0.24.
- Conferência na árvore final (200 músicas, 5 jogadores): maior diferença entre o Shapley exato (atributo como jogador único) e o TreeSHAP com dummies somadas = 0.017 em log1p; mesmo ranking global: True.

## Evidência para as hipóteses do roadmap (parcial; a conclusão fica para a Etapa 5)
- H1 (atributos musicais preveem melhor que a constante): ganho de MAE do conjunto A sobre o baseline = 0.8% (ridge) e -1.0% (árvore) no cenário música; no B, permutar os 10 atributos musicais aumenta o MAE em 0.006 (ridge) e 0.016 (árvore).
- H2 (o período acrescenta informação): ganho do B = 28.7% (ridge) e 28.8% (árvore); permutar o contexto aumenta o MAE em 1.7× (ridge) e 1.8× (árvore) esse ganho.
- H3 (a identidade do artista acrescenta informação): ganho do C − ganho do B = +1.1 p.p. (ridge) e -0.4 p.p. (árvore) no cenário música.
- H4 (artistas não vistos): ganho do B no cenário artista = 28.6% (ridge) e 28.0% (árvore); fração musical do SHAP nos folds = 15% (árvore) e 30% (ridge).

## Limitações
- Importâncias e SHAP descrevem os modelos, não causas. `release_period` mistura tempo de acúmulo de streams e a sobrevivência de músicas antigas numa lista de 2023.
- O SHAP intervencional trata os atributos como independentes; na árvore, somar as dummies é uma aproximação (ver a conferência acima).
- O cenário por artista agrupa por `main_artist` (componente gigante no grafo de colaborações): colaboradores podem estar no treino e no teste.
- A amostra só tem músicas já populares (seleção pelo alvo).
- Dados ainda não tratados no notebook 01: 1 música(s) com streams < 1 milhão (mínimo = 2762) e 91 com caractere de substituição (`ï¿½`) no nome, não detectados pela verificação de mojibake.
