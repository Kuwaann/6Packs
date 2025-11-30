import 'package:flutter/material.dart';
import 'package:aplikasi_6packs/widgets/custom_thumb_shape.dart';
import 'package:aplikasi_6packs/widgets/customTickMarkShape.dart';

class SeberapaAktifPage extends StatefulWidget {
  const SeberapaAktifPage({super.key});

  @override
  State<SeberapaAktifPage> createState() => _SeberapaAktifPageState();
}

class _SeberapaAktifPageState extends State<SeberapaAktifPage> {
  double _sliderValue = 0.0;

  String getActivityLabel(double value) {
    switch (value.toInt()) {
      case 0:
        return 'Bisa dibilang, saya sangat jarang berolahraga. Mager adalah gaya hidup.';
      case 1:
        return 'Olahraga? Saya jarang banget. Paling jalan kaki sebentar atau olahraga di kasur.';
      case 2:
        return 'Level keaktifan saya di sedang. Kadang semangat, kadang lupa. Seminggu sekali pasti gerak, walau cuma ringan.';
      case 3:
        return 'Saya sudah cukup aktif! Rutin olahraga 2-3 kali seminggu.';
      case 4:
        return 'Hidup seimbang! Saya adalah orang yang aktif. Olahraga adalah rutinitas harian yang wajib.';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.only(left: 40, right: 40, bottom: 30, top: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Seberapa Aktif Anda dalam Berolahraga?",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          Expanded(
            child: ShaderMask(
              shaderCallback: (Rect bounds) {
                return const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black, Color.fromARGB(0, 0, 0, 0)],
                  stops: [0.0, 1],
                ).createShader(bounds);
              },
              blendMode: BlendMode.dstIn,
              child: Image.asset("assets/images/seberapaaktif.png"),
            ),
          ),
          Column(
            children: [
              // Label aktif saat ini
              Text(
                getActivityLabel(_sliderValue),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                ),
              ),
              SizedBox(height: 20),

              // Slider
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: Color(0xFF8B1E1E),
                  inactiveTrackColor: Colors.grey.shade800,
                  thumbColor: Color(0xFF8B1E1E),
                  overlayColor: Color(0xFF8B1E1E).withOpacity(0.2),
                  thumbShape: CustomThumbShape(
                    thumbRadius: 10.0,
                    borderWidth: 3.0,
                  ),
                  trackHeight: 8.0, // Garis lebih tebal
                  activeTickMarkColor:
                      Colors.white, // Titik putih untuk bagian aktif
                  inactiveTickMarkColor: Colors.white.withOpacity(
                    0.5,
                  ), // Titik putih transparan untuk bagian tidak aktif
                  tickMarkShape: CustomTickMarkShape(
                    tickMarkRadius: 5.0,
                  ), // Custom ukuran titik
                ),
                child: Slider(
                  value: _sliderValue,
                  min: 0.0,
                  max: 4.0,
                  divisions: 4,
                  onChanged: (value) {
                    setState(() {
                      _sliderValue = value;
                    });
                  },
                ),
              ),

              // Labels
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Sangat Jarang",
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    Text(
                      "Sangat Aktif",
                      style: TextStyle(color: Colors.white, fontSize: 12),
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
