import 'package:agrich/driverhome.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:agrich/nav.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

import 'package:cloud_firestore/cloud_firestore.dart';


class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLogin = true;
  bool isLoading = false;
  String errorMessage = '';
  bool showPassword = false;
  bool showConfirmPassword = false;

  String selectedRole = 'farmer';

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();

  void _toggleMode(bool login) {
    setState(() {
      isLogin = login;
      errorMessage = '';
    });
  }

  String _mapFirebaseError(String code, [String? fallbackMessage]) {
    switch (code) {
      case 'invalid-email':
        return 'That email address looks invalid.';
      case 'user-disabled':
        return 'This account has been disabled. Contact support if you think this is an error.';
      case 'user-not-found':
        return 'No account found with that email.';
      case 'wrong-password':
        return 'Incorrect password. Try again or reset your password.';
      case 'email-already-in-use':
        return 'That email is already registered. Try signing in or use a different email.';
      case 'weak-password':
        return 'Password is too weak. Use at least 6 characters.';
      case 'operation-not-allowed':
        return 'This sign-in method is not enabled in Firebase.';
      case 'network-request-failed':
        return 'Network error. Check your connection and try again.';
      case 'too-many-requests':
        return 'Too many attempts. Try again later.';
      default:
        return fallbackMessage ?? 'Something went wrong. Please try again.';
    }
  }

  Future<void> _routeUserByRole() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final usersRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
    final snap = await usersRef.get();

    if (!snap.exists || snap.data() == null || snap.data()!['role'] == null) {
      String? chosenRole = await showDialog<String>(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
            title: const Text("Choose account type", style: TextStyle(fontSize: 16),),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: const Text("Farmer"),
                  onTap: () => Navigator.pop(ctx, "farmer"),
                ),
                ListTile(
                  title: const Text("Pickup Driver"),
                  onTap: () => Navigator.pop(ctx, "driver"),
                ),
              ],
            ),
          );
        },
      );

      if (chosenRole == null) {
        await FirebaseAuth.instance.signOut();
        setState(() => errorMessage = 'Role selection required to continue.');
        return;
      }

      await usersRef.set({
        'username': user.displayName ?? '',
        'email': user.email ?? '',
        'role': chosenRole,
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      if (!mounted) return;
      if (chosenRole == 'driver') {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const DriverHomePage()));
      } else {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainNavigationPage()));
      }

      return;
    }

    final role = (snap.data()!['role'] as String).toLowerCase();
    if (!mounted) return;
    if (role == 'driver') {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const DriverHomePage()));
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainNavigationPage()));
    }
  }

  Future<void> _handleAuth() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();
    final username = usernameController.text.trim();

    if (email.isEmpty) {
      setState(() {
        isLoading = false;
        errorMessage = 'Please enter your email address.';
      });
      return;
    }

    final emailRegex = RegExp(r"^[^\s@]+@[^\s@]+\.[^\s@]+$");
    if (!emailRegex.hasMatch(email)) {
      setState(() {
        isLoading = false;
        errorMessage = 'Please enter a valid email address.';
      });
      return;
    }

    if (password.isEmpty) {
      setState(() {
        isLoading = false;
        errorMessage = 'Please enter your password.';
      });
      return;
    }

    if (password.length < 6) {
      setState(() {
        isLoading = false;
        errorMessage = 'Password must be at least 6 characters.';
      });
      return;
    }

    if (!isLogin) {
      if (username.isEmpty) {
        setState(() {
          isLoading = false;
          errorMessage = 'Please enter a username.';
        });
        return;
      }

      if (confirmPassword.isEmpty) {
        setState(() {
          isLoading = false;
          errorMessage = 'Please confirm your password.';
        });
        return;
      }

      if (password != confirmPassword) {
        setState(() {
          isLoading = false;
          errorMessage = 'Passwords do not match.';
        });
        return;
      }
    }

    try {
      UserCredential userCredential;
      if (isLogin) {
        userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);

        await _routeUserByRole();
      } else {
        userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
        await userCredential.user!.updateDisplayName(username);
        await userCredential.user!.reload();

        await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
          'username': username,
          'email': email,
          'role': selectedRole, 
          'createdAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));

        if (context.mounted) {
          if (selectedRole == 'driver') {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const DriverHomePage()));
          } else {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainNavigationPage()));
          }
        }
      }
    } on FirebaseAuthException catch (e) {
      final friendly = _mapFirebaseError(e.code, e.message);
      setState(() => errorMessage = friendly);
    } catch (e) {
      setState(() => errorMessage = 'An unexpected error occurred. Please try again.');
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      if (kIsWeb) {
        GoogleAuthProvider googleProvider = GoogleAuthProvider();
        await FirebaseAuth.instance.signInWithPopup(googleProvider);
      } else {
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
        if (googleUser == null) {
          setState(() => isLoading = false);
          return;
        }
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        await FirebaseAuth.instance.signInWithCredential(credential);
      }

      
      await _routeUserByRole();
    } on FirebaseAuthException catch (e) {
      setState(() => errorMessage = _mapFirebaseError(e.code, e.message));
    } catch (e) {
      setState(() => errorMessage = 'Google sign-in failed. Please try again.');
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _signInWithFacebook() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      if (kIsWeb) {
        final facebookProvider = FacebookAuthProvider();
        await FirebaseAuth.instance.signInWithPopup(facebookProvider);
      } else {
        final LoginResult result = await FacebookAuth.instance.login(permissions: ['email', 'public_profile']);

        if (result.status == LoginStatus.success) {
          final accessToken = result.accessToken;
          final credential = FacebookAuthProvider.credential(accessToken!.token);
          await FirebaseAuth.instance.signInWithCredential(credential);
        } else {
          setState(() => errorMessage = 'Facebook sign-in failed: ${result.message}');
          return;
        }
      }

      await _routeUserByRole();
    } on FirebaseAuthException catch (e) {
      setState(() => errorMessage = _mapFirebaseError(e.code, e.message));
    } catch (e) {
      setState(() => errorMessage = 'Facebook sign-in failed. Please try again.');
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView( 
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.asset('assets/logo.png', height: 129, width: 129),
                ),
                const SizedBox(height:10),
                _buildToggle(),
                const SizedBox(height: 24),
                _buildForm(), 

                if (errorMessage.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(errorMessage, style: const TextStyle(color: Colors.red)),
                  ),
                const SizedBox(height: 12),
                if (isLogin)
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: const Text("Forgot Password?", style: TextStyle(color: Colors.black87, decoration: TextDecoration.underline)),
                    ),
                  ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _handleAuth,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(221, 8, 53, 10),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(isLogin ? 'Sign In' : 'Register', style: const TextStyle(fontSize: 16, color: Colors.white)),
                  ),
                ),
                const SizedBox(height: 10),
                const Center(child: Text("Other sign in options")),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _socialButton('assets/google.png', _signInWithGoogle),
                    const SizedBox(width: 20),
                    _socialButton('assets/facebook.png', _signInWithFacebook),
                  ],
                ),
                const SizedBox(height: 20), 
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildToggle() {
    return Container(
      height: 45,
      decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(8)),
      child: Row(
        children: [
          _toggleButton(true, "Log In"),
          _toggleButton(false, "Register"),
        ],
      ),
    );
  }

  Widget _toggleButton(bool login, String label) {
    final selected = isLogin == login;
    return Expanded(
      child: InkWell(
        onTap: () => _toggleMode(login),
        child: Container(
          decoration: BoxDecoration(color: selected ? Colors.white : Colors.transparent, borderRadius: BorderRadius.circular(8)),
          alignment: Alignment.center,
          child: Text(label, style: TextStyle(color: selected ? Colors.black : Colors.black54, fontWeight: FontWeight.w500, fontSize: 15)),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!isLogin) ...[
          const Text("Username"),
          const SizedBox(height: 4),
          Material(
            elevation: 1,
            borderRadius: BorderRadius.circular(8),
            child: TextField(
              controller: usernameController,
              style: const TextStyle(fontSize: 13.5),
              decoration: const InputDecoration(
                hintText: "Enter your username",
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
        const Text("Email address"),
        const SizedBox(height: 4),
        Material(
          elevation: 1,
          borderRadius: BorderRadius.circular(8),
          child: TextField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            style: const TextStyle(fontSize: 13.5),
            decoration: const InputDecoration(
              hintText: "Your email",
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              border: InputBorder.none,
            ),
          ),
        ),
        const SizedBox(height: 20),
        const Text("Password"),
        const SizedBox(height: 4),
        Material(
          elevation: 1,
          borderRadius: BorderRadius.circular(8),
          child: TextField(
            controller: passwordController,
            obscureText: !showPassword,
            style: const TextStyle(fontSize: 13.5),
            decoration: InputDecoration(
              hintText: "Password",
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              border: InputBorder.none,
              suffixIcon: IconButton(
                icon: Icon(showPassword ? Icons.visibility : Icons.visibility_off, size: 20),
                onPressed: () => setState(() => showPassword = !showPassword),
              ),
            ),
          ),
        ),
        if (!isLogin) ...[
          const SizedBox(height: 20),
          const Text("Confirm Password"),
          const SizedBox(height: 4),
          Material(
            elevation: 1,
            borderRadius: BorderRadius.circular(8),
            child: TextField(
              controller: confirmPasswordController,
              obscureText: !showConfirmPassword,
              style: const TextStyle(fontSize: 13.5),
              decoration: InputDecoration(
                hintText: "Re-enter password",
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                border: InputBorder.none,
                suffixIcon: IconButton(
                  icon: Icon(showConfirmPassword ? Icons.visibility : Icons.visibility_off, size: 20),
                  onPressed: () => setState(() => showConfirmPassword = !showConfirmPassword),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),

          
          const Text("Account type"),
          const SizedBox(height: 4),
          Material(
            elevation: 1,
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedRole,
                  isExpanded: true,
                  items: const [
                    DropdownMenuItem(value: 'farmer', child: Text('Farmer')),
                    DropdownMenuItem(value: 'driver', child: Text('Pickup Driver')),
                  ],
                  onChanged: (val) => setState(() => selectedRole = val ?? 'farmer'),
                ),
              ),
            ),
          ),
        ]
      ],
    );
  }

  Widget _socialButton(String asset, VoidCallback onTap) {
    return InkWell(
      borderRadius: BorderRadius.circular(50),
      onTap: onTap,
      child: Container(
        height: 44,
        width: 44,
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          shape: BoxShape.circle,
        ),
        child: Image.asset(asset),
      ),
    );
  }
}
