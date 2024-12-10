import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:panther_watch/authentication/service/AuthService.dart';
import 'package:panther_watch/navigation/navigation_provider.dart';
import 'package:panther_watch/pages/home/home.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLoading = false;
  bool isSignup = false;
  bool _isLoggedIn = false;
  LatLng location = LatLng(0, 0);
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();


  void signup() async {

    if (usernameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please enter your username', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
      ));

      return;
    }

    if (emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please enter your email', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
      ));

      return;
    }

    if (passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please enter a Password', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
      ));

      return;
    }

    if (confirmPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please confirm your Password', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
      ));

      return;
    }

    try {

      setState(() {
        isLoading = true;
      });

      final user = await AuthService.signUp(emailController.text, passwordController.text, usernameController.text, location);

      if (user != null) {

        setState(() {
          isSignup = false;
        });

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: Text('Signed up Successfully'),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      }

      setState(() {
        isLoading = false;
      });

    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Text(e.toString()),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );

      setState(() {
        isLoading = false;
      });
    }
    

  }

  @override
  Widget build(BuildContext context) {

    final navigationProvider = Provider.of<NavigationProvider>(context);

    if (_isLoggedIn) {
      return MenuLayer();
    }

    void login() async {

    if (emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please enter your email', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
      ));

      return;
    }

    if (passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please enter your Password', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
      ));

      return;
    }

    try {

      setState(() {
        isLoading = true;
      });

      final response = await AuthService.login(emailController.text, passwordController.text);

      if (response != null) {
        _isLoggedIn = true;
        setState(() {
          navigationProvider.getType();
          isLoading = false;
        });
      }


    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Text(e.toString()),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );

      setState(() {
        isLoading = false;
      });
    }
    

  }
    
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/login.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              SizedBox(height: isSignup ? 150 : 200),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * .20,
                            height: MediaQuery.of(context).size.width * .20,
                            child: Image.asset('assets/logo.jpg'),
                          ),
                          VerticalDivider(color: Colors.grey, thickness: 2,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'PantherWatch',
                                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                              ),
                              Text('CONNECTING THE STATE WAY', style: TextStyle(fontSize: 11, letterSpacing: 2),)
                            ],
                          ),
                        ],
                      ),
                      if (isSignup) ...[
                        SizedBox(height: 20),
                        TextField(
                          controller: usernameController,
                          decoration: InputDecoration(
                            labelText: "Username",
                          ),
                        ),
                      ],
                      SizedBox(height: 15),
                      TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: "Email",
                        ),
                      ),
                      SizedBox(height: 15),
                      TextField(
                        controller: passwordController,
                        decoration: InputDecoration(labelText: "Password"),
                        obscureText: true,
                      ),
                      if (isSignup) ... [
                        SizedBox(height: 30),
                        TextField(
                          controller: confirmPasswordController,
                          decoration: InputDecoration(labelText: "Confirm Password"),
                          obscureText: true,
                        ),
                      ],
                      SizedBox(height: 30),
                      InkWell(
                        onTap: isLoading ? (){} : isSignup ? signup : login,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 45,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 0, 58, 166),
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: isLoading ? Container(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white)) : Text(isSignup ? 'SIGNUP' : 'LOGIN', style: TextStyle(letterSpacing: 2, color: Colors.white),),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      if (!isSignup) ... [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Don\'t have an account?'),
                            SizedBox(width: 5),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  isSignup = !isSignup;
                                });
                              },
                              child: Text('Signup', style: TextStyle(color: Color.fromARGB(255, 0, 58, 166)),)
                            )
                          ],
                        )
                      ] else ... [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Already have an account?'),
                            SizedBox(width: 5),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  isSignup = !isSignup;
                                });
                              },
                              child: Text('Login', style: TextStyle(color: Color.fromARGB(255, 0, 58, 166)),)
                            )
                          ],
                        )
                      ]
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
