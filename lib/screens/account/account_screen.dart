import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kenko/widgets/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  static const String routeName = '/account';

  @override
  State<AccountScreen> createState() => _AccountScreenState();

  static Route route()  {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => const AccountScreen(),
    );
  }
}

class _AccountScreenState extends State<AccountScreen> {
  String userId = '';
  String userName = '';
  String userEmail = '';
  bool isEmailValid = false;
  TextEditingController userNameController = TextEditingController();
  TextEditingController usermailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetUserIdFromSharedPreferences();
    fetchDataFromFirebase();
  }
  Future<void> initStateAsync() async{
    await fetUserIdFromSharedPreferences();
    await fetchDataFromFirebase();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: KenkoAppBar(title: 'Account'),
      bottomNavigationBar: KenkoNavBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: userId.isEmpty || userId=='0'
            ? buildLoginScreen()
            : BuildeLoggedInScreen(),
      ),
    );
  }
  Future<void> fetchDataFromFirebase() async {
    if(userId.isNotEmpty && userId !='0'){
      final DocumentReference userDocRef = FirebaseFirestore.instance.collection('users').doc(userId);
      try {
        DocumentSnapshot documentSnapshot = await userDocRef.get();
        if (documentSnapshot.exists) {
          setState(() {
            userName = documentSnapshot['name'];
            userEmail = documentSnapshot['mail'];
          });
          print('UserId from Firestore: $userId'); // Dodaj ten wypis
        } else {
          print("doc not exist");
        }
      } catch (e) {
        print('$e');
      }
    }
  }
  Widget buildLoginScreen() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextField(
          controller: userNameController,
          decoration: InputDecoration(labelText: "Username"),
        ),
        SizedBox(height: 16),
        TextField(
          controller: usermailController,
          decoration: InputDecoration(
            labelText: "Email",
            errorText: isEmailValid ? 'niepoprawny email lub login' : null,
          ),
        ),
        SizedBox(height: 16),
        ElevatedButton(onPressed: () async  {
          await checkUserExis();
          saveUserID();
        }, child: Text('Login'))
      ],
    );
  }
  Future <void> checkUserExis() async {
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('name', isEqualTo: userNameController.text)
        .where('mail', isEqualTo: usermailController.text)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      final DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
      setState(() {
        userName = documentSnapshot['name'];
        userEmail = documentSnapshot['mail'];
        userId = documentSnapshot.id;
      });
    } else {
      setState(() {
        usermailController.clear();
        isEmailValid = true;
      });
    }
  }
  Widget? BuildeLoggedInScreen() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ListTile(
            title: Text(
              'Imię',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              userName,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          ListTile(
            title: Text(
              'E-mail',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              userEmail,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ElevatedButton(onPressed: () async  {
            await checkUserExis();
            Logout();
          }, child: Text('wyloguj'))
        ]);
  }
  Future<void>saveUserID() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('userId', userId);
  }
  Future <void>Logout() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.clear();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context)=>const AccountScreen()),
    );
  }

  Future<void> fetUserIdFromSharedPreferences() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String storedUserId = prefs.getString('userId') ?? '';
    print('Stored userId from SharedPreferences: $storedUserId');
    setState(() {
      userId = storedUserId;
    });
    fetchDataFromFirebase();
  }
}
