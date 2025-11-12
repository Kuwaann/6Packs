import 'package:flutter/material.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              left: 20,
              top: 50,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              )
            ),
            Positioned(
              left: 0,
              right: 0,
              top: 64,
              child: ColorFiltered(
                colorFilter: const ColorFilter.matrix(<double>[
                    0.2126, 0.7152, 0.0722, 0, 0, // Red
                    0.2126, 0.7152, 0.0722, 0, 0, // Green
                    0.2126, 0.7152, 0.0722, 0, 0, // Blue
                    0, 0, 0, 1, 0,                 // Alpha
                ]),
                child: Image.asset(
                  "assets/images/splashscreen.png",
                  fit: BoxFit.cover,
                  width: 700,
                  height: 900,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black,
                    Colors.black,
                    Colors.transparent,
                  ],
                  stops: [0.0,0.4,0.9]
                )
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 70),
                    child: Column(
                      spacing: 50,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          child: Column(
                            children: [
                              ShaderMask(
                                shaderCallback: (Rect bounds){
                                  return const LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.black,
                                      Color.fromARGB(0, 0, 0, 0),
                                    ],
                                    stops: [0.0,1]
                                  ).createShader(bounds);
                                },
                                blendMode: BlendMode.dstIn,
                                child: Text(
                                  "6Packs",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 40,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                              Transform.translate(
                                offset: const Offset(0, -15),
                                child: Text(
                                  "Aplikasi yang menjadi solusi dan life-changing dalam  waktu dekat",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          child: Column(
                            spacing: 20,
                            children: [
                              Container(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: (){
                                    Navigator.pushNamed(context, '/daftar');
                                  }, 
                                  style: ElevatedButton.styleFrom(
                                    shadowColor: Colors.transparent,
                                    elevation: 0,
                                    backgroundColor: Color(0xFF620000)
                                  ),
                                  child: Text(
                                    "Buat Akun Baru",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  )
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: (){
                                    Navigator.pushNamed(context, '/masuk');
                                  }, 
                                  style: ElevatedButton.styleFrom(
                                    shadowColor: Colors.transparent,
                                    elevation: 0,
                                    backgroundColor: Colors.transparent
                                  ),
                                  child: Text(
                                    "Masuk dengan Akun yang Sudah Ada",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  )
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}