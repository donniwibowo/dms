import 'package:flutter/material.dart';
import 'package:best_flutter_ui_templates/design_storage/home_design.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LoginView extends StatefulWidget {
  @override
  _MyappState createState() => _MyappState();
}

class _MyappState extends State<LoginView> {
  late SharedPreferences sharedPreferences;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  checkLoginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString("user_token") != null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (BuildContext context) => DesignHomeScreen(
                    folder_parent_id: "0",
                  )),
          (Route<dynamic> route) => false);
    }
  }

  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();
  final snackbarKey = GlobalKey<ScaffoldState>();
  bool _obscureText1 = true;
  // Toggles the password show status
  void _togglevisibility() {
    setState(() {
      _obscureText1 = !_obscureText1;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      // backgroundColor: Colors.amber.shade300,
      backgroundColor: Color(0xffc9ccff),
      key: snackbarKey,
      body: Container(
        height: height,
        width: width,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: width,
                height: height * 0.45,
                child: Image.asset(
                  'assets/introduction_animation/login_avatar.png',
                  // fit: BoxFit.contain,
                  width: 100,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'LOGIN',
                      style: TextStyle(
                          fontSize: 30.0, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
                child: TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    suffixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(
                      // borderSide: BorderSide(width: 3, color: Colors.white),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
                child: TextField(
                  obscureText: _obscureText1,
                  controller: passwordController,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    suffixIcon: GestureDetector(
                      onTap: () {
                        _togglevisibility();
                      },
                      child: Icon(
                        _obscureText1 ? Icons.visibility : Icons.visibility_off,
                        color: Colors.blueGrey,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Material(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      elevation: 10,
                      clipBehavior: Clip.antiAlias,
                      child: MaterialButton(
                        minWidth: double.infinity,
                        height: 50,
                        child: Text(
                          'Login',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        color: Color(0xff132137),
                        onPressed: () {
                          signIn(emailController.text, passwordController.text);
                        },
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  signIn(String email, password) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {'email': email, 'password': password};
    var jsonResponse = null;
    var response = await http.post(
        // "http://34.101.208.151/agutask/dms/api/user/login",
        "http://34.101.208.151/agutask/dms/api/user/login",
        body: data);
    jsonResponse = json.decode(response.body);
    if (response.statusCode == 200) {
      if (jsonResponse != null) {
        print(jsonResponse);
        print('finally masuk');
        sharedPreferences.setString("user_token", jsonResponse['user_token']);
        sharedPreferences.setString("email", jsonResponse['data']['email']);
        sharedPreferences.setString(
            "fullname", jsonResponse['data']['fullname']);
        sharedPreferences.setString("phone", jsonResponse['data']['phone']);
        sharedPreferences.setString("user_id", jsonResponse['data']['user_id']);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (BuildContext context) => DesignHomeScreen(
                      folder_parent_id: "0",
                    )),
            (Route<dynamic> route) => false);
      }
    } else {
      showAlertDialog(context, "E-mail atau Kata Sandi Salah.");
    }
  }
}

showAlertDialog(BuildContext context, String message) {
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Error"),
    content: Text(message),
    actions: [
      TextButton(
        child: Text("OK"),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

class Second extends StatefulWidget {
  @override
  _SecondState createState() => _SecondState();
}

class _SecondState extends State<Second> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool _isLoading = false;

  final snackbarKey = GlobalKey<ScaffoldState>();
  bool _obscureText1 = false;
  bool _obscureText2 = false;
  // Toggles the password show status
  void _togglevisibility() {
    setState(() {
      _obscureText2 = !_obscureText2;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        height: height,
        width: width,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: width,
                height: height * 0.45,
                child: Image.asset(
                  'assets/images/play.png',
                  fit: BoxFit.fill,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Signup',
                      style: TextStyle(
                          fontSize: 25.0, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
              TextField(
                controller: _email,
                decoration: InputDecoration(
                  hintText: 'Email',
                  suffixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              TextField(
                obscureText: true,
                controller: _password,
                decoration: InputDecoration(
                  hintText: 'Password',
                  suffixIcon: GestureDetector(
                    onTap: () {
                      _togglevisibility();
                    },
                    child: Icon(
                      _obscureText2 ? Icons.visibility : Icons.visibility_off,
                      color: Colors.blueGrey,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Forget password?',
                      style: TextStyle(fontSize: 12.0),
                    ),
                    MaterialButton(
                      child: Text(
                        'Signup',
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Color(0xff132137),
                      onPressed: () => submit(context),
                      //  {
                      //   Navigator.of(context).push(MaterialPageRoute(
                      //       builder: (context) => DesignHomeScreen()));
                      // },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.0),
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginView()));
                },
                child: Text.rich(
                  TextSpan(
                      text: 'Already have an account',
                      style: TextStyle(color: Colors.grey),
                      children: [
                        TextSpan(
                          text: ' Signin',
                          style: TextStyle(color: Color(0xff132137)),
                        ),
                      ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

//flutter run --no-sound-null-safety
  Future<void> submit(BuildContext context) async {
    Map data = {'email': _email.text, 'password': _password.text};
    var jsonResponse = null;
    var response =
        await http.post("https://discoverkorea.site/apiuser/store", body: data);
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      if (jsonResponse != null) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => LoginView()),
            (Route<dynamic> route) => false);
      }
    } else {
      var snackbar = SnackBar(
        content: Text(response.body,
            style: TextStyle(color: Colors.white.withOpacity(0.8))),
        backgroundColor: Colors.black,
      );
      // snackbarKey.currentState.showSnackBar(snackbar);
    }
  }
}
