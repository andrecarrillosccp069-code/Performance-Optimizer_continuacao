# 🚀 Guia para Build de Release - Performance Optimizer

## 📋 Pré-requisitos

### 1. Ambiente de Desenvolvimento
```bash
# Verificar versões
flutter --version
dart --version
java -version

# Versões recomendadas:
# Flutter: 3.16.0+
# Dart: 3.2.0+
# Java: 17+
```

### 2. Dependências Instaladas
```bash
# Verificar se todas as dependências estão instaladas
flutter pub get
flutter doctor
```

## 🔐 Configuração de Assinatura

### 1. Gerar Keystore (Primeira vez)
```bash
# Navegar para o diretório android
cd android

# Gerar keystore (GUARDE ESTAS INFORMAÇÕES COM SEGURANÇA!)
keytool -genkey -v -keystore app-release-key.keystore -keyalg RSA -keysize 2048 -validity 10000 -alias app

# Informações sugeridas:
# Nome: Performance Optimizer
# Organização: Sua Empresa
# Cidade: Sua Cidade
# Estado: Seu Estado
# País: BR
# Senha: [SENHA_SEGURA] - ANOTE ESTA SENHA!
```

### 2. Configurar key.properties
```bash
# Criar arquivo android/key.properties
cat > android/key.properties << EOF
storePassword=[SUA_SENHA_KEYSTORE]
keyPassword=[SUA_SENHA_KEY]
keyAlias=app
storeFile=app-release-key.keystore
EOF
```

### 3. Verificar android/app/build.gradle
O arquivo já deve estar configurado com:
```gradle
android {
    ...
    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }
    buildTypes {
        release {
            signingConfig signingConfigs.release
        }
    }
}
```

## 📱 Build para Android

### 1. Limpar Build Anterior
```bash
flutter clean
flutter pub get
```

### 2. Build APK (Para testes)
```bash
# APK para testes em dispositivos específicos
flutter build apk --release

# APK universal (maior tamanho, mas compatível com todos)
flutter build apk --release --split-per-abi
```

### 3. Build AAB (Para Play Store) - RECOMENDADO
```bash
# Android App Bundle - formato preferido da Play Store
flutter build appbundle --release
```

### 4. Localização dos Arquivos
```bash
# APK:
build/app/outputs/flutter-apk/app-release.apk

# AAB:
build/app/outputs/bundle/release/app-release.aab
```

## 🌐 Build para Web

### 1. Build Web Release
```bash
# Build otimizado para web
flutter build web --release

# Build com otimizações específicas
flutter build web --release --web-renderer canvaskit
```

### 2. Testar Localmente
```bash
# Servir arquivos web
cd build/web
python3 -m http.server 8000

# Ou usar qualquer servidor HTTP
# Acessar: http://localhost:8000
```

### 3. Deploy Web
```bash
# Os arquivos estão em: build/web/
# Copie todo o conteúdo para seu servidor web
# Ou use serviços como Firebase Hosting, Netlify, Vercel
```

## ✅ Checklist Pré-Release

### Código e Funcionalidades
- [ ] Todas as funcionalidades testadas
- [ ] Sem erros de compilação
- [ ] Sem warnings críticos
- [ ] Performance otimizada
- [ ] Testes em dispositivos reais

### Configurações Android
- [ ] Versão incrementada em pubspec.yaml
- [ ] Ícone do app configurado
- [ ] Permissões justificadas
- [ ] Keystore configurado
- [ ] ProGuard habilitado (se necessário)

### Monetização
- [ ] AdMob configurado (se usando anúncios)
- [ ] In-app purchases configurados
- [ ] IDs de produtos corretos

### Compliance
- [ ] Política de privacidade atualizada
- [ ] Termos de uso atualizados
- [ ] Permissões documentadas

## 🔍 Testes Finais

### 1. Instalar APK em Dispositivo Real
```bash
# Instalar APK via ADB
adb install build/app/outputs/flutter-apk/app-release.apk

# Ou transferir APK para dispositivo e instalar manualmente
```

### 2. Testes Essenciais
- [ ] App abre sem crashes
- [ ] Todas as telas funcionam
- [ ] Análise de sistema funciona
- [ ] Tema claro/escuro funciona
- [ ] Anúncios aparecem (se aplicável)
- [ ] Compras in-app funcionam (se aplicável)
- [ ] Performance adequada

### 3. Testes de Compatibilidade
- [ ] Android 6.0 (API 23)
- [ ] Android 8.0 (API 26)
- [ ] Android 10 (API 29)
- [ ] Android 12+ (API 31+)
- [ ] Diferentes tamanhos de tela
- [ ] Diferentes densidades

## 📊 Análise do Build

### 1. Tamanho do App
```bash
# Verificar tamanho do APK/AAB
ls -lh build/app/outputs/flutter-apk/app-release.apk
ls -lh build/app/outputs/bundle/release/app-release.aab

# Meta: < 20MB para boa experiência do usuário
```

### 2. Análise de Performance
```bash
# Profile build para análise
flutter build apk --profile
flutter install --profile

# Usar Flutter Inspector para análise
```

## 🚀 Upload para Play Store

### 1. Preparar AAB
```bash
# Usar o arquivo AAB gerado:
build/app/outputs/bundle/release/app-release.aab
```

### 2. Play Console
1. Acesse [Google Play Console](https://play.google.com/console)
2. Selecione seu app
3. Vá em "Release" > "Production"
4. Clique em "Create new release"
5. Upload do AAB
6. Preencha as informações de release
7. Revisar e publicar

### 3. Informações de Release (Exemplo)
```
Versão: 1.0.0
Novidades:
• Lançamento inicial do Performance Optimizer
• Análise completa do sistema Android
• Otimização de performance em tempo real
• Interface moderna com tema claro/escuro
• Limpeza inteligente de arquivos temporários
• Monitoramento de bateria e conectividade
```

## 🔧 Troubleshooting

### Erro de Assinatura
```bash
# Verificar se keystore existe
ls -la android/app-release-key.keystore

# Verificar configuração
cat android/key.properties
```

### Erro de Build
```bash
# Limpar completamente
flutter clean
cd android && ./gradlew clean && cd ..
flutter pub get
flutter build appbundle --release
```

### Erro de Permissões
```bash
# Verificar permissões no AndroidManifest.xml
cat android/app/src/main/AndroidManifest.xml
```

### App Muito Grande
```bash
# Build com split por ABI
flutter build apk --release --split-per-abi

# Ou otimizar recursos
flutter build appbundle --release --obfuscate --split-debug-info=debug-info/
```

## 📝 Comandos Úteis

### Informações do Build
```bash
# Ver informações detalhadas
flutter build appbundle --release --verbose

# Analisar bundle
bundletool build-apks --bundle=app-release.aab --output=app.apks
```

### Debugging
```bash
# Build debug para testes
flutter build apk --debug
flutter install --debug

# Logs em tempo real
flutter logs
```

### Limpeza
```bash
# Limpeza completa
flutter clean
flutter pub get
cd android && ./gradlew clean && cd ..
```

## 🎯 Próximos Passos Após Release

1. **Monitoramento**
   - Acompanhar crashes no Play Console
   - Monitorar reviews e ratings
   - Verificar métricas de performance

2. **Atualizações**
   - Incrementar versão em pubspec.yaml
   - Fazer build com nova versão
   - Upload de nova release

3. **Marketing**
   - Compartilhar nas redes sociais
   - Pedir reviews para usuários
   - Otimizar ASO (App Store Optimization)

---

## 🆘 Suporte

Se encontrar problemas durante o build:

1. Consulte a documentação oficial do Flutter
2. Verifique issues no GitHub do projeto
3. Entre em contato: support@performanceoptimizer.com

**Boa sorte com o lançamento! 🎉**