import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';
import 'package:test_task/core/services/remote_config_service.dart';
import 'package:flutter/foundation.dart'; // for @pragma

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Ensure Firebase is initialized
  await FirebaseRemoteConfigService().initialize();

  await HomeWidget.registerInteractivityCallback(backgroundCallback);

  runApp(const MyApp());
}

@pragma('vm:entry-point')
Future<void> backgroundCallback(Uri? uri) async {
  if (uri != null) {
    if (uri.host == 'increment') {
      print('Increment button pressed from widget inside Home class!');
      log("Increment button pressed");

      await _increment();

      // final currentCount =
      //     await HomeWidget.getWidgetData<String>('_name') ?? '0';
      // int counter = int.tryParse(currentCount) ?? 0;
      // counter++;

      // await HomeWidget.saveWidgetData('_name', counter.toString());
      // await HomeWidget.updateWidget(
      //   name: 'HomeScreenWidgetProvider',
      //   androidName: 'HomeScreenWidgetProvider',
      //   iOSName: 'HomeScreenWidgetProvider',
      // );
    }
  } else {
    log("uri null");
  }
}

/// Gets the currently stored Value
Future<String> get _value async {
  final value =
      await HomeWidget.getWidgetData<String>('_name', defaultValue: '0') ?? "0";

  //getWidgetData<String>('_name') ?? '0'
  return value;
}

/// Stores value in the Widget Configuration
Future<void> _sendAndUpdate([int? value]) async {
  var stringval = value.toString();
  await HomeWidget.saveWidgetData('_name', stringval);
  await HomeWidget.updateWidget(
    name: 'HomeScreenWidgetProvider',
    androidName: 'HomeScreenWidgetProvider',
    iOSName: 'HomeScreenWidgetProvider',
  );
}

Future<int> _increment() async {
  final stringval = await _value;
  final oldValue = int.parse(stringval);

  final newValue = oldValue + 1;
  log("val is $newValue");
  await _sendAndUpdate(newValue);
  return newValue;
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: MyHomePage(title: "title"),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  // int _counter = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(
      this,
    ); //to listen to app lifecycle changes by implementing the WidgetsBindingObserver interface.
    //_loadCounter();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setState(() {});
    }
  }

  Future<void> _incrementCounter() async {
    await _increment();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),

            FutureBuilder<String>(
              future: _value,
              builder:
                  (_, snapshot) => Text(
                    (snapshot.data ?? "0"),
                    //.toString(),
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

















/*  FirebaseMessaging.instance.getInitialMessage().then((message) {
    if (message != null) {
      _handleNotificationTap(message);
    }
  });*/



/*


// إعداد Intent لبث الضغط على الزر incrementButton
       //     val incrementIntent = Intent("es.antonborri.home_widget.action.BACKGROUND").apply {
         //       setPackage(context.packageName)  // لضمان استلام البث فقط داخل التطبيق
                putExtra("uri", "myApp://increment")
         //   }

         //   val incrementPendingIntent = PendingIntent.getBroadcast(
         //       context,
          //      0,
           //     incrementIntent,
             //   PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
          //  )

          //  views.setOnClickPendingIntent(R.id.incrementButton, incrementPendingIntent)



  */