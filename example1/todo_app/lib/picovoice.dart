// import 'package:path_provider/path_provider.dart';
// import 'package:picovoice/picovoice_manager.dart';
// import 'package:picovoice/picovoice_error.dart';

// PicovoiceManager _picovoiceManager;

// void _initPicovoice() async {
//     String platform = Platform.isAndroid ? "android" : "ios";
//     String keywordAsset = "assets/$platform/pico_clock_$platform.ppn";
//     String keywordPath = await _extractAsset(keywordAsset);
//     String contextAsset = "assets/$platform/flutter_clock_$platform.rhn";
//     String contextPath = await _extractAsset(contextAsset);

//     try {
//       _picovoiceManager = await PicovoiceManager.create(
//           keywordPath, 
//           _wakeWordCallback, 
//           contextPath, 
//           _inferenceCallback);
//       _picovoiceManager.start();
//     } on PvError catch (ex) {
//       print(ex);
//     }
// }

// void _wakeWordCallback(int keywordIndex) {
//   print("wake word detected!");
// }

// void _inferenceCallback(Map<String, dynamic> inference) {
//     print(inference);
// }

// Future<String> _extractAsset(String resourcePath) async {   
//     String resourceDirectory = (await getApplicationDocumentsDirectory()).path;
//     String outputPath = '$resourceDirectory/$resourcePath';
//     File outputFile = new File(outputPath);

//     ByteData data = await rootBundle.load(resourcePath);
//     final buffer = data.buffer;

//     await outputFile.create(recursive: true);
//     await outputFile.writeAsBytes(
//         buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
//     return outputPath;
// }