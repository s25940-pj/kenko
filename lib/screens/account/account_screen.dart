import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kenko/widgets/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  static const String routeName = '/account';

  @override
  State<AccountScreen> createState() => _AccountScreenState();

  static Route route() {
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
  bool isNotRegisterVisible = true;

  @override
  void initState() {
    super.initState();
    fetUserIdFromSharedPreferences();
    fetchDataFromFirebase();
  }

  Future<void> initStateAsync() async {
    await fetUserIdFromSharedPreferences();
    await fetchDataFromFirebase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const KenkoAppBar(title: 'Account'),
      bottomNavigationBar: const KenkoNavBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: userId.isEmpty || userId == '0'
            ? buildLoginScreen()
            : BuildLoggedInScreen(),
      ),
    );
  }

  Future<void> fetchDataFromFirebase() async {
    if (userId.isNotEmpty && userId != '0') {
      final DocumentReference userDocRef =
          FirebaseFirestore.instance.collection('users').doc(userId);
      try {
        DocumentSnapshot documentSnapshot = await userDocRef.get();
        if (documentSnapshot.exists) {
          setState(() {
            userName = documentSnapshot['name'];
            userEmail = documentSnapshot['mail'];
          });
          print('UserId from Firestore: $userId');
        } else {
          print("doc not exist");
        }
      } catch (e) {
        print('$e');
      }
    }
  }

  Widget buildLoginScreen() {
    if (isNotRegisterVisible) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Login"),
          TextField(
            controller: userNameController,
            decoration: const InputDecoration(labelText: "Username"),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: usermailController,
            decoration: InputDecoration(
              labelText: "Email",
              errorText: isEmailValid ? 'Invalid email' : null,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
              onPressed: () async {
                await checkUserExis();
                saveUserID();
              },
              child: const Text('Login')),
          ElevatedButton(
            onPressed: () {
              setState(() {
                isNotRegisterVisible = false;
                buildLoginScreen();
              });
            },
            child: const Text('Register'),
          ),
        ],
      );
    } else {
      return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Text("Registration"),
        ListTile(
          title: TextField(
            controller: userNameController,
            decoration: const InputDecoration(labelText: "Name"),
          ),
        ),
        ListTile(
          title: TextField(
            controller: usermailController,
            decoration: const InputDecoration(labelText: "Email"),
          ),
        ),
        ElevatedButton(
          onPressed: () async {
            sendAccToFirebase();
            isNotRegisterVisible = true;
            buildLoginScreen();
          },
          child: const Text('Confirm'),
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              isNotRegisterVisible = true;
              buildLoginScreen();
            });
          },
          child: const Text('Back'),
        ),
      ]);
    }
  }

  Future<void> checkUserExis() async {
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
        print("jest taki user");
      });
    } else {
      setState(() {
        usermailController.clear();
        isEmailValid = true;
      });
    }
  }

  Widget? BuildLoggedInScreen() {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      ListTile(
        title: const Text(
          'Imię',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          userName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      ListTile(
        title: const Text(
          'E-mail',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          userEmail,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      ElevatedButton(
          onPressed: () async {
            await checkUserExis();
            Logout();
          },
          child: const Text('Log out'))
    ]);
  }

  Future<void> saveUserID() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('userId', userId);
  }

  Future<void> Logout() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.clear();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const AccountScreen()),
    );
  }

  Future<void> fetUserIdFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String storedUserId = prefs.getString('userId') ?? '';
    print('Stored userId from SharedPreferences: $storedUserId');
    setState(() {
      userId = storedUserId;
    });
    fetchDataFromFirebase();
  }

  void sendAccToFirebase() async {
    int randomId = DateTime.now().millisecondsSinceEpoch;
    String ID = randomId.toString();
    await FirebaseFirestore.instance.collection('users').doc(ID).set({
      'name': userNameController.text,
      'mail': usermailController.text,
    });
    usermailController.clear();
    userNameController.clear();
    isNotRegisterVisible = true;
    buildLoginScreen();
  }
}
