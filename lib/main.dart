import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:vibration/vibration.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MyLuckDay',
      themeMode: ThemeMode.system,
      theme: ThemeData(
        primaryColor: Colors.cyanAccent,
        primarySwatch: Colors.cyan,
        useMaterial3: false,
      ),
      home: LotteryHomePage(),
    );
  }
}

class LotteryHomePage extends StatefulWidget {
  @override
  _LotteryHomePageState createState() => _LotteryHomePageState();
}

class _LotteryHomePageState extends State<LotteryHomePage> {
  List<int> ssqRedBalls = [];
  List<int> ssqBlueBall = [];

  List<int> dltFrontArea = [];
  List<int> dltBackArea = [];

  // 双色球号码
  List<int> redBalls = [];
  List<int> blueBall = [];

  // 大乐透号码
  List<int> frontBalls = [];
  List<int> backBalls = [];

  void generateRandomNumbers() {
    setState(() {
      ssqRedBalls = _generateRandomNumbers(33, 6);
      ssqBlueBall = _generateRandomNumbers(16, 1);
      dltFrontArea = _generateRandomNumbers(35, 5);
      dltBackArea = _generateRandomNumbers(12, 2);
    });
    //HapticFeedback.vibrate();
    Vibration.vibrate();
  }

  List<int> _generateRandomNumbers(int max, int count) {
    List<int> numbers = List.generate(max, (index) => index + 1);
    numbers.shuffle();
    return numbers.take(count).toList()..sort();
  }

  // 生成双色球号码
  void generateRandomNumbers2() {
    final random = Random();

    // 生成6个不重复的红球号码
    final redSet = <int>{};
    while (redSet.length < 6) {
      redSet.add(random.nextInt(33) + 1); // 红球号码范围是1-33
    }
    redBalls = redSet.toList()..sort();

    // 生成1个蓝球号码
    final blueSet = <int>{};
    blueSet.add(random.nextInt(16) + 1);
    blueBall = blueSet.toList(); // 蓝球号码范围是1-16

    // 生成5个不重复的前区号码
    final frontSet = <int>{};
    while (frontSet.length < 5) {
      frontSet.add(random.nextInt(35) + 1); // 前区号码范围是1-35
    }
    frontBalls = frontSet.toList()..sort();

    // 生成2个不重复的后区号码
    final backSet = <int>{};
    while (backSet.length < 2) {
      backSet.add(random.nextInt(12) + 1); // 后区号码范围是1-12
    }
    backBalls = backSet.toList()..sort();

    setState(() {});

    Vibration.vibrate();
  }


  String getAvatar() {
    List<String> list = [
      'assets/avatar01.png',
      'assets/avatar02.png',
      'assets/avatar03.png',
      'assets/avatar04.png',
      'assets/avatar05.png',
    ];
    Random random = Random();
    return list[random.nextInt(list.length)];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'MyLuckDay',
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          Image.asset(
            getAvatar(),
            width: 50,
            height: 50,
          ),
          const SizedBox(
            width: 15,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/icon01.png',
                  width: 100,
                  height: 100,
                ),
                SizedBox(width: 10,),
                Image.asset(
                  'assets/icon02.png',
                  width: 100,
                  height: 100,
                ),
                SizedBox(width: 10,),
                Image.asset(
                  'assets/icon04.png',
                  width: 115,
                  height: 115,
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildGradientText(
              '双色球选号',
              25,
              [
                Colors.redAccent,
                Colors.pinkAccent,
                Colors.purpleAccent,
                Colors.deepPurpleAccent,
                Colors.indigoAccent,
                Colors.blueAccent,
                Colors.lightBlueAccent,
                Colors.cyanAccent,
              ],
            ),
            const SizedBox(height: 10),
            _buildNumberRow('红球', redBalls, Colors.red),
            _buildNumberRow('蓝球', blueBall, Colors.blue),
            const SizedBox(height: 20),
            _buildGradientText(
              '大乐透选号',
              25,
              [
                Colors.cyan,
                Colors.lightBlue,
                Colors.blue,
                Colors.indigo,
                Colors.deepPurple,
                Colors.purple,
                Colors.pink,
                Colors.red,
              ],
            ),
            const SizedBox(height: 10),
            _buildNumberRow('前区', frontBalls, Colors.redAccent),
            _buildNumberRow('后区', backBalls, Colors.blueAccent),
            const SizedBox(height: 30),
            Center(
              child: Container(
                width: 300,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.greenAccent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextButton(
                  onPressed: generateRandomNumbers2,
                  child: _buildGradientText(
                    'get Luck One',
                    25,
                    [
                      Colors.redAccent,
                      Colors.blueAccent,
                    ],
                  ),
                ),
              ),
            ),
            Center(
              child: Lottie.asset(
                'assets/animation01.json',
                width: 200,
                height: 200,
                fit: BoxFit.fill,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGradientText(String text, double fontSize, List<Color> colors) {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return LinearGradient(
          colors: colors,
          tileMode: TileMode.mirror,
        ).createShader(bounds);
      },
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white, // 需要设置颜色，否则不会显示文字
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildNumberRow(String title, List<int> numbers, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            '$title: ',
            style: TextStyle(
                fontSize: 20, color: color, fontWeight: FontWeight.bold),
          ),
          Text(
            numbers.isNotEmpty ? numbers.join("  ") : '',
            style: TextStyle(
                fontSize: 20, color: color, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
