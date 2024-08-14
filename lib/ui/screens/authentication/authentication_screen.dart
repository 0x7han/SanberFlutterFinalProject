import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sanber_flutter_final_project/helper/pop_up_helper.dart';
import 'package:sanber_flutter_final_project/helper/theme_helper.dart';
import 'package:sanber_flutter_final_project/logic/blocs/auth/auth_bloc.dart';
import 'package:sanber_flutter_final_project/routes/named_router.dart';
import 'package:sanber_flutter_final_project/ui/widgets/ink_well_button_widget.dart';
import 'package:sanber_flutter_final_project/ui/widgets/text_form_field_widget.dart';

class AuthenticationScreen extends StatefulWidget {
  final bool isLogin;
  const AuthenticationScreen({super.key, this.isLogin = true});

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  late TextEditingController _namaController;
  late TextEditingController _noHpController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();

    if (!widget.isLogin) {
      _namaController = TextEditingController();
      _noHpController = TextEditingController();
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    if (!widget.isLogin) {
      _namaController.dispose();
      _noHpController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeHelper themeHelper = ThemeHelper(context);
    return Scaffold(
      appBar: AppBar(),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
           if (state is AuthAuthenticated) {
            
            context.goNamed(NamedRouter.cashierScreen);
          } else if (state is AuthError) {

           PopUpHelper.snackbar(context, message: state.message);
          }
        },
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Center(
                    child: Text(
                      'Rei POS',
                      style: themeHelper.textTheme.displayMedium!
                          .copyWith(fontWeight: FontWeight.w100),
                    ),
                  ),
                  const SizedBox(
                    height: 64,
                  ),
                  if (!widget.isLogin)
                    Column(
                      children: [
                        TextFormFieldWidget(
                          textEditingController: _namaController,
                          label: 'Nama',
                          placeholder: 'John Doe',
                          prefixIcon: Icons.person,
                        ),
                        TextFormFieldWidget(
                          textEditingController: _noHpController,
                          label: 'Nomor Handphone',
                          placeholder: '081229182731',
                          prefixIcon: Icons.phone,
                        ),
                      ],
                    ),
                  TextFormFieldWidget(
                    textEditingController: _emailController,
                    label: 'Email',
                    placeholder: 'johndoe@gmail.com',
                    prefixIcon: Icons.email,
                  ),
                  TextFormFieldWidget(
                    obscureText: true,
                    textEditingController: _passwordController,
                    label: 'Password',
                    placeholder: '',
                    prefixIcon: Icons.lock,
                  ),
                  const SizedBox(height: 32),
                  InkWellButtonWidget.primary(
                    label: widget.isLogin ? 'Masuk' : 'Daftar',
                    onTap: () {
                      if (widget.isLogin) {
                        context.read<AuthBloc>().add(SignInRequest(
                              email: _emailController.text,
                              password: _passwordController.text,
                            ));
                      } else {
                        context.read<AuthBloc>().add(SignUpRequest(
                              email: _emailController.text,
                              password: _passwordController.text,
                              fullname: _namaController.text,
                              noHp: _noHpController.text,
                            ));
                      }
                    },
                  ),
                  if (widget.isLogin)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Center(
                        child: Column(
                          children: [
                            const Text('Belum punya akun?'),
                            TextButton(
                              onPressed: () => context.pushNamed(NamedRouter.registerScreen),
                              child: const Text('Daftar'),
                            )
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
