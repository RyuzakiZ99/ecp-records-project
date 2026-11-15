# Relatório de qualidade dos dados

- Linhas no CSV bruto: **953**
- Linhas removidas: **0**
- Linhas no arquivo limpo: **953**
- Linhas usáveis na modelagem supervisionada: **952**
- Artistas principais distintos: **459**

| Etapa | Item | n | Ação | Motivo |
| --- | --- | ---: | --- | --- |
| leitura | nomes com possível mojibake | 0 | mantidos e registrados | lido em cp1252; conferir manualmente se houver casos |
| numérico | valor não numérico em streams | 1 | convertido para NaN e registrado |  |
| numérico | separador de milhares em in_deezer_playlists | 79 | vírgula removida |  |
| numérico | separador de milhares em in_shazam_charts | 7 | vírgula removida |  |
| ausentes | in_shazam_charts vazio | 50 | tratado abaixo |  |
| ausentes | key vazio | 95 | tratado abaixo |  |
| ausentes | key vazio (tratamento) | 95 | categoria "Unknown" + key_missing | nunca imputar C |
| ausentes | in_shazam_charts vazio (tratamento) | 50 | NaN + indicador | fora dos modelos principais |
| validação | data de lançamento inválida | 0 | registrado |  |
| duplicatas | duplicatas exatas | 0 | removidas (mantida a primeira) |  |
| duplicatas | linhas em grupos quase_igual | 6 | política: flag | decisão final pendente |
| duplicatas | linhas em grupos divergente | 4 | política: flag | decisão final pendente |
| derivadas | artist_count diverge do nº de nomes | 2 | marcado em artist_count_mismatch | nomes com vírgula (ex.: 'Tyler, The Creator') também caem aqui |
| alvo | linhas sem streams válido | 1 | usable_for_supervised=False | fora da modelagem supervisionada; mantidas na EDA sem alvo |
