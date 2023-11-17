// Importing Libraries
import 'package:door_lock/screens/user_screen.dart';
import 'package:door_lock/services/local_auth_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/io.dart';

import 'admin_screen.dart';

// Administrator Credentials
const adminLogin = "admin";
const adminPassWord = "admin";

// User Credentials
const userLogin = "user";
const userPassWord = "user";

class LoginScreen extends StatefulWidget{
  const LoginScreen({super.key});

  @override
  State <LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final _textControllerCard = TextEditingController();
  final _textControllerUser = TextEditingController();
  final _textControllerPassword = TextEditingController();

  bool authenticated = false;
  bool biometry = false;
  String? user; 
  String? password; 
  String? card; 
  late bool lockstatus; 
  bool connected = false; 
  late IOWebSocketChannel channel;

  @override
  void initState(){
    super.initState();

  }

    // Show Alert
  showAlert(BuildContext context) {
    showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Row(
          children:[
           Icon(
            Icons.warning_amber,
            color: Color.fromARGB(255, 238, 146, 9),
            size: 45.0,
            ),

             SizedBox(width: 35),

            Text('Atenção!'),
          ]
          ),
        content: Text("Dados incorretos!"), 

        actions: <Widget>[
          TextButton(
            child: Text("Ok"),
           onPressed: () async {         
              Navigator.of(context).pop();
            },
          ),
 
        ],  
      );
     },
    );
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text('NERo Lock Login'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            
            // Username text
            const Text(
              'Usuário',
              style: TextStyle( 
                      fontSize: 20,
                      color: Colors.black,
              )
            ),
            
            // Username input
            Flexible(
            child:  Container(
              decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius:  BorderRadius.circular(20),
            ),
            child: TextFormField(
              controller: _textControllerUser,
              decoration: InputDecoration(
                hintStyle: TextStyle(fontSize: 20),
                hintText: "Username",
                suffixIcon: Icon(Icons.person,color: Colors.black, size: 30),
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(10),
             ),
            ),
            ),
          ),
           
           // Password Text
           const Text(
              'Senha',
              style: TextStyle( 
                      fontSize: 20,
                      color: Colors.black,
              )
          ),
          
          // Password Input
          Flexible(
            child:  Container(
              decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius:  BorderRadius.circular(20),
            ),
            child: TextFormField(
              controller: _textControllerPassword,
              decoration: InputDecoration(
                hintStyle: TextStyle(fontSize: 20),
                hintText: "Password",
                suffixIcon: Icon(Icons.password,color: Colors.black, size: 30),
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(10),
             ),
            ),
            ),
          ),

          // Card Text
           const Text(
              'Código do Cartão',
              style: TextStyle( 
                      fontSize: 20,
                      color: Colors.black,
              )
          ),
          
          // Card Input
          Flexible(
            child:  Container(
              decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius:  BorderRadius.circular(20),
            ),
            child: TextFormField(
              controller: _textControllerCard,
              decoration: InputDecoration(
                hintStyle: TextStyle(fontSize: 20),
                hintText: "A1:B2:C3:D4",
                suffixIcon: Icon(Icons.key,color: Colors.black, size: 30),
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(10),
             ),
            ),
            ),
          ),
           
            // Login Button
            ElevatedButton(
              onPressed: () async {
                 // Admin Access
                 if (_textControllerUser.text == adminLogin && _textControllerPassword.text == adminPassWord && _textControllerCard.text != "") {
                   SharedPreferences prefs = await SharedPreferences.getInstance();
                   prefs.setString('User_Key', _textControllerUser.text);
                   prefs.setString('Password_Key', _textControllerPassword.text);
                   prefs.setString('Card_Key', _textControllerCard.text);
                   setState(() {
                    user = prefs.getString('User_Key')!; 
                    password = prefs.getString('Password_Key')!;
                    card = prefs.getString('Card_Key')!;       
                   }); 

                   _AdminPage(context);
                 }
                 // User Access
                 else if (_textControllerUser.text == userLogin && _textControllerPassword.text == userPassWord && _textControllerCard.text != "") {
                   SharedPreferences prefs = await SharedPreferences.getInstance();
                   prefs.setString('User_Key', _textControllerUser.text);
                   prefs.setString('Password_Key', _textControllerPassword.text);
                   prefs.setString('Card_Key', _textControllerCard.text);
                   setState(() {
                      user = prefs.getString('User_Key')!; 
                      password = prefs.getString('Password_Key')!;
                      card = prefs.getString('Card_Key')!;        
                   });  

                   _UserPage(context);
                 }
                 // Show Alert
                 else {
                  showAlert(context);
                 }              
              },
              child: const Text('Entrar'),
            ),                               
          ],
        )
        )
    );
  }
  
  // User Page
  void _UserPage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {         
          return const UserScreen();
        },
      ),
    );
  }
  
  // Admin Page
  void _AdminPage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {         
          return const AdminScreen();
        },
      ),
    );
  }
}
