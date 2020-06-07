import 'package:flutter/material.dart';
import 'package:qr_reader/src/bloc/scan_bloc.dart';
import 'package:qr_reader/src/models/scan_model.dart';
import 'package:qr_reader/src/utility/utils.dart';

class MapasPage extends StatelessWidget {
  final scansBloc = ScansBloc();

  @override
  Widget build(BuildContext context) {

    scansBloc.obtenerScans();

    return StreamBuilder(
      stream: scansBloc.scanStream,
      // initialData: InitialDat,
      builder: (BuildContext context, AsyncSnapshot<List<ScanModel>> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        final scans = snapshot.data;
        if (scans.length == 0) {
          return Center(
            child: Text("No data que mostrar"),
          );
        }

        return ListView.builder(
          itemCount: scans.length,
          itemBuilder: (BuildContext context, int index) {
            return Dismissible(
              onDismissed: (direction) {
                scansBloc.borrarScan(scans[index].id);
              },
              background: Container(
                color: Colors.red,
              ),
              key: UniqueKey(),
              child: ListTile(
                leading: Icon(Icons.map),
                title: Text(scans[index].valor),
                subtitle: Text("${scans[index].id}"),
                trailing: Icon(Icons.keyboard_arrow_right),
                onTap: (){ 
                  abrirScan ( context,  scans[index]);
                } ,
              ),
            );
          },
        );
      },
    );
  }
}
