# Roteiro do projeto — ECP Records

## 1. Pergunta de pesquisa

> Entre as músicas desta base, quais características estão associadas a mais reproduções? Quanto os atributos musicais explicam, comparados à identidade do artista e ao período de lançamento?

O objetivo é investigar padrões e construir modelos interpretáveis para explicar e prever diferenças de popularidade **dentro da amostra disponível**, usando `streams` como indicador operacional de popularidade.

Este roteiro refina a proposta registrada em [proposition.md](./proposition.md).

### Limites da pergunta

- A base contém músicas já populares. Sem exemplos de músicas pouco populares, não podemos determinar o que separa um sucesso de um fracasso.
- Associação não implica causalidade: uma característica associada a mais streams não necessariamente produzirá mais streams se for alterada.
- Previsões e explicações do modelo não constituem uma receita garantida de sucesso.
- A identidade do artista não mede diretamente sua fama. Para investigar fama com mais rigor, seria necessário um indicador anterior ao resultado, como audiência prévia.
- A base reúne músicas populares em 2023, mas inclui lançamentos de 1930 a 2023. Apenas 175 dos 953 registros têm lançamento em 2023.
- É necessário confirmar na fonte a data de coleta e se `streams` representa reproduções acumuladas ou de um período específico. Não assumir que são apenas reproduções de 2023.

## 2. Hipóteses e desenho dos experimentos

1. Atributos musicais predizem streams melhor que uma previsão constante.
2. O período de lançamento acrescenta informação aos atributos musicais.
3. A identidade do artista acrescenta informação aos atributos musicais e ao contexto de lançamento.
4. Os padrões aprendidos mantêm alguma capacidade preditiva para artistas não vistos no treinamento.

Comparar os seguintes conjuntos de variáveis:

| Experimento | Variáveis explicativas | Objetivo |
| --- | --- | --- |
| A — Musical | BPM, tonalidade, modo, dançabilidade, valência, energia, acústica, instrumentalidade, vivacidade e proporção de fala | Medir o sinal preditivo dos atributos musicais |
| B — Musical + contexto | Variáveis de A + período de lançamento e quantidade de artistas | Avaliar o ganho proporcionado pelo contexto |
| C — Musical + contexto + artista | Variáveis de B + identidade do artista | Avaliar a informação adicional da identidade do artista |

Não usar nome da música como preditor. Tratar tonalidade como categoria, sem atribuir uma ordem numérica arbitrária às notas.

Playlists e charts ficam fora dos modelos principais: podem refletir o próprio sucesso e não estar disponíveis antes dele. Caso sejam analisados, criar um experimento separado sobre exposição e popularidade, sem apresentá-lo como uma fórmula de composição musical.

## 3. Etapa 1 — Auditar e preparar os dados

Fonte local: [spotify-2023.csv](./dataset/spotify-2023.csv).

### Achados da inspeção inicial

| Achado | Ação |
| --- | --- |
| 953 registros e 24 colunas | Criar um dicionário de dados e conferir os significados na fonte |
| Arquivo não é UTF-8; leitura realizada com `cp1252` | Definir explicitamente a codificação e verificar os nomes importados |
| Um valor inválido em `streams` | Inspecionar e corrigir somente com fonte verificável; caso contrário, excluir esse registro da modelagem supervisionada e registrar a decisão |
| 95 valores vazios em `key` | Investigar a origem da ausência; não substituir automaticamente por `C`, embora essa tonalidade não apareça nos valores preenchidos |
| 50 valores vazios em `in_shazam_charts` | Tratar como ausentes, sem assumir que significam zero |
| Contagens com separador de milhares, como `"2,445"` | Normalizar os separadores antes da conversão numérica |
| Quatro pares repetidos de nome da música + artistas | Conferir versões e diferenças entre registros antes de deduplicar |

### Tarefas

- [ ] Documentar a fonte, a coleta e o significado das variáveis.
- [ ] Conferir tipos, valores ausentes, datas, faixas e possíveis duplicatas.
- [ ] Registrar quantos registros são corrigidos, excluídos ou mantidos e por quê.
- [ ] Preservar o CSV original e tornar a limpeza reproduzível.
- [ ] Definir o tratamento das categorias e valores ausentes.

**Entregável:** diagnóstico de qualidade, dicionário de dados e processo reproduzível de limpeza.

## 4. Etapa 2 — Análise exploratória

- [ ] Comparar a distribuição de `streams` na escala original e em `log1p(streams)`.
- [ ] Visualizar as distribuições dos atributos musicais e possíveis valores extremos.
- [ ] Calcular correlações de Spearman entre atributos numéricos e streams.
- [ ] Examinar correlações entre os próprios atributos, para identificar redundância.
- [ ] Usar gráficos de dispersão para investigar relações não lineares.
- [ ] Comparar streams por tonalidade, modo e período de lançamento.
- [ ] Investigar a concentração de registros por artista.
- [ ] Verificar se padrões aparentes mudam entre períodos de lançamento ou são dominados por poucos artistas.

Quando houver comparações inferenciais, reportar tamanho de efeito e incerteza, não apenas valores-p. Considerar testes de permutação e intervalos por bootstrap. Se forem testadas várias hipóteses simultaneamente, aplicar uma correção para comparações múltiplas, como Holm.

Considerar a dependência entre músicas do mesmo artista nas reamostragens. Resultados exploratórios descrevem a amostra selecionada, não todas as músicas do Spotify.

**Entregável:** gráficos e síntese das evidências, limitações e hipóteses que merecem modelagem.

## 5. Etapa 3 — Modelagem e validação

### Alvo e modelos iniciais

Usar regressão de `log1p(streams)` como abordagem inicial. Isso reduz a influência da escala muito assimétrica, sem exigir um corte arbitrário entre músicas “populares” e “não populares”.

Comparar:

1. **Baseline constante:** mediana do alvo de treinamento, como referência para MAE.
2. **Regressão Ridge:** referência regularizada e relativamente simples.
3. **Árvore de decisão rasa:** modelo capaz de representar relações não lineares por regras legíveis.

Começar pelos experimentos A e B. Adicionar C depois de estabelecer essa comparação. Deixar redes neurais para uma extensão posterior, somente se houver justificativa experimental.

### Protocolo de avaliação

- [ ] Fixar a semente aleatória e usar as mesmas divisões para comparar modelos e conjuntos de variáveis.
- [ ] Ajustar imputação, codificação e normalização somente nos dados de treinamento de cada fold.
- [ ] Impedir que registros duplicados da mesma música apareçam simultaneamente no treino e no teste.
- [ ] Usar validação cruzada para medir o desempenho em músicas não usadas no ajuste, distinguindo esse cenário da generalização para novos artistas.
- [ ] Fazer também avaliação por artista, tratando colaborações para evitar artistas compartilhados entre treino e teste; documentar a viabilidade e as limitações desse agrupamento.
- [ ] Definir explicitamente como o modelo trata artistas e categorias desconhecidos.
- [ ] Se houver ajuste de hiperparâmetros, fazê-lo sem consultar os dados usados na avaliação final.
- [ ] Comparar o ganho sobre o baseline e a variação de desempenho entre folds.

Métricas:

- **MAE na escala log:** erro absoluto médio no alvo transformado.
- **R² na escala log:** desempenho em relação à referência baseada na média; pode ser negativo.
- **Spearman entre previsão e alvo:** qualidade da ordenação de popularidade.

O ganho do experimento C não deve ser chamado automaticamente de “efeito causal da fama”. Também não se deve confundir generalização para novos artistas com generalização para outros anos.

**Entregável:** tabela comparativa de desempenho, protocolo de validação e análise dos ganhos de cada grupo de variáveis.

## 6. Etapa 4 — Interpretabilidade

Aplicar os métodos gradualmente, a modelos com desempenho previamente avaliado:

1. **Regras da árvore:** identificar padrões legíveis e verificar se mudam muito entre divisões dos dados.
2. **Importância por permutação:** medir, em dados de avaliação, quais atributos contribuem para a previsão.
3. **SHAP:** estudar explicações globais e exemplos individuais.
4. **ALE ou PDP:** investigar como a previsão responde aos atributos, considerando correlações e regiões com poucos dados.
5. **LIME e Anchors:** como extensão, comparar explicações locais, estabilidade e cobertura.
6. **Contrafactuais e recourse:** explorar alterações plausíveis que mudem a previsão, respeitando limites dos atributos e dependências entre características.

Nos contrafactuais, não sugerir troca de identidade do artista ou data de lançamento como ações musicais. Evitar combinações fora do suporte dos dados. Uma mudança na previsão não garante uma mudança real nos streams.

Importâncias e explicações podem ser afetadas por atributos correlacionados; interpretá-las como comportamento do modelo, não como prova de causalidade.

**Entregável:** explicações globais, alguns casos individuais e avaliação crítica da estabilidade e plausibilidade dos resultados.

## 7. Etapa 5 — Responder à pergunta de pesquisa

Organizar a conclusão em torno de:

- Quanto os atributos musicais ajudam a prever streams em comparação ao baseline?
- Qual é o ganho ao incluir contexto de lançamento e identidade do artista?
- Quais padrões são consistentes entre modelos e divisões dos dados?
- O desempenho se mantém para artistas não vistos?
- O que os métodos de interpretabilidade permitem explicar — e o que permanece incerto?

A conclusão deve ser proporcional à evidência. Encontrar pouco sinal preditivo também é um resultado válido. Não apresentar uma regra universal de sucesso nem uma relação causal que o desenho observacional não permite estabelecer.

## 8. Primeiro marco de execução

Prioridade inicial:

1. Auditar e limpar a base.
2. Produzir a análise exploratória.
3. Comparar baseline, Ridge e árvore nos experimentos A e B.
4. Avaliar as primeiras regras e importâncias.

Avançar para identidade do artista e explicações locais após esse marco. Não é necessário implementar todos os métodos de interpretabilidade de uma vez.