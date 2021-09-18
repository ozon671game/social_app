import 'package:flutter/material.dart';

import 'profile.dart';
import 'service.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {

  List<UserCard> usersList = [];

  Future<void> func() async{
    usersList = await updateData();
    setState(() {});
  }


  @override
  void initState() {
    super.initState();
    func();
  }

  int _selectedIndex = 0;

  final List<Widget> _appBarList = <Widget>[
    const Text('All Users'),
    const Text('Me is: '),
    const Text('Users'),
    const Text('Users'),
    const Text('Users'),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {

    // static initialization inside class
    final List<Widget> _widgetOptions = <Widget>[
      ListUsersTab(usersList),
      UserTab(usersList[0]),
      const Text('Business'),
      const Text('School'),
      const Text(

        'Settings',
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.add_alert_sharp)),
        ],
        backgroundColor: Colors.indigoAccent,
        title: _appBarList.elementAt(_selectedIndex),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
                child: ListTile(
                    leading: Icon(Icons.account_circle_outlined),
                    title: Text('My Account'))),
            ListTile(
              leading: const Icon(Icons.message),
              title: const Text('Messages'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Exit'),
              onTap: () {},
            ),
          ],
        ),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.accessibility),
            label: 'All Users',
            backgroundColor: Colors.indigoAccent,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Me',
            backgroundColor: Colors.indigoAccent,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Business',
            backgroundColor: Colors.indigoAccent,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'School',
            backgroundColor: Colors.indigoAccent,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
            backgroundColor: Colors.indigoAccent,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}

class UserCardFull extends StatefulWidget {

  int id;
  UserCard user;

  UserCardFull(this.id, this.user,{Key? key});

  @override
  State<UserCardFull> createState() => _UserCardFullState();
}

class _UserCardFullState extends State<UserCardFull> {
  @override
  Widget build(BuildContext context){
  return Scaffold(
    appBar: AppBar(
      title: Text(widget.user.name),
      actions: [
        IconButton(icon: const Icon(Icons.arrow_back), onPressed: (){Navigator.pop(context);},),
      ],
    ),
    body: UserTab(widget.user),
  );
}
}

class ListUsersTab extends StatelessWidget {
  final List<UserCard> usersList;

  ListUsersTab(this.usersList);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return ListTile(
          leading: const Icon(Icons.account_circle),
          title: Text(usersList[index].name),
          subtitle: Text(usersList[index].email),
          onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context) => (UserCardFull(index,usersList[index]))));},
        );
      },
      itemCount: usersList.length,
    );
  }
}

class UserTab extends StatefulWidget {

  UserCard user;
  UserTab(this.user);

  @override
  State<StatefulWidget> createState() => UserTabState(user);
}

class UserTabState extends State<UserTab> {

  UserCard user;
  UserTabState(this.user);

  bool isExpandedd = false;
  List<String> myStrings = ['View All', 'Hide'];
  late String varString;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    varString = !isExpandedd ? myStrings[0] : myStrings[1];
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        DrawerHeader(
          child: ListTile(
            leading: Image.asset('UserPhoto'),
            trailing:
                IconButton(onPressed: () {}, icon: const Icon(Icons.edit)),
            title: Text(
              user.name,
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w800,
              ),
            ),
            subtitle: Text(user.email),
          ),
        ),

        Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          IconButton(
              onPressed: () {}, tooltip: 'Edit', icon: const Icon(Icons.edit)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.add_a_photo)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.edit)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.edit)),
        ]),

        Container(
          padding: EdgeInsets.zero,
          child: ExpansionPanelList(
            expansionCallback: (int index, bool isExpanded) {
              setState(() {
                isExpandedd = !isExpandedd;
                varString = !isExpandedd ? myStrings[0] : myStrings[1];
              });
            },
            children: [
              ExpansionPanel(
                headerBuilder: (BuildContext context, bool isExpanded) {
                  return ListTile(
                    title: const Text('Info'),
                    subtitle: Text(varString),
                  );
                },
                body: Column(
                  children: [
                    ListTile(
                      title: const Text('Adress'),
                      subtitle: Text(user.adress),
                    ),
                    ListTile(
                      title: const Text('Phone'),
                      subtitle: Text(user.phone),
                    ),
                    ListTile(
                      title: const Text('Website'),
                      subtitle: Text(user.website),
                    ),
                  ],
                ),
                isExpanded: isExpandedd,
              ),
            ],
          ),
        ),

        // ListView.separated(
        //     padding: const EdgeInsets.all(8),
        //     itemCount: 3,
        //     separatorBuilder: (BuildContext context, int index) => Divider(),
        //     itemBuilder: (BuildContext context, int index) {
        //       return Container(
        //           padding: EdgeInsets.symmetric(vertical: 10),
        //           child: Text('users[index]', style: TextStyle(fontSize: 22))
        //       );
        //     }
        // ),
      ],
    );
  }
}

class Menus extends StatelessWidget {
  const Menus({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text('Info'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
