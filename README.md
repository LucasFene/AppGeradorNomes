# Gerador de Nomes para Startups

**Autor:** Lucas Fernandes Silva

## Descrição do App
O Gerador de Nomes para Startups é um aplicativo Flutter que sugere nomes criativos para novas empresas. O usuário fornece uma breve descrição do negócio e, utilizando um modelo de linguagem (LLM), o app gera opções de nomes inovadores e relevantes para o contexto informado. O objetivo é facilitar o processo de brainstorming e ajudar empreendedores a encontrar o nome ideal para suas startups.

## Tecnologias Utilizadas
- **Flutter**: Framework para desenvolvimento de aplicativos móveis multiplataforma.
- **Dart**: Linguagem de programação utilizada pelo Flutter.
- **flutter_dotenv**: Gerenciamento de variáveis de ambiente para configuração segura.
- **Integração com LLM**: Utilização de um modelo de linguagem para geração dos nomes.

## Instruções de Instalação e Execução
1. **Pré-requisitos:**
   - Flutter instalado ([Guia oficial](https://docs.flutter.dev/get-started/install))
   - Dart SDK

2. **Clone o repositório:**
   ```sh
   git clone https://github.com/seu-usuario/gerador_nomes_startups.git
   cd gerador_nomes_startups
   ```

3. **Configure as variáveis de ambiente:**
   - Crie um arquivo `.env` na raiz do projeto com as chaves necessárias (exemplo: API_KEY para o serviço LLM).

4. **Instale as dependências:**
   ```sh
   flutter pub get
   ```

5. **Execute o aplicativo:**
   ```sh
   flutter run
   ```

## Como o LLM foi Utilizado
O aplicativo utiliza um modelo de linguagem (LLM) para gerar sugestões de nomes a partir da descrição fornecida pelo usuário. A integração é feita por meio de um serviço dedicado, que envia a descrição para o LLM e recebe de volta uma lista de nomes criativos. As credenciais e configurações de acesso ao LLM são gerenciadas por variáveis de ambiente, garantindo segurança e flexibilidade.

---

Sinta-se à vontade para contribuir ou sugerir melhorias!


![image](https://github.com/user-attachments/assets/0dc24477-248b-493b-b52d-4c408579ca38)

