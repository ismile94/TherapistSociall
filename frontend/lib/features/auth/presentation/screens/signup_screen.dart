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
import '../../../../shared/widgets/profession_autocomplete.dart';
import '../../../../shared/widgets/city_autocomplete.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _professionController = TextEditingController();
  final _cityController = TextEditingController();
  final _phoneController = TextEditingController();

  final _nameFocusNode = FocusNode();
  final _surnameFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _professionFocusNode = FocusNode();
  final _cityFocusNode = FocusNode();
  final _phoneFocusNode = FocusNode();

  String? _selectedProfession;

  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _professionController.dispose();
    _cityController.dispose();
    _phoneController.dispose();
    _nameFocusNode.dispose();
    _surnameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _professionFocusNode.dispose();
    _cityFocusNode.dispose();
    _phoneFocusNode.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    // Validate profession field
    if (_selectedProfession == null || _selectedProfession!.isEmpty) {
      _professionController.text = '';
    } else {
      _professionController.text = _selectedProfession!;
    }

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final client = ref.read(graphqlClientProvider);

      const signUpMutation = '''
        mutation SignUp(\$input: SignUpInput!) {
          signUp(input: \$input) {
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
          document: gql(signUpMutation),
          variables: {
            'input': {
              'email': _emailController.text.trim(),
              'password': _passwordController.text,
              'name': _nameController.text.trim(),
              'surname': _surnameController.text.trim(),
              'profession': _professionController.text.trim(),
              'city': _cityController.text.trim(),
              'phone': _phoneController.text.trim().isNotEmpty
                  ? _phoneController.text.trim()
                  : null,
            },
          },
        ),
      );

      if (result.hasException) {
        String errorMessage = 'Sign up failed';

        if (mounted) {
          final l10n = AppLocalizations.of(context);
          errorMessage = l10n != null
              ? '${l10n.signUp} ${l10n.error.toLowerCase()}'
              : 'Sign up failed';
        }

        final exception = result.exception;
        if (exception != null) {
          // Check for GraphQL errors
          final graphqlErrors = exception.graphqlErrors;
          if (graphqlErrors.isNotEmpty) {
            errorMessage = graphqlErrors.first.message;
          }
          // Check for network/other errors
          else if (exception.linkException != null) {
            final linkException = exception.linkException;
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

            // Log detailed error for debugging (only in debug mode)
            assert(() {
              debugPrint('LinkException: $linkException');
              return true;
            }());
          }
          // Use exception message as fallback
          else {
            errorMessage = exception.toString();
          }
        }

        // Log full exception for debugging (only in debug mode)
        assert(() {
          debugPrint('SignUp Exception: $exception');
          return true;
        }());
        throw Exception(errorMessage);
      }

      if (result.data != null && result.data!['signUp'] != null) {
        final authData = result.data!['signUp'];
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
              ? '${l10n.signUp} ${l10n.error.toLowerCase()}: No data received'
              : 'Sign up failed: No data received');
        } else {
          throw Exception('Sign up failed: No data received');
        }
      }
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n != null
                ? '${l10n.signUp} ${l10n.error.toLowerCase()}: ${e.toString()}'
                : 'Sign up failed: ${e.toString()}'),
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
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.background,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.backgroundLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.arrow_back_ios_new,
              size: 18,
              color: AppColors.textPrimary,
            ),
          ),
          onPressed: () => context.go('/login'),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: LanguageSelector(),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 10),
                // Title with better styling
                Text(
                  l10n.createAccount,
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                        letterSpacing: -0.5,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  l10n.joinTherapistSocial,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 16,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                // Name and Surname row
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _nameController,
                        focusNode: _nameFocusNode,
                        textInputAction: TextInputAction.next,
                        textCapitalization: TextCapitalization.words,
                        onFieldSubmitted: (_) {
                          _surnameFocusNode.requestFocus();
                        },
                        decoration: InputDecoration(
                          labelText: l10n.name,
                          hintText: l10n.firstName,
                          prefixIcon: const Icon(Icons.person_outline),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return l10n.required;
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _surnameController,
                        focusNode: _surnameFocusNode,
                        textInputAction: TextInputAction.next,
                        textCapitalization: TextCapitalization.words,
                        onFieldSubmitted: (_) {
                          _emailFocusNode.requestFocus();
                        },
                        decoration: InputDecoration(
                          labelText: l10n.surname,
                          hintText: l10n.lastName,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return l10n.required;
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Email
                TextFormField(
                  controller: _emailController,
                  focusNode: _emailFocusNode,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    _passwordFocusNode.requestFocus();
                  },
                  decoration: InputDecoration(
                    labelText: '${l10n.email} *',
                    hintText: l10n.enterYourEmail,
                    prefixIcon: const Icon(Icons.email_outlined),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return l10n.emailIsRequired;
                    }
                    if (!value.contains('@')) {
                      return l10n.pleaseEnterAValidEmail;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                // Password
                TextFormField(
                  controller: _passwordController,
                  focusNode: _passwordFocusNode,
                  obscureText: _obscurePassword,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    _professionFocusNode.requestFocus();
                  },
                  decoration: InputDecoration(
                    labelText: '${l10n.password} *',
                    hintText: l10n.atLeast8Characters,
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
                      return l10n.passwordIsRequired;
                    }
                    if (value.length < 8) {
                      return l10n.passwordTooShort;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                // Profession - Autocomplete
                ProfessionAutocomplete(
                  value: _selectedProfession,
                  focusNode: _professionFocusNode,
                  nextFocusNode: _cityFocusNode,
                  textInputAction: TextInputAction.next,
                  onChanged: (value) {
                    setState(() {
                      _selectedProfession = value;
                      _professionController.text = value ?? '';
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return l10n.requiredField(l10n.profession);
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                // City - Autocomplete with Mapbox (only Mapbox suggestions allowed)
                CityAutocomplete(
                  value: _cityController.text.isNotEmpty
                      ? _cityController.text
                      : null,
                  focusNode: _cityFocusNode,
                  nextFocusNode: _phoneFocusNode,
                  textInputAction: TextInputAction.next,
                  onChanged: (value) {
                    setState(() {
                      _cityController.text = value ?? '';
                    });
                  },
                ),
                const SizedBox(height: 20),
                // Phone (optional)
                TextFormField(
                  controller: _phoneController,
                  focusNode: _phoneFocusNode,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) {
                    _handleSignUp();
                  },
                  decoration: InputDecoration(
                    labelText: l10n.phone,
                    hintText: l10n.yourPhoneNumber,
                    prefixIcon: const Icon(Icons.phone_outlined),
                  ),
                ),
                const SizedBox(height: 36),
                // Modern Sign up button with gradient
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
                    onPressed: _isLoading ? null : _handleSignUp,
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
                            l10n.createAccount,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 16),
                // Login link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      l10n.alreadyHaveAccount,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                    TextButton(
                      onPressed: () => context.go('/login'),
                      child: Text(l10n.signIn),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
