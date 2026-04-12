# CarDex - Projeto Flutter

Projeto criado baseado em SPEC.md.

## Configuração do Firebase

Para rodar o app, você precisa configurar o Firebase:

1. Crie um projeto no [Firebase Console](https://console.firebase.google.com/)
2. Adicione um app Android com o package name `com.cardex.cardex`
3. Baixe o arquivo `google-services.json`
4. Coloque o arquivo em `android/app/google-services.json`

## Rodar o app

```bash
cd cardex
flutter run
```

## Estrutura

- `lib/core/` - Tema e configurações
- `lib/models/` - Modelos de dados (User, Car, Rating)
- `lib/services/` - Serviços (Auth, Car, Rating)
- `lib/screens/` - Telas
- `lib/widgets/` - Widgets reutilizáveis