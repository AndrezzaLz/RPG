# Feature: Matchmaking

Esta funcionalidade é o núcleo do aplicativo ("Tinder de RPG"), responsável por conectar jogadores a mestres e mesas de RPG.

## Responsabilidades
- **Feed de Swipe:** Exibição interativa de cartões de campanhas e perfis de jogadores usando mecânica de deslize (swipe right/left).
- **Algoritmo de Compatibilidade:** Filtragem de campanhas por preferências de sistema (ex: D&D, Tormenta, Call of Cthulhu), horários e estilo de jogo.
- **Registro de Interações:** Armazenamento de curtidas, rejeições e detecção de matches no Supabase.

## Estrutura
- `models/`: Estruturas de dados dos cartões de matchmaking, campanhas e filtros.
- `providers/`: Gerenciamento do estado dos cards, pilha de swipes e requisições de novos perfis/mesas.
- `screens/`: Tela principal do swiper (`SwipeScreen` / `MatchmakingScreen`) e detalhes rápidos da campanha.
- `widgets/`: Componentes visuais dos cards (foto de capa, sinopse, tags de sistema, horários) e botões de ação (like/pass).
