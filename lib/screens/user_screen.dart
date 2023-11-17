// Importing Libraries
import 'package:door_lock/services/local_auth_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/io.dart';

const user = "Usuário";

class UserScreen extends StatefulWidget{
  const UserScreen({super.key});

  @override
  State <UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {

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
  showAlert(BuildContext context, String warning) {
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
        content: Text("Deseja $warning o código?"),
        actions: <Widget>[
          TextButton(
            child: Text("Sim"),
           onPressed: () async {
              if (warning == "salvar" && _textController.text != ""){
                   SharedPreferences prefs = await SharedPreferences.getInstance();
                   prefs.setString('TestString_Key', _textController.text);
                   setState(() {
                    cardData = prefs.getString('TestString_Key')!; 
                   });            
              }
              else if (warning == "deletar"){
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  prefs.remove('TestString_Key');
                  _textController.clear();
                  setState(() {
                  cardData = "A1:B2:C3:D4"; 
                });
              }
              Navigator.of(context).pop();
            },
          ),
 
           TextButton(
            child: Text("Não"),
            onPressed: () {
               if (warning == "salvar" && _textController.text != ""){
                 _textController.clear();
               }
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
                    color: Colors.green,
        )),
        centerTitle: true,
        automaticallyImplyLeading: false, 
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [

           /* 
            SizedBox(height: 50),

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
      ),
      */
        
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
                            
          ],
        )
        )
    );
  }
}
