import 'package:flutter/material.dart';
import 'package:pruebasmodbus/servicio_modbus.dart';
import 'package:logging/logging.dart';

void main() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((LogRecord rec) {
    print('${rec.level.name}: ${rec.time} [${rec.loggerName}]: ${rec.message}');
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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

  dynamic valorLeido;
  dynamic inputRegisterLeido;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              ServicioModbus.estadoConexion ? "CONECTADO A PLC EN 192.168.1.20" : "DESCONECTADO",
              style: Theme.of(context).textTheme.headline5,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            const SizedBox(height: 20),
            valorLeido != null ? Text("Coil Leído: " + (valorLeido?.toString() ?? ""), style: Theme.of(context).textTheme.headline5,
              textAlign: TextAlign.center,) : Container(),
            inputRegisterLeido != null ? Text("InputRegister Leído: " + (inputRegisterLeido?.toString() ?? ""), style: Theme.of(context).textTheme.headline5,
              textAlign: TextAlign.center) : Container(),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                  // await ServicioModbus.configurar("192.168.1.20", 502);
                  await ServicioModbus.configurar("10.0.2.2", 502);
                  setState(() {
                    
                  });
              }, 
              child: const Text("CONECTAR"),
            ),
            ElevatedButton(
              onPressed: () async {
                  await ServicioModbus.desconectar();
                  setState(() {
                    
                  });
              }, 
              child: const Text("DESCONECTAR"),
            ),
             ElevatedButton(
              onPressed: () async {
                  var coil = await ServicioModbus.leerCoil(3);
                  valorLeido = coil[0];
                  setState((){});
              }, 
              child: const Text("LEER COIL"),
            ),
            ElevatedButton(
              onPressed: () async {
                  var inputR = await ServicioModbus.leerInputRegister(3);
                  inputRegisterLeido = inputR?[0];
                  setState((){});
              }, 
              child: const Text("LEER INPUTREGISTER"),
            ),
            ElevatedButton(
              onPressed: () async {
                  var inputR = await ServicioModbus.leerHoldingR(0);
                  inputRegisterLeido = inputR?[0];
                  setState((){});
              }, 
              child: const Text("LEER INPUTREGISTER"),
            ),
          ],
        ),
      ),
    );
  }
}
