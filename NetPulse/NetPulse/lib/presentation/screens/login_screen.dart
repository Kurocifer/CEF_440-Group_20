import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:netpulse/presentation/widgets/action_button.dart';
import '../blocs/auth_bloc.dart';
import '../blocs/auth_event.dart';
import '../blocs/auth_state.dart';
import 'create_account_screen.dart';
import 'package:netpulse/main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: BlocListener<AuthBloc, NetpulseAuthState>(
        listener: (context, state) {
          if (state is NetpulseAuthSuccess) {
            Get.offAllNamed('/home');
          } else if (state is NetpulseAuthFailure) {
            String errorMessage;
            if (state.message.toLowerCase().contains('invalid') ||
                state.message.toLowerCase().contains('credential')) {
              errorMessage = 'Invalid email or password. Please try again.';
            } else if (state.message.toLowerCase().contains('network') ||
                state.message.toLowerCase().contains('connection')) {
              errorMessage =
                  'Unable to connect. Please check your internet connection and try again.';
            } else if (state.message.toLowerCase().contains('timeout')) {
              errorMessage = 'Connection timed out. Please try again later.';
            } else {
              errorMessage =
                  'An unexpected error occurred. Please try again later.';
            }
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: colorScheme.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  title: Center(
                    child: Text(
                      'Login Failed',
                      style: GoogleFonts.poppins(
                        color: colorScheme.error,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  content: Text(
                    errorMessage,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(
                        'OK',
                        style: GoogleFonts.poppins(
                          color: colorScheme.secondary,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                  actionsAlignment: MainAxisAlignment.center,
                  elevation: 10,
                );
              },
            );
          }
        },
        child: Stack(
          children: [
            Container(
              // decoration: BoxDecoration(
              //   gradient: LinearGradient(
              //     begin: Alignment.topLeft,
              //     end: Alignment.bottomRight,
              //     colors: isDarkMode
              //         ? [colorScheme.background, primaryColor.withOpacity(0.7)]
              //         : [
              //             colorScheme.background,
              //             secondaryColor.withOpacity(0.3),
              //           ],
              //   ),
              // ),
            ),
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 48.0,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Image.asset(
                        'assets/images/netpulse_logo.png',
                        height: 100,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'NetPulse',
                        style: GoogleFonts.poppins(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.secondary,

                          // color: colorScheme.onPrimary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Welcome back!',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          color: colorScheme.secondary,

                          // color: colorScheme.onPrimary.withOpacity(0.8),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        'Time to rate the Network',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          color: colorScheme.secondary,

                          // color: colorScheme.onPrimary.withOpacity(0.8),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 48),

                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(
                            Icons.email_rounded,
                            color: colorScheme.secondary,
                          ),
                          hintText: 'Enter your email',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!value.contains('@')) {
                            return 'Enter a valid email address';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: Icon(
                            Icons.lock_rounded,
                            color: colorScheme.secondary,
                          ),
                          hintText: 'Enter your password',
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off_rounded
                                  : Icons.visibility_rounded,
                              color: colorScheme.secondary,
                            ),
                            onPressed: () => setState(
                              () => _obscurePassword = !_obscurePassword,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Forgot Password feature coming soon',
                                ),
                              ),
                            );
                          },
                          child: Text(
                            'Forgot password?',
                            style: GoogleFonts.poppins(
                              color: colorScheme.secondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      // ElevatedButton(
                      //   onPressed: () {
                      //     if (_formKey.currentState!.validate()) {
                      //       context.read<AuthBloc>().add(AuthLoginRequested(
                      //             _emailController.text,
                      //             _passwordController.text,
                      //           ));
                      //     }
                      //   },
                      //   style: ElevatedButton.styleFrom(
                      //     minimumSize: const Size(double.infinity, 50),
                      //   ),
                      //   child: Text(
                      //     'Log In',
                      //     style: GoogleFonts.poppins(
                      //       fontSize: 18,
                      //       fontWeight: FontWeight.bold,
                      //     ),
                      //   ),
                      // ),
                      BuildActionButton(
                        context: context,
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            context.read<AuthBloc>().add(
                              AuthLoginRequested(
                                _emailController.text,
                                _passwordController.text,
                              ),
                            );
                          }
                        },
                        label: 'Log In',
                        buttonGradient: LinearGradient(
                          colors: [primaryColor, secondaryColor],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        textColor: colorScheme.onPrimary,
                      ),
                      const SizedBox(height: 20),
                      TextButton(
                        onPressed: () =>
                            Get.to(() => const CreateAccountScreen()),
                        child: Text(
                          "Don't have an account? Sign up",
                          style: GoogleFonts.poppins(
                            color: colorScheme.secondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget _buildActionButton({
  //   required BuildContext context,
  //   required String label,
  //   required VoidCallback? onPressed,
  //   LinearGradient? buttonGradient,
  //   required Color textColor,
  // }) {
  //   return Container(
  //     decoration: BoxDecoration(
  //       gradient: buttonGradient,
  //       borderRadius: BorderRadius.circular(12),
  //     ),
  //     child: ElevatedButton(
  //       onPressed: onPressed,
  //       style: ElevatedButton.styleFrom(
  //         backgroundColor: Colors.transparent,
  //         foregroundColor: textColor,
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(12),
  //         ),
  //         padding: EdgeInsets.zero,
  //         elevation: 0,
  //         shadowColor: Colors.transparent,
  //       ),
  //       child: Padding(
  //         padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
  //         child: Row(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             const SizedBox(width: 8),
  //             Expanded(
  //               child: Text(
  //                 label,
  //                 textAlign: TextAlign.center,
  //                 overflow: TextOverflow.ellipsis,
  //                 maxLines: 1,
  //                 style: GoogleFonts.poppins(
  //                   fontSize: 18,
  //                   fontWeight: FontWeight.bold,
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
