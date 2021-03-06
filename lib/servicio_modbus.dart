
import 'dart:typed_data';

import 'package:pruebasmodbus/modbus_dart/lib/modbus.dart';

// import 'package:modbus/modbus.dart';

class ServicioModbus {

  static ModbusClient? client;
  static bool statusConnection = false;
  late ModbusConnector connector;
  static Future<bool> configurar(String ip, int port) async {
    client = createTcpClient(ip,
      port: port,
      mode: ModbusMode.rtu,
      timeout: const Duration(seconds: 2),
    );
    try {
      await client!.connect();
      statusConnection = true;
    } catch(e) {
      statusConnection = false;
    }
    return statusConnection;
  }
  
  static Future<List<bool?>> leerCoil(int address) async {
    try {
     var coil = await client!.readCoils(0x0002, 1);
     return coil;
    }catch(e) {
      return [];
    }

  }

  static Future<Uint16List?> leerInputRegister(int address) async {
    try {
      var ir = await client!.readInputRegisters(0x0001, 1);
      return ir;
    } catch(e) {
      return null;
    }
  }

    static Future<Uint16List?> leerHoldingR(int address) async {
    try {
      var ir = await client!.readHoldingRegisters(0x0000, 1);
      return ir;
    } catch(e) {
      return null;
    }
  }

  static desconectar() async {
    try {
      await client!.close();
    } catch(e) {

    } finally {
      statusConnection = false;
    }
  }

}