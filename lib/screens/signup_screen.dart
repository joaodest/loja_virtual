import 'package:flutter/material.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';


class SignUpScreen extends StatefulWidget {
  SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _nameController = TextEditingController();

  final _emailController = TextEditingController();

  final _passController = TextEditingController();

  final _addressController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final _scaffoldKey = GlobalKey<ScaffoldState>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Criar Conta"),
          centerTitle: true,
          backgroundColor: Color(0xff000706),
        ),
        body: ScopedModelDescendant<UserModel>(
          builder: (context, child, model) {
            if (model.isLoading)
              return Center(child: CircularProgressIndicator());
            return Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: ListView(
                  children: [
                    TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          hintText: 'Nome',
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
                        validator: (text) {
                          if (text!.isEmpty) return 'Nome Inválido';
                        }),
                    SizedBox(height: 16),
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
                          if (text!.isEmpty || !text.contains('@')) {
                            return 'E-mail inválido';
                          }
                          return null;
                        }),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _passController,
                      decoration: InputDecoration(
                          hintText: 'Senha',
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff0c7e7e)),
                          ),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xff0c7e7e),
                              ))),
                      obscureText: true,
                      validator: (text) {
                        if (text!.isEmpty || text.length < 8) {
                          return 'Senha Inválida';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                        controller: _addressController,
                        decoration: InputDecoration(
                          hintText: 'Endereço',
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
                        validator: (text) {
                          if (text!.isEmpty) {
                            return 'Endereço Inválido';
                          }
                          return null;
                        }
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 45,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            Map<String, dynamic> userData = {
                              "name": _nameController.text,
                              "email": _emailController.text,
                              "address": _addressController.text,
                            };
                            model.signUp(
                                userData: userData,
                                pass: _passController.text,
                                onSuccess: _onSuccess,
                                onFail: _onFail
                            );
                          }
                        },
                        child: Text(
                          'Criar Conta',
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
          },
        )
    );
  }

  void _onSuccess() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Usuário criado com sucesso!"),
      backgroundColor: Theme
          .of(context)
          .primaryColor,
      duration: const Duration(seconds: 3),
    ));
    Future.delayed(Duration(seconds: 2)).then((value) {
      Navigator.of(context).pop();
    });
  }

  void _onFail() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text(
          "Falha ao criar usuário! Por Favor, tente novamente!"),
      backgroundColor: Color(0xff820000),
      duration: const Duration(seconds: 3),
    ));
  }
}