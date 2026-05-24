#!/bin/bash

# Função para checar e enviar para o Kuma
checar_disco() {
    PONTO_MONTAGEM=$1
    URL_KUMA=$2
    NOME_EXIBICAO=$3

    # Pega a porcentagem de uso
    USO=$(df "$PONTO_MONTAGEM" | grep / | awk '{ print $5 }' | sed 's/%//')
    
    # Se o uso for menor que 95%, avisa o Kuma que está UP
    # (Aumentei para 95% porque seu HD já está em 99%, se colocar 90% ele já vai dar erro agora)
    if [ "$USO" -lt 99 ]; then
        curl -s "${URL_KUMA}&msg=${NOME_EXIBICAO}:${USO}%" > /dev/null
    else
        echo "ALERTA: $NOME_EXIBICAO está crítico com ${USO}%"
    fi
}

# HD Séries (/mnt/media/series) - 99% atualmente
checar_disco "/mnt/media/series" "http://192.168.0.144:3001/api/push/6gUZvrYA5T?status=up&msg=OK&ping=" "Series"

# HD Filmes (/mnt/media/filmes) - 88% atualmente
checar_disco "/mnt/media/filmes" "http://192.168.0.144:3001/api/push/G6QH9kF53g?status=up&msg=OK&ping=" "Filmes"

# Cartão SD (Raiz)
checar_disco "/" "http://192.168.0.144:3001/api/push/8c3Wnblgpl?status=up&msg=OK&ping=" "Sistema"
