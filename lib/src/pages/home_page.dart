import 'package:flutter/material.dart';
import 'package:qr_reader/src/bloc/scan_bloc.dart';
import 'package:qr_reader/src/models/scan_model.dart';
import 'package:qr_reader/src/pages/direcciones_page.dart';
import 'package:qr_reader/src/pages/mapas_page.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:qr_reader/src/utility/utils.dart' as utils;


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;

  final scansBloc = ScansBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("QR Scanner"),
        actions: <Widget>[
          IconButton(
            icon: Icon( Icons.delete_forever),
            onPressed: (){
              scansBloc.borrarScans();
            },
          )
        ],
      ),
      body: _callPage(currentIndex),
      bottomNavigationBar: _crearBottomNavigationBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon( Icons.filter_center_focus ),
        onPressed: _scanQR,
      ),
    );
  }

  Widget _callPage(int paginaActual) {
    switch (paginaActual) {
      case 0:
        return MapasPage();
      case 1:
        return DireccionesPage();
        break;
      default:
        
    }

    return MapasPage();
  }

  Widget _crearBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (indice) {
        setState(() {
         currentIndex = indice; 
        });
      },
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.map), title: Text("Mapas")),
        BottomNavigationBarItem(
            icon: Icon(Icons.brightness_5), title: Text("Direcciones"))
      ],
    );
  }

  void _scanQR() async {
     ScanResult futureString ;

    // geo:40.649256132187084,-73.93590345820316

    try{
      futureString = await BarcodeScanner.scan();
    }catch( e ){

      futureString.rawContent = e.toString(); 
    }

    // futureString.rawContent = "https://google.com";

    // print("datos = ${futureString.rawContent}");
    //final scan = ScanModel( valor: "http://google.com");
    scansBloc.agregarScan( ScanModel( valor : futureString.rawContent  ) );
    //scansBloc.agregarScan(ScanModel( valor: "geo:40.649256132187084,-73.93590345820316"));

    //utils.abrirScan(scan);

  }
}
