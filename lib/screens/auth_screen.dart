import 'package:bordered_text/bordered_text.dart';
import 'package:flutter/material.dart';
import 'package:fluttershopudemy/models/http_exception.dart';
import 'package:fluttershopudemy/providers/auth.dart';
import 'package:provider/provider.dart';

enum AuthMode { Signup, Login }

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    // final transformConfig = Matrix4.rotationZ(-8 * pi / 180);
    // transformConfig.translate(-10.0);
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).backgroundColor.withOpacity(0.5),
                  Theme.of(context).accentColor.withOpacity(0.7),
                  // Color.fromRGBO(200, 255, 255, 1).withOpacity(0.5),
                  // Color.fromRGBO(50, 50, 117, 1).withOpacity(0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0, 1],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    child: Container(
                      width: double.infinity,

                      margin: EdgeInsets.only(bottom: 20.0),
                      //padding: EdgeInsets.symmetric(
                      //vertical: 8.0, horizontal: 110.0),
                      //transform: Matrix4.rotationZ(-8 * pi / 180)
                      //.. = include offset with translate, but with previous method return
                      //similar to folder structure
                      //..translate(0.0),
                      // decoration: BoxDecoration(
                      //   borderRadius: BorderRadius.circular(2),
                      //   //color: Colors.deepPurple.shade400,
                      //   gradient: LinearGradient(
                      //     colors: [
                      //       Theme.of(context).backgroundColor.withOpacity(0.4),
                      //       Theme.of(context).accentColor.withOpacity(0.8),
                      //       // Color.fromRGBO(150, 50, 117, 1).withOpacity(0.9),
                      //       // Color.fromRGBO(200, 255, 255, 1).withOpacity(0.5),
                      //     ],
                      //     begin: Alignment.topLeft,
                      //     end: Alignment.bottomRight,
                      //     stops: [0, 1],
                      //   ),
                      //   boxShadow: [
                      //     BoxShadow(
                      //       blurRadius: 8,
                      //       color: Colors.black26,
                      //       offset: Offset(0, 2),
                      //     )
                      //   ],
                      // ),
                      child: BorderedText(
                        child: Text(
                          '_shopContext',
                          style: TextStyle(
                            color: Theme.of(context)
                                .accentTextTheme
                                .headline6
                                .color,
                            fontSize: 44,
                            fontFamily: 'Anton',
                            fontWeight: FontWeight.normal,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: deviceSize.width > 600 ? 2 : 1,
                    child: AuthCard(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({
    Key key,
  }) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();

  //animation
  AnimationController _controller;
  //specify what to animate
  Animation<Offset> _slideAnimation;
  Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _slideAnimation = Tween<Offset>(
        begin: Offset(0, -1.5),
        end: Offset(
          0,
          0,
        )).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.fastOutSlowIn,
      ),
    );
    _opacityAnimation = Tween(
      begin: 0.0,
      end: 10.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );
    // _heightAnimation.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void _showErrorDialog(String message) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text('An error occurred'),
              content: Text(message),
              actions: [
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                )
              ],
            ));
  }

  void _submit() async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });

    try {
      if (_authMode == AuthMode.Login) {
        // Log user in
        await Provider.of<Auth>(context, listen: false).login(
          _authData['email'],
          _authData['password'],
        );
      } else {
        //sign up
        await Provider.of<Auth>(context, listen: false).signup(
          _authData['email'],
          _authData['password'],
        );
      }
      setState(() {
        _isLoading = false;
      });
    } on HttpException catch (error) {
      //specific errors as returned by login and signup
      var errorMessage = 'Authentication failed';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage =
            'That email address has already been registered. Forget, did we?';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'Invalid email address';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'Does your password even lift, brother?';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'No user with that email';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid password';
      }
      _showErrorDialog(errorMessage);
    } catch (error) {
      //any errors
      const errorMessage = 'Authentication failed';
      _showErrorDialog(errorMessage);
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        return _authMode = AuthMode.Signup;
      });
      _controller.forward();
    } else {
      setState(() {
        return _authMode = AuthMode.Login;
      });
      _controller.reverse();
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
        height: _authMode == AuthMode.Signup ? 340 : 260,
        // height: _heightAnimation.value.height,
        constraints:
            BoxConstraints(minHeight: _authMode == AuthMode.Signup ? 340 : 260),
        width: deviceSize.width * 0.75,
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                      labelText: 'E-Mail',
                      labelStyle: TextStyle(letterSpacing: 2)),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value.isEmpty || !value.contains('@')) {
                      return 'Invalid email!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['email'] = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(letterSpacing: 2)),
                  obscureText: true,
                  controller: _passwordController,
                  validator: (value) {
                    if (value.isEmpty || value.length < 5) {
                      return 'Password is too short!';
                    } else
                      return null;
                  },
                  onSaved: (value) {
                    _authData['password'] = value;
                  },
                ),
                AnimatedContainer(
                  duration: Duration(
                    milliseconds: 300,
                  ),
                  constraints: BoxConstraints(
                    minHeight: _authMode == AuthMode.Signup ? 60 : 0,
                    maxHeight: _authMode == AuthMode.Signup ? 120 : 0,
                  ),
                  curve: Curves.easeIn,
                  child: FadeTransition(
                    opacity: _opacityAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: TextFormField(
                        enabled: _authMode == AuthMode.Signup,
                        decoration: InputDecoration(
                            labelText: 'Confirm Password',
                            labelStyle: TextStyle(letterSpacing: 2)),
                        obscureText: true,
                        validator: _authMode == AuthMode.Signup
                            ? (value) {
                                if (value != _passwordController.text) {
                                  return 'Passwords do not match!';
                                } else
                                  return null;
                              }
                            : null,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                if (_isLoading)
                  CircularProgressIndicator()
                else
                  RaisedButton(
                    child: Text(
                        _authMode == AuthMode.Login ? 'LOGIN' : 'SIGN UP',
                        style: TextStyle(letterSpacing: 2)),
                    onPressed: _submit,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                    color: Theme.of(context).primaryColor,
                    textColor: Theme.of(context).primaryTextTheme.button.color,
                  ),
                FlatButton(
                  child: Text(
                      '${_authMode == AuthMode.Login ? 'SIGNUP' : 'LOGIN'}',
                      style: TextStyle(letterSpacing: 2)),
                  onPressed: _switchAuthMode,
                  padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  textColor: Theme.of(context).primaryColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
