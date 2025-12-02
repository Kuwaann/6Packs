import 'package:flutter/material.dart';

class TipeBadanPage extends StatefulWidget {
  const TipeBadanPage({super.key});

  @override
  State<TipeBadanPage> createState() => _TipeBadanPageState();
}

class _TipeBadanPageState extends State<TipeBadanPage> {
  final PageController _pageController = PageController();
  int currentIndex = 0;

  final List<Map<String, String>> bodyTypes = [
    {"image": "assets/images/Kurus.png", "label": "Kurus"},
    {"image": "assets/images/Berisi.png", "label": "Berisi"},
    {"image": "assets/images/Sangat Berisi.png", "label": "Sangat Berisi"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.only(left: 40, right: 40, bottom: 96, top: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 350,
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (i) {
                  setState(() => currentIndex = i);
                },
                itemCount: bodyTypes.length,
                itemBuilder: (context, index) {
                  final item = bodyTypes[index];
                  return Container(
                    height: double.infinity,
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          clipBehavior: Clip.hardEdge,
                          child: Image.asset(
                            width: 240,
                            item["image"]!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Column(
              spacing: 5,
              children: [
                Text(
                  bodyTypes[currentIndex]['label']!,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.chevron_left_rounded, color: Colors.white),
                    Text(
                      "Geser untuk mengganti tipe perut Anda",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    Icon(Icons.chevron_right_rounded, color: Colors.white),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
