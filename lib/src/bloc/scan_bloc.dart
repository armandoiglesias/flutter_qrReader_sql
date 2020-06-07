

import 'dart:async';

import 'package:qr_reader/src/bloc/validator.dart';
import 'package:qr_reader/src/providers/db_provider.dart';

class ScansBloc with Validators{

  static final ScansBloc _singleton = ScansBloc._internal();

    factory ScansBloc(){
      return _singleton;
    }

  ScansBloc._internal(){
    obtenerScans();
  }

  final _scansController = StreamController<List<ScanModel>>.broadcast();

  Stream<List<ScanModel>>get scanStream => _scansController.stream.transform( validarGeo );
  Stream<List<ScanModel>>get scanStreamHttp => _scansController.stream.transform(validarHttp);

  dispose(){
    _scansController?.close();
  }

  obtenerScans() async{
    _scansController.sink.add( await DBProvider.db.getScans() );
  }

  borrarScan(int id) async{
    await DBProvider.db.deleteScan(id);
    obtenerScans();
  }

  borrarScans() async{
    await DBProvider.db.deleteAll();
    obtenerScans();
  }

  agregarScan( ScanModel scan ) async  {
    await DBProvider.db.nuevoScan(scan);
    obtenerScans();
  }

}