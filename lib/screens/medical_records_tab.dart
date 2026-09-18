import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class MedicalRecordsTab extends StatelessWidget {
  const MedicalRecordsTab({super.key});

  final List<Map<String, dynamic>> _records = const [
    {
      'date': '12 Sep 2026',
      'title': 'Pemeriksaan Rutin Penyakit Dalam',
      'doctor': 'Dr. Budi Santoso, Sp.PD',
      'hospital': 'RS Medika Utama',
      'diagnosis': 'Kondisi fisik stabil, tekanan darah normal.',
      'prescription': 'Amlodipine 5mg (1x1 setelah makan)',
      'status': 'Selesai',
      'type': 'Konsultasi Dokter',
    },
    {
      'date': '28 Agu 2026',
      'title': 'Hasil Tes Darah Lengkap & Kolesterol',
      'doctor': 'Lab RS Medika Utama',
      'hospital': 'Laboratorium Medika',
      'diagnosis': 'Kolesterol Total 190 mg/dL (Normal)',
      'prescription': 'Vitamin C 500mg, Multivitamin',
      'status': 'Tersedia PDF',
      'type': 'Hasil Laboratorium',
    },
    {
      'date': '15 Jul 2026',
      'title': 'Pemeriksaan Kesehatan Mata',
      'doctor': 'Dr. Ratna Dewi, Sp.KOR',
      'hospital': 'Klinik Utama Sehat',
      'diagnosis': 'Miopia ringan R: -0.75 L: -0.50',
      'prescription': 'Kacamata anti-radiasi',
      'status': 'Selesai',
      'type': 'Spesialis',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Rekam Medis Digital',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Riwayat diagnosis, resep obat, & hasil lab Anda',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 20),

          // Certificate / Encrypted Banner
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.lightTealBg,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.primaryTeal.withValues(alpha: 0.2)),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.lock_person_rounded,
                  color: AppColors.primaryTeal,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Rekam Medis Terprivasi',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryTealDark,
                        ),
                      ),
                      Text(
                        'Semua dokumen dienkripsi penuh sesuai standar HIPPA & Kemenkes.',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          // Medical Records List
          Expanded(
            child: ListView.separated(
              itemCount: _records.length,
              separatorBuilder: (ctx, idx) => const SizedBox(height: 14),
              itemBuilder: (context, index) {
                final item = _records[index];
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.background,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              item['type'],
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primaryTeal,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.event_note_rounded,
                                size: 14,
                                color: AppColors.textMuted,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                item['date'],
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        item['title'],
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${item['doctor']} • ${item['hospital']}',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          color: AppColors.textMuted,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.inputBg,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.borderLight),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.medical_information_outlined,
                                  size: 16,
                                  color: AppColors.primaryTeal,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Diagnosis:',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textDark,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              item['diagnosis'],
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                color: AppColors.textDark,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(
                                  Icons.medication_outlined,
                                  size: 16,
                                  color: AppColors.accentTeal,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Resep Obat:',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textDark,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              item['prescription'],
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                color: AppColors.textDark,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Mengunduh dokumen PDF rekam medis...',
                                  style: GoogleFonts.plusJakartaSans(),
                                ),
                                backgroundColor: AppColors.primaryTeal,
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.download_rounded,
                            size: 16,
                            color: AppColors.primaryTeal,
                          ),
                          label: Text(
                            'Unduh Dokumen PDF',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryTeal,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
