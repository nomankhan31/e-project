import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart'; // 1. Provider package ko import kiya
import 'package:watchhub/services/cart_provider.dart';
import 'firebase_options.dart';
import 'app_routes.dart';

// 2. Apne providers ka folder path check kar ke import karlein
// Agar aapki provider file ka folder path mukhtalif hai to use yahan sahi karlein

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    // 3. App ko MultiProvider ke sath wrap kiya taake CartProvider register ho sake
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: const WatchHubApp(),
    ),
  );
}

class WatchHubApp extends StatelessWidget {
  const WatchHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WatchHub Premium',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF172554)),
      ),
      initialRoute: '/splash',
      routes: AppRoutes.routes,
    );
  }
}
