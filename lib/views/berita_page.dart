import 'package:flutter/material.dart';

class BeritaPage extends StatefulWidget {
  const BeritaPage({super.key});

  @override
  State<BeritaPage> createState() => _BeritaPageState();
}

class _BeritaPageState extends State<BeritaPage> {
  final List<Map<String, String>> newsList = [
    {
      "title": "Tips Menjaga Kesehatan di Rumah",
      "desc":
          "Menjaga kesehatan dimulai dari kebiasaan kecil sehari-hari. Simak tips berikut untuk tetap sehat meski sibuk.",
    },
    {
      "title": "Manfaat Olahraga Setiap Pagi",
      "desc":
          "Olahraga pagi memberi energi untuk beraktivitas, meningkatkan metabolisme, dan memperbaiki mood.",
    },
    {
      "title": "Makanan Tinggi Protein yang Murah",
      "desc":
          "Tidak harus mahal untuk makan sehat. Berikut daftar makanan tinggi protein yang ramah dompet.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      /// Custom AppBar
      appBar: AppBar(
        automaticallyImplyLeading: false,
        scrolledUnderElevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        title: Text("Berita", style: TextStyle(fontSize: 15)),
      ),

      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10,
          children: [
            SizedBox(height: 10),
            ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: newsList.length,
              separatorBuilder: (context, index) => SizedBox(height: 10),
              itemBuilder: (context, index) {
                final item = newsList[index];

                return InkWell(
                  onTap: () {},
                  child: Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white.withOpacity(0.08),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      spacing: 20,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Thumbnail
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),

                        /// Berita
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 8,
                            children: [
                              Text(
                                item["title"]!,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                ),
                              ),
                              Text(
                                item["desc"]!,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
