# Documentação Oficial: RPG - Procura-se Exploradores

## 1. Visão Geral do Projeto

O "RPG - Procura-se Exploradores" (apelidado de "Tinder de RPG") é um hub de matchmaking projetado para conectar jogadores e mestres de RPG. O objetivo principal é solucionar a incompatibilidade de horários, a falta de confiança em jogadores desconhecidos e o alto índice de faltas ("furos") nas sessões, através de um sistema de afinidade, reputação e chat direto.

## 2. Escolhas de Software e Arquitetura

Para garantir alta performance, facilidade de trabalho em equipe e uma interface nativa fluida, a base tecnológica foi definida da seguinte forma:

* **Front-end:** Flutter. Permite compilação nativa, garantindo os 60fps necessários para a fluidez das animações de cards (swipes).

* **Gerenciamento de Estado:** Provider. Escolhido pela curva de aprendizado amigável, ideal para equipes acadêmicas, mantendo o estado reativo de forma simples.

* **Arquitetura de Diretórios:** Feature-First. O código é organizado por domínios de negócio (ex: `auth`, `matchmaking`, `chat`), minimizando conflitos de *merge* quando vários alunos trabalham no mesmo repositório.

* **Roteamento:** GoRouter. Solução oficial, baseada em URLs, que facilita o controle de rotas protegidas (ex: impedir acesso ao chat se não estiver logado).

* **Back-end e Banco de Dados:** Supabase. Atua como BaaS (Backend-as-a-Service), provendo banco PostgreSQL, Autenticação, Storage e Realtime via WebSockets.

* **Segurança (RLS):** Row Level Security direto no banco. Regras como "não exibir cards de usuários já avaliados" serão tratadas pelo Supabase, aliviando o processamento do aplicativo.

* **Performance de UI:** `cached_network_image` para cache local de avatares e imagens de campanhas.

* **Padrões de Código:** Código escrito 100% em Inglês (variáveis, classes, commits). Utilização do `flutter_lints` em modo rigoroso para padronizar a escrita do grupo.

## 3. Casos de Uso Principais (Use Cases)

1. **UC01 - Matchmaking (Swipe):** O usuário (jogador ou mestre) visualiza cards (de campanhas ou de perfis). Ele pode deslizar para a esquerda (X - Recusar) ou direita (Check - Aceitar). Se houver aceite mútuo entre mestre e jogador, o sistema registra um "Match".

2. **UC02 - Cadastro de Campanhas:** Um mestre de RPG pode criar uma mesa especificando o sistema (ex: D&D, Ordem Paranormal), título, descrição, estilo de jogo (tags) e imagem de capa.

3. **UC03 - Comunicação Pós-Match (Chat):** Após um match, um canal de texto é aberto. Os usuários podem trocar mensagens em tempo real para combinar detalhes, horários e links (como Discord ou VTTs).

4. **UC04 - Gestão de Perfil e Reputação:** Os usuários mantêm um perfil com avatar, bio e um sistema de "Familiaridade" (Reputação) alimentado por avaliações pós-jogo e check-ins de presença.

5. UC05 - Chat de IA explicando os jogos (mockup)

## 4. Design e Identidade Visual

O aplicativo segue uma estética imersiva focada em fantasia medieval:

* **Paleta de Cores:** Tons terrosos. Fundo marrom escuro (`#2C1A12`), detalhes em laranja rústico (`#D35400`) e marrom sela (`#8B4513`).

* **Texturas:** O fundo principal simula textura de madeira. Os contêineres de texto e cards de perfil simulam pergaminhos envelhecidos (creme `#F0E6D2`).

* **Navegação Inferior (Bottom Tab):** Ícones temáticos em vez de padrões convencionais:

  * Dado (Rolagens/Sistemas)

  * Lupa (Pesquisa/Filtros)

  * Dragão (Match/Home - Tela Central)

  * Chapéu de Mago (IA/Ferramentas Futuras)

  * Avatar (Perfil/Loja)

## 5. Plano de Execução (Prompt a Prompt)

Este é o roteiro que usaremos com a Inteligência Artificial para construir o app progressivamente. Para avançar no projeto, copie e cole o objetivo de cada etapa no chat quando formos programar:

* **Prompt 1: Setup Core e Design System.** "Crie o arquivo `constants/colors.dart` com nossa paleta terrosa, e implemente o `main.dart` configurando o `GoRouter` e o `Provider`. Faça também o widget reutilizável `ParchmentCard`."

* **Prompt 2: Layout da Home e Bottom Navigation.** "Crie o esqueleto da tela principal que conterá o BottomNavigationBar com os ícones temáticos (Dado, Lupa, Dragão, Chapéu, Avatar)."

* **Prompt 3: Motor de Swipe (Mockado).** "Na feature de matchmaking, crie a `SwipeScreen` utilizando o `flutter_card_swiper`. Crie modelos de dados mockados (falsos) de campanhas e perfis para testarmos as animações e física de jogar para os lados."

* **Prompt 4: Autenticação com Supabase.** "Configure o cliente Supabase no diretório `core/services`. Crie as telas de `LoginScreen` e `RegisterScreen` na feature `auth`, conectando-as com os métodos de e-mail/senha do Supabase."

* **Prompt 5: Integração de Banco (Swipes Reais).** "Substitua os dados mockados da `SwipeScreen` por uma *Query* no Supabase. Implemente a lógica no Provider para salvar na tabela `swipes` toda vez que o usuário deslizar um card."

* **Prompt 6: Lista de Matches e Chat.** "Na feature de chat, crie a tela `ChatList` puxando os matches do banco. Depois, crie a `ChatRoom` usando os *Streams* do Supabase (Realtime) para envio e recebimento de mensagens instantâneas."

* **Prompt 7: Perfil e Criação de Campanhas.** "Na feature de profile, crie o formulário para edição de bio e foto. Adicione também a tela para o Mestre preencher os dados de uma nova campanha e salvar na tabela `campaigns`."