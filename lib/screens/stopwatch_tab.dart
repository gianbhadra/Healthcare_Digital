import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class StopwatchTab extends StatefulWidget {
  const StopwatchTab({super.key});

  @override
  State<StopwatchTab> createState() => _StopwatchTabState();
}

class _StopwatchTabState extends State<StopwatchTab> {
  final Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;
  final List<String> _laps = [];

  void _startStopwatch() {
    _stopwatch.start();
    _timer = Timer.periodic(const Duration(milliseconds: 30), (timer) {
      if (mounted) setState(() {});
    });
  }

  void _pauseStopwatch() {
    _stopwatch.stop();
    _timer?.cancel();
    if (mounted) setState(() {});
  }

  void _resetStopwatch() {
    _stopwatch.reset();
    _stopwatch.stop();
    _timer?.cancel();
    _laps.clear();
    if (mounted) setState(() {});
  }

  void _addLap() {
    if (_stopwatch.isRunning) {
      final String lapTime = _formattedTime;
      setState(() {
        _laps.insert(0, 'Putaran ${_laps.length + 1}: $lapTime');
      });
    }
  }

  String get _formattedTime {
    final elapsed = _stopwatch.elapsed;
    final String minutes =
        (elapsed.inMinutes % 60).toString().padLeft(2, '0');
    final String seconds =
        (elapsed.inSeconds % 60).toString().padLeft(2, '0');
    final String milliseconds =
        ((elapsed.inMilliseconds % 1000) ~/ 10).toString().padLeft(2, '0');
    return '$minutes:$seconds.$milliseconds';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Text(
            'Stopwatch Medis / Olahraga',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Ukur detak jantung, napas, atau waktu olahraga',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 30),

          // Digital Timer Ring
          Container(
            width: 220,
            height: 220,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(
                color: _stopwatch.isRunning
                    ? AppColors.primaryTeal
                    : AppColors.borderLight,
                width: 4,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryTeal.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Center(
              child: Text(
                _formattedTime,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 34,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textDark,
                  letterSpacing: -1,
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),

          // Action Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton.filled(
                onPressed: _stopwatch.isRunning ? _addLap : _resetStopwatch,
                icon: Icon(
                  _stopwatch.isRunning
                      ? Icons.flag_rounded
                      : Icons.refresh_rounded,
                ),
                iconSize: 26,
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.lightTealBg,
                  foregroundColor: AppColors.primaryTeal,
                ),
              ),
              const SizedBox(width: 24),
              ElevatedButton(
                onPressed:
                    _stopwatch.isRunning ? _pauseStopwatch : _startStopwatch,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _stopwatch.isRunning
                      ? Colors.orangeAccent
                      : AppColors.primaryTeal,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  _stopwatch.isRunning ? 'Jeda' : 'Mulai',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Lap List
          Expanded(
            child: _laps.isEmpty
                ? Center(
                    child: Text(
                      'Belum ada catatan lap',
                      style: GoogleFonts.plusJakartaSans(
                        color: AppColors.textMuted,
                        fontSize: 13,
                      ),
                    ),
                  )
                : ListView.separated(
                    itemCount: _laps.length,
                    separatorBuilder: (ctx, idx) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      return ListTile(
                        dense: true,
                        title: Text(
                          _laps[index],
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textDark,
                          ),
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
