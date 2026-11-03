# Feature: Profile

Esta funcionalidade cuida da visualização e gerenciamento do perfil do usuário, seja ele mestre, jogador ou ambos.

## Responsabilidades
- **Exibição do Perfil:** Visualização pública e privada com foto, bio, sistemas favoritos e estilo de jogo (roleplay, combate, exploração).
- **Edição de Perfil:** Atualização de avatar, preferências, disponibilidade de horários e papel preferido.
- **Gestão de Campanhas:** Listagem e criação de campanhas anunciadas pelo usuário (para mestres).

## Estrutura
- `models/`: Estruturas de dados do perfil do usuário e preferências de RPG.
- `providers/`: Gerenciamento de estado dos dados do perfil, upload de avatar e sincronização com o banco de dados.
- `screens/`: Tela principal de perfil (`ProfileScreen`) e tela de edição (`EditProfileScreen`).
- `widgets/`: Componentes visuais como cabeçalho com foto/nível (`ProfileHeader`), chips de tags de sistema e listas de campanhas ativas.
