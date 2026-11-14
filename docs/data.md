## Dados disponíveis

Dicionário das 24 variáveis

| Coluna | Descrição | Tipo esperado | Unidade ou domínio | Papel no projeto | Pendências |
| --- | --- | --- | --- | --- | --- |
| `track_name` | Nome da música | Texto | Nome livre | Identificação; não usar como preditor | Sem pendências |
| `artist(s)_name` | Nome dos artistas da música | Texto | Um ou mais nomes de artistas | Identificação; preditor no experimento C | Sem pendências |
| `artist_count` | Número de artistas que contribuíram para a música | Inteiro | Contagem de artistas; esperado >= 1 | Contexto de lançamento e colaboração (B/C) | Sem pendências |
| `released_year` | Ano de lançamento da música | Inteiro | Ano do calendário (AAAA) | Contexto de lançamento (B/C) | Sem pendências |
| `released_month` | Mês de lançamento da música | Inteiro | Mês de 1 a 12 | Contexto de lançamento (B/C) | Validar em conjunto com ano e dia. |
| `released_day` | Dia do mês de lançamento da música | Inteiro | Dia de 1 a 31 conforme o mês e o ano | Contexto de lançamento (B/C) | Validar em conjunto com ano e mês. |
| `in_spotify_playlists` | Número de playlists do Spotify que incluem a música | Inteiro | Contagem de playlists; esperado >= 0 | Exposição; fora dos modelos principais | Confirmar dia e mês da coleta. |
| `in_spotify_charts` | Presença e classificação da música nos charts do Spotify | Numérico (codificação a confirmar) | Presença/classificação em charts; unidade não esclarecida | Exposição; fora dos modelos principais | Confirmar se o valor representa posição ou contagem e o significado de zero. |
| `streams` | Total acumulado de reproduções da música no Spotify até a data de coleta em 2023 | Inteiro | Contagem de reproduções; esperado >= 0 | Alvo | Confirmar dia e mês da coleta. |
| `in_apple_playlists` | Número de playlists do Apple Music que incluem a música | Inteiro | Contagem de playlists; esperado >= 0 | Exposição; fora dos modelos principais | Confirmar dia e mês da coleta. |
| `in_apple_charts` | Presença e classificação da música nos charts do Apple Music | Numérico (codificação a confirmar) | Presença/classificação em charts; unidade não esclarecida | Exposição; fora dos modelos principais | Confirmar se o valor representa posição ou contagem e o significado de zero. |
| `in_deezer_playlists` | Número de playlists do Deezer que incluem a música | Inteiro | Contagem de playlists; esperado >= 0 | Exposição; fora dos modelos principais | Normalizar separadores de milhares antes da conversão numérica. |
| `in_deezer_charts` | Presença e classificação da música nos charts do Deezer | Numérico (codificação a confirmar) | Presença/classificação em charts; unidade não esclarecida | Exposição; fora dos modelos principais | Confirmar se o valor representa posição ou contagem e o significado de zero. |
| `in_shazam_charts` | Presença e classificação da música nos charts do Shazam | Numérico (codificação a confirmar) | Presença/classificação em charts; unidade não esclarecida | Exposição; fora dos modelos principais | Confirmar se o valor representa posição ou contagem e o significado de zero; normalizar separadores de milhares; investigar o significado dos valores ausentes sem assumir zero. |
| `bpm` | Andamento da música medido em batidas por minuto | Numérico | Batidas por minuto; esperado > 0 | Atributo musical (A/B/C) | Sem pendências |
| `key` | Tonalidade da música | Categórico | Notas musicais; sem ordem numérica arbitrária | Atributo musical (A/B/C) | Investigar o significado dos valores vazios; não substituir automaticamente por C. |
| `mode` | Modo musical da música | Categórico | Major (maior) ou Minor (menor) | Atributo musical (A/B/C) | Sem pendências |
| `danceability_%` | Indicador de adequação da música para dançar | Numérico | Escala percentual; esperado de 0 a 100 | Atributo musical (A/B/C) | Confirmar método de cálculo e transformação. |
| `valence_%` | Indicador de positividade do conteúdo musical | Numérico | Escala percentual sugerida pelo nome; esperado de 0 a 100 | Atributo musical (A/B/C) | Confirmar escala, transformação e método de cálculo. |
| `energy_%` | Indicador de energia percebida da música | Numérico | Escala percentual sugerida pelo nome; esperado de 0 a 100 | Atributo musical (A/B/C) | Confirmar escala, transformação e método de cálculo. |
| `acousticness_%` | Indicador da quantidade de som acústico na música | Numérico | Escala percentual sugerida pelo nome; esperado de 0 a 100 | Atributo musical (A/B/C) | Confirmar escala, transformação e método de cálculo. |
| `instrumentalness_%` | Indicador da quantidade de conteúdo instrumental na música | Numérico | Escala percentual sugerida pelo nome; esperado de 0 a 100 | Atributo musical (A/B/C) | Confirmar escala, transformação e método de cálculo. |
| `liveness_%` | Indicador da presença de elementos de apresentação ao vivo | Numérico | Escala percentual sugerida pelo nome; esperado de 0 a 100 | Atributo musical (A/B/C) | Confirmar escala, transformação e método de cálculo. |
| `speechiness_%` | Indicador da quantidade de palavras faladas na música | Numérico | Escala percentual sugerida pelo nome; esperado de 0 a 100 | Atributo musical (A/B/C) | Confirmar escala, transformação e método de cálculo. |