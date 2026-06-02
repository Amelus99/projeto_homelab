cat << 'EOF' > README.md
# 🚀 Projeto Homelab - Raspberry Pi 4B

Bem-vindo ao repositório de infraestrutura do meu Homelab! Este projeto gerencia uma stack de serviços auto-hospedados (Self-Hosted) rodando em um **Raspberry Pi 4B (4GB RAM)** com **Raspbian (ARM64)**.

O foco desta arquitetura é **eficiência extrema, baixo consumo de memória e estabilidade**. Todos os serviços foram meticulosamente limitados via `cgroups` (Deploy Resources) para evitar o acionamento do OOM Killer (Out-Of-Memory Killer) do Linux, garantindo que a stack inteira opere de forma fluida sem estourar a capacidade do hardware.

---

## 🏗️ Arquitetura de Hardware e Rede

* **Hardware Base:** Raspberry Pi 4 Model B (4GB de RAM).
* **Armazenamento de Mídia:** Ponto de montagem unificado em `/mnt/media`.
* **Rede:** Orquestração via `homelab_network` (Bridge customizada), com suporte a aceleração de hardware (`/dev/dri`) mapeada diretamente para os serviços de streaming.

---

## 🛠️ Stack de Serviços (Docker Compose)

A infraestrutura foi dividida em blocos lógicos para facilitar a manutenção. Abaixo está a lista de todos os contêineres ativos, suas portas de acesso local e o limite rígido de RAM alocado para cada um.

### 🌐 Dashboard & Utilitários
| Serviço | Porta(s) | RAM Máxima | Descrição |
| :--- | :--- | :--- | :--- |
| **Heimdall** | `80`, `443` | 64MB | Ponto de entrada central/dashboard para todos os serviços. |
| **Duplicati** | `8200` | 512MB | Rotinas de backup criptografado das configurações e volumes. |

### 📥 Downloads e Indexadores
| Serviço | Porta(s) | RAM Máxima | Descrição |
| :--- | :--- | :--- | :--- |
| **qBittorrent**| `8080`, `6881` | 512MB | Cliente de download via protocolo Torrent. |
| **Prowlarr** | `9696` | 256MB | Gerenciador central de indexadores e trackers. |
| **FlareSolverr**| `8191` | 1GB | Servidor proxy headless para resolver captchas do Cloudflare. |

### 🤖 Automação de Mídia (Os "Arrs")
| Serviço | Porta(s) | RAM Máxima | Descrição |
| :--- | :--- | :--- | :--- |
| **Radarr** | `7878` | 512MB | Gerenciamento e automação de Filmes. |
| **Sonarr** | `8989` | 512MB | Gerenciamento e automação de Séries de TV. |
| **Bazarr** | `6767` | 512MB | Busca, download e sincronização automática de legendas. |
| **Jellyseerr** | `5055` | 512MB | Portal de requisição e descoberta de mídia para os usuários. |

### 🍿 Gestão de Mídia & Streaming
| Serviço | Porta(s) | RAM Máxima | Descrição |
| :--- | :--- | :--- | :--- |
| **Jellyfin** | `8096` | 1.5GB | Servidor de mídia principal (com aceleração de hardware ativada). |
| **Plex** | Rede `host` | 1GB | Servidor de mídia secundário/alternativo operando direto na rede. |

### 📊 Estatísticas e Monitoramento
| Serviço | Porta(s) | RAM Máxima | Descrição |
| :--- | :--- | :--- | :--- |
| **Jellystat** | `3002` | 512MB | Dashboard de estatísticas de reprodução integrado ao Jellyfin. |
| **Jellystat-DB**| Interna | 128MB | Banco de dados PostgreSQL dedicado para o Jellystat. |
| **Uptime Kuma**| `3001` | 512MB | Monitoramento contínuo de uptime, latência e certificados. |

### 🛡️ Manutenção, Rede e Leitura
| Serviço | Porta(s) | RAM Máxima | Descrição |
| :--- | :--- | :--- | :--- |
| **AdGuard Home**| `53`, `3000`, `8082`| 128MB | Sinkhole de DNS para bloqueio de anúncios e rastreadores na rede. |
| **Suwayomi** | `4567` | 1GB | Servidor de mangás (Tachidesk) para leitura e download automatizado. |
| **Watchtower** | Interna | 128MB | Atualização automática das imagens Docker durante a madrugada. |

---

## 📂 Estrutura de Diretórios e Volumes

O projeto utiliza *Bind Mounts* relativos (`./nome_do_servico/config`) para manter todas as configurações de aplicativos na mesma pasta do repositório, facilitando backups via Duplicati. A mídia pesada é mapeada externamente via `/mnt/media`.

## ⚙️ Como Executar (Deployment)

1. Clone o repositório na máquina host:
   ```bash
   git clone [https://github.com/SEU_USUARIO/projeto_homelab.git](https://github.com/SEU_USUARIO/projeto_homelab.git)
   cd projeto_homelab
