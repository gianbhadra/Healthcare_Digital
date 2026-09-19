import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';

class HealthCalculatorScreen extends StatefulWidget {
  const HealthCalculatorScreen({super.key});

  @override
  State<HealthCalculatorScreen> createState() => _HealthCalculatorScreenState();
}

class _HealthCalculatorScreenState extends State<HealthCalculatorScreen> {
  final TextEditingController _heightController = TextEditingController(text: '172');
  final TextEditingController _weightController = TextEditingController(text: '68');
  final TextEditingController _ageController = TextEditingController(text: '28');

  double _bmi = 22.98;
  double _bmr = 0;
  double _dailyCalories = 0;
  String _category = 'Normal (Ideal)';
  Color _categoryColor = Colors.green;
  String _gender = 'Laki-laki';
  double _activityFactor = 1.2;
  String? _inputError;

  void _calculateBMI() {
    final double? h = double.tryParse(_heightController.text);
    final double? w = double.tryParse(_weightController.text);
    final int? age = int.tryParse(_ageController.text);

    if (h != null && w != null && age != null && h > 0 && w > 0 && age > 0) {
      final double heightInMeters = h / 100;
      final double calculatedBmi = w / (heightInMeters * heightInMeters);
      final calculatedBmr = _gender == 'Laki-laki'
          ? (10 * w) + (6.25 * h) - (5 * age) + 5
          : (10 * w) + (6.25 * h) - (5 * age) - 161;

      setState(() {
        _inputError = null;
        _bmi = calculatedBmi;
        _bmr = calculatedBmr;
        _dailyCalories = calculatedBmr * _activityFactor;
        if (_bmi < 18.5) {
          _category = 'Kekurangan Berat Badan (Underweight)';
          _categoryColor = Colors.amber;
        } else if (_bmi < 24.9) {
          _category = 'Normal (Ideal)';
          _categoryColor = Colors.green;
        } else if (_bmi < 29.9) {
          _category = 'Kelebihan Berat Badan (Overweight)';
          _categoryColor = Colors.orange;
        } else {
          _category = 'Obesitas';
          _categoryColor = Colors.redAccent;
        }
      });
    } else {
      setState(() {
        _inputError = 'Isi tinggi, berat, dan umur dengan angka yang valid.';
      });
    }
  }

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: Text(
          'Kalkulator Kesehatan',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
          ),
        ),
        iconTheme: const IconThemeData(color: AppColors.textDark),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Result Display Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF006D5B), Color(0xFF00897B)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Text(
                    'Indeks Massa Tubuh (BMI)',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      color: Colors.white70,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _bmi.toStringAsFixed(1),
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 42,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _category,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: _categoryColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: _ResultValue(
                          label: 'BMR',
                          value: '${_bmr.round()} kkal',
                        ),
                      ),
                      Expanded(
                        child: _ResultValue(
                          label: 'Kebutuhan / hari',
                          value: '${_dailyCalories.round()} kkal',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Form Controls
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Masukkan Informasi Fisik:',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _heightController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Tinggi Badan (cm)',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onChanged: (_) => _calculateBMI(),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: _weightController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Berat Badan (kg)',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onChanged: (_) => _calculateBMI(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: _ageController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Usia (Tahun)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  DropdownButtonFormField<String>(
                    initialValue: _gender,
                    decoration: const InputDecoration(
                      labelText: 'Jenis Kelamin',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'Laki-laki', child: Text('Laki-laki')),
                      DropdownMenuItem(value: 'Perempuan', child: Text('Perempuan')),
                    ],
                    onChanged: (value) {
                      if (value != null) setState(() => _gender = value);
                    },
                  ),
                  const SizedBox(height: 14),
                  DropdownButtonFormField<double>(
                    initialValue: _activityFactor,
                    decoration: const InputDecoration(
                      labelText: 'Tingkat Aktivitas',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 1.2, child: Text('Minim aktivitas')),
                      DropdownMenuItem(value: 1.375, child: Text('Aktivitas ringan')),
                      DropdownMenuItem(value: 1.55, child: Text('Aktivitas sedang')),
                      DropdownMenuItem(value: 1.725, child: Text('Aktivitas tinggi')),
                    ],
                    onChanged: (value) {
                      if (value != null) setState(() => _activityFactor = value);
                    },
                  ),
                  if (_inputError != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      _inputError!,
                      style: const TextStyle(color: Colors.redAccent, fontSize: 12),
                    ),
                  ],
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _calculateBMI,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryTeal,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Hitung Ulang BMI & Kalori',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultValue extends StatelessWidget {
  final String label;
  final String value;

  const _ResultValue({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11)),
        const SizedBox(height: 4),
        Text(
          value,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}
