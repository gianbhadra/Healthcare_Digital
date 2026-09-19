import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';
import '../../services/database_helper.dart';
import 'package:intl/intl.dart';

class HealthHistoryScreen extends StatefulWidget {
  const HealthHistoryScreen({super.key});

  @override
  State<HealthHistoryScreen> createState() => _HealthHistoryScreenState();
}

class _HealthHistoryScreenState extends State<HealthHistoryScreen> {
  List<Map<String, dynamic>> _history = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final history = await DatabaseHelper.instance.getHistory();
    setState(() {
      _history = history.map((e) => {
            ...e,
            'id': e['id'].toString(),
          }).toList();
    });
  }

  void _showHistoryDialog([Map<String, dynamic>? item]) {
    final titleController = TextEditingController(text: item?['title'] as String? ?? '');
    final locationController = TextEditingController(text: item?['location'] as String? ?? '');
    final noteController = TextEditingController(text: item?['note'] as String? ?? '');
    String selectedCategory = item?['category'] as String? ?? 'Vaksinasi';
    final isEdit = item != null;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            isEdit ? 'Edit Riwayat' : 'Tambah Riwayat',
            style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Judul (Contoh: Vaksin)'),
                ),
                TextField(
                  controller: locationController,
                  decoration: const InputDecoration(labelText: 'Lokasi (Contoh: RSUD)'),
                ),
                DropdownButtonFormField<String>(
                  initialValue: selectedCategory,
                  items: ['Vaksinasi', 'Pemeriksaan Rutin', 'Laboratorium', 'Lainnya']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) selectedCategory = val;
                  },
                  decoration: const InputDecoration(labelText: 'Kategori'),
                ),
                TextField(
                  controller: noteController,
                  decoration: const InputDecoration(labelText: 'Catatan'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                final title = titleController.text.trim();
                final location = locationController.text.trim();
                final note = noteController.text.trim();
                if (title.isEmpty || location.isEmpty || note.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Semua field riwayat wajib diisi.')),
                  );
                  return;
                }

                final data = {
                  'title': title,
                  'location': location,
                  'category': selectedCategory,
                  'note': note,
                  'date': item?['date'] ?? DateFormat('dd MMM yyyy').format(DateTime.now()),
                };
                if (isEdit) {
                  await DatabaseHelper.instance.updateHistory(
                    data,
                    int.parse(item['id'].toString()),
                  );
                } else {
                  await DatabaseHelper.instance.insertHistory(data);
                }
                if (!context.mounted) return;
                Navigator.pop(context);
                _loadHistory();
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteDialog(Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Hapus Riwayat?',
            style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
          ),
          content: Text('Anda yakin ingin menghapus "${item['title']}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                await DatabaseHelper.instance.deleteHistory(int.parse(item['id']));
                if (!context.mounted) return;
                Navigator.pop(context);
                _loadHistory();
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Hapus', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: Text(
          'Riwayat Kesehatan',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
          ),
        ),
        iconTheme: const IconThemeData(color: AppColors.textDark),
      ),
      body: _history.isEmpty
          ? Center(
              child: Text(
                'Belum ada riwayat kesehatan',
                style: GoogleFonts.plusJakartaSans(color: AppColors.textMuted),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: _history.length,
              separatorBuilder: (ctx, idx) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = _history[index];
                return GestureDetector(
                  onTap: () => _showHistoryDialog(item),
                  onLongPress: () => _showDeleteDialog(item),
                  child: Container(
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
                                color: AppColors.lightTealBg,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                item['category']!,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primaryTeal,
                                ),
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  item['date']!,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textMuted,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () => _showDeleteDialog(item),
                                  icon: const Icon(Icons.delete_outline_rounded),
                                  tooltip: 'Hapus riwayat',
                                  color: Colors.redAccent,
                                  iconSize: 20,
                                  visualDensity: VisualDensity.compact,
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          item['title']!,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textDark,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Lokasi: ${item['location']!}',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            color: AppColors.textMuted,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Catatan: ${item['note']!}',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            color: AppColors.textDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showHistoryDialog,
        backgroundColor: AppColors.primaryTeal,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

