import 'package:flutter/material.dart';

class StorageScreen extends StatefulWidget {
  const StorageScreen({super.key});

  @override
  State<StorageScreen> createState() => _StorageScreenState();
}

class _StorageScreenState extends State<StorageScreen> {
  bool isCleaningFiles = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWeb = screenWidth > 600;
    
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(isWeb ? 32.0 : 20.0),
            child: Column(
              children: [
              // Header
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.storage,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Armazenamento',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Gerencie seus arquivos',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 40),

              // Storage Usage
              const Text(
                '17.3 GB',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'de 64 GB usados',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 20),

              // Progress Bar
              Container(
                width: double.infinity,
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: 0.27, // 17.3/64
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '46.7 GB disponíveis',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 40),

              // Categories Section
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'CATEGORIAS',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Storage Categories
              _buildStorageCategory(
                icon: Icons.image,
                title: 'Imagens',
                size: '4.2 GB',
                percentage: 35,
                color: Colors.blue,
              ),
              _buildStorageCategory(
                icon: Icons.videocam,
                title: 'Vídeos',
                size: '8.1 GB',
                percentage: 55,
                color: Colors.red,
              ),
              _buildStorageCategory(
                icon: Icons.audiotrack,
                title: 'Áudio',
                size: '1.8 GB',
                percentage: 15,
                color: Colors.green,
              ),
              _buildStorageCategory(
                icon: Icons.description,
                title: 'Documentos',
                size: '0.9 GB',
                percentage: 8,
                color: Colors.orange,
              ),
              _buildStorageCategory(
                icon: Icons.download,
                title: 'Downloads',
                size: '2.3 GB',
                percentage: 19,
                color: Colors.purple,
              ),

              SizedBox(height: isWeb ? 60 : 40),

              // Clean Files Button
              Container(
                width: isWeb ? 400 : double.infinity,
                height: isWeb ? 56 : 50,
                child: ElevatedButton.icon(
                  onPressed: isCleaningFiles ? null : _cleanFiles,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(isWeb ? 28 : 25),
                    ),
                    elevation: 2,
                  ),
                  icon: isCleaningFiles
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                          ),
                        )
                      : const Icon(Icons.cleaning_services),
                  label: Text(
                    isCleaningFiles ? 'Limpando...' : 'Limpar Arquivos',
                    style: TextStyle(
                      fontSize: isWeb ? 18 : 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: isWeb ? 40 : 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStorageCategory({
    required IconData icon,
    required String title,
    required String size,
    required int percentage,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '$percentage%',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  size,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _cleanFiles() {
    setState(() {
      isCleaningFiles = true;
    });

    // Simulate file cleaning
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          isCleaningFiles = false;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Arquivos limpos com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    });
  }
}