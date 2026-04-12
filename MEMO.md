# CarDex - Memo do Projeto

## O que foi feito

### 1. Estrutura Base
- Projeto Flutter criado em `cardex/`
- Dependências Firebase configuradas (pubspec.yaml)
- Arquivos models: `user.dart`, `car.dart`, `rating.dart`
- Arquivos services: `auth_service.dart`, `car_service.dart`, `rating_service.dart`
- Telas: Login, Register, Home, AddCar, EditCar, CarDetail, Feed, Profile
- Widget: CarCard, RatingStars

### 2. Firebase (Rules)
- Arquivos em `firebase/`
  - `rules/firestore.rules` - Regras de segurança
  - `rules/storage.rules` - Regras para fotos
  - `indexes/firestore.indexes.json` - Índices necessários

### 3. Funcionalidades Implementadas
- Login Email/Senha
- Login Google
- Cadastro de carro (câmera/galeria)
- Edição de carro (EditCarScreen)
- Exclusão de carro
- Sistema de avaliações (1-5 estrelas)
- Feed explorar
- Perfil com estadísticas

### 4. Melhorias UI
- Show/hide password no cadastro
- PickImage com opção câmera/galeria
- Widget RatingStars reutilizável
- Validação de senha (mín 6 caracteres)

## Próximos Passos

### Configuração Firebase (OBRIGATÓRIO para rodar)
1. Criar projeto no Firebase Console
2. Adicionar app Android (package: `com.cardex.cardex`)
3. Baixar `google-services.json`
4. Colocar em `android/app/google-services.json`
5. Habilitar Auth (Email/Google), Firestore, Storage

### Para Testar
```bash
cd cardex
flutter build apk --debug
# ou
flutter run
```

### Possíveis Melhorias Futuras
- Dark mode toggle no app
- Compartilhamento de carros
- Notificações
- Chat entre usuários
- Lista de favoritos