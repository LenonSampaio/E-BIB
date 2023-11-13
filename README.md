

# E-bib: Sistema de Gerenciamento de Livros e Empréstimos
![celular5](https://github.com/LenonSampaio/E-BIB/assets/46564907/7f6b379f-b6ae-4122-af7a-939b7dbe6c51)

Bem-vindo ao repositório do E-bib, um sistema de gerenciamento de biblioteca desenvolvido em Flutter! Este projeto permite o cadastro e gerenciamento de livros, controle de empréstimos e autenticação de usuários. O backend também foi desenvolvido em Flutter, garantindo o armazenamento seguro de livros e informações de empréstimos.

## Funcionalidades Principais
![Captura de tela 2023-11-13 134826](https://github.com/LenonSampaio/E-BIB/assets/46564907/28e859da-dbbf-41ef-abf9-32325d9e1d75)
1. **Cadastro de Livros:** Adicione novos livros à biblioteca, informando detalhes como título, autor, ano de publicação e outras informações relevantes e sincronize ao Cloud Firestore em tempo real.

2. **Gerenciamento de Empréstimos:** Controle os empréstimos de livros, registrando as datas de retirada e devolução, além de informações do usuário que realizou o empréstimo.

3. **Autenticação de Usuários:** Garanta a segurança do sistema com a autenticação de usuários, permitindo que apenas usuários autorizados acessem as funcionalidades do sistema.

4. **Armazenamento de Livros:** Utilize o backend desenvolvido em Flutter para armazenar e recuperar informações sobre os livros cadastrados, garantindo a persistência dos dados.

## Tecnologias Utilizadas

[![My Skills](https://skillicons.dev/icons?i=flutter)](https://skillicons.dev) **Flutter:** Framework de desenvolvimento de aplicativos multiplataforma.

[![My Skills](https://skillicons.dev/icons?i=dart)](https://skillicons.dev) **Dart:** Linguagem de programação utilizada pelo Flutter.
[![My Skills](https://skillicons.dev/icons?i=firebase)](https://skillicons.dev) **Firebase:** Plataforma de desenvolvimento móvel do Google, utilizada para autenticação de usuários e armazenamento de dados.

## Como Iniciar

1. **Pré-requisitos:**
   - Certifique-se de ter o Flutter instalado. Caso não tenha, siga as instruções [aqui](https://flutter.dev/docs/get-started/install).

2. **Clone o Repositório:**
   ```bash
   git clone https://github.com/seu-usuario/e-bib.git
   cd e-bib
   ```

3. **Instale as Dependências:**
   ```bash
   flutter pub get
   ```

4. **Configuração do Backend:**
   - O backend foi desenvolvido em Flutter e pode ser configurado para armazenar dados usando o Firebase ou outra solução de sua escolha. Siga as instruções no diretório `backend` para configurar o armazenamento.

5. **Executar o Aplicativo:**
   ```bash
   flutter run
   ```

## Contribuições

Contribuições são bem-vindas! Se você encontrar bugs, tiver sugestões de novas funcionalidades ou melhorias, sinta-se à vontade para abrir uma issue ou enviar um pull request.

## Licença

Este projeto é licenciado sob a [MIT License](LICENSE), o que significa que você é livre para utilizá-lo conforme sua necessidade.

---

Esperamos que o E-bib seja útil para o gerenciamento eficiente de bibliotecas e empréstimos de livros. Se tiver alguma dúvida ou sugestão, sinta-se à vontade para entrar em contato.

Divirta-se codificando! 🚀
