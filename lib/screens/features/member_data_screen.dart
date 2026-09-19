import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_logo.dart';

class MemberDataScreen extends StatefulWidget {
  const MemberDataScreen({super.key});

  @override
  State<MemberDataScreen> createState() => _MemberDataScreenState();
}

class _MemberDataScreenState extends State<MemberDataScreen> {
  String _searchQuery = '';

  // Daftar anggota tetap. Kolom 'nim' berisi NIM masing-masing anggota.
  static const List<Map<String, String>> _members = [
    {
      'name': 'GIAN BAHDRA Q K',
      'nim': '124240016',
      'gender': 'Laki-laki',
    },
    {
      'name': 'SEPIAN EKA NUGRAHA',
      'nim': '124240028',
      'gender': 'Laki-laki',
    },
    {
      'name': 'RIFQY RAHMAD L H',
      'nim': '124240169',
      'gender': 'Laki-laki',
    },
    {
      'name': 'ILHAMSYAH ADI K',
      'nim': '124240198',
      'gender': 'Laki-laki',
    },
  ];

<<<<<<< HEAD
  List<Map<String, String>> get _filteredMembers {
    final query = _searchQuery.toLowerCase();
    return _members.where((m) {
      return m['name']!.toLowerCase().contains(query) ||
          m['nim']!.contains(_searchQuery);
=======
  static final List<Map<String, dynamic>> _defaultMembers = [
    {
      'id': '1',
      'name': 'Gian Bhadra Q.K.',
      'age': '23 th',
      'dob': '14 Mei 2002',
      'gender': 'Laki-laki',
      'nik': '3201011405020001',
      'blood': 'A+',
      'isElderly': false,
      'avatarIcon': Icons.person_outline_rounded.codePoint,
    },
    {
      'id': '2',
      'name': 'Sipian Eka Nugraha',
      'age': '27 th',
      'dob': '09 Agustus 1999',
      'gender': 'Laki-laki',
      'nik': '3201010908990002',
      'blood': 'O+',
      'isElderly': false,
      'avatarIcon': Icons.person_outline_rounded.codePoint,
    },
    {
      'id': '3',
      'name': 'Rifqy Rahmad L.H.',
      'age': '25 th',
      'dob': '22 Maret 2001',
      'gender': 'Laki-laki',
      'nik': '3201012203010003',
      'blood': 'B+',
      'isElderly': false,
      'avatarIcon': Icons.person_outline_rounded.codePoint,
    },
    {
      'id': '4',
      'name': 'Ilhamsyah Adi K.',
      'age': '29 th',
      'dob': '18 November 1997',
      'gender': 'Laki-laki',
      'nik': '3201011811970004',
      'blood': 'AB+',
      'isElderly': false,
      'avatarIcon': Icons.person_outline_rounded.codePoint,
    },
  ];

  IconData _memberIcon(dynamic codePoint) {
    if (codePoint == Icons.person_outline_rounded.codePoint) {
      return Icons.person_outline_rounded;
    }
    return Icons.person_outline_rounded;
  }

  @override
  void initState() {
    super.initState();
    _loadMembers();
  }

  Future<void> _loadMembers() async {
    final members = await DatabaseHelper.instance.getMembers();
    if (!mounted) return;

    final sourceMembers = members.isEmpty ? _defaultMembers : members;
    setState(() {
      _membersList = sourceMembers.map((m) {
        final isElderly = m['isElderly'] is bool
            ? m['isElderly'] as bool
            : m['isElderly'] == 1;

        return {
          ...m,
          'id': m['id']?.toString() ?? '',
          'isElderly': isElderly,
          'avatarIcon': _memberIcon(m['avatarIcon']),
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
>>>>>>> 91af534 (update tampilan)
    }).toList();
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
        actions: const [
          CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.lightTealBg,
            child: Icon(
              Icons.person,
              color: AppColors.primaryTeal,
              size: 20,
            ),
          ),
          SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Title with Back Button
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
<<<<<<< HEAD
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
                      '${_members.length} Anggota',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textMuted,
=======
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.02),
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
                            color: Colors.black.withOpacity(0.02),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.tune_rounded,
                        color: AppColors.primaryTeal,
                        size: 22,
>>>>>>> 91af534 (update tampilan)
                      ),
                    ),
                  ],
                ),
<<<<<<< HEAD
=======
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
                              color: Colors.black.withOpacity(0.03),
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
>>>>>>> 91af534 (update tampilan)
              ],
            ),
            const SizedBox(height: 18),

            // Search Input
            Container(
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
                onChanged: (val) => setState(() => _searchQuery = val),
                decoration: InputDecoration(
                  hintText: 'Cari nama atau NIM anggota...',
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
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Member Cards List
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
                  return _MemberCard(
                    name: m['name']!,
                    nim: m['nim']!,
                    gender: m['gender']!,
                  );
                },
              ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _MemberCard extends StatelessWidget {
  final String name;
  final String nim;
  final String gender;

  const _MemberCard({
    required this.name,
    required this.nim,
    required this.gender,
  });

  @override
  Widget build(BuildContext context) {
    final bool isMale = gender == 'Laki-laki';
    final Color genderColor =
        isMale ? const Color(0xFF0369A1) : const Color(0xFFC2410C);

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
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  color: Color(0xFFE8F3FF),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person_outline_rounded,
                  color: Color(0xFF0284C7),
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  name,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textDark,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              // Gender Badge
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
                      color: genderColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      gender,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: genderColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),

              // NIM Badge
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
                      'NIM: $nim',
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
        ],
      ),
    );
  }
}
