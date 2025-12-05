import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'performance_screen.dart';

class AnalysisScreen extends StatefulWidget {
  const AnalysisScreen({super.key});

  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {
  int systemScore = 85;
  bool isAnalyzing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
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
                      Icons.analytics,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Análise',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Diagnóstico do Sistema',
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

              // Score Circle
              CircularPercentIndicator(
                radius: 120.0,
                lineWidth: 12.0,
                animation: true,
                percent: systemScore / 100,
                center: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$systemScore',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 48.0,
                        color: Colors.white,
                      ),
                    ),
                    const Text(
                      'Pontos',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                circularStrokeCap: CircularStrokeCap.round,
                progressColor: Colors.white,
                backgroundColor: Colors.grey[800]!,
              ),
              const SizedBox(height: 20),

              const Text(
                'Sistema Saudável',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'Última análise: há 2 horas',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 40),

              // Results Section
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'RESULTADOS',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Status Items
              _buildStatusItem(
                icon: Icons.security,
                title: 'Segurança',
                subtitle: 'Protegido',
                isGood: true,
              ),
              _buildStatusItem(
                icon: Icons.wifi,
                title: 'Conexão',
                subtitle: 'Estável',
                isGood: true,
              ),
              _buildStatusItem(
                icon: Icons.battery_full,
                title: 'Bateria',
                subtitle: 'Boa saúde',
                isGood: true,
              ),
              _buildStatusItem(
                icon: Icons.speed,
                title: 'Performance',
                subtitle: '2 problemas',
                isGood: false,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PerformanceScreen(),
                    ),
                  );
                },
              ),

              const Spacer(),

              // Analyze Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: isAnalyzing ? null : _startAnalysis,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: isAnalyzing
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                          ),
                        )
                      : const Text(
                          'Analisar Novamente',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isGood,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: Colors.white,
                  size: 24,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                        subtitle,
                        style: TextStyle(
                          color: isGood ? Colors.grey : Colors.orange,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  isGood ? Icons.check_circle : Icons.warning,
                  color: isGood ? Colors.green : Colors.orange,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _startAnalysis() {
    setState(() {
      isAnalyzing = true;
    });

    // Simulate analysis
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          isAnalyzing = false;
          systemScore = 85 + (DateTime.now().millisecond % 10);
        });
      }
    });
  }
}