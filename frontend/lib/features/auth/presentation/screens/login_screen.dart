import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../core/themes/colors.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/network/graphql_client.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../../../shared/widgets/language_selector.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final client = ref.read(graphqlClientProvider);

      const loginMutation = '''
        mutation Login(\$input: LoginInput!) {
          login(input: \$input) {
            user {
              id
              email
              role
            }
            accessToken
            refreshToken
            expiresIn
          }
        }
      ''';

      final result = await client.mutate(
        MutationOptions(
          document: gql(loginMutation),
          variables: {
            'input': {
              'email': _emailController.text.trim(),
              'password': _passwordController.text,
            },
          },
        ),
      );

      if (result.hasException) {
        String errorMessage = 'Login failed';

        final exception = result.exception;
        if (exception != null) {
          final graphqlErrors = exception.graphqlErrors;
          if (graphqlErrors.isNotEmpty) {
            errorMessage = graphqlErrors.first.message;
          } else if (exception.linkException != null) {
            if (mounted) {
              final l10n = AppLocalizations.of(context);
              if (l10n != null) {
                errorMessage = '${l10n.connectionError}\n'
                    '${l10n.checkInternetConnection}\n'
                    '${l10n.checkBackendServer(AppConfig.graphqlEndpoint)}\n'
                    '${l10n.checkCorsSettings}';
              } else {
                errorMessage =
                    'Connection error: Unable to connect to server. Please check:\n'
                    '1. Your internet connection\n'
                    '2. Backend server is running at ${AppConfig.graphqlEndpoint}\n'
                    '3. CORS settings allow requests from this app';
              }
            } else {
              errorMessage =
                  'Connection error: Unable to connect to server. Please check:\n'
                  '1. Your internet connection\n'
                  '2. Backend server is running at ${AppConfig.graphqlEndpoint}\n'
                  '3. CORS settings allow requests from this app';
            }
          } else {
            errorMessage = exception.toString();
          }
        }

        throw Exception(errorMessage);
      }

      if (result.data != null && result.data!['login'] != null) {
        final authData = result.data!['login'];
        final accessToken = authData['accessToken'] as String?;
        final refreshToken = authData['refreshToken'] as String?;
        final user = authData['user'] as Map<String, dynamic>?;
        final userId = user?['id'] as String?;

        // Store tokens in secure storage
        if (accessToken != null) {
          await SecureStorageService.saveAccessToken(accessToken);
        }
        if (refreshToken != null) {
          await SecureStorageService.saveRefreshToken(refreshToken);
        }
        if (userId != null) {
          await SecureStorageService.saveUserId(userId);
        }

        // Navigate to home screen
        if (mounted) {
          context.go('/');
        }
      } else {
        if (mounted) {
          final l10n = AppLocalizations.of(context);
          throw Exception(l10n != null
              ? '${l10n.login} ${l10n.error.toLowerCase()}: No data received'
              : 'Login failed: No data received');
        } else {
          throw Exception('Login failed: No data received');
        }
      }
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n != null
                ? '${l10n.login} ${l10n.error.toLowerCase()}: ${e.toString()}'
                : 'Login failed: ${e.toString()}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Language selector
                const Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    LanguageSelector(),
                  ],
                ),
                const SizedBox(height: 20),
                // Modern Logo with gradient
                Center(
                  child: Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.gradientStart,
                          AppColors.gradientEnd,
                        ],
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryBlue.withValues(alpha: 0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.people_outline,
                      size: 65,
                      color: AppColors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                // Welcome text with better styling
                Text(
                  l10n.welcomeBack,
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                        letterSpacing: -0.5,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  l10n.signInToContinue,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 16,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),
                // Email field
                TextFormField(
                  controller: _emailController,
                  focusNode: _emailFocusNode,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    _passwordFocusNode.requestFocus();
                  },
                  decoration: InputDecoration(
                    labelText: l10n.email,
                    hintText: l10n.enterYourEmail,
                    prefixIcon: const Icon(Icons.email_outlined),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return l10n.pleaseEnterYourEmail;
                    }
                    if (!value.contains('@')) {
                      return l10n.pleaseEnterAValidEmail;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                // Password field
                TextFormField(
                  controller: _passwordController,
                  focusNode: _passwordFocusNode,
                  obscureText: _obscurePassword,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) {
                    if (_emailController.text.isEmpty) {
                      _emailFocusNode.requestFocus();
                    } else {
                      _handleLogin();
                    }
                  },
                  decoration: InputDecoration(
                    labelText: l10n.password,
                    hintText: l10n.enterYourPassword,
                    prefixIcon: const Icon(Icons.lock_outlined),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return l10n.pleaseEnterYourPassword;
                    }
                    if (value.length < 8) {
                      return l10n.passwordTooShort;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                // Forgot password
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // Forgot password functionality will be implemented later
                    },
                    child: Text(l10n.forgotPassword),
                  ),
                ),
                const SizedBox(height: 32),
                // Modern Login button with gradient
                Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        AppColors.gradientStart,
                        AppColors.gradientEnd,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryBlue.withValues(alpha: 0.4),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.white,
                              ),
                            ),
                          )
                        : Text(
                            l10n.signIn,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 28),
                // Modern Divider
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 1,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              AppColors.divider,
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        l10n.or,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 1,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.divider,
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                // Modern Sign up button
                OutlinedButton(
                  onPressed: () {
                    context.go('/signup');
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    side: const BorderSide(
                      color: AppColors.primaryBlue,
                      width: 2,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    l10n.createAccount,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
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
