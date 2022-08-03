import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  static const customSwatch = MaterialColor(
    0xFFFF5252,
    <int, Color>{
      50: Color(0xFFFFEBEE),
      100: Color(0xFFFFCDD2),
      200: Color(0xFFEF9A9A),
      300: Color(0xFFE57373),
      400: Color(0xFFEF5350),
      500: Color(0xFFFF5252),
      600: Color(0xFFE53935),
      700: Color(0xFFD32F2F),
      800: Color(0xFFC62828),
      900: Color(0xFFB71C1C),
    },
  );

  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFFCFCFC),
        appBarTheme: const AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarBrightness: Brightness.light,
            statusBarIconBrightness: Brightness.dark,
          ),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: const PreviewScreen(),
    );
  }
}

class PreviewScreen extends StatefulWidget {
  const PreviewScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<PreviewScreen> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  @override
  void initState() {
    super.initState();
  }

  Future<Uint8List> getFile() async {
    try {
      final ByteData fileData = await NetworkAssetBundle(
        Uri.parse(
          "https://juventudedesporto.cplp.org/files/sample-pdf_9359.pdf",
        ),
      ).load("");
      final Uint8List bytes = fileData.buffer.asUint8List();
      return bytes;
    } catch (ee) {
      throw Exception();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf1f5f9),
      // appBar: AppBar(
      //   leading: IconButton(
      //     onPressed: () => Navigator.pop(context),
      //     icon: const Icon(Icons.arrow_back_outlined),
      //   ),
      //   centerTitle: true,
      //   title: const Text("Preview"),
      // ),
      body: FutureBuilder<Uint8List>(
        future: getFile(),
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            return InteractiveViewer(
              maxScale: 3,
              minScale: 0.1,
              child: SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: PdfPreview(
                  build: (format) => snapshot.data!,
                  canDebug: false,
                  useActions: false,
                  onError: (_, __) => const Center(
                    child: Text('Error'),
                  ),
                  loadingWidget: const CupertinoActivityIndicator(),
                  scrollViewDecoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.7),
                    ),
                    color: const Color(0xFFf1f5f9),
                  ),
                  pdfPreviewPageDecoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.7),
                    ),
                    color: Colors.white,
                  ),
                  initialPageFormat: PdfPageFormat.a4,
                  pdfFileName: "mydoc.pdf",
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Error'),
            );
          } else {
            return const Center(
              child: CupertinoActivityIndicator(),
            );
          }
        },
      ),
    );
  }
}
