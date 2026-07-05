import 'package:flutter/material.dart';

//! since  you did not explicitly state whether I should use stfull widget then,
///since the right drop button  is going to drop a some menu of  datials when it is
///pressed then assume I will use stful widget
///!but other wise  if press and open a different screen for each different then I will only comment the statless widget

// class ProfileScreen extends StatelessWidget {
//   const ProfileScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
// }

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Screen.screen();
  }
}

class Screen {
  static screen() {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          width: double.infinity,
          height: 1200,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 450,
                // color: Colors.blueGrey,
                child: Stack(
                  children: [
                    Positioned(
                      top: 70,
                      left: 10,
                      child: Text(
                        'Profile',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 29,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 70,
                      right: 10,
                      child: IconButton(
                        onPressed: () {},
                        style: IconButton.styleFrom(
                          // backgroundColor: Colors.white,
                          iconSize: 35,
                        ),
                        icon: Icon(Icons.notification_add_outlined),
                      ),
                    ),
                    Positioned(
                      top: 150,
                      left: 8,
                      right: 8,
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.all(
                            Radius.circular(100),
                          ),
                          child: Image.asset(
                            'assets/images/profileImage.jpg',
                            fit: BoxFit.fill,
                          ),
                        ),
                        title: Text('Mr.Mark'),
                        subtitle: Text('Show profile'),
                        trailing: IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.arrow_forward_ios)),
                      ),
                    ),
                    Positioned(
                      // bottom: 40,
                      top: 258,
                      left: 8,
                      right: 8,
                      child: Container(
                        height: 120,
                        width: 640,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.all(
                            Radius.circular(8),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black87,
                            )
                          ],
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              top: 8,
                              bottom: 8,
                              right: 8,
                              child: Image.asset('assets/icons/cash.png'),
                            ),
                            Positioned(
                              //! only added the position to resize the text to the left of the the container
                              //! so you what you turn to put in there I think using the positioned widget will just help you much
                              //! note this is flexible to consider not strict or mandatory
                              left: 8,
                              right: 100,
                              top: 8,
                              bottom: 8,
                              child: SizedBox(
                                height: 94,
                                width: 540,
                                child: Text(
                                  ''' Lorem ipsum dolor sit amet consectetur adipisicing elit. Quam eaque veritatis nulla, harum quasi totam ea eveniet est ab enim cupiditate id quaerat mollitia adipisci? Amet asperiores beatae magni debitis. Lorem ipsum dolor sit amet consectetur adipisicing elit. Quam eaque veritatis nulla, harum quasi totam ea eveniet est ab enim cupiditate id quaerat mollitia adipisci? Amet asperiores beatae magni debitis.''',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 398,
                      left: 8,
                      child: Text(
                        'Settings',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight(400),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  height: 300,
                  width: double.infinity,
                  child: Column(
                    children: [
                      Expanded(
                        child: ListTile(
                          leading: Image.asset(
                            'assets/icons/user-circle.png',
                            height: 25,
                            width: 25,
                          ),
                          title: Text(
                            'Personal information',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight(480),
                            ),
                          ),
                          trailing: IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.arrow_forward_ios)),
                        ),
                      ),
                      Expanded(
                        child: ListTile(
                          leading: Image.asset(
                            'assets/icons/money.png',
                            height: 25,
                            width: 25,
                          ),
                          title: Text(
                            'Payment and payouts',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight(480),
                            ),
                          ),
                          trailing: IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.arrow_forward_ios),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListTile(
                          leading: Image.asset(
                            'assets/icons/taxes.png',
                            height: 25,
                            width: 25,
                          ),
                          title: Text(
                            'Taxes ',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight(480),
                            ),
                          ),
                          trailing: IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.arrow_forward_ios)),
                        ),
                      ),
                      Expanded(
                        child: ListTile(
                          leading: Image.asset(
                            'assets/icons/shield.png',
                            height: 25,
                            width: 25,
                          ),
                          title: Text(
                            'Logic & security',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight(480),
                            ),
                          ),
                          trailing: IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.arrow_forward_ios)),
                        ),
                      ),
                      Expanded(
                        child: ListTile(
                          leading: Image.asset(
                            'assets/icons/accessibility.png',
                            height: 25,
                            width: 25,
                          ),
                          title: Text(
                            'Accessibility',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight(480),
                            ),
                          ),
                          trailing: IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.arrow_forward_ios),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        //!lastly since you stated you have created a universal BottomNavigationBar  already so you I will comment this out ,
        //!incase you say otherwise
        //!

        // bottomNavigationBar: BottomAppBar(
        //   height: 50,
        //   child: Row(
        //     children: [
        //       Icon(Icons.home),
        //     ],
        //   ),
        // ),

        //!
      ),
    );
  }
}
