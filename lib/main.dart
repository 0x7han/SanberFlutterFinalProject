import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sanber_flutter_final_project/firebase_options.dart';
import 'package:sanber_flutter_final_project/helper/local_notification_helper.dart';
import 'package:sanber_flutter_final_project/logic/blocs/auth/auth_bloc.dart';
import 'package:sanber_flutter_final_project/logic/blocs/cart/cart_bloc.dart';
import 'package:sanber_flutter_final_project/logic/blocs/cashier/cashier_bloc.dart';
import 'package:sanber_flutter_final_project/logic/blocs/product/product_bloc.dart';
import 'package:sanber_flutter_final_project/routes/config_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalNotificationHelper().init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<AuthBloc>(
        create: (_) => AuthBloc(),
      ),
      BlocProvider<CartBloc>(
        create: (_) => CartBloc(),
      ),
      BlocProvider<CashierBloc>(
        create: (_) => CashierBloc(),
      ),
      BlocProvider<ProductBloc>(
        create: (_) => ProductBloc(),
      ),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Final Project - Raihan Rabbani',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: ConfigRouter.shared.router,
    );
  }
}
