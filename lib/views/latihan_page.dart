import 'dart:async';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../models/paket_model.dart';
import '../services/workout_api.dart';

enum WorkoutPhase { prep, exercise, rest, finished }

class LatihanPage extends StatefulWidget {
  const LatihanPage({super.key});

  @override
  State<LatihanPage> createState() => _LatihanPageState();
}

class _LatihanPageState extends State<LatihanPage> {
  // --- DATA UTAMA ---
  late WorkoutPackage paket;
  bool _isInit = false;

  // --- STATE ---
  WorkoutPhase _phase = WorkoutPhase.prep;
  int _exerciseIndex = 0;
  bool _isPaused = false;

  // --- TIMER ---
  Timer? _timer;
  int _countdown = 30;

  // --- DURASI TOTAL ---
  DateTime? _startTime;
  DateTime? _endTime;

  // --- API & VIDEO ---
  final MuscleWikiApiService _api = MuscleWikiApiService();
  VideoPlayerController? _videoController;
  bool _isVideoInitialized = false;
  bool _isLoadingVideo = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit) {
      final args = ModalRoute.of(context)!.settings.arguments as Map;
      paket = args["paket"] as WorkoutPackage;

      _startTime = DateTime.now();
      _startPrep();
      _isInit = true;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _videoController?.dispose();
    super.dispose();
  }

  // ==========================================
  // LOGIKA FLOW
  // ==========================================

  void _startPrep() {
    setState(() {
      _phase = WorkoutPhase.prep;
      _countdown = 10; // Persiapan cukup 10 detik
      _isPaused = false;
    });
    _startTimer(onFinished: _startNextExercise);
  }

  Future<void> _startNextExercise() async {
    _timer?.cancel();
    _disposeVideo();

    setState(() {
      _phase = WorkoutPhase.exercise;
      _isLoadingVideo = true;
      _isPaused = false;
    });

    final movement = paket.movements[_exerciseIndex];

    // Load Video
    await _loadVideoFromApi(movement.name);

    setState(() {
      _isLoadingVideo = false;
    });

    // Jika tipe latihan "detik", mulai countdown
    if (movement.type == 'detik') {
      setState(() {
        _countdown = movement.amount;
      });
      _startTimer(onFinished: _goToRestOrFinish);
    }
  }

  void _goToRestOrFinish() {
    _timer?.cancel();

    if (_exerciseIndex >= paket.movements.length - 1) {
      _finishWorkout();
    } else {
      _startRest();
    }
  }

  void _startRest() {
    _disposeVideo();

    setState(() {
      _phase = WorkoutPhase.rest;
      _countdown = 30; // Istirahat 30 detik
      _isPaused = false;
    });

    _startTimer(onFinished: () {
      setState(() {
        _exerciseIndex++;
      });
      _startNextExercise();
    });
  }

  void _finishWorkout() {
    _endTime = DateTime.now();
    _disposeVideo();
    setState(() {
      _phase = WorkoutPhase.finished;
    });
  }

  // ==========================================
  // LOGIKA TIMER & PAUSE
  // ==========================================

  void _startTimer({required VoidCallback onFinished}) {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_isPaused) return; // Jika pause, timer tidak berkurang

      if (_countdown <= 0) {
        timer.cancel();
        onFinished();
      } else {
        setState(() {
          _countdown--;
        });
      }
    });
  }

  void _togglePause() {
    setState(() {
      _isPaused = !_isPaused;
      if (_isPaused) {
        _videoController?.pause();
      } else {
        _videoController?.play();
      }
    });
  }

  void _skipCurrentPhase() {
    _timer?.cancel();
    if (_phase == WorkoutPhase.prep) {
      _startNextExercise();
    } else if (_phase == WorkoutPhase.rest) {
      setState(() {
        _exerciseIndex++;
      });
      _startNextExercise();
    } else if (_phase == WorkoutPhase.exercise) {
      _goToRestOrFinish();
    }
  }

  void _disposeVideo() {
    _videoController?.dispose();
    _videoController = null;
    _isVideoInitialized = false;
  }

  Future<void> _loadVideoFromApi(String queryName) async {
    try {
      final exercises = await _api.getExerciseByName(queryName);
      if (exercises.isNotEmpty && exercises.first.videos.isNotEmpty) {
        final url = exercises.first.videos.first;

        _videoController = VideoPlayerController.networkUrl(
          Uri.parse(url),
          httpHeaders: {
            'X-RapidAPI-Key': MuscleWikiApiService.apiKey,
            'X-RapidAPI-Host': MuscleWikiApiService.host,
          },
        );

        await _videoController!.initialize();
        _videoController!.setLooping(true);
        if (!_isPaused) _videoController!.play();

        if (mounted) {
          setState(() {
            _isVideoInitialized = true;
          });
        }
      }
    } catch (e) {
      debugPrint("Gagal load video: $e");
    }
  }


  String _formatTimer(int totalSeconds) {
    int m = totalSeconds ~/ 60;
    int s = totalSeconds % 60;
    return "${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}";
  }

  String _formatDuration(int totalSeconds) {
    int m = totalSeconds ~/ 60;
    int s = totalSeconds % 60;
    return "${m}m ${s}s";
  }


  @override
  Widget build(BuildContext context) {
    if (_phase == WorkoutPhase.finished) {
      return _buildFinishedView();
    }

    final movement = paket.movements[_exerciseIndex];
    final bool isExercise = _phase == WorkoutPhase.exercise;
    final String titleText =
        isExercise ? movement.name : (_phase == WorkoutPhase.rest ? "ISTIRAHAT" : "PERSIAPAN");

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              paket.level,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            if (paket.level == 'Noob')
              const Icon(Icons.star, color: Colors.white, size: 14)
            else if (paket.level == 'Pro')
              const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.star, color: Colors.white, size: 14),
                    Icon(Icons.star, color: Colors.white, size: 14)
                  ])
            else
              const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.star, color: Colors.white, size: 14),
                    Icon(Icons.star, color: Colors.white, size: 14),
                    Icon(Icons.star, color: Colors.white, size: 14)
                  ]),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text("Keluar Latihan?"),
                content: const Text("Progress latihan Anda akan hilang."),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text("Batal")),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        Navigator.pop(context);
                      },
                      child: const Text("Keluar", style: TextStyle(color: Colors.red))),
                ],
              ),
            );
          },
        ),
        actions: const [
          SizedBox(width: kToolbarHeight),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // --- BAGIAN ATAS (Progress & Video) ---
            Column(
              spacing: 20,
              children: [
                // 1. Progress Indicator
                Column(
                  spacing: 10,
                  children: [
                    Text(
                      "${_exerciseIndex + 1} dari ${paket.movements.length}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // Progress Bar Garis-garis
                    Row(
                      children: List.generate(paket.movements.length, (index) {
                        return Expanded(
                          child: Container(
                            height: 4,
                            margin: const EdgeInsets.symmetric(horizontal: 2),
                            decoration: BoxDecoration(
                              // Putih untuk yang sudah/sedang, Abu untuk yang belum
                              color: index <= _exerciseIndex
                                  ? Colors.white
                                  : Colors.white24,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),

                // 2. Judul & Icon Info
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        titleText,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24, // Sedikit lebih besar
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        // Fitur tambahan: Info gerakan (bisa diisi nanti)
                      },
                      icon: const Icon(Icons.info_outline,
                          color: Colors.amber, size: 24),
                    )
                  ],
                ),

                // 3. Video Player Container
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Container(
                      color: Colors.grey[900],
                      child: isExercise
                          ? (_isLoadingVideo
                              ? const Center(
                                  child: CircularProgressIndicator(
                                      color: Colors.white))
                              : _isVideoInitialized
                                  ? VideoPlayer(_videoController!)
                                  : const Center(
                                      child: Icon(Icons.videocam_off,
                                          color: Colors.white54, size: 40)))
                          : Center(
                              // Tampilan saat Istirahat/Prep (Tanpa Video)
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    _phase == WorkoutPhase.rest
                                        ? Icons.self_improvement
                                        : Icons.accessibility_new,
                                    color: Colors.white24,
                                    size: 50,
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    _phase == WorkoutPhase.rest
                                        ? "Ambil Nafas..."
                                        : "Siap-siap!",
                                    style: const TextStyle(color: Colors.white54),
                                  )
                                ],
                              ),
                            ),
                    ),
                  ),
                ),

                // 4. Deskripsi Singkat (Repetisi / Info)
                if (isExercise && movement.type == 'repetisi')
                  Text(
                    "Lakukan ${movement.amount} Repetisi",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                
                if (_phase == WorkoutPhase.rest)
                   Text(
                    "Selanjutnya: ${paket.movements[_exerciseIndex+1].name}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white54),
                   )
              ],
            ),

            // --- BAGIAN TENGAH (Timer Besar) ---
            Text(
              // Tampilkan Timer jika tipe 'detik' atau sedang istirahat/prep
              (isExercise && movement.type == 'repetisi')
                  ? "Manual" // Jika repetisi, tidak ada timer
                  : _formatTimer(_countdown),
              style: TextStyle(
                color: (isExercise && movement.type == 'repetisi') 
                    ? Colors.white24 
                    : (_countdown <= 3 ? Colors.redAccent : Colors.white),
                fontSize: 80, // Ukuran Besar sesuai request
                fontWeight: FontWeight.bold,
                fontFeatures: const [FontFeature.tabularFigures()], // Agar angka tidak goyang
              ),
            ),

            // --- BAGIAN BAWAH (Tombol) ---
            Column(
              spacing: 15,
              children: [
                // Tombol Pause / Resume
                if (_phase != WorkoutPhase.prep) // Prep tidak perlu pause
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: _togglePause,
                      style: ElevatedButton.styleFrom(
                        shadowColor: Colors.transparent,
                        elevation: 0,
                        backgroundColor: const Color(0xFF620000), // Merah Gelap
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        _isPaused ? "Resume" : "Pause",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),

                // Tombol Skip / Selesai
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: _skipCurrentPhase,
                    style: ElevatedButton.styleFrom(
                      shadowColor: Colors.transparent,
                      elevation: 0,
                      backgroundColor: Colors.white, // Putih
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      isExercise ? "Selesai / Lanjut" : "Skip",
                      style: const TextStyle(
                        color: Color(0xFF620000), // Teks Merah Gelap
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildFinishedView() {
    final duration = _endTime!.difference(_startTime!).inSeconds;
    
    int baseCal = 0;
    if (paket.level == "Noob") baseCal = 5;
    if (paket.level == "Pro") baseCal = 8;
    if (paket.level == "Hacker") baseCal = 12;
    final totalCalories = baseCal * paket.movements.length;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        padding: const EdgeInsets.all(30),
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.emoji_events, color: Colors.amber, size: 100),
            const SizedBox(height: 20),
            Text(
              "SELAMAT!",
              style: TextStyle(
                  color: Colors.blue[400],
                  fontSize: 28,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              "Paket ${paket.level} Selesai",
              style: const TextStyle(color: Colors.white, fontSize: 20),
            ),
            const SizedBox(height: 50),
            
            // Statistik
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem(paket.movements.length.toString(), "Latihan"),
                  Container(width: 1, height: 40, color: Colors.white24),
                  _buildStatItem("$totalCalories", "Kkal"),
                  Container(width: 1, height: 40, color: Colors.white24),
                  _buildStatItem(_formatDuration(duration), "Waktu"),
                ],
              ),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/homepage', (route) => false);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0089CE),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
                child: const Text("Kembali ke Beranda",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        Text(label,
            style: const TextStyle(color: Colors.white54, fontSize: 12)),
      ],
    );
  }
}