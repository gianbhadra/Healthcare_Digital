import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_logo.dart';
import 'add_edit_member_screen.dart';
import '../../services/database_helper.dart';

class MemberDataScreen extends StatefulWidget {
  const MemberDataScreen({super.key});

  @override
  State<MemberDataScreen> createState() => _MemberDataScreenState();
}

class _MemberDataScreenState extends State<MemberDataScreen> {
  String _selectedFilter = 'Semua';
  String _searchQuery = '';

  List<Map<String, dynamic>> _membersList = [];

  @override
  void initState() {
    super.initState();
    _loadMembers();
  }

  Future<void> _loadMembers() async {
    final members = await DatabaseHelper.instance.getMembers();
    if (!mounted) return;
    setState(() {
      _membersList = members.map((m) {
        return {
          ...m,
          'id': m['id'].toString(),
          'isElderly': m['isElderly'] == 1,
          // ignore: non_const_argument_for_const_parameter
          'avatarIcon': IconData(m['avatarIcon'] as int, fontFamily: 'MaterialIcons'),
        };
      }).toList();
    });
  }

  List<Map<String, dynamic>> get _filteredMembers {
    return _membersList.where((m) {
      final matchesSearch = m['name']
              .toString()
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          m['nik'].toString().contains(_searchQuery);

      if (!matchesSearch) return false;

      if (_selectedFilter == 'Laki-laki') {
        return m['gender'] == 'Laki-laki';
      } else if (_selectedFilter == 'Perempuan') {
        return m['gender'] == 'Perempuan';
      } else if (_selectedFilter == 'Lansia (>60)') {
        return m['isElderly'] == true;
      }
      return true;
    }).toList();
  }

  void _showDetailDialog(Map<String, dynamic> member) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              CircleAvatar(
                backgroundColor: AppColors.lightTealBg,
                child: Icon(
                  member['avatarIcon'] as IconData,
                  color: AppColors.primaryTeal,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      member['name'] as String,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textDark,
                      ),
                    ),
                    Text(
                      'Detail Rekam Pasien',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _DetailRow(label: 'NIK lengkap', value: member['nik'] as String),
              _DetailRow(label: 'Tanggal Lahir', value: member['dob'] as String),
              _DetailRow(label: 'Usia', value: member['age'] as String),
              _DetailRow(label: 'Jenis Kelamin', value: member['gender'] as String),
              _DetailRow(label: 'Golongan Darah', value: member['blood'] as String),
              _DetailRow(label: 'Status BPJS', value: 'Aktif (Kelas 1)'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Tutup',
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryTeal,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteDialog(Map<String, dynamic> member) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            'Hapus Data Anggota?',
            style: GoogleFonts.plusJakartaSans(
              fontWeight: FontWeight.w800,
              color: AppColors.textDark,
            ),
          ),
          content: Text(
            'Apakah Anda yakin ingin menghapus "${member['name']}" dari daftar anggota keluarga?',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              color: AppColors.textMuted,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Batal',
                style: GoogleFonts.plusJakartaSans(
                  color: AppColors.textMuted,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                await DatabaseHelper.instance.deleteMember(int.parse(member['id']));
                _loadMembers();
                if (!context.mounted) return;
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Data ${member['name']} berhasil dihapus.',
                      style: GoogleFonts.plusJakartaSans(),
                    ),
                    backgroundColor: Colors.redAccent,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Hapus',
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _navigateToAddMember() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddEditMemberScreen(),
      ),
    );

    if (result != null && result is Map<String, dynamic>) {
      final inserted = await DatabaseHelper.instance.insertMember({
        'name': result['name'],
        'age': result['age'] ?? '20 th',
        'dob': result['dob'] ?? '14 Mei 2004',
        'gender': result['gender'] ?? 'Laki-laki',
        'nik': result['nik'] ?? '3201••••1405',
        'blood': result['blood'] ?? 'Gol. O',
        'isElderly': 0,
        'avatarIcon': Icons.person_outline_rounded.codePoint,
      });

      if (!mounted) return;
      if (inserted != 1) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Gagal menyimpan anggota. Pastikan server dan database aktif.',
              style: GoogleFonts.plusJakartaSans(),
            ),
            backgroundColor: Colors.redAccent,
          ),
        );
        return;
      }

      await _loadMembers();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Anggota "${result['name']}" berhasil ditambahkan!',
              style: GoogleFonts.plusJakartaSans(),
            ),
            backgroundColor: AppColors.primaryTeal,
          ),
        );
      }
    }
  }

  void _navigateToEditMember(Map<String, dynamic> member) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditMemberScreen(memberToEdit: member),
      ),
    );

    if (result != null && result is Map<String, dynamic>) {
      await DatabaseHelper.instance.updateMember({
        'name': result['name'],
        'age': result['age'] ?? member['age'],
        'dob': result['dob'],
        'gender': result['gender'],
        'nik': result['nik'],
        'blood': result['blood'],
        'isElderly': member['isElderly'] ? 1 : 0,
        'avatarIcon': (member['avatarIcon'] as IconData).codePoint,
      }, int.parse(member['id']));

      _loadMembers();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Data "${result['name']}" berhasil diperbarui!',
              style: GoogleFonts.plusJakartaSans(),
            ),
            backgroundColor: AppColors.primaryTeal,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredMembers;

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
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Title with Back Button
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
                              'Data Anggota',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textDark,
                                letterSpacing: -0.4,
                              ),
                            ),
                            Text(
                              '${_membersList.length} Pasien Terdaftar Aktif',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          width: 38,
                          height: 38,
                          decoration: const BoxDecoration(
                            color: Color(0xFFEFF6FF),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.search_rounded,
                            color: AppColors.textDark,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 38,
                          height: 38,
                          decoration: const BoxDecoration(
                            color: Color(0xFFEFF6FF),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.filter_list_rounded,
                            color: AppColors.textDark,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 18),

                // Search Input & Filter Tune Button Row
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.02),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: TextField(
                          onChanged: (val) {
                            setState(() {
                              _searchQuery = val;
                            });
                          },
                          decoration: InputDecoration(
                            hintText: 'Cari nama atau NIK anggota...',
                            hintStyle: GoogleFonts.plusJakartaSans(
                              color: AppColors.textLight,
                              fontSize: 14,
                            ),
                            prefixIcon: const Icon(
                              Icons.search_rounded,
                              color: AppColors.textMuted,
                              size: 20,
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.02),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.tune_rounded,
                        color: AppColors.primaryTeal,
                        size: 22,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Filter Category Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _FilterChipItem(
                        label: 'Semua (${_membersList.length})',
                        isSelected: _selectedFilter == 'Semua',
                        onTap: () => setState(() => _selectedFilter = 'Semua'),
                      ),
                      const SizedBox(width: 8),
                      _FilterChipItem(
                        label: 'Laki-laki',
                        isSelected: _selectedFilter == 'Laki-laki',
                        onTap: () =>
                            setState(() => _selectedFilter = 'Laki-laki'),
                      ),
                      const SizedBox(width: 8),
                      _FilterChipItem(
                        label: 'Perempuan',
                        isSelected: _selectedFilter == 'Perempuan',
                        onTap: () =>
                            setState(() => _selectedFilter = 'Perempuan'),
                      ),
                      const SizedBox(width: 8),
                      _FilterChipItem(
                        label: 'Lansia (>60)',
                        isSelected: _selectedFilter == 'Lansia (>60)',
                        onTap: () =>
                            setState(() => _selectedFilter = 'Lansia (>60)'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Patient Member Cards List
                if (filtered.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: Text(
                        'Tidak ada data anggota ditemukan',
                        style: GoogleFonts.plusJakartaSans(
                          color: AppColors.textMuted,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filtered.length,
                    separatorBuilder: (ctx, idx) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final m = filtered[index];
                      final bool isMale = m['gender'] == 'Laki-laki';

                      return Container(
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
                            // Member Top Header (Avatar, Name, Age, Blood Type)
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFE8F3FF),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    m['avatarIcon'] as IconData,
                                    color: const Color(0xFF0284C7),
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Flexible(
                                            child: Text(
                                              m['name'] as String,
                                              style:
                                                  GoogleFonts.plusJakartaSans(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w800,
                                                color: AppColors.textDark,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          const SizedBox(width: 8),

                                          // Age Badge
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 3,
                                            ),
                                            decoration: BoxDecoration(
                                              color: m['isElderly'] == true
                                                  ? const Color(0xFFFED7AA)
                                                  : const Color(0xFFF1F5F9),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Text(
                                              m['age'] as String,
                                              style:
                                                  GoogleFonts.plusJakartaSans(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w700,
                                                color: m['isElderly'] == true
                                                    ? const Color(0xFFC2410C)
                                                    : AppColors.textDark,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.cake_outlined,
                                            size: 14,
                                            color: AppColors.textMuted,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            m['dob'] as String,
                                            style: GoogleFonts.plusJakartaSans(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: AppColors.textMuted,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                // Blood Type Badge Top Right
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFEE2E2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    m['blood'] as String,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w800,
                                      color: const Color(0xFFDC2626),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),

                            // Gender & NIK Badges Row
                            Row(
                              children: [
                                // Gender Badge
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isMale
                                        ? const Color(0xFFE0F2FE)
                                        : const Color(0xFFFFEDD5),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        isMale ? Icons.male : Icons.female,
                                        size: 14,
                                        color: isMale
                                            ? const Color(0xFF0369A1)
                                            : const Color(0xFFC2410C),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        m['gender'] as String,
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                          color: isMale
                                              ? const Color(0xFF0369A1)
                                              : const Color(0xFFC2410C),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),

                                // NIK Badge
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF1F5F9),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.verified_user_outlined,
                                        size: 13,
                                        color: AppColors.textMuted,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        'NIK: ${m['nik']}',
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.textDark,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // Action Buttons (Detail, Edit, Delete)
                            Row(
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    height: 38,
                                    child: ElevatedButton.icon(
                                      onPressed: () => _showDetailDialog(m),
                                      icon: const Icon(
                                        Icons.visibility_outlined,
                                        size: 16,
                                      ),
                                      label: Text(
                                        'Detail',
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xFFEFF6FF),
                                        foregroundColor:
                                            const Color(0xFF0284C7),
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: SizedBox(
                                    height: 38,
                                    child: ElevatedButton.icon(
                                      onPressed: () => _navigateToEditMember(m),
                                      icon: const Icon(
                                        Icons.edit_outlined,
                                        size: 16,
                                      ),
                                      label: Text(
                                        'Edit',
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xFFEFF6FF),
                                        foregroundColor:
                                            const Color(0xFF0284C7),
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                SizedBox(
                                  width: 40,
                                  height: 38,
                                  child: ElevatedButton(
                                    onPressed: () => _showDeleteDialog(m),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFFEE2E2),
                                      foregroundColor: const Color(0xFFDC2626),
                                      elevation: 0,
                                      padding: EdgeInsets.zero,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.delete_outline_rounded,
                                      size: 18,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                const SizedBox(height: 80),
              ],
            ),
          ),

          // Floating Action Button (+ Tambah Anggota)
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton.extended(
              onPressed: _navigateToAddMember,
              backgroundColor: const Color(0xFF006D5B),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              icon: const Icon(
                Icons.person_add_alt_1_rounded,
                color: Colors.white,
                size: 20,
              ),
              label: Text(
                'Tambah Anggota',
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
    );
  }
}

class _FilterChipItem extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChipItem({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF006D5B) : const Color(0xFFEFF6FF),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
            color: isSelected ? Colors.white : const Color(0xFF334155),
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              color: AppColors.textMuted,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }
}
