import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'login.dart'; 

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation =
        Tween<double>(begin: 1.0, end: 0.0).animate(_fadeController);

    
    Future.delayed(Duration(seconds: 3), () {
      _fadeController.forward(); 
    });

    
    _fadeController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AuthPage()),
        );
      }
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              
              Lottie.asset(
                'assets/recycle.json',
                width: 200,
                height: 200,
              ),
              SizedBox(height: 30),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Agrich Ghana',
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[700],
                    ),
                  ),
                  SizedBox(width: 2),
                  Image.asset(
                    'assets/logo.png',
                    width: 75,
                    height: 75,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
