# 🐉 RPG - Procura-se Exploradores (Tinder de RPG)

Bem-vindo ao repositório oficial do projeto **RPG - Procura-se Exploradores**. 
Este aplicativo funciona como um hub de matchmaking projetado para conectar jogadores e mestres de RPG de forma intuitiva, resolvendo problemas de incompatibilidade de horários, falta de confiança e "furos" nas sessões de jogo.

## 📱 Tecnologias Utilizadas

Este projeto foi construído focando em performance nativa e escalabilidade:
* **Front-end:** [Flutter](https://flutter.dev/) (Dart)
* **Back-end & Banco de Dados:** [Supabase](https://supabase.com/) (PostgreSQL, Auth, Realtime)
* **Gerência de Estado:** Provider
* **Roteamento:** GoRouter
* **Animações de UI:** flutter_card_swiper, cached_network_image

## 🛠 Pré-requisitos

Para rodar o projeto na sua máquina, cada membro da equipe precisa instalar as seguintes ferramentas:
1. **[Flutter SDK](https://docs.flutter.dev/get-started/install):** Certifique-se de configurar as variáveis de ambiente e rodar `flutter doctor` para validar a instalação.
2. **[Visual Studio Code](https://code.visualstudio.com/):** Instale as extensões oficiais "Flutter" e "Dart".
3. **Emulador ou Celular Físico:** Configure um emulador via Android Studio ou conecte seu celular via cabo (com depuração USB ativada).

## 🚀 Como executar o projeto

Siga o passo a passo abaixo no terminal do seu editor:

1. **Clone o repositório:**
   ```bash
   git clone <COLOQUE_O_LINK_DO_GITHUB_AQUI>
   cd tinder_de_rpg
   ```

2. **Instale as dependências:**
   ```bash
   flutter pub get
   ```

3. **Configure as Variáveis de Ambiente:**
   * Na raiz do projeto, crie um arquivo chamado `.env`.
   * Copie o conteúdo de `.env.example` para dentro de `.env`.
   * Solicite as chaves do Supabase (`SUPABASE_URL` e `SUPABASE_ANON_KEY`) ao administrador do projeto e preencha no arquivo `.env`.

4. **Execute o Aplicativo:**
   ```bash
   flutter run
   ```

## 📂 Arquitetura do Projeto

Utilizamos o padrão **Feature-First** para evitar conflitos (merge conflicts) durante o desenvolvimento em grupo. Toda a lógica está dentro da pasta `lib/`:

```text
lib/
  ├── core/             # Cores, temas, rotas e configuração do Supabase
  ├── features/
  │   ├── auth/         # Login, Cadastro e Onboarding
  │   ├── matchmaking/  # Tela principal (SwipeScreen) e cards
  │   ├── chat/         # Lista de matches e mensagens em tempo real
  │   └── profile/      # Perfil do usuário e gestão de campanhas
  └── main.dart
```

## 🤝 Padrões de Desenvolvimento (Equipe)

* **Idioma do Código:** O código-fonte (nomes de variáveis, classes, métodos e commits) **deve** ser escrito em inglês. Apenas os textos de interface (UI) e documentação podem estar em português.
* **Lints Rigorosos:** O projeto utiliza regras estritas no `analysis_options.yaml`. O código só deve ser comitado (commit) se o VS Code não apresentar nenhum aviso de erro (warnings de linting).
* **Trabalho por Funcionalidade:** Ao iniciar uma nova tarefa, crie uma *branch* específica para a sua *feature* (ex: `feature/login-screen`) antes de mandar para a *main*.

---
*Desenvolvido pela equipe PDQ Productions.*