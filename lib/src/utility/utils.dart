
import 'package:qr_reader/src/models/scan_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

abrirScan(BuildContext context,  ScanModel model) async {

if ( model.valor.contains("http") ) {
  if (await canLaunch(model.valor)) {
    await launch(model.valor);
  } else {
    throw 'Could not launch ${ model.valor }';
  }
}else{
  print("Geo");
  Navigator.pushNamed(context, "mapa", arguments: model);
}

  
}