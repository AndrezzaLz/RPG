# Feature: Auth

Esta funcionalidade é responsável por todo o fluxo de autenticação e gerenciamento de sessão dos usuários no aplicativo.

## Responsabilidades
- **Login e Registro:** Autenticação via e-mail/senha ou provedores sociais através do Supabase Auth.
- **Recuperação de Senha:** Fluxo de redefinição de credenciais de acesso.
- **Onboarding:** Coleta inicial de dados cadastrais para novos jogadores e mestres.
- **Sessão:** Manutenção e persistência do token/estado de sessão do usuário.

## Estrutura
- `models/`: Modelos de dados relacionados à autenticação (ex: dados do usuário autenticado, payload de login).
- `providers/`: Gerenciamento de estado (ChangeNotifier/Provider) para login, cadastro e controle de sessão.
- `screens/`: Telas de visualização (ex: login, cadastro, recuperação de senha).
- `widgets/`: Componentes visuais reutilizáveis exclusivos da autenticação (ex: botões personalizados, campos de entrada, formulários).
