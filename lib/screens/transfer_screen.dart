import 'package:flutter/material.dart';

class TransferScreen extends StatefulWidget {
  const TransferScreen({super.key});

  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  bool _circleChecked = false;
  bool value = false;
  bool dropdown_value = false;
  String date = 'Todays_date';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Transfer',
          style: TextStyle(fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            spacing: 10,
            //   mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,

            children: [
              Text('Amount'),
              TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green))),
              ),
              Column(
                children: [
                  ListTile(
                    title: Text(
                      'Recurring',
                      style: TextStyle(fontSize: 15),
                    ),
                    trailing: Checkbox(
                        shape: CircleBorder(),
                        value: _circleChecked,
                        onChanged: (bool? value) {
                          setState(() {
                            _circleChecked = value ?? false;
                          });
                        }),
                  ),
                  const Divider(),
                  ListTile(
                    title: Text('From'),
                    trailing: SizedBox(
                      width: 200,
                      height: 30,
                      child: TextField(
                        decoration: InputDecoration(
                            fillColor: Colors.green,
                            border: OutlineInputBorder()),
                      ),
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    title: Text('To'),
                    trailing: DropdownButton(
                        items: [], onChanged: (dropdown_value) {}),
                  ),
                  const Divider(),
                  ListTile(
                    title: Text("Date"),
                    trailing: Text('$date'),
                  ),
                  const Divider(),
                ],
              ),
              Text(
                  'Disclaimer: By proceeding with this transaction, you confirm that you have verified the recipients account number, phone number, and/or card details are accurate and belong to the intended recipient. We are not responsible for funds sent to an incorrect or unintended recipient due to inaccurate details entered by the sender. Transactions to a wrong number or card may be irreversible and are not guaranteed to be refunded. Please review all details carefully before confirming payment.'),
                  const SizedBox(height: 50,),
              SizedBox(
                width: 300,
                height: 50,
                  child:
                      ElevatedButton(style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade400,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5)))
                      ), onPressed: () {}, child: Text("Continue")))
            ],
          ),
        ),
      ),
    );
  }
}
