# Saritas — Site com painel administrativo (backend)

Esta versão usa **Next.js + Supabase**. Diferente do site HTML estático, ela precisa de banco de dados, armazenamento de imagens e autenticação. Para publicar, use Vercel (GitHub Pages sozinho não executa o app Next.js nem conecta um backend por conta própria).

## O que o cliente poderá alterar
- Nome, subtítulo, título e descrição da página inicial.
- WhatsApp e Instagram.
- Logo/foto do topo.
- Adicionar, editar, ocultar e excluir produtos.
- Enviar/substituir foto de cada produto e editar nome, categoria e descrição.
- Os produtos aparecem automaticamente no catálogo e no filtro correspondente.
- A página de produto abre ampliada e permite iniciar pedido no WhatsApp.

## 1. Criar Supabase
1. Crie um projeto em https://supabase.com/.
2. Abra SQL Editor e execute todo o conteúdo de `supabase/schema.sql`.
3. Em Authentication > Users, crie o usuário (email e senha) do responsável pela loja.
4. Copie o UUID desse usuário.
5. No SQL Editor, execute (substitua pelo UUID real):
   ```sql
   insert into public.admin_users (user_id) values ('COLE-O-UUID-DO-USUARIO-AQUI');
   ```
6. Em Project Settings > API, copie Project URL e a chave `anon`/publishable. **Nunca use a service_role key no navegador ou no GitHub.**

## 2. Configurar localmente
1. Instale Node.js LTS: https://nodejs.org/.
2. Extraia a pasta e abra-a no VS Code.
3. Copie `.env.example` para `.env.local`.
4. Preencha `NEXT_PUBLIC_SUPABASE_URL` e `NEXT_PUBLIC_SUPABASE_ANON_KEY`.
5. No terminal do VS Code, rode:
   ```bash
   npm install
   npm run dev
   ```
6. Acesse http://localhost:3000 e o painel em http://localhost:3000/admin.

## 3. Publicar
1. Suba a pasta do projeto ao GitHub (não inclua `.env.local`).
2. Importe o repositório em https://vercel.com/.
3. Em Vercel > Project Settings > Environment Variables, adicione as mesmas duas variáveis.
4. Faça deploy.

## Segurança e observações
- O painel exige login e a tabela `admin_users` autoriza quais contas podem alterar os dados.
- As regras RLS do SQL restringem gravações a administradores. Não publique a chave `service_role`.
- O site envia resumo do pedido ao WhatsApp. Arquivos de arte para bordado precisam ser anexados manualmente na conversa; este starter não guarda arquivos de arte enviados por clientes.
- As imagens incluídas são as fotos de referência já presentes no projeto anterior. Troque-as por fotos originais se necessário.
- Antes de usar comercialmente, teste o projeto e revise a política de privacidade, especialmente se vier a armazenar dados de clientes.
