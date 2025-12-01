import 'package:flutter/material.dart';
import 'package:aplikasi_6packs/widgets/custom_thumb_shape.dart';
import 'package:aplikasi_6packs/widgets/customTickMarkShape.dart';

class RencanaPage extends StatefulWidget {
  const RencanaPage({super.key});

  @override
  State<RencanaPage> createState() => _RencanaPageState();
}

class _RencanaPageState extends State<RencanaPage> {
  double _sliderValue = 0.0;

  String getActivityLabel(double value) {
    switch (value.toInt()) {
      case 0:
        return '1';
      case 1:
        return '2';
      case 2:
        return '3';
      case 3:
        return '4';
      case 4:
        return '5';
      case 5:
        return '6';
      case 6:
        return '7';
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
            "Berapa Hari Rencana Anda Berolahraga Dalam Waktu Satu Minggu?",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          Expanded(child: Image.asset("assets/images/rencana.png")),
          Column(
            children: [
              // Label aktif saat ini
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    getActivityLabel(_sliderValue),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 64,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    "x",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
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
                  max: 6.0,
                  divisions: 6,
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
