import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class DeviceService {
  static final DeviceService _instance = DeviceService._internal();
  factory DeviceService() => _instance;
  DeviceService._internal();

  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();
  final Battery _battery = Battery();
  final Connectivity _connectivity = Connectivity();

  // Informações do dispositivo
  Future<Map<String, dynamic>> getDeviceInfo() async {
    try {
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await _deviceInfo.androidInfo;
        return {
          'model': androidInfo.model,
          'brand': androidInfo.brand,
          'manufacturer': androidInfo.manufacturer,
          'version': androidInfo.version.release,
          'sdkInt': androidInfo.version.sdkInt,
          'totalMemory': _formatBytes(await _getTotalMemory()),
          'availableMemory': _formatBytes(await _getAvailableMemory()),
        };
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await _deviceInfo.iosInfo;
        return {
          'model': iosInfo.model,
          'name': iosInfo.name,
          'systemName': iosInfo.systemName,
          'systemVersion': iosInfo.systemVersion,
          'totalMemory': _formatBytes(await _getTotalMemory()),
          'availableMemory': _formatBytes(await _getAvailableMemory()),
        };
      }
    } catch (e) {
      print('Erro ao obter informações do dispositivo: $e');
    }
    return {};
  }

  // Informações da bateria
  Future<Map<String, dynamic>> getBatteryInfo() async {
    try {
      final batteryLevel = await _battery.batteryLevel;
      final batteryState = await _battery.batteryState;
      
      return {
        'level': batteryLevel,
        'state': batteryState.toString().split('.').last,
        'isCharging': batteryState == BatteryState.charging,
        'health': _getBatteryHealth(batteryLevel),
      };
    } catch (e) {
      print('Erro ao obter informações da bateria: $e');
      return {
        'level': 85,
        'state': 'unknown',
        'isCharging': false,
        'health': 'Boa',
      };
    }
  }

  // Informações de conectividade
  Future<Map<String, dynamic>> getConnectivityInfo() async {
    try {
      final connectivityResult = await _connectivity.checkConnectivity();
      final connectionType = connectivityResult.toString().split('.').last;
      
      return {
        'type': connectionType,
        'isConnected': connectivityResult != ConnectivityResult.none,
        'quality': _getConnectionQuality(connectionType),
      };
    } catch (e) {
      print('Erro ao obter informações de conectividade: $e');
      return {
        'type': 'wifi',
        'isConnected': true,
        'quality': 'Boa',
      };
    }
  }

  // Informações de armazenamento
  Future<Map<String, dynamic>> getStorageInfo() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final totalSpace = await _getTotalStorageSpace();
      final freeSpace = await _getFreeStorageSpace();
      final usedSpace = totalSpace - freeSpace;
      
      return {
        'total': _formatBytes(totalSpace),
        'used': _formatBytes(usedSpace),
        'free': _formatBytes(freeSpace),
        'usedPercentage': ((usedSpace / totalSpace) * 100).round(),
        'categories': await _getStorageCategories(),
      };
    } catch (e) {
      print('Erro ao obter informações de armazenamento: $e');
      return {
        'total': '64 GB',
        'used': '17.3 GB',
        'free': '46.7 GB',
        'usedPercentage': 27,
        'categories': _getMockStorageCategories(),
      };
    }
  }

  // Análise de performance
  Future<Map<String, dynamic>> getPerformanceAnalysis() async {
    final deviceInfo = await getDeviceInfo();
    final batteryInfo = await getBatteryInfo();
    final connectivityInfo = await getConnectivityInfo();
    final storageInfo = await getStorageInfo();
    
    int score = 100;
    List<String> issues = [];
    
    // Análise da bateria
    if (batteryInfo['level'] < 20) {
      score -= 15;
      issues.add('Bateria baixa');
    }
    
    // Análise do armazenamento
    if (storageInfo['usedPercentage'] > 80) {
      score -= 20;
      issues.add('Armazenamento quase cheio');
    }
    
    // Análise da conectividade
    if (!connectivityInfo['isConnected']) {
      score -= 10;
      issues.add('Sem conexão com a internet');
    }
    
    // Análise da memória (simulada)
    if (await _getAvailableMemory() < 1024 * 1024 * 1024) { // Menos de 1GB
      score -= 15;
      issues.add('Pouca memória disponível');
    }
    
    return {
      'score': score.clamp(0, 100),
      'status': _getPerformanceStatus(score),
      'issues': issues,
      'recommendations': _getRecommendations(issues),
    };
  }

  // Métodos auxiliares
  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  String _getBatteryHealth(int level) {
    if (level > 80) return 'Excelente';
    if (level > 60) return 'Boa';
    if (level > 40) return 'Regular';
    if (level > 20) return 'Baixa';
    return 'Crítica';
  }

  String _getConnectionQuality(String type) {
    switch (type) {
      case 'wifi':
        return 'Excelente';
      case 'mobile':
        return 'Boa';
      case 'ethernet':
        return 'Excelente';
      default:
        return 'Desconhecida';
    }
  }

  String _getPerformanceStatus(int score) {
    if (score >= 90) return 'Excelente';
    if (score >= 75) return 'Boa';
    if (score >= 60) return 'Regular';
    if (score >= 40) return 'Ruim';
    return 'Crítica';
  }

  List<String> _getRecommendations(List<String> issues) {
    List<String> recommendations = [];
    
    for (String issue in issues) {
      switch (issue) {
        case 'Bateria baixa':
          recommendations.add('Carregue o dispositivo');
          break;
        case 'Armazenamento quase cheio':
          recommendations.add('Limpe arquivos desnecessários');
          break;
        case 'Sem conexão com a internet':
          recommendations.add('Verifique sua conexão Wi-Fi ou dados móveis');
          break;
        case 'Pouca memória disponível':
          recommendations.add('Feche aplicativos em segundo plano');
          break;
      }
    }
    
    return recommendations;
  }

  // Métodos simulados para obter informações do sistema
  Future<int> _getTotalMemory() async {
    return 8 * 1024 * 1024 * 1024; // 8GB
  }

  Future<int> _getAvailableMemory() async {
    return 3 * 1024 * 1024 * 1024; // 3GB
  }

  Future<int> _getTotalStorageSpace() async {
    return 64 * 1024 * 1024 * 1024; // 64GB
  }

  Future<int> _getFreeStorageSpace() async {
    return 47 * 1024 * 1024 * 1024; // 47GB
  }

  Future<List<Map<String, dynamic>>> _getStorageCategories() async {
    return _getMockStorageCategories();
  }

  List<Map<String, dynamic>> _getMockStorageCategories() {
    return [
      {
        'name': 'Imagens',
        'size': '4.2 GB',
        'percentage': 35,
        'icon': 'image',
        'color': 'blue',
      },
      {
        'name': 'Vídeos',
        'size': '8.1 GB',
        'percentage': 55,
        'icon': 'videocam',
        'color': 'red',
      },
      {
        'name': 'Áudio',
        'size': '1.8 GB',
        'percentage': 15,
        'icon': 'audiotrack',
        'color': 'green',
      },
      {
        'name': 'Documentos',
        'size': '0.9 GB',
        'percentage': 8,
        'icon': 'description',
        'color': 'orange',
      },
      {
        'name': 'Apps',
        'size': '2.3 GB',
        'percentage': 19,
        'icon': 'apps',
        'color': 'purple',
      },
    ];
  }

  // Simulação de limpeza
  Future<Map<String, dynamic>> performCleanup() async {
    await Future.delayed(const Duration(seconds: 3));
    
    return {
      'success': true,
      'spaceCleaned': '1.2 GB',
      'filesRemoved': 1247,
      'message': 'Limpeza concluída com sucesso!',
    };
  }

  // Solicitar permissões necessárias
  Future<bool> requestPermissions() async {
    try {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.storage,
        Permission.phone,
      ].request();
      
      return statuses.values.every((status) => status.isGranted);
    } catch (e) {
      print('Erro ao solicitar permissões: $e');
      return false;
    }
  }
}