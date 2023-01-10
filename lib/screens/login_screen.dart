import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:loja_virtual/screens/home_screen.dart';
import 'package:loja_virtual/screens/signup_screen.dart';
import 'package:scoped_model/scoped_model.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}
final _formKey = GlobalKey<FormState>();

class _LoginScreenState extends State<LoginScreen> {

  final _emailController = TextEditingController();

  final _passController = TextEditingController();


  Future _usuarioLogado() async {
  FirebaseAuth auth = FirebaseAuth.instance;
  User? usuarioLogado = await auth.currentUser;

  if (usuarioLogado != null){
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => HomeScreen())
    );
  }
}

@override
void initState() {
    _usuarioLogado();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Entrar"),
          centerTitle: true,
          backgroundColor: Color(0xff000706),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0, top: 8),
              child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                            builder: (context) => SignUpScreen()
                        )
                    );
                  },
                  child: Text(
                    'CRIAR CONTA',
                    style: TextStyle(fontSize: 12, color: Colors.white),
                  )
              ),
            ),
          ],
        ),
        body: ScopedModelDescendant<UserModel>(
            builder: (context, child, model) {
              if (model.isLoading) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: ListView(
                    children: [
                      TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            hintText: 'E-mail',
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xff0c7e7e),
                              ),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xff0c7e7e),
                              ),
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (text) {
                            if (text!.isEmpty || !text.contains('@'))
                              return 'E-mail inválido';
                          }
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _passController,
                        decoration: InputDecoration(
                            hintText: 'Senha',
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xff0c7e7e)
                              ),
                            ),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xff0c7e7e),
                                )
                            )
                        ),
                        obscureText: true,
                        validator: (text) {
                          if (text!.isEmpty || text.length < 8)
                            return 'Senha Inválida';
                        },
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            if(_emailController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text(
                                        "Insira seu e-mail para recuperação!"),
                                    backgroundColor: Color(0xff820000),
                                    duration: const Duration(seconds: 3),
                                  ));
                            } else {
                              model.recoverPass(_emailController.text);
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: const Text(
                                    "Confira seu E-mail"),
                                backgroundColor: Theme.of(context).primaryColor,
                                duration: const Duration(seconds: 3),
                              ));
                            }
                          },
                          child: Text(
                            "Esqueci minha senha",
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: Color(0xff0c7e7e),
                            ),
                          ),
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 45,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {

                            }
                            model.signIn(
                                email: _emailController.text,
                                pass: _passController.text,
                                onSuccess: _onSuccess,
                                onFail: _onFail
                            );
                          },
                          child: Text('Entrar',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme
                                .of(context)
                                .primaryColor,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            }
        )
    );
  }

  void _onSuccess() {
    Navigator.of(context).pop;
  }

  void _onFail() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text(
          "Falha ao entrar!"),
      backgroundColor: Color(0xff820000),
      duration: const Duration(seconds: 3),
    ));
  }
}
