## Q1 - Nome do projeto:

ECP Records

## Q2 - Lista de tópicos:

- Alálise de dados.
- Modelos interpretáveis (árvores) OU Redes neurais
- LIME.
- Contrafactuais, Anchors e recourse
- Valores de Shapley e SHAP.
- Métodos globais baseados em efeitos e importância.

## Q3 - Definição do problema / objeto de estudo e o que já se sabe a respeito na literatura:

O objeto de estudo é rank de popularidade de músicas (de 2023) e se é possível definir uma fórmula para fazer uma música de sucesso, e como o impacto do artista e a influência de determinadas mudanças nas características da música afetam essa fórmula.

Como referência já encontramos o seguinte artigo que aborda tópicos semelhantes: '<https://www.academia.edu/108800370/Predicting_Music_Popularity_Using_Spotify_and_YouTube_Features>'

## Q4 - Grande pergunta fundamental:

Existe uma fórmula global para fazer música?

## Q5 - Hipótese específica para responder a pergunta:

Minha hipótese é que existe uma combinação de fatores musicais (bpm, root note, etc), combinado com 'efeito fama' que leva ao sucesso.

## Q5.5 - Como montar a modelagem e análise para responder à pergunta:

Nós queremos tentar usar ao máximo possível as categorias musicais (dancability_%, valence_%, liveliness_%) do dataset, e não depender tanto de atributos não relacionados à música em sí, como ano de lançamento da música e/ou idade da música por exemplo.

## Q6 - Possíveis limitações na hipótese e/ou falhas nas suposições:

A principal limitação na minha hipótese é que essa 'fórumla mágica' para produção de música pode não existir. Além disso, atributos musicais são não-lineares e podem não apresentar uma correlação definida. Outro grande risco é que os dados são puramente do ano de 2023, e por causa disso pode não ser uma fórmula generalizada para outros períodos.

## Q7 - Dados necessários para testar a hipótese/abordagem:

Para testar minha hipótese, são necessários dados de popularidade e composição das músicas.

## Q8 - Risco de abordagem:

É possível que o experimento não se generalize para outros anos, pois os dados são apenas do ano de 2023.

## Q9 - Risco técnico; quais desafios são antecipados.

O maior desafio que temos é não conseguir coletar dados além de 2023, e por consequência, não poder generalizar a fórmula.

## Q10:

Vou usar dados de músicas do spotify para descobrir se existe uma combinação de fatores musicais que permite a identificação/criação de uma música popular.