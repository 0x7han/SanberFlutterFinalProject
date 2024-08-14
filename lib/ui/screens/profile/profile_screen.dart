import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sanber_flutter_final_project/helper/theme_helper.dart';
import 'package:sanber_flutter_final_project/logic/blocs/auth/auth_bloc.dart';
import 'package:sanber_flutter_final_project/repositories/auth_repository.dart';
import 'package:sanber_flutter_final_project/routes/named_router.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late AuthBloc _authBloc;

  late AuthRepository _authRepository;
  late String uid;
  @override
  void initState() {
    super.initState();
    _authBloc = context.read<AuthBloc>();

    _authRepository = AuthRepository();

    final authState = _authBloc.state;
    if (authState is AuthAuthenticated) {
      uid = authState.user.uid;
    }
  }

  TableRow _tableRowBuilder(String header, String data) {
    ThemeHelper themeHelper = ThemeHelper(context);
    return TableRow(decoration: const BoxDecoration(), children: [
      SizedBox(
          height: 30,
          child: Text(
            header,
            style: themeHelper.textTheme.bodyMedium!
                .copyWith(fontWeight: FontWeight.bold),
          )),
      SizedBox(height: 30, child: Text(data)),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    ThemeHelper themeHelper = ThemeHelper(context);
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
          future: _authRepository.getUserInfo(uid),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final Map<String, dynamic> data = snapshot.data!;
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: themeHelper.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(32),
                      ),
                      child: Icon(
                        Icons.person,
                        size: 120,
                        color: themeHelper.colorScheme.primary.withOpacity(0.5),
                      ),
                    ),
                    Text(
                      data['fullname'],
                      style: themeHelper.textTheme.titleLarge,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Container(
                      margin: const EdgeInsets.all(32),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                              width: 2,
                              color: themeHelper.colorScheme.onSurface
                                  .withOpacity(0.1))),
                      child: Table(
                        children: [
                          _tableRowBuilder('Nama Lengkap', data['fullname']),
                          _tableRowBuilder('Nomor HP', data['noHp']),
                          _tableRowBuilder('Email', data['email']),
                          _tableRowBuilder('Password', data['password']),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    FilledButton.tonalIcon(
                        style: const ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll(Colors.red),
                            iconColor: MaterialStatePropertyAll(Colors.white),
                            foregroundColor:
                                MaterialStatePropertyAll(Colors.white)),
                        onPressed: () {
                          _authBloc.add(SignOutRequest());
                          context.goNamed(NamedRouter.loginScreen);
                        },
                        icon: const Icon(Icons.logout),
                        label: const Text('Logout'))
                  ],
                ),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}
