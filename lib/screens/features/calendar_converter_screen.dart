import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_logo.dart';

class CalendarConverterScreen extends StatefulWidget {
  const CalendarConverterScreen({super.key});

  @override
  State<CalendarConverterScreen> createState() =>
      _CalendarConverterScreenState();
}

class _CalendarConverterScreenState extends State<CalendarConverterScreen> {
  DateTime _selectedDate = DateTime.now();


  // ─── Masehi / Gregorian ───────────────────────────────────────────────────



  String get _dayNameShortId {
    const days = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];
    return days[_selectedDate.weekday - 1];
  }

  bool get _isLeapYear {
    final y = _selectedDate.year;
    return (y % 4 == 0 && y % 100 != 0) || (y % 400 == 0);
  }

  int get _dayOfYear {
    return _selectedDate.difference(DateTime(_selectedDate.year, 1, 1)).inDays +
        1;
  }

  // ─── Hijriah (Islamic) ────────────────────────────────────────────────────
  // Simplified but accurate Hijriah calculation using JDN method

  Map<String, dynamic> get _hijriah {
    final jdn = _dateToJDN(_selectedDate.year, _selectedDate.month, _selectedDate.day);
    return _jdnToHijri(jdn);
  }

  int _dateToJDN(int year, int month, int day) {
    return (1461 * (year + 4800 + (month - 14) ~/ 12)) ~/ 4 +
        (367 * (month - 2 - 12 * ((month - 14) ~/ 12))) ~/ 12 -
        (3 * ((year + 4900 + (month - 14) ~/ 12) ~/ 100)) ~/ 4 +
        day -
        32075;
  }

  Map<String, dynamic> _jdnToHijri(int jdn) {
    int l = jdn - 1948440 + 10632;
    int n = (l - 1) ~/ 10631;
    l = l - 10631 * n + 354;
    int j = ((10985 - l) ~/ 5316) * ((50 * l) ~/ 17719) +
        (l ~/ 5670) * ((43 * l) ~/ 15238);
    l = l - ((30 - j) ~/ 15) * ((17719 * j) ~/ 50) -
        (j ~/ 16) * ((15238 * j) ~/ 43) +
        29;
    int month = (24 * l) ~/ 709;
    int day = l - (709 * month) ~/ 24;
    int year = 30 * n + j - 30;

    const months = [
      'Muharram',
      'Safar',
      'Rabiul Awal',
      'Rabiul Akhir',
      'Jumadil Awal',
      'Jumadil Akhir',
      'Rajab',
      "Sya'ban",
      'Ramadhan',
      'Syawal',
      "Dzulqa'dah",
      'Dzulhijjah',
    ];
    final monthName = (month >= 1 && month <= 12) ? months[month - 1] : '';
    final monthNum = month;

    return {
      'day': day,
      'month': monthNum,
      'monthName': monthName,
      'year': year,
      'display': '$day $monthName $year H',
      'sub': 'Bulan ke-$monthNum Kalender Qamariyah',
    };
  }

  // ─── Weton Jawa ───────────────────────────────────────────────────────────

  Map<String, dynamic> get _wetonJawa {
    const pasaran = ['Legi', 'Pahing', 'Pon', 'Wage', 'Kliwon'];
    const hari = ['Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu', 'Senin', 'Selasa'];
    const wuku = [
      'Sinta',
      'Landep',
      'Wukir',
      'Kurantil',
      'Tolu',
      'Gumbreg',
      'Warigalit',
      'Warigagung',
      'Julungwangi',
      'Sungsang',
      'Galungan',
      'Kuningan',
      'Langkir',
      'Mandasiya',
      'Julungpujut',
      'Pahang',
      'Kuruwelut',
      'Marakeh',
      'Tambir',
      'Medangkungan',
      'Maktal',
      'Wuye',
      'Manahil',
      'Prangbakat',
      'Bala',
      'Ugu',
      'Wayang',
      'Kulawu',
      'Dukut',
      'Watugunung',
    ];


    // Anchor: 1 Jan 1900 = Selasa Wage (weekday 1, pasaran 3)
    final anchor = DateTime(1900, 1, 1);
    final diff = _selectedDate.difference(anchor).inDays;

    int pasaranIdx = (diff + 3) % 5;
    if (pasaranIdx < 0) pasaranIdx += 5;

    int hariIdx = _selectedDate.weekday - 1; // 0=Mon..6=Sun

    int wukuIdx = (diff ~/ 7) % 30;
    if (wukuIdx < 0) wukuIdx += 30;

    // Neptu
    const neptusHari = [4, 8, 3, 7, 6, 5, 9]; // Sen Sel Rab Kam Jum Sab Min
    const neptusPasaran = [5, 9, 7, 4, 8]; // Leg Pah Pon Wag Kli
    final neptusTotal =
        neptusHari[hariIdx] + neptusPasaran[pasaranIdx];

    final hariName = hari[hariIdx];
    final pasaranName = pasaran[pasaranIdx];
    final wukuName = wuku[wukuIdx % 30];
    final neptuH = neptusHari[hariIdx];
    final neptuP = neptusPasaran[pasaranIdx];

    // Paringkelan
    const paringkelan = ['Tungle', 'Aryang', 'Wurukung', 'Paningron', 'Uwas', 'Mawulu'];
    final paringkelanIdx = diff % 6 < 0 ? (diff % 6 + 6) : diff % 6;

    return {
      'hari': hariName,
      'pasaran': pasaranName,
      'wuku': wukuName,
      'neptuH': neptuH,
      'neptuP': neptuP,
      'neptu': neptusTotal,
      'weton': '$hariName $pasaranName',
      'sub': 'Wuku: $wukuName | Paringkelan: ${paringkelan[paringkelanIdx]}',
    };
  }

  // ─── Saka Bali ────────────────────────────────────────────────────────────

  Map<String, dynamic> get _sakaBali {
    // Approximate Saka: Masehi year - 78, with Sasih month names
    int sakaYear = _selectedDate.year - 78;


    const sasih = [
      'Kasa',
      'Karo',
      'Katiga',
      'Kapat',
      'Kelima',
      'Kenem',
      'Kepitu',
      'Kewolu',
      'Kesanga',
      'Kedasa',
      'Desta',
      'Sadha',
    ];
    final sasihName = sasih[(_selectedDate.month - 1) % 12];

    const pawukon = [
      'Sinta',
      'Landep',
      'Wuku',
      'Kurantil',
      'Tolu',
      'Gumbreg',
      'Warigalit',
      'Warigagung',
      'Julungwangi',
      'Sungsang',
      'Galungan',
      'Kuningan',
      'Langkir',
      'Mandasiya',
      'Julungpujut',
    ];
    final anchor = DateTime(1900, 1, 1);
    final diff = _selectedDate.difference(anchor).inDays;
    int pawukonIdx = (diff ~/ 7) % pawukon.length;
    if (pawukonIdx < 0) pawukonIdx += pawukon.length;

    // Pancawara Bali
    const pancawara = ['Umanis', 'Paing', 'Pon', 'Wage', 'Kliwon'];
    int pancawaraIdx = diff % 5;
    if (pancawaraIdx < 0) pancawaraIdx += 5;

    // Saptawara (7-day week)
    const saptawara = [
      'Redite',
      'Soma',
      'Anggara',
      'Buda',
      'Wraspati',
      'Sukra',
      'Saniscara'
    ];
    int saptawaraIdx = (_selectedDate.weekday) % 7;

    return {
      'saptawara': saptawara[saptawaraIdx],
      'pancawara': pancawara[pancawaraIdx],
      'sasih': sasihName,
      'year': sakaYear,
      'pawukon': pawukon[pawukonIdx],
      'display': '${saptawara[saptawaraIdx]} ${pancawara[pancawaraIdx]}, $sasihName $sakaYear Saka',
      'sub': 'Penanggalan Candrasengkala Tradisional Bali',
    };
  }

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
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

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final DateFormat fullFormatter = DateFormat('d MMMM yyyy', 'id_ID');
    final DateFormat inputFormatter = DateFormat('MM/dd/yyyy');

    final weton = _wetonJawa;
    final hijr = _hijriah;
    final saka = _sakaBali;
    final masehi2026 = '${_selectedDate.year} M';

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
            // Header Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
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
                          'Konversi Kalender',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textDark,
                            letterSpacing: -0.4,
                          ),
                        ),
                        Text(
                          'Masehi, Hijriah, Weton, dan Saka',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    color: Color(0xFFEFF6FF),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.info_outline_rounded,
                    color: AppColors.textDark,
                    size: 18,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // ─── Date Input Section ───────────────────────────────────────────

            Text(
              'Pilih Tanggal Acuan',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 8),

            // Date Input Row
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.calendar_today_rounded,
                    color: AppColors.primaryTeal,
                    size: 18,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      inputFormatter.format(_selectedDate),
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _pickDate(context),
                    child: const Icon(
                      Icons.date_range_rounded,
                      color: AppColors.textMuted,
                      size: 22,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Quick Date Chips
            Row(
              children: [
                _QuickDateChip(
                  label: 'Hari Ini',
                  onTap: () => setState(() {
                    _selectedDate = DateTime.now();
                  }),
                ),
                const SizedBox(width: 8),
                _QuickDateChip(
                  label: 'Besok',
                  onTap: () => setState(() {
                    _selectedDate = DateTime.now().add(const Duration(days: 1));
                  }),
                ),
                const SizedBox(width: 8),
                _QuickDateChip(
                  label: '${DateFormat('d MMM yyyy', 'id_ID').format(_selectedDate)} (Preset)',
                  isPreset: true,
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Convert Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: () => setState(() {}),
                icon: const Icon(Icons.sync_rounded, size: 20),
                label: Text(
                  'Konversi Tanggal',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF006D5B),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Info Banner
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF8F6),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.sync_alt_rounded,
                    color: AppColors.primaryTeal,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Sinkronisasi jadwal imunisasi, siklus terapi, dan tracisi keluarga secara selaras.',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ─── Masehi (Gregorian) ───────────────────────────────────────────

            _CalendarCard(
              systemTag: 'SISTEM INTERNASIONAL',
              systemTagColor: const Color(0xFF0284C7),
              calendarName: 'Kalender Masehi\n(Gregorian)',
              calendarIcon: Icons.calendar_month_outlined,
              calendarIconColor: const Color(0xFF0284C7),
              calendarIconBg: const Color(0xFFE0F2FE),
              trailingBadge: _dayNameShortId,
              trailingBadgeColor: const Color(0xFF0369A1),
              trailingBadgeBg: const Color(0xFFE0F2FE),
              mainDateText: '${fullFormatter.format(_selectedDate)} ',
              mainDateTrailing: masehi2026,
              mainDateTrailingColor: const Color(0xFF0369A1),
              subLine1Icon: Icons.info_outline_rounded,
              subLine1Text:
                  'Tahun Kabisat: ${_isLeapYear ? "Ya" : "Tidak"} | Hari ke-$_dayOfYear dalam setahun',
            ),
            const SizedBox(height: 14),

            // ─── Hijriah ─────────────────────────────────────────────────────

            _CalendarCard(
              systemTag: 'SIKLUS BULAN',
              systemTagColor: const Color(0xFF7C3AED),
              calendarName: 'Kalender Hijriah\n(Islamic)',
              calendarIcon: Icons.nights_stay_outlined,
              calendarIconColor: const Color(0xFF7C3AED),
              calendarIconBg: const Color(0xFFF3E8FF),
              trailingBadge: 'Qamariyah',
              trailingBadgeColor: const Color(0xFF7C3AED),
              trailingBadgeBg: const Color(0xFFF3E8FF),
              mainDateText: hijr['display'],
              mainDateTrailing: '${hijr['year']} H',
              mainDateTrailingColor: const Color(0xFF7C3AED),
              subLine1Icon: Icons.brightness_3_rounded,
              subLine1Text: hijr['sub'],
            ),
            const SizedBox(height: 14),

            // ─── Weton Jawa ───────────────────────────────────────────────────

            _WetonCard(
              systemTag: 'KEARIFAN NUSANTARA',
              systemTagColor: const Color(0xFFD97706),
              trailingBadge: 'Neptu ${weton['neptu']}',
              trailingBadgeBg: const Color(0xFFFEF3C7),
              trailingBadgeColor: const Color(0xFFB45309),
              calendarName: 'Kalender Weton\nJawa',
              calendarIcon: Icons.balance_outlined,
              calendarIconBg: const Color(0xFFFEF3C7),
              calendarIconColor: const Color(0xFFD97706),
              mainDateText: weton['weton'],
              mainDateTrailing:
                  '$_dayNameShortId ${weton['neptuH']} + Legi ${weton['neptuP']}',
              mainDateTrailingColor: const Color(0xFFD97706),
              subLine1Icon: Icons.flare_rounded,
              subLine1Text: weton['sub'],
            ),
            const SizedBox(height: 14),

            // ─── Saka Bali ────────────────────────────────────────────────────

            _CalendarCard(
              systemTag: 'TRADISI SURYA-CANDRA',
              systemTagColor: const Color(0xFF16A34A),
              calendarName: 'Kalender Saka Bali',
              calendarIcon: Icons.temple_hindu_outlined,
              calendarIconColor: const Color(0xFF16A34A),
              calendarIconBg: const Color(0xFFDCFCE7),
              trailingBadge: 'Sasih ${saka['sasih']}',
              trailingBadgeColor: const Color(0xFF15803D),
              trailingBadgeBg: const Color(0xFFDCFCE7),
              mainDateText: saka['display'],
              mainDateTrailing: '',
              mainDateTrailingColor: Colors.transparent,
              subLine1Icon: Icons.info_outline_rounded,
              subLine1Text: saka['sub'],
            ),
            const SizedBox(height: 20),

            // ─── Medical Advice Banner ─────────────────────────────────────────

            Container(
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
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.health_and_safety_outlined,
                    color: AppColors.primaryTeal,
                    size: 22,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Catatan Pelayanan Kesehatan',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textDark,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Pencocokan tanggal kalender lunar dan pasaran Jawa membantu keluarga dalam menentukan jadwal operasi elektif, khitanan, hingga upacara adat aqiqah atau otonan tanpa tumpang tindih jadwal medis.',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            color: AppColors.textMuted,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
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

// ─── Reusable Card Widgets ────────────────────────────────────────────────────

class _QuickDateChip extends StatelessWidget {
  final String label;
  final bool isPreset;
  final VoidCallback onTap;

  const _QuickDateChip({
    required this.label,
    required this.onTap,
    this.isPreset = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isPreset ? const Color(0xFFE6F7F5) : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isPreset ? AppColors.primaryTeal : AppColors.borderLight,
            width: isPreset ? 1.2 : 1.0,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: isPreset ? AppColors.primaryTeal : AppColors.textDark,
          ),
        ),
      ),
    );
  }
}

class _CalendarCard extends StatelessWidget {
  final String systemTag;
  final Color systemTagColor;
  final String calendarName;
  final IconData calendarIcon;
  final Color calendarIconColor;
  final Color calendarIconBg;
  final String trailingBadge;
  final Color trailingBadgeColor;
  final Color trailingBadgeBg;
  final String mainDateText;
  final String mainDateTrailing;
  final Color mainDateTrailingColor;
  final IconData subLine1Icon;
  final String subLine1Text;

  const _CalendarCard({
    required this.systemTag,
    required this.systemTagColor,
    required this.calendarName,
    required this.calendarIcon,
    required this.calendarIconColor,
    required this.calendarIconBg,
    required this.trailingBadge,
    required this.trailingBadgeColor,
    required this.trailingBadgeBg,
    required this.mainDateText,
    required this.mainDateTrailing,
    required this.mainDateTrailingColor,
    required this.subLine1Icon,
    required this.subLine1Text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
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
          // System Tag + Trailing Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                systemTag,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.4,
                  color: systemTagColor,
                ),
              ),
              if (trailingBadge.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: trailingBadgeBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    trailingBadge,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: trailingBadgeColor,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),

          // Calendar Name with Icon
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: calendarIconBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(calendarIcon, color: calendarIconColor, size: 22),
              ),
              const SizedBox(width: 12),
              Text(
                calendarName,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textDark,
                  height: 1.3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Main Date Display Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Text(
                  mainDateText,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textDark,
                    letterSpacing: -0.3,
                  ),
                ),
              ),
              if (mainDateTrailing.isNotEmpty)
                Text(
                  mainDateTrailing,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: mainDateTrailingColor,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),

          // Sub Info Row
          Row(
            children: [
              Icon(subLine1Icon, size: 14, color: AppColors.textMuted),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  subLine1Text,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: AppColors.textMuted,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _WetonCard extends StatelessWidget {
  final String systemTag;
  final Color systemTagColor;
  final String trailingBadge;
  final Color trailingBadgeBg;
  final Color trailingBadgeColor;
  final String calendarName;
  final IconData calendarIcon;
  final Color calendarIconBg;
  final Color calendarIconColor;
  final String mainDateText;
  final String mainDateTrailing;
  final Color mainDateTrailingColor;
  final IconData subLine1Icon;
  final String subLine1Text;

  const _WetonCard({
    required this.systemTag,
    required this.systemTagColor,
    required this.trailingBadge,
    required this.trailingBadgeBg,
    required this.trailingBadgeColor,
    required this.calendarName,
    required this.calendarIcon,
    required this.calendarIconBg,
    required this.calendarIconColor,
    required this.mainDateText,
    required this.mainDateTrailing,
    required this.mainDateTrailingColor,
    required this.subLine1Icon,
    required this.subLine1Text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
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
                systemTag,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.4,
                  color: systemTagColor,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: trailingBadgeBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  trailingBadge,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: trailingBadgeColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: calendarIconBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(calendarIcon, color: calendarIconColor, size: 22),
              ),
              const SizedBox(width: 12),
              Text(
                calendarName,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textDark,
                  height: 1.3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                mainDateText,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textDark,
                  letterSpacing: -0.3,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: trailingBadgeBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  mainDateTrailing,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: mainDateTrailingColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(subLine1Icon, size: 14, color: AppColors.textMuted),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  subLine1Text,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: AppColors.textMuted,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
