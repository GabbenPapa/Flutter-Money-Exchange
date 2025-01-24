import 'dart:async';
import 'package:flutter/material.dart';

import 'currancy_pair_model.dart';
import 'remote_service.dart';
import 'user_controller.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 1210, 50, 240)),
        useMaterial3: true,
      ),
      home: const CurrencyExchangeScreen(title: 'Currency Exchange'),
    );
  }
}

class CurrencyExchangeScreen extends StatefulWidget {
  const CurrencyExchangeScreen({super.key, required this.title});

  final String title;

  @override
  State<CurrencyExchangeScreen> createState() => _CurrencyExchangeScreenState();
}

class _CurrencyExchangeScreenState extends State<CurrencyExchangeScreen> {
  @override
  void initState() {
    var remoteService = RemoteService();
    var userController = UserController(
      remoteService,
      _streamController.stream,
      _setCurrancyList,
      _onErrorMessage,
    );
    userController.startUserLoop();
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    _streamController.close();
    super.dispose();
  }

  final _textController = TextEditingController();
  final _streamController = StreamController<String>.broadcast();

  void _onUserInput() {
    _streamController.add(_textController.text);
  }

  List<CurrancyPairModel> _currancyList = [];

  void _setCurrancyList(List<CurrancyPairModel> list) {
    setState(() {
      _currancyList = list;
    });
  }

  void _onErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _textController,
                        decoration: const InputDecoration(hintText: 'Amount'),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _onUserInput,
                      child: const Text('Convert'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ..._currancyList.map(
                  (e) => ListTile(
                    title: Text('${e.baseCurrency}-${e.targetCurrency}'),
                    subtitle: Text('${e.conversionRate}'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
