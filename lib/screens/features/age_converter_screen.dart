import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_logo.dart';

class AgeConverterScreen extends StatefulWidget {
  const AgeConverterScreen({super.key});

  @override
  State<AgeConverterScreen> createState() => _AgeConverterScreenState();
}

class _AgeConverterScreenState extends State<AgeConverterScreen> {
  DateTime _birthDate = DateTime(2004, 5, 14);
  String? _selectedMember = 'Andi Pratama (14 Mei 2004)';

  final Map<String, DateTime> _membersMap = {
    'Andi Pratama (14 Mei 2004)': DateTime(2004, 5, 14),
    'Siti Rahma (28 Agustus 1991)': DateTime(1991, 8, 28),
    'Budi Santoso (10 Januari 1965)': DateTime(1965, 1, 10),
    'Ratna Dewi (03 Maret 2009)': DateTime(2009, 3, 3),
  };

  // Age Calculations
  Map<String, int> get _detailedAge {
    final now = DateTime.now();
    int years = now.year - _birthDate.year;
    int months = now.month - _birthDate.month;
    int days = now.day - _birthDate.day;

    if (days < 0) {
      final prevMonthLastDay = DateTime(now.year, now.month, 0).day;
      days += prevMonthLastDay;
      months--;
    }

    if (months < 0) {
      months += 12;
      years--;
    }

    return {'years': years, 'months': months, 'days': days};
  }

  int get _totalMonths {
    return (_detailedAge['years']! * 12) + _detailedAge['months']!;
  }

  int get _totalWeeks {
    return _totalDays ~/ 7;
  }

  int get _totalDays {
    final now = DateTime.now();
    return now.difference(_birthDate).inDays;
  }

  int get _totalHours {
    final now = DateTime.now();
    return now.difference(_birthDate).inHours;
  }

  int get _totalMinutes {
    final now = DateTime.now();
    return now.difference(_birthDate).inMinutes;
  }

  int get _totalSeconds {
    final now = DateTime.now();
    return now.difference(_birthDate).inSeconds;
  }

  int get _daysToNextBirthday {
    final now = DateTime.now();
    DateTime nextBday = DateTime(now.year, _birthDate.month, _birthDate.day);
    if (nextBday.isBefore(now)) {
      nextBday = DateTime(now.year + 1, _birthDate.month, _birthDate.day);
    }
    return nextBday.difference(now).inDays;
  }

  String get _zodiac {
    final day = _birthDate.day;
    final month = _birthDate.month;
    if ((month == 3 && day >= 21) || (month == 4 && day <= 19)) return 'Aries ♈';
    if ((month == 4 && day >= 20) || (month == 5 && day <= 20)) return 'Taurus ♉';
    if ((month == 5 && day >= 21) || (month == 6 && day <= 20)) return 'Gemini ♊';
    if ((month == 6 && day >= 21) || (month == 7 && day <= 22)) return 'Cancer ♋';
    if ((month == 7 && day >= 23) || (month == 8 && day <= 22)) return 'Leo ♌';
    if ((month == 8 && day >= 23) || (month == 9 && day <= 22)) return 'Virgo ♍';
    if ((month == 9 && day >= 23) || (month == 10 && day <= 22)) return 'Libra ♎';
    if ((month == 10 && day >= 23) || (month == 11 && day <= 21)) return 'Scorpio ♏';
    if ((month == 11 && day >= 22) || (month == 12 && day <= 21)) return 'Sagitarius ♐';
    if ((month == 12 && day >= 22) || (month == 1 && day <= 19)) return 'Capricorn ♑';
    if ((month == 1 && day >= 20) || (month == 2 && day <= 18)) return 'Aquarius ♒';
    return 'Pisces ♓';
  }

  String get _shio {
    final shios = [
      'Monyet 🐒',
      'Ayam 🐓',
      'Anjing 🐕',
      'Babi 🐖',
      'Tikus 🐀',
      'Kerbau 🐂',
      'Macan 🐅',
      'Kelinci 🐇',
      'Naga 🐉',
      'Ular 🐍',
      'Kuda 🐎',
      'Kambing 🐐'
    ];
    return shios[_birthDate.year % 12];
  }

  String get _ageCategory {
    final y = _detailedAge['years']!;
    if (y < 2) return 'Bayi (<2 tahun)';
    if (y < 12) return 'Anak-anak (2-11 tahun)';
    if (y < 18) return 'Remaja (12-17 tahun)';
    if (y < 45) return 'Dewasa Muda (18-44 tahun)';
    if (y < 60) return 'Dewasa Paruh Baya (45-59 tahun)';
    return 'Lansia (≥60 tahun)';
  }

  String get _medicalAdvice {
    final y = _detailedAge['years']!;
    if (y < 18) {
      return 'Pastikan kelengkapan imunisasi dasar, konsumsi kalsium & protein cukup, serta tidur 8-10 jam per hari.';
    } else if (y < 60) {
      return 'Jaga pola makan seimbang, rutin olahraga 150 menit/minggu, minum air 2L/hari, & lakukan medical check-up tahunan.';
    } else {
      return 'Lakukan kontrol rutin tekanan darah & gula darah, latihan keseimbangan fisik, serta konsumsi multivitamin lansia.';
    }
  }

  Future<void> _selectBirthDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _birthDate,
      firstDate: DateTime(1920),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryTeal,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _birthDate) {
      setState(() {
        _birthDate = picked;
        _selectedMember = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('dd MMMM yyyy', 'id_ID');
    final age = _detailedAge;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            const HealthCareLogo(size: 32),
            const SizedBox(width: 10),
            Text(
              'HealthCare Digital',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.textDark,
              ),
            ),
          ],
        ),
        actions: [
          const CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.lightTealBg,
            child: Icon(
              Icons.person,
              color: AppColors.primaryTeal,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row with Back Button
            Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 38,
                    height: 38,
                    decoration: const BoxDecoration(
                      color: Color(0xFFEFF6FF),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_back_rounded,
                      color: AppColors.textDark,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Konversi Umur Detail',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textDark,
                        letterSpacing: -0.4,
                      ),
                    ),
                    Text(
                      'Kalkulator hitung usia presisi & status medis',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Date Picker Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Dropdown Member Fast Select
                  Text(
                    'Pilih dari Anggota Terdaftar:',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String>(
                    initialValue: _selectedMember,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.inputBg,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.borderLight),
                      ),
                    ),
                    items: _membersMap.keys
                        .map(
                          (m) => DropdownMenuItem(
                            value: m,
                            child: Text(
                              m,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          _selectedMember = val;
                          _birthDate = _membersMap[val]!;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  const Divider(height: 1),
                  const SizedBox(height: 14),

                  // Manual Date Picker Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tanggal Lahir Terpilih:',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              color: AppColors.textMuted,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            formatter.format(_birthDate),
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textDark,
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton.icon(
                        onPressed: () => _selectBirthDate(context),
                        icon: const Icon(Icons.edit_calendar_rounded, size: 16),
                        label: Text(
                          'Pilih Tanggal',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF006D5B),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Highlight Age Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF006D5B), Color(0xFF00897B)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryTeal.withValues(alpha: 0.25),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Usia Saat Ini',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                  const SizedBox(height: 6),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '${age['years']} ',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 36,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                        TextSpan(
                          text: 'Tahun  ',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        TextSpan(
                          text: '${age['months']} ',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        TextSpan(
                          text: 'Bulan  ',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        TextSpan(
                          text: '${age['days']} ',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        TextSpan(
                          text: 'Hari',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(color: Colors.white24, height: 24),

                  // Birthday Countdown Banner
                  Row(
                    children: [
                      const Icon(
                        Icons.card_giftcard_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Tersisa $_daysToNextBirthday hari lagi menuju ulang tahun berikutnya 🥳',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Conversions Grid (Months, Weeks, Days, Hours, Minutes, Seconds)
            Text(
              'Rincian Konversi Waktu:',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _AgeStatCard(
                    title: 'Total Bulan',
                    value: NumberFormat('#,###').format(_totalMonths),
                    unit: 'Bulan',
                    icon: Icons.calendar_month_rounded,
                    color: const Color(0xFF0284C7),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _AgeStatCard(
                    title: 'Total Minggu',
                    value: NumberFormat('#,###').format(_totalWeeks),
                    unit: 'Minggu',
                    icon: Icons.date_range_rounded,
                    color: const Color(0xFF16A34A),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _AgeStatCard(
                    title: 'Total Hari',
                    value: NumberFormat('#,###').format(_totalDays),
                    unit: 'Hari',
                    icon: Icons.today_rounded,
                    color: const Color(0xFFD97706),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _AgeStatCard(
                    title: 'Total Jam',
                    value: NumberFormat('#,###').format(_totalHours),
                    unit: 'Jam',
                    icon: Icons.access_time_filled_rounded,
                    color: const Color(0xFF7C3AED),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _AgeStatCard(
                    title: 'Total Menit',
                    value: NumberFormat('#,###').format(_totalMinutes),
                    unit: 'Menit',
                    icon: Icons.timer_rounded,
                    color: const Color(0xFF2563EB),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _AgeStatCard(
                    title: 'Total Detik',
                    value: NumberFormat('#,###').format(_totalSeconds),
                    unit: 'Detik',
                    icon: Icons.timelapse_rounded,
                    color: const Color(0xFF0EA5E9),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _AgeStatCard(
                    title: 'Zodiak',
                    value: _zodiac,
                    unit: '',
                    icon: Icons.stars_rounded,
                    color: const Color(0xFFDB2777),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _AgeStatCard(
                    title: 'Shio Lahir',
                    value: _shio,
                    unit: '',
                    icon: Icons.pets_rounded,
                    color: const Color(0xFFEA580C),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _AgeStatCard(
                    title: 'Kategori',
                    value: _ageCategory.split(' ')[0],
                    unit: '',
                    icon: Icons.health_and_safety_rounded,
                    color: const Color(0xFF0D7C66),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(child: const SizedBox()), // Empty space to balance the row
              ],
            ),
            const SizedBox(height: 20),

            // Medical Age Group & Advice Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Kategori Usia Medis:',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textMuted,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.lightTealBg,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _ageCategory,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primaryTeal,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.health_and_safety_outlined,
                        color: AppColors.primaryTeal,
                        size: 22,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _medicalAdvice,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            color: AppColors.textDark,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _AgeStatCard extends StatelessWidget {
  final String title;
  final String value;
  final String unit;
  final IconData icon;
  final Color color;

  const _AgeStatCard({
    required this.title,
    required this.value,
    required this.unit,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 10),
          Text(
            title,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 2),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: value,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textDark,
                  ),
                ),
                if (unit.isNotEmpty)
                  TextSpan(
                    text: ' $unit',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textMuted,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
