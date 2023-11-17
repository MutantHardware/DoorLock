// Importing Libraries
import 'package:door_lock/services/local_auth_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/io.dart';

import 'login_screen.dart';


const user = "Administrador";


class AdminScreen extends StatefulWidget{
  const AdminScreen({super.key});

  @override
  State <AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {

  final _textController = TextEditingController();
  bool authenticated = false;
  bool biometry = false;
  String? cardData;
  String ESP32IPAdress = "ws://192.168.0.107";
  late bool lockstatus; 
  bool connected = false; 
  late IOWebSocketChannel channel;

  @override
  void initState(){
    super.initState();
    loadData();

    Future.delayed(Duration.zero,() async {
        connect(); 
    });
  }

  connect() { 
    try {
      channel = IOWebSocketChannel.connect(ESP32IPAdress);
      setState(() {
        connected = true; 
      });
      channel.stream.listen((message) {
        print(message);
      }, 
      
        onDone: () {
          setState(() {
                connected = false;
          });    
        },
        onError: (error) {
        },);
    }
    
    catch (_){}
  }

  void loadData() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      cardData = prefs.getString('TestString_Key');
    });
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
            Text('Atenção!'),
          ]
          ),
        content: Text("Deseja Resetar o Login?"),
        actions: <Widget>[
          TextButton(
            child: Text("Sim"),
           onPressed: () {
              _LoginPage(context);
              Navigator.of(context).pop();
            },
          ),
 
           TextButton(
            child: Text("Não"),
            onPressed: () {
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
        title: const Text('$user',
                 style: TextStyle( 
                    fontSize: 20,
                    color: Colors.red,
        )),
        centerTitle: true,
        leading: GestureDetector(
        onTap: () { 
          setState(() {
            showAlert(context);
          }); 
        },
        child: Icon(
          Icons.arrow_back,  
        ),
  ),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [

            /*SizedBox(height: 50),

            const Text(
              'Digite o código do seu cartão',
              style: TextStyle( 
                      fontSize: 20,
                      color: Colors.black,
              )
            ),
             Row(
        children: <Widget>[
           Flexible(
            child:  Container(
              decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius:  BorderRadius.circular(20),
            ),
            child: TextFormField(
              controller: _textController,
              decoration: InputDecoration(
                hintStyle: TextStyle(fontSize: 20),
                hintText: cardData != null ? cardData : "A1:B2:C3:D4",
                suffixIcon: Icon(Icons.key,color: Colors.black, size: 30),
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(10),
             ),
            ),
            ),
          ),
           
           // Save Card Data Button
           IconButton(
                      onPressed: () async {
                        showAlert(context,"salvar");
                      },
                      color: Colors.green, 
                      iconSize: 50,
                      icon: const Icon(Icons.done),
                  ),
                  
                  // Delete Card Data Button
                  IconButton(
                    onPressed: () async {
                      showAlert(context,"deletar");
                    },
                    color: Colors.red, 
                    iconSize: 50,
                    icon: const Icon(Icons.clear),
                  ),
                  
        ],
      ),*/
        
        Container(
          height: 100,
          width: 350,
  padding: const EdgeInsets.all(16.0),
  
  decoration: BoxDecoration(
    border: Border.all(
      width: 3  ,
    ),
  ),
  child: Row(
          mainAxisAlignment: MainAxisAlignment.center, //Center Row contents horizontally,
crossAxisAlignment: CrossAxisAlignment.center, //Center Row contents vertically,
                children: [
                  
                  Text(authenticated ? "Tranca Aberta" : "Tranca Fechada", 
                       style: TextStyle(color: authenticated ? Colors.green : Colors.red,
                       fontSize: 30)),

                  Icon(authenticated ? Icons.lock_open : Icons.lock, color: Colors.blueGrey, size: 30),
                ],
              ) ,       
),

            // Open Door Button
            ElevatedButton(
              onPressed: connected ? () async {                      
                 setState(() {
                
                 });
                 await Future.delayed(const Duration(seconds: 2));            
              } : null,
              child: const Text('Abrir Porta'),
            ),
           
            // ADD Card Button
            ElevatedButton(
              onPressed: connected ? () async {                    
                 setState(() {
                                
                 });
                 await Future.delayed(const Duration(seconds: 2));               
              } : null,
              child: const Text('Adicionar Cartão'),
            ),

            // Delete Card Button
            ElevatedButton(
              onPressed: connected ? () async {
                 if (cardData != null && cardData != "A1:B2:C3:D4"){
                   channel.sink.add(cardData);
                 }
                       
                 setState(() {
                   authenticated = true;                   
                 });

                 await Future.delayed(const Duration(seconds: 2));
                 setState(() {
                   authenticated = false;
                 });
              } : null,
              child: const Text('Deletar Cartão'),
            ),
          
            ElevatedButton(
              onPressed: () async{
                 final authenticate = await LocalAuth.authenticate();
                setState(() {                
                   authenticated = authenticate;
                });

                await Future.delayed(const Duration(seconds: 2));
                 setState(() {
                   authenticated = false;
                 });
              }, 
              child: const Text('Biometria/Identificação Facial'),
              ),

            Switch(
            value: biometry,
            onChanged: (value) {
              setState(() {
                biometry = value;
              });
            },
          ),
                            
          ],
        )
        )
    );
  }

  // Login Page
  void _LoginPage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {         
          return const LoginScreen();
        },
      ),
    );
  }
}
