import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sanber_flutter_final_project/helper/theme_helper.dart';
import 'package:sanber_flutter_final_project/routes/named_router.dart';



class NavigationBarWidget extends StatefulWidget {
  final Widget child;
  const NavigationBarWidget({super.key, required this.child});

  @override
  State<NavigationBarWidget> createState() =>
      _NavigationBarWidgetState();
}

class _NavigationBarWidgetState extends State<NavigationBarWidget> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    ThemeHelper themeHelper = ThemeHelper(context);
    Color selectedIconColor = themeHelper.colorScheme.primary;
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: (value) {
            setState(() {
              _selectedIndex = value;
            });

            String destination = '';
            switch (_selectedIndex) {

              case 0:
                destination = NamedRouter.cashierScreen;
                break;
              case 1:
                destination = NamedRouter.productScreen;
                break;
              case 2:
                destination = NamedRouter.reportScreen;
                break;
              case 3:
                destination = NamedRouter.profileScreen;
                break;
            }
            context.goNamed(destination);
          },
          destinations: [

            NavigationDestination(
                icon: const Icon(Icons.sell_outlined),
                selectedIcon: Icon(Icons.sell, color: selectedIconColor,),
                label: 'Cashier'),


            NavigationDestination(
                icon: const Icon(Icons.inventory_2_outlined),
                selectedIcon: Icon(Icons.inventory_2, color: selectedIconColor,),
                label: 'Product'),


            NavigationDestination(
                icon: const Icon(Icons.note_alt_outlined),
                selectedIcon: Icon(Icons.note_alt, color: selectedIconColor,),
                label: 'Report'),
            NavigationDestination(
                icon: const Icon(Icons.person_outlined),
                selectedIcon: Icon(Icons.person, color: selectedIconColor,),
                label: 'Profile'),
          ]),
    );
  }
}
