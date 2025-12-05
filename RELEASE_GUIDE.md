# Guia de Release para Play Store

Este guia contém todas as informações necessárias para publicar o Performance Optimizer na Google Play Store.

## 📋 Checklist Pré-Release

### ✅ Desenvolvimento Completo
- [x] Funcionalidades principais implementadas
- [x] Extração de dados reais do dispositivo
- [x] Sistema de temas (claro/escuro)
- [x] Planos gratuito e premium
- [x] Sistema de anúncios integrado
- [x] Compras in-app configuradas
- [x] Splash screen personalizada
- [x] Interface otimizada para mobile

### ✅ Documentação
- [x] Política de Privacidade criada
- [x] Termos de Uso criados
- [x] Descrição da Play Store preparada
- [x] README.md atualizado

### ✅ Configurações Android
- [x] Permissões necessárias adicionadas
- [x] Build configurado para release
- [x] ProGuard configurado
- [x] Ícone do app criado

## 🔧 Preparação para Build

### 1. Configurar Keystore (Primeira vez)
```bash
# Criar keystore para assinatura
keytool -genkey -v -keystore ~/performance-optimizer-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias performance-optimizer

# Criar arquivo key.properties na raiz do projeto Android
echo "storePassword=SUA_SENHA_STORE" > android/key.properties
echo "keyPassword=SUA_SENHA_KEY" >> android/key.properties
echo "keyAlias=performance-optimizer" >> android/key.properties
echo "storeFile=~/performance-optimizer-key.jks" >> android/key.properties
```

### 2. Build para Release
```bash
# Limpar builds anteriores
flutter clean
flutter pub get

# Build App Bundle (recomendado para Play Store)
flutter build appbundle --release

# Ou build APK se necessário
flutter build apk --release
```

### 3. Localizar Arquivos
- **App Bundle**: `build/app/outputs/bundle/release/app-release.aab`
- **APK**: `build/app/outputs/flutter-apk/app-release.apk`

## 📱 Informações do App
- **Package Name**: `com.performanceoptimizer.app`
- **Version Name**: `2.1.0`
- **Version Code**: `2`
- **Target SDK**: `34` (Android 14)
- **Min SDK**: `21` (Android 5.0)

### Arquiteturas Suportadas
- ARM64 (arm64-v8a)
- ARM32 (armeabi-v7a)
- x86_64

### Permissões
- `INTERNET` - Para conectividade
- `ACCESS_NETWORK_STATE` - Para verificar status da rede
- `WRITE_EXTERNAL_STORAGE` - Para salvar dados
- `READ_EXTERNAL_STORAGE` - Para ler dados
- `BATTERY_STATS` - Para monitoramento de bateria

## 🌐 Versão Web

### Arquivos Gerados
- **Build Web**: `build/web/` (completo)
- **URL de Teste**: https://work-1-npuwxzdludpajbqg.prod-runtime.all-hands.dev

### Hospedagem
O build web está pronto para ser hospedado em qualquer servidor web estático:
- Firebase Hosting
- Netlify
- Vercel
- GitHub Pages
- Servidor Apache/Nginx

## 🔐 Assinatura Digital

### Chave de Release
- **Arquivo**: `android/app/app-release-key.jks`
- **Alias**: `performance-optimizer-key`
- **Validade**: 10.000 dias
- **Algoritmo**: RSA 2048 bits

⚠️ **IMPORTANTE**: Mantenha a chave de assinatura em local seguro! Ela é necessária para todas as atualizações futuras na Play Store.

## 📋 Passos para Publicação na Play Store

### 1. Preparação
- [x] APK/AAB gerado e assinado
- [x] Ícone do app configurado
- [x] Permissões definidas
- [x] Versão incrementada

### 2. Console do Google Play
1. Acesse [Google Play Console](https://play.google.com/console)
2. Crie um novo app ou selecione existente
3. Faça upload do arquivo `app-release.aab` (recomendado) ou `app-release.apk`
4. Preencha as informações do app:
   - Título: "Performance Optimizer"
   - Descrição curta e completa
   - Screenshots (necessário criar)
   - Ícone de alta resolução (512x512px)
   - Banner promocional (opcional)

### 3. Configurações Obrigatórias
- Classificação de conteúdo
- Política de privacidade (se aplicável)
- Público-alvo
- Categoria do app
- Informações de contato

### 4. Testes
- Teste interno (recomendado)
- Teste fechado (opcional)
- Teste aberto (opcional)
- Produção

## 🚀 Deploy Web

### Opção 1: Firebase Hosting
```bash
npm install -g firebase-tools
firebase login
firebase init hosting
# Selecione build/web como diretório público
firebase deploy
```

### Opção 2: Netlify
1. Acesse [Netlify](https://netlify.com)
2. Arraste a pasta `build/web` para o deploy
3. Configure domínio personalizado (opcional)

### Opção 3: Vercel
```bash
npm install -g vercel
cd build/web
vercel
```

## 📊 Monitoramento

### Analytics (Recomendado)
- Google Analytics
- Firebase Analytics
- Crashlytics (para Android)

### Performance
- Firebase Performance Monitoring
- Google PageSpeed Insights (web)

## 🔄 Atualizações Futuras

### Android
1. Incremente o `version` no `pubspec.yaml`
2. Execute `flutter build appbundle --release`
3. Faça upload do novo AAB no Play Console

### Web
1. Execute `flutter build web --release`
2. Faça deploy da pasta `build/web` atualizada

## 📞 Suporte

Para dúvidas sobre o processo de publicação:
- [Documentação Flutter](https://docs.flutter.dev/deployment)
- [Google Play Console Help](https://support.google.com/googleplay/android-developer)
- [Firebase Hosting Docs](https://firebase.google.com/docs/hosting)

---

**Data de Build**: 05/12/2025
**Flutter Version**: 3.16.9
**Dart Version**: 3.2.6