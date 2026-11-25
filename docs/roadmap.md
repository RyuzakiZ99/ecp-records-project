# Roteiro do projeto — ECP Records

## 1. Pergunta de pesquisa

> Entre as músicas desta base, quais atributos musicais, e quais combinações deles, estão associados a mais reproduções **do que o esperado para a idade da música**? Quanto a fama do artista acrescenta a esses atributos?

O objetivo é investigar padrões e construir modelos interpretáveis para explicar e prever diferenças de popularidade **dentro da amostra disponível**, usando `streams` como indicador operacional de popularidade.

Este roteiro refina a proposta registrada em [proposition.md](./proposition.md). Ele segue duas respostas da proposta:

- **Q5 (hipótese):** uma combinação de fatores musicais, junto com o "efeito fama", leva ao sucesso.
- **Q5.5 (modelagem):** usar ao máximo os atributos musicais e depender o mínimo possível de atributos não musicais, como ano de lançamento e idade da música.

### Como a Q5.5 entra no desenho

- Os **atributos musicais são os preditores principais** e o foco de todas as explicações.
- Ano, período e idade **deixam de ser preditores**. A idade é usada só para ajustar o alvo: o modelo tenta explicar quanto a música ficou acima ou abaixo do esperado para a idade dela.
- A **fama** é um bloco separado, acrescentado depois, para medir o que soma aos atributos musicais.

Não basta apagar a idade. `streams` é acumulado, e músicas antigas tiveram mais tempo para acumular. Sem o ajuste, um atributo musical que mudou ao longo dos anos recebe o efeito do tempo: no notebook 02, a correlação de `danceability_%` com o alvo passa de −0,08 para +0,07 quando o ano é controlado.

### Por que o desenho anterior foi revisto

| Evidência (CV por música) | Resultado |
| --- | --- |
| Modelos do conjunto B (notebook 03) | MAE de 0,633 (árvore) e 0,634 (Ridge); na constante, 0,891 |
| Só a média do período, sem atributo musical* | MAE de 0,630: o ganho de B vem do período |
| Só a idade em dias, com curva suave* | MAE de 0,591: controla melhor o tempo que as cinco faixas |
| Atributos musicais no alvo ajustado pela idade* | Ganho de MAE entre −1,8% e +0,3%, conforme o modelo |
| Fama sem ajustar a idade* | Ganho de MAE de 3% a 4% com Ridge, árvore e floresta |
| Fama com o alvo ajustado pela idade* | Ganho de MAE entre −0,4% e +0,4% |
| Musical + fama com o alvo ajustado* | Ganho de MAE entre −1,3% e +1,0%; o melhor caso é a floresta, e cai para −0,1% na CV por artista |

\* Teste preliminar, feito fora do repositório. Deve ser reproduzido no notebook 03 antes de ser citado como resultado. Os testes com alvo ajustado e os de fama não incluem a música "Que Vuelvas" (ver seção 3).

### Limites da pergunta

- A base contém músicas já populares. Sem exemplos de músicas pouco populares, não podemos determinar o que separa um sucesso de um fracasso.
- Associação não implica causalidade: uma característica associada a mais streams não necessariamente produzirá mais streams se for alterada.
- Previsões e explicações do modelo não constituem uma receita garantida de sucesso.
- O sinal musical esperado é pequeno. O desenho dá aos atributos musicais a melhor chance de aparecer, mas não garante que exista uma fórmula.
- "Acima do esperado para a idade" é uma comparação entre músicas já populares, não uma medida absoluta de sucesso.
- A identidade do artista não mede diretamente sua fama. A base não tem audiência prévia, então a fama só pode ser aproximada (ver seção 2).
- A base reúne músicas populares em 2023, mas inclui lançamentos de 1930 a 2023. Apenas 175 dos 953 registros têm lançamento em 2023.
- É necessário confirmar na fonte a data de coleta e se `streams` representa reproduções acumuladas ou de um período específico. Não assumir que são apenas reproduções de 2023.

## 2. Hipóteses e desenho dos experimentos

1. Os atributos musicais predizem a popularidade ajustada pela idade melhor que uma previsão constante.
2. As **combinações** de atributos musicais (interações e relações não lineares) predizem melhor que a soma de efeitos lineares.
3. A fama do artista acrescenta informação aos atributos musicais.
4. Os padrões musicais se mantêm para artistas não vistos no treinamento e entre períodos de lançamento.

### Alvo

- **Principal:** `log1p(streams)` menos o valor esperado para a idade. O valor esperado vem de uma curva suave de `log1p(idade em dias)`, ajustada **somente no treino** de cada fold.
- **Secundário, para Anchors e contrafactuais:** acima ou abaixo da mediana do alvo ajustado, com a mediana calculada no treino.
- **Sensibilidade:** `log1p(streams)` sem ajuste e ajuste por período em vez de idade.

Como a mesma curva é subtraída do valor real e da previsão, o MAE no alvo ajustado é igual ao MAE da previsão completa (curva da idade + modelo musical). As comparações continuam na escala log.

### Conjuntos de variáveis

| Experimento | Variáveis explicativas | Alvo | Objetivo |
| --- | --- | --- | --- |
| **A — Musical (principal)** | BPM, tonalidade, modo, dançabilidade, valência, energia, acústica, instrumentalidade, vivacidade e proporção de fala | Ajustado | Medir o sinal dos atributos musicais (H1, H2 e H4) |
| **F — Fama** | Presença anterior do artista e quantidade de artistas | Ajustado | Medir a fama isolada |
| **A+F — Musical + fama** | Variáveis de A e de F | Ajustado | Testar a hipótese da Q5 (H3) |
| T — Tempo (referência) | Idade da música | Sem ajuste | Mostrar quanto o tempo explica sozinho |
| B e C (auxiliares) | Conjuntos já avaliados: A + período + quantidade de artistas; B + identidade do artista | Sem ajuste | Manter a comparação com os resultados anteriores |

As explicações da Etapa 4 usam A e A+F. T, B e C aparecem só como referência.

### Como aproximar a fama

- **Presença anterior:** número de músicas do artista na base lançadas **antes** da música analisada, em `log1p`. Excluir versões da mesma música e, em colaborações, usar o artista com maior contagem.
- A contagem usa apenas nomes e datas. Não usar a média de streams do artista, que vazaria o alvo.
- No teste preliminar, a contagem é zero em 40% das músicas e tem correlação de −0,44 com a idade. Por isso só deve ser avaliada com o alvo ajustado.
- A presença na base já reflete popularidade em 2023. Tratar como aproximação, nunca como efeito causal da fama.

### Outras regras

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
| "Que Vuelvas" com 2.762 streams; a segunda menor música tem 1,37 milhão. O valor já está assim no CSV original, e a música consta em 763 playlists do Spotify | **Decisão pendente.** Proposta: aplicar a regra do valor inválido (corrigir com fonte verificável ou excluir da modelagem) e reportar a sensibilidade com e sem ela |
| 91 registros com `ï¿½` nos nomes, alguns truncados, que a checagem atual não detecta | Ampliar a checagem e unificar as grafias de artista, porque elas definem os grupos por artista e a presença anterior |

### Tarefas

- [ ] Documentar a fonte, a coleta e o significado das variáveis.
- [ ] Conferir tipos, valores ausentes, datas, faixas e possíveis duplicatas.
- [ ] Registrar quantos registros são corrigidos, excluídos ou mantidos e por quê.
- [ ] Preservar o CSV original e tornar a limpeza reproduzível.
- [ ] Definir o tratamento das categorias e valores ausentes.
- [ ] Calcular a idade em dias e a presença anterior do artista, depois de resolver duplicatas e grafias.
- [ ] Registrar as decisões em `docs/decisions.md`, que ainda precisa ser criado.

**Entregável:** diagnóstico de qualidade, dicionário de dados e processo reproduzível de limpeza.

## 4. Etapa 2 — Análise exploratória

- [ ] Comparar a distribuição de `streams` na escala original e em `log1p(streams)`.
- [ ] Visualizar as distribuições dos atributos musicais e possíveis valores extremos.
- [ ] Examinar a relação entre idade e streams e escolher a forma da curva de ajuste.
- [ ] Calcular correlações de Spearman entre atributos musicais e o alvo, antes e depois do ajuste pela idade, e destacar as que mudam de sinal.
- [ ] Explorar combinações de atributos musicais (por exemplo, dançabilidade × valência), limitando a lista de pares antes de olhar o resultado.
- [ ] Examinar correlações entre os próprios atributos, para identificar redundância.
- [ ] Usar gráficos de dispersão para investigar relações não lineares.
- [ ] Comparar o alvo ajustado por tonalidade e modo.
- [ ] Comparar a presença anterior do artista com a idade e com o alvo ajustado.
- [ ] Investigar a concentração de registros por artista.
- [ ] Verificar se padrões aparentes mudam entre períodos de lançamento ou são dominados por poucos artistas.

Quando houver comparações inferenciais, reportar tamanho de efeito e incerteza, não apenas valores-p. Considerar testes de permutação e intervalos por bootstrap. Se forem testadas várias hipóteses simultaneamente, aplicar uma correção para comparações múltiplas, como Holm.

Considerar a dependência entre músicas do mesmo artista nas reamostragens. Resultados exploratórios descrevem a amostra selecionada, não todas as músicas do Spotify.

**Entregável:** gráficos e síntese das evidências, limitações e hipóteses que merecem modelagem.

## 5. Etapa 3 — Modelagem e validação

### Alvo e modelos iniciais

Usar regressão do alvo ajustado pela idade, definido na seção 2. A escala log reduz a assimetria de `streams`, sem exigir um corte arbitrário entre músicas “populares” e “não populares”.

Comparar:

1. **Baseline constante:** mediana do alvo ajustado no treinamento. Equivale a prever só pela idade.
2. **Regressão Ridge:** efeitos lineares e somados (H1).
3. **Árvore de decisão rasa:** regras legíveis usando só atributos musicais.
4. **Floresta aleatória:** interações e relações não lineares, para testar H2 contra a Ridge. SHAP, LIME e Anchors são mais úteis nela do que em uma árvore já legível.

Começar por A. Adicionar F e A+F depois de estabelecer essa comparação. Deixar redes neurais para uma extensão posterior, somente se houver justificativa experimental.

Cuidados com a árvore: profundidade até 3, pelo menos 40 músicas por folha e nenhuma variável de tempo entre os candidatos a nó. Não interpretar limiares ao pé da letra nem ajustar a árvore em busca de um desenho mais bonito.

### Protocolo de avaliação

- [ ] Fixar a semente aleatória e usar as mesmas divisões para comparar modelos e conjuntos de variáveis.
- [ ] Ajustar a curva da idade, a imputação, a codificação e a normalização somente nos dados de treinamento de cada fold.
- [ ] Conferir que o alvo ajustado não guarda relação relevante com a idade no teste.
- [ ] Impedir que registros duplicados da mesma música apareçam simultaneamente no treino e no teste.
- [ ] Usar validação cruzada para medir o desempenho em músicas não usadas no ajuste, distinguindo esse cenário da generalização para novos artistas.
- [ ] Fazer também avaliação por artista, tratando colaborações para evitar artistas compartilhados entre treino e teste; documentar a viabilidade e as limitações desse agrupamento.
- [ ] Definir explicitamente como o modelo trata artistas e categorias desconhecidos.
- [ ] Se houver ajuste de hiperparâmetros, fazê-lo sem consultar os dados usados na avaliação final.
- [ ] Comparar o ganho sobre o baseline e a variação de desempenho entre folds.
- [ ] Comparar cada modelo com um teste nulo: embaralhar as linhas dos atributos musicais e refazer o ajuste.
- [ ] Estimar a incerteza por bootstrap de artista e corrigir por Holm quando várias hipóteses forem testadas.
- [ ] Avaliar H4 também por período: treinar sem um período e medir nele a ordenação (Spearman), quando houver músicas suficientes. Ajustar a idade dentro do período testado, pois a curva não pode ser extrapolada.
- [ ] Repetir os resultados principais com e sem "Que Vuelvas" e com as duas formas de ajuste do tempo.

Métricas:

- **MAE na escala log:** erro absoluto médio no alvo ajustado.
- **R² no alvo ajustado:** parcela explicada da variação que sobra depois da idade; pode ser negativo.
- **Spearman entre previsão e alvo ajustado:** qualidade da ordenação.
- **AUC no alvo secundário:** 0,5 equivale ao acaso.

### Critério para passar à Etapa 4

Um conjunto tem sinal se superar o baseline nas duas formas de validação **e** o teste nulo. Se não tiver, os métodos da Etapa 4 ainda podem ser aplicados, mas como **análise exploratória do modelo**, com esse aviso em cada resultado. Não trocar de alvo, conjunto ou modelo até encontrar um que pareça significativo.

Nenhum ganho de F, A+F ou C deve ser chamado de “efeito causal da fama”. Também não se deve confundir generalização para novos artistas com generalização para outros anos.

**Entregável:** tabela comparativa de desempenho, protocolo de validação e análise dos ganhos de cada grupo de variáveis.

## 6. Etapa 4 — Interpretabilidade

Aplicar os métodos gradualmente, aos modelos A e A+F no alvo ajustado, com o desempenho da Etapa 3 informado ao lado de cada explicação:

1. **Importância por permutação:** medir, em dados de avaliação, quais atributos contribuem para a previsão. Permutar cada atributo musical e também os grupos inteiros (musicais × fama).
2. **SHAP:** estudar explicações globais e exemplos individuais. Mostrar o ranking entre os atributos musicais, a dependência e as interações na floresta. Um valor φ multiplica por cerca de e^φ os streams esperados para a idade.
3. **LIME e Anchors:** como extensão, comparar explicações locais, estabilidade e cobertura. Anchors usa o alvo secundário, e a precisão de cada regra deve ser comparada com a proporção base da classe.
4. **Contrafactuais e recourse:** explorar alterações plausíveis que mudem a previsão de “abaixo” para “acima do esperado”, respeitando limites dos atributos e dependências entre características. Somente atributos musicais podem mudar; idade e fama ficam fixas.

Em todos, verificar se o resultado se repete entre folds e entre a Ridge e a floresta, e compará-lo ao de um modelo treinado com os atributos musicais embaralhados.

Nos contrafactuais, evitar combinações fora do suporte dos dados. Uma mudança na previsão não garante uma mudança real nos streams.

Importâncias e explicações podem ser afetadas por atributos correlacionados; interpretá-las como comportamento do modelo, não como prova de causalidade.

**Entregável:** explicações globais, alguns casos individuais e avaliação crítica da estabilidade e plausibilidade dos resultados.

## 7. Etapa 5 — Responder à pergunta de pesquisa

Organizar a conclusão em torno de:

- Quanto os atributos musicais explicam além do esperado para a idade da música?
- Combinações de atributos musicais explicam mais que os efeitos isolados?
- Quanto a fama acrescenta aos atributos musicais, e com que limitações de medida?
- Quais padrões musicais são consistentes entre modelos, divisões dos dados e períodos?
- O desempenho se mantém para artistas não vistos?
- O que os métodos de interpretabilidade permitem explicar — e o que permanece incerto?

A resposta à Q4 (“existe uma fórmula global para fazer música?”) deve separar três resultados possíveis: sinal musical consistente, sinal fraco ou instável, e nenhum sinal distinguível do acaso.

A conclusão deve ser proporcional à evidência. Encontrar pouco sinal preditivo também é um resultado válido. Não apresentar uma regra universal de sucesso nem uma relação causal que o desenho observacional não permite estabelecer.

## 8. Próximo marco de execução

As Etapas 1 a 3 e parte da Etapa 4 já foram executadas com o desenho anterior. Nesta ordem:

1. **Notebook 01:** decidir "Que Vuelvas", corrigir as grafias de artista, calcular idade em dias e presença anterior, e registrar as decisões.
2. **Notebook 02:** refazer as correlações com o alvo ajustado e explorar as combinações.
3. **Notebook 03:** criar o alvo ajustado, reproduzir os testes preliminares da seção 1 e comparar baseline, Ridge, árvore e floresta em A, F e A+F.
4. **Notebook 04:** refazer permutação e SHAP nos modelos A e A+F. As regras da árvore saem da Etapa 4; a árvore fica na comparação de modelos.
5. Só então avançar para LIME, Anchors e contrafactuais.

As hipóteses foram renumeradas, então os resumos gerados em `reports/` ainda citam as antigas:

| Hipótese antiga | Situação |
| --- | --- |
| H1 — atributos musicais × constante | Continua como H1, agora no alvo ajustado |
| H2 — o período acrescenta informação | Já respondida; virou o controle de tempo |
| H3 — a identidade do artista acrescenta | Substituída pela fama (nova H3); a identidade fica no conjunto C, auxiliar |
| H4 — artistas não vistos | Continua como H4, ampliada para períodos |
| — | Nova H2: combinações de atributos musicais |

**Extensão opcional:** incluir uma base externa com músicas pouco populares e os mesmos atributos. Permitiria estudar o que separa um sucesso de um fracasso, mas exige conferir a compatibilidade das variáveis.

Não é necessário implementar todos os métodos de interpretabilidade de uma vez.
