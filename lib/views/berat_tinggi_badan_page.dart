import 'package:flutter/material.dart';

class BeratTinggiBadanPage extends StatefulWidget {
  const BeratTinggiBadanPage({super.key});

  @override
  State<BeratTinggiBadanPage> createState() => _BeratTinggiBadanPageState();
}

class _BeratTinggiBadanPageState extends State<BeratTinggiBadanPage> {
  final TextEditingController beratController = TextEditingController();
  final TextEditingController tinggiController = TextEditingController();

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

          // 👉 FORM INPUT
          Column(
            spacing: 40,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ===========================
              //           BERAT BADAN
              // ===========================
              Column(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Berat Badan",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),

                  Container(
                    height: 52,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.02),
                      border: Border.all(color: Colors.white.withOpacity(0.04)),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: beratController,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(horizontal: 16),
                            ),
                          ),
                        ),

                        // KG BOX
                        Container(
                          height: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          decoration: BoxDecoration(
                            color: const Color(0xFF620000),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: const Center(
                            child: Text(
                              "kg",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),

              // ===========================
              //         TINGGI BADAN
              // ===========================
              Column(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Tinggi Badan",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),

                  Container(
                    height: 52,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.02),
                      border: Border.all(color: Colors.white.withOpacity(0.04)),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: tinggiController,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(horizontal: 16),
                            ),
                          ),
                        ),

                        // CM BOX
                        Container(
                          height: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          decoration: BoxDecoration(
                            color: const Color(0xFF620000),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: const Center(
                            child: Text(
                              "cm",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),

          // NOTE (opsional, biar mirip Figma)
          const Text(
            "Isi berat dan tinggi badan Anda\ndengan benar untuk perhitungan akurat.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
