import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sanber_flutter_final_project/model/product.dart';
import 'package:sanber_flutter_final_project/routes/named_router.dart';
import 'package:sanber_flutter_final_project/ui/screens/authentication/authentication_screen.dart';
import 'package:sanber_flutter_final_project/ui/screens/cart/cart_screen.dart';
import 'package:sanber_flutter_final_project/ui/screens/report/report_screen.dart';
import 'package:sanber_flutter_final_project/ui/screens/cashier/cashier_screen.dart';
import 'package:sanber_flutter_final_project/ui/screens/payment/payment_action_screen.dart';
import 'package:sanber_flutter_final_project/ui/screens/payment/payment_screen.dart';
import 'package:sanber_flutter_final_project/ui/screens/payment/payment_status_screen.dart';
import 'package:sanber_flutter_final_project/ui/screens/product/product_action_screen.dart';
import 'package:sanber_flutter_final_project/ui/screens/product/product_screen.dart';
import 'package:sanber_flutter_final_project/ui/screens/profile/profile_screen.dart';
import 'package:sanber_flutter_final_project/ui/widgets/navigation_bar_widget.dart';

class ConfigRouter {
  static final ConfigRouter shared = ConfigRouter._internal();

  factory ConfigRouter() {
    return shared;
  }

  ConfigRouter._internal();

  static final _root = GlobalKey<NavigatorState>();
  static final _shell = GlobalKey<NavigatorState>();

  final router = GoRouter(
    initialLocation: '/',
    navigatorKey: _root,
    routes: [
      GoRoute(
        path: '/',
        redirect: (context, state) => NamedRouter.loginScreen,
      ),

      GoRoute(
        path: NamedRouter.loginScreen,
        name: NamedRouter.loginScreen,
        builder: (context, state) => const AuthenticationScreen(),
      ),
      GoRoute(
        path: NamedRouter.registerScreen,
        name: NamedRouter.registerScreen,
        builder: (context, state) {
          return const AuthenticationScreen(
            isLogin: false,
          );
        },
      ),
      ShellRoute(
        parentNavigatorKey: _root,
        navigatorKey: _shell,
        builder: (context, state, child) {
          return NavigationBarWidget(child: child);
        },
        routes: [
          GoRoute(
            path: NamedRouter.cashierScreen,
            name: NamedRouter.cashierScreen,
            builder: (context, state) => const CashierScreen(),
            routes: [
              GoRoute(
                parentNavigatorKey: _root,
                path: NamedRouter.cartScreen,
                name: NamedRouter.cartScreen,
                builder: (context, state) {
                  return const CartScren();
                },
                routes: [
                  GoRoute(
                    parentNavigatorKey: _root,
                    path: NamedRouter.paymentScreen,
                    name: NamedRouter.paymentScreen,
                    builder: (context, state) {
                      return const PaymentScreen();
                    },
                    routes: [
                      GoRoute(
                        parentNavigatorKey: _root,
                        path: NamedRouter.paymentDetailScreen,
                        name: NamedRouter.paymentDetailScreen,
                        builder: (context, state) {
                          final Map<String, dynamic> data =
                              state.extra as Map<String, dynamic>;
                          return PaymentActionScreen(
                            data: data,
                          );
                        },
                      ),
                      GoRoute(
                        parentNavigatorKey: _root,
                        path: NamedRouter.paymentStatusScreen,
                        name: NamedRouter.paymentStatusScreen,
                        builder: (context, state) {
                          final Map<String, dynamic> data = state.extra as Map<String, dynamic>;

                          return PaymentStatusScreen(
                            cashier: data['cashier'],
                            isFromPayment: data['isFromPayment'],
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          GoRoute(
            path: NamedRouter.productScreen,
            name: NamedRouter.productScreen,
            builder: (context, state) => const ProductScreen(),
            routes: [
              GoRoute(
                parentNavigatorKey: _root,
                path: NamedRouter.productAddScreen,
                name: NamedRouter.productAddScreen,
                builder: (context, state) => const ProductActionScreen(),
              ),
              GoRoute(
                parentNavigatorKey: _root,
                path: NamedRouter.productEditScreen,
                name: NamedRouter.productEditScreen,
                builder: (context, state) {
                  final Product product = state.extra as Product;
                  return ProductActionScreen(
                    product: product,
                  );
                },
              ),
            ],
          ),
          GoRoute(
            path: NamedRouter.reportScreen,
            name: NamedRouter.reportScreen,
            builder: (context, state) => const ReportScreen(),
          ),
          GoRoute(
            path: NamedRouter.profileScreen,
            name: NamedRouter.profileScreen,
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),
    ],
  );
}
