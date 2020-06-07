import 'dart:async';

import 'package:qr_reader/src/models/scan_model.dart';

class Validators{
  final validarGeo = StreamTransformer<List<ScanModel>, List<ScanModel>>.fromHandlers(
    handleData: (scan, sink){
      final geoScans = scan.where(  (p) => p.tipo == "geo").toList();
      sink.add(geoScans);
      

    }
  );

  final validarHttp = StreamTransformer<List<ScanModel>, List<ScanModel>>.fromHandlers(
    handleData: (scan, sink){
      final geoScans = scan.where(  (p) => p.tipo == "http").toList();
      sink.add(geoScans);
      

    }
  );
}