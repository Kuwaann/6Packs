import 'package:aplikasi_6packs/views/berat_tinggi_badan_page.dart';
import 'package:aplikasi_6packs/views/seberapaaktif_page.dart';
import 'package:aplikasi_6packs/views/tipe_badan_page.dart';
import 'package:flutter/material.dart';

class QuestionPage extends StatefulWidget {
  const QuestionPage({super.key});

  @override
  State<QuestionPage> createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  int currentPagesIndex = 0;

  List<Widget> pages = [
    TipeBadanPage(),
    BeratTinggiBadanPage(),
    SeberapaAktifPage(),
  ];

  List<String> pagesTitle = [
    "Pilih Tipe Perut Anda",
    "Berat dan Tinggi Badan",
    "Rencana Latihan",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        title: Column(
          spacing: 20,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(pagesTitle[currentPagesIndex], style: TextStyle(fontSize: 15)),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: SizedBox(
                height: 6,
                child: Stack(
                  children: [
                    // TRACK PUTIH (fixed)
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),

                    // PROGRESS MERAH (animated)
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 350),
                      curve: Curves.easeInOut,
                      left: 0,
                      top: 0,
                      bottom: 0,

                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 350),
                        curve: Curves.easeInOut,
                        width:
                            (MediaQuery.of(context).size.width -
                                80) // lebar max
                            *
                            ((currentPagesIndex + 1) / 3), // progress
                        decoration: BoxDecoration(
                          color: Color(0xFF910303),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      body: pages[currentPagesIndex],
      bottomNavigationBar: BottomAppBar(
        color: Colors.black,
        child: Container(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: () {
              if (currentPagesIndex < 2) {
                setState(() {
                  currentPagesIndex++;
                });
              }
            },
            style: ElevatedButton.styleFrom(
              shadowColor: Colors.transparent,
              elevation: 0,
              backgroundColor: Color(0xFF620000),
            ),
            child: Text(
              "Selanjutnya",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
