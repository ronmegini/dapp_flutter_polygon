import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'artpainter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Generate art',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Generate art'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ArtWork artWork = ArtWork();
  int numberOfColors = Colors.primaries.length;
  GlobalKey paintAreaKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(artWork.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CustomPaint(
                key: paintAreaKey,
                foregroundPainter: ArtPainter(artWork),
                size: Size(width / 2, width)),
          ],
        ),
      ),
      floatingActionButton: ElevatedButton(
        child: const Text('Press to make 10 NFTs'),
        onPressed: () async {
          Directory appDocDir = await getApplicationDocumentsDirectory();
          // Upload files to /Users/ronmegini/Library/Containers/com.example.generateArt/Data/Documents
          String appDocPath = appDocDir.path;
          var random = Random();
          for (int i = 0; i < 10; i++) {
            artWork.title = 'Circle $i';
            artWork.backgroundIndex = random.nextInt(numberOfColors);
            artWork.forgroundIndex = random.nextInt(numberOfColors);
            while (artWork.forgroundIndex == artWork.backgroundIndex) {
              artWork.forgroundIndex = random.nextInt(numberOfColors);
            } // Avoid having the same forground and background color
            artWork.radiusIndex = random.nextInt(10) + 1;
            // Here you should check that the artwork is unique
            Uint8List pngBytes = await getPng(artWork);
            var myFile = File(appDocPath + '/' + artWork.title + '.png');
            myFile.writeAsBytesSync(pngBytes);
            String traits =
                '[{"trait_type":"BgColor","value": "${artWork.backgroundIndex}"},' +
                    '{"trait_type":"FgColor","value": "${artWork.forgroundIndex}"},' +
                    '{"trait_type":"Radius","value": "${artWork.radiusIndex}"}]';
            String nftJson = '{"name": "${artWork.title}",' +
                '"description": "This is circle number $i",' +
                '"image": "ipfs://IMAGES_CID/${artWork.title}.png",' +
                '"attributes": $traits}';
            myFile = File(appDocPath + '/' + artWork.title + '.json');
            myFile.writeAsStringSync(nftJson);
            setState(() {});
            await Future.delayed(const Duration(milliseconds: 1000));
          }
        },
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
