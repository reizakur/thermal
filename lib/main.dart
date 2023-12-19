// import 'package:blue_thermal_printer_example/testprint.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/services.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;

  List<BluetoothDevice> _devices = [];
  BluetoothDevice? _device;
    BluetoothDevice? _devicedua;
  bool _connected = false;
  TestPrint testPrint = TestPrint();

  @override
  void initState() {
    super.initState();
    initPlatformState();
    print(_device?.name);
    print('wakwawww 888');
    print(_devicedua?.name);
  }

  Future<void> initPlatformState() async {
    bool? isConnected = await bluetooth.isConnected;
    List<BluetoothDevice> devices = [];
    try {
      devices = await bluetooth.getBondedDevices();
    } on PlatformException {}

    bluetooth.onStateChanged().listen((state) {
      switch (state) {
        case BlueThermalPrinter.CONNECTED:
          setState(() {
            _connected = true;
            print("bluetooth device state: connected");
          });
          break;
        case BlueThermalPrinter.DISCONNECTED:
          setState(() {
            _connected = false;
            print("bluetooth device state: disconnected");
          });
          break;
        case BlueThermalPrinter.DISCONNECT_REQUESTED:
          setState(() {
            _connected = false;
            print("bluetooth device state: disconnect requested");
          });
          break;
        case BlueThermalPrinter.STATE_TURNING_OFF:
          setState(() {
            _connected = false;
            print("bluetooth device state: bluetooth turning off");
          });
          break;
        case BlueThermalPrinter.STATE_OFF:
          setState(() {
            _connected = false;
            print("bluetooth device state: bluetooth off");
          });
          break;
        case BlueThermalPrinter.STATE_ON:
          setState(() {
            _connected = false;
            print("bluetooth device state: bluetooth on");
          });
          break;
        case BlueThermalPrinter.STATE_TURNING_ON:
          setState(() {
            _connected = false;
            print("bluetooth device state: bluetooth turning on");
          });
          break;
        case BlueThermalPrinter.ERROR:
          setState(() {
            _connected = false;
            print("bluetooth device state: error");
          });
          break;
        default:
          print(state);
          break;
      }
    });

    if (!mounted) return;
    setState(() {
      _devices = devices;
    });

    if (isConnected == true) {
      setState(() {
        _connected = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Blue Thermal Printer'),
        ),
        body: Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Device satu:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: 30,
                    ),
                             Expanded(
  child: DropdownButton(
    items: _getDeviceItems(),
    onChanged: (BluetoothDevice? value) {
      setState(() {
        _device = value;
        print('value2244');
        print(value);
        print(_device);
        print(_device?.name); // Add the print statement here
      });
    },
    value: _device,
  ),
)
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Device dua:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Expanded(
  child: DropdownButton(
    items: _getDeviceItems(),
    onChanged: (BluetoothDevice? value) {
      setState(() {
        _devicedua = value;
        print('value2222');
        print(value);
        print(_devicedua);
        print(_devicedua?.name); // Add the print statement here
      });
    },
    value: _devicedua,
  ),
)
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: Colors.brown),
                      onPressed: () {
                        initPlatformState();
                      },
                      child: Text(
                        'Refresh',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: _connected ? Colors.red : Colors.green),
                      onPressed: _connected ? _disconnect : _connect,
                      child: Text(
                        _connected ? 'Disconnect' : 'Connect',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 10.0, right: 10.0, top: 50),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.brown),
                    onPressed: () {
                       final lineCharacter = '-';
  final lineWidth = 48;  // Adjust the width as needed

  // Calculate the number of spaces needed for alignment
  // final text = "SUBTOTAL";
  final spaceCount = 10 - 5;

  // Create the line with additional spaces
  final spaces = ' ' * spaceCount;

String horizontalLine = List.filled(25, lineCharacter).join('');


                  String receipt = 
                  "/align left"
                  
                  " "
                  "**TERIMA KASIH**\n"; 
                testPrint.printCustom(receipt, '\x0A',_devicedua!);
                        print('masuk pak');
                    },
                    child: Text('PRINT TEST',
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<DropdownMenuItem<BluetoothDevice>> _getDeviceItems() {
    List<DropdownMenuItem<BluetoothDevice>> items = [];
    if (_devices.isEmpty) {
      items.add(DropdownMenuItem(
        child: Text('NONE'),
      ));
    } else {
      _devices.forEach((device) {
        items.add(DropdownMenuItem(
          child: Text(device.name ?? ""),
          value: device,
        ));
      });
    }
    return items;
  }

  void _connect() {
    print('ini mau konek');
    print(_device);
    print(_device?.name); 
    print(_device?.address);
        print('7777777');
    print(_devicedua);
    print(_devicedua?.name);
    print(_devicedua?.address);
    if (_device != null) {
      print('device tudak kosong');
      print(_device?.name);
      bluetooth.isConnected.then((isConnected) async {
        print('isConnected cintoy');
        print(isConnected);
if (isConnected == false) {
  print('Trying to connect...');
  bluetooth.connect(_device!).then((connected) {
    setState(() {
      _connected = connected;
    });
    if (_connected) {
      print('Connected successfully to ${_device?.name}');
   
    } else {
      print('Failed to connect to ${_device?.name}');
    }

  }).catchError((error) {
    setState(() {
      _connected = false;
    });
    bluetooth.disconnect().then((disconnected) {
    if (disconnected) {
      print('Disconnected from ${_device?.name}');
    } else {
      print('Failed to disconnect from ${_device?.name}');
    }
  });
    print('Error while connecting: $error ${_device?.name}');
  });
}


        print('cie g bisaa');

      //    if (_devicedua != null) {
      //   print('Next Bluetooth Device:');
      //   print(_devicedua);
      //   print(_devicedua?.name);
      //   print(_devicedua?.address);

      //   if (isConnected == false) {
      //     print('cie bisaa');
      //     bluetooth.connect(_devicedua!).catchError((error) {
      //       setState(() => _connected = false);
      //       print(_connected);
      //       print('error ini kaya nya');
      //        print(error);
      //     });
      //     setState(() => _connected = true);
      //                 print('ga error ini kaya nya');
      //                 print(_connected);
      //   }
      // }
      });
    } else {
      
      print('kosong');
      show('No device selected.');
    }
  }

  void _disconnect() {
    
    print('ini mau gamau konek');
    bluetooth.disconnect();
    setState(() => _connected = false);
  }

  Future show(
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) async {
    await new Future.delayed(new Duration(milliseconds: 100));
    ScaffoldMessenger.of(context).showSnackBar(
      new SnackBar(
        content: new Text(
          message,
          style: new TextStyle(
            color: Colors.white,
          ),
        ),
        duration: duration,
      ),
    );
  }
}


class TestPrint {
 BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
  Future<void> printCustom(String text, String lineBreak, BluetoothDevice _devicedua) async {
  String customData = '$text$lineBreak';
   final leftAlign = '\x1B\x61\x00';
    final centerAlign = '\x1B\x61\x01';
    final rightAlign = '\x1B\x61\x02';

    // Replace alignment tags with control characters
    text = text.replaceAll('/align left', leftAlign);
    text = text.replaceAll('/align center', centerAlign);
    text = text.replaceAll('/align right', rightAlign);
  try { 
    bool? isConnected = await bluetooth.isConnected;
    if (isConnected == true) { 
      print('damn');
      bluetooth.write(text); 
      
print(text);
print('hahahah');
       bluetooth.disconnect().then((disconnected) {
    if (disconnected) {
      print('damn 555');
      print('Disconnected from ${_devicedua?.name}'); 
    
    } else {
      print('damn 333');
      print('Failed to disconnect from ${_devicedua?.name}');
    }
  }); 
    } else { 
      print('Bluetooth device is not connected');
    }
  } catch (error) { 
    print('Error while printing: $error');
  }
}

}
