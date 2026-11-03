# Feature: Chat

Esta funcionalidade gerencia a comunicação em tempo real entre jogadores e mestres após a ocorrência de um match mútuo.

## Responsabilidades
- **Lista de Conversas:** Exibição dos matches ativos e prévia das últimas mensagens trocadas.
- **Mensagens em Tempo Real:** Envio e recebimento instantâneo de texto através das assinaturas WebSocket do Supabase Realtime.
- **Notificações de Interação:** Indicadores de novas mensagens e confirmações de envio/leitura.

## Estrutura
- `models/`: Estruturas de dados de mensagens, salas de conversa (matches) e status de envio.
- `providers/`: Gerenciamento de estado das conversas, streams em tempo real do Supabase e fila de mensagens.
- `screens/`: Telas de listagem de conversas e tela individual de chat.
- `widgets/`: Balões de mensagem (`ChatBubble`), barra de entrada de texto e cabeçalho com informações do match.
