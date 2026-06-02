cat << 'EOF' > README.md
# 🚀 Projeto Homelab - Raspberry Pi 4B

Bem-vindo ao repositório de infraestrutura do meu Homelab! Este projeto gerencia uma stack de serviços auto-hospedados (Self-Hosted) rodando em um **Raspberry Pi 4B (4GB RAM)** com **Raspbian Lite (64-bit)**.

O foco desta arquitetura é **eficiência extrema, baixo consumo de memória e estabilidade**, lidando com os gargalos de hardware de um SBC (Single Board Computer) ARM64, além de gerenciar tráfego de rede avançado e inferência de IA distribuída.

---

## 🏗️ Arquitetura de Hardware e Rede

* **Hardware Base:** Raspberry Pi 4 Model B (4GB de RAM).
* **SO:** Raspbian Lite (ARM64) - Headless.
* **Rede Privada (SDN):** O RPi atua como um **Exit Node do Tailscale** (Baremetal), garantindo acesso remoto seguro e criptografado para dispositivos móveis sem necessidade de expor portas na internet.
* **Processamento de IA Distribuído:** Para contornar a limitação de 4GB de RAM, as requisições de Inteligência Artificial são feitas através do Agente Pi local, mas a inferência (computação bruta) é processada via rede por um desktop remoto rodando **Ollama** utilizando uma RTX 4060, mantendo a RAM do Pi completamente livre para os serviços de mídia.

---

## 🛠️ Stack de Serviços

O ambiente é híbrido, misturando serviços isolados via Docker (com limitação rigorosa de recursos via `cgroups`) e aplicações nativas (*baremetal*) para máxima performance de I/O.

### 🐳 Docker (Gerenciados via Compose)
| Categoria | Serviço | Porta | Descrição |
| :--- | :--- | :--- | :--- |
| **Dashboard** | Heimdall | `80` | Ponto de entrada central para todos os serviços. |
| **Streaming** | Jellyfin | `8096` | Servidor de mídia open-source (Sam Home Video). |
| **Monitoramento** | Uptime Kuma | `3001` | Monitoramento contínuo de uptime e latência da stack. |
| **Monitoramento** | JellyStat | `3002` | Estatísticas detalhadas de reprodução do Jellyfin. |
| **Automação** | Prowlarr | `9696` | Gerenciador central de indexadores (Torrents/Usenet). |
| **Automação** | Sonarr | `8989` | Gerenciamento e automação de Séries de TV. |
| **Automação** | Radarr | `7878` | Gerenciamento e automação de Filmes. |
| **Automação** | Bazarr | `6767` | Busca, download e tradução automática de legendas. |
| **Download** | qBittorrent-nox | `8080` | Cliente de download integrado ao ecossistema Arr. |
| **Segurança** | Vaultwarden | `8083` | Gerenciador de senhas (backend em Rust). |
| **Backup** | Duplicati | `8200` | Backup criptografado de volumes e configurações. |

### 💻 Baremetal (Nativos no SO)
* **Plex Media Server (`32400`):** Operando nativamente para acesso direto ao hardware e melhor descoberta DLNA na rede local.
* **File Browser (`8081`):** Gerenciador de arquivos via interface web para manipulação direta de dados no armazenamento.
* **Tailscale:** Gerenciamento de rede mesh e túnel criptografado.
* **Ollama Pi:** Ponto de contato local para roteamento de agentes de IA.

---

## 📂 Estrutura do Repositório

* `docker-compose.yml`: A declaração unificada de todos os serviços Docker, redes e volumes, configurada com hard-limits de memória.
* `scripts/`: Scripts customizados para automação de manutenção, faxina de logs e monitoramento de desempenho.
* `.gitignore`: Previne o commit acidental de arquivos `.env`, bancos de dados sensíveis e chaves de API.

---

## ⚙️ Como Executar (Deployment)

1. Clone o repositório na máquina host:
```bash
   git clone [https://github.com/Amelus99/projeto_homelab.git](https://github.com/Amelus99/projeto_homelab.git)
   cd projeto_homelab
