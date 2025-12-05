# Performance Optimizer

Um aplicativo de otimização de performance para Android e Web, desenvolvido em Flutter.

## 📱 Funcionalidades

### Tela de Análise
- Score circular do sistema (0-100 pontos)
- Análise em tempo real do sistema
- Status de segurança, conexão, bateria e performance
- Botão para nova análise

### Tela de Armazenamento
- Visualização do uso de armazenamento (17.3 GB de 64 GB)
- Categorização por tipo de arquivo:
  - Imagens (4.2 GB - 35%)
  - Vídeos (8.1 GB - 55%)
  - Áudio (1.8 GB - 15%)
  - Documentos (0.9 GB - 8%)
  - Downloads (2.3 GB - 19%)
- Função de limpeza de arquivos

### Tela de Performance
- Métricas de RAM (78%) e temperatura (42°C)
- Ferramentas de otimização:
  - Limpar Cache
  - Encontrar Arquivos Duplicados
  - Gerenciar Apps em Segundo Plano
  - Otimizar Memória RAM
- Botão de otimização rápida

### Tela de Ajustes
- Perfil do usuário (Plano Premium)
- Configurações gerais:
  - Notificações
  - Tema Escuro
- Configurações de segurança:
  - Proteção em tempo real
- Informações do app:
  - Versão 2.1.0
  - Avaliação do app

## 🚀 Como Executar

### Versão Web (Para Testes)
O aplicativo está disponível em: https://work-1-pkwumyknhkrfxqvo.prod-runtime.all-hands.dev

### Desenvolvimento Local

#### Pré-requisitos
- Flutter SDK 3.16.9 ou superior
- Android Studio (para builds Android)
- Chrome/Edge (para desenvolvimento web)

#### Instalação
```bash
# Clone o repositório
git clone <url-do-repositorio>
cd Performance_Optimizer

# Instale as dependências
flutter pub get

# Execute na web
flutter run -d chrome

# Execute no Android (com dispositivo conectado)
flutter run
```

### Build para Produção

#### Android (Play Store)
```bash
# Build APK
flutter build apk --release

# Build App Bundle (recomendado para Play Store)
flutter build appbundle --release
```

#### Web
```bash
# Build para web
flutter build web --release
```

## 📦 Dependências

- `percent_indicator`: Indicadores circulares de progresso
- `device_info_plus`: Informações do dispositivo
- `battery_plus`: Status da bateria
- `connectivity_plus`: Status da conexão
- `path_provider`: Acesso aos diretórios do sistema
- `shared_preferences`: Armazenamento de preferências

## 🎨 Design

O aplicativo segue um design dark theme moderno com:
- Cores principais: #1A1A1A (fundo), #2A2A2A (cards)
- Tipografia clara e hierárquica
- Ícones intuitivos
- Navegação por bottom navigation bar

## 📱 Configuração Android

### Permissões
- `INTERNET`: Acesso à internet
- `ACCESS_NETWORK_STATE`: Status da rede
- `WRITE_EXTERNAL_STORAGE`: Escrita no armazenamento
- `READ_EXTERNAL_STORAGE`: Leitura do armazenamento
- `BATTERY_STATS`: Estatísticas da bateria

### Configurações do Build
- `minSdkVersion`: 21 (Android 5.0+)
- `targetSdkVersion`: 34 (Android 14)
- `compileSdkVersion`: 34
- Application ID: `com.performanceoptimizer.app`

## 🔧 Estrutura do Projeto

```
lib/
├── main.dart                 # Ponto de entrada do app
└── screens/
    ├── home_screen.dart      # Tela principal com navegação
    ├── analysis_screen.dart  # Tela de análise do sistema
    ├── settings_screen.dart  # Tela de configurações
    ├── storage_screen.dart   # Tela de armazenamento
    └── performance_screen.dart # Tela de ferramentas de performance
```

## 📄 Licença

© 2024 Performance Optimizer - Todos os direitos reservados