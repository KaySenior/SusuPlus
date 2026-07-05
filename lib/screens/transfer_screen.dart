import "package:flutter/material.dart";
import '../routes/routes.dart';
import 'package:go_router/go_router.dart';

void main() {}

// class TransferScrenn extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold();
//   }
// }
class TransferScreen extends StatefulWidget {
  const TransferScreen({super.key});

  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: true,
        elevation: 15,
        shadowColor: const Color.fromARGB(66, 36, 22, 22),
        backgroundColor: Colors.white,
        title: Text(
          'Transfer',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          height: 800,
          child: Stack(
            children: [
              Positioned(
                left: 0,
                right: 0,
                top: 20,
                child: Center(
                  child: Text(
                    'Amount',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 8,
                right: 8,
                top: 60,
                child: Container(
                  width: 320,
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: BoxBorder.all(width: 2),
                  ),
                ),
              ),
              Positioned(
                left: 8,
                right: 8,
                top: 150,
                child: Container(
                  child: Column(
                    children: [
                      ListTile(
                        leading: Text('From',
                            style: TextStyle(
                              fontWeight: FontWeight(400),
                              fontSize: 20,
                            )),
                        // tileColor: Colors.white,
                        trailing: Icon(Icons.arrow_drop_down),
                      ),
                      ListTile(
                        leading: Text('To',
                            style: TextStyle(
                              fontWeight: FontWeight(400),
                              fontSize: 20,
                            )),
                        // tileColor: Colors.white,
                        trailing: Icon(Icons.arrow_drop_down),
                      ),
                      ListTile(
                        leading: Text(
                          'Date',
                          style: TextStyle(
                            fontWeight: FontWeight(400),
                            fontSize: 20,
                          ),
                        ),
                        // tileColor: Colors.white,
                        trailing: Icon(Icons.arrow_drop_down),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 8,
                right: 8,
                top: 400,
                bottom: 0,
                child: Text(
                  ''' Lorem ipsum dolor sit amet consectetur adipisicing elit. Quam eaque veritatis nulla, harum quasi totam ea eveniet est ab enim cupiditate id quaerat mollitia adipisci? Amet asperiores beatae magni debitis. Lorem ipsum dolor sit amet consectetur adipisicing elit. Quam eaque veritatis nulla, harum quasi totam ea eveniet est ab enim cupiditate id quaerat mollitia adipisci? Amet asperiores beatae magni debitis.''',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Positioned(
                bottom: 55,
                left: 8,
                right: 8,
                child: Center(
                  child: SizedBox(
                    width: 500,
                    height: 64,
                    child: ElevatedButton(
                      onPressed: () {
                        context.go('/homepage');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 144, 150, 155),
                      ),
                      child: Text(
                        'Continue',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight(500),
                          fontSize: 25,
                        ),
                      ),
                    ),
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
