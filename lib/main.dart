import 'package:flutter/material.dart';
import 'package:panther_watch/navigation/navigation_provider.dart';
import 'package:panther_watch/pages/home/home.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NavigationProvider())
      ],
      child: MaterialApp(
        title: 'Panther Watch',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 0, 58, 166)),
          useMaterial3: true,
        ),
        home: MenuLayer(),
      ),
    );
  }
}
