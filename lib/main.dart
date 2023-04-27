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

  dynamic valueRead;
  dynamic registerRead;

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
              ServicioModbus.statusConnection ? "CONNECTED TO PLC: 192.168.1.5" : "DISCONNECTED",
              style: Theme.of(context).textTheme.headline5,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            const SizedBox(height: 20),
            valueRead != null ? Text("Coil read: " + (valueRead?.toString() ?? ""), style: Theme.of(context).textTheme.headline5,
              textAlign: TextAlign.center,) : Container(),
            registerRead != null ? Text("InputRegister read: " + (registerRead?.toString() ?? ""), style: Theme.of(context).textTheme.headline5,
              textAlign: TextAlign.center) : Container(),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                  // await ServicioModbus.configurar("192.168.1.20", 502);
                  await ServicioModbus.configurar("10.0.2.2", 502);
                  setState(() {
                    
                  });
              }, 
              child: const Text("CONNECT"),
            ),
            ElevatedButton(
              onPressed: () async {
                  await ServicioModbus.desconectar();
                  setState(() {
                    
                  });
              }, 
              child: const Text("DISCONNECT"),
            ),
             ElevatedButton(
              onPressed: () async {
                  var coil = await ServicioModbus.leerCoil(3);
                  setState((){});
                  if(coil.isEmpty) return;
                  valueRead = coil[0];
                  setState((){});
              }, 
              child: const Text("READ COIL"),
            ),
            ElevatedButton(
              onPressed: () async {
                  var inputR = await ServicioModbus.leerInputRegister(3);
                  registerRead = (inputR?.isEmpty ?? true) ? 0 : inputR?[0] ?? 0;
                  setState((){});
              }, 
              child: const Text("READ INPUTREGISTER"),
            ),
            ElevatedButton(
              onPressed: () async {
                  var inputR = await ServicioModbus.readHoldingR(0);
                  registerRead = (inputR?.isEmpty ?? true) ? 0 : inputR?[0] ?? 0;
                  setState((){});
              }, 
              child: const Text("READ HOLDINGREGISTER"),
            ),
          ],
        ),
      ),
    );
  }
}
