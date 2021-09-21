import 'package:flutter/material.dart';

import 'profile.dart';
import 'service.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
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
  List<Post> postList = [];

  Future<void> func() async {
    usersList = await updateDataUserList();
    postList = await updateDataPostList();
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
      ListUsersTab(usersList, postList),
      UserTab(usersList[0], postList),
      AllPostWidget(usersList[0].id, usersList[0], postList),
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
            DrawerHeader(
              child: ListTile(
                leading: const Icon(Icons.account_circle_outlined),
                title: Text(usersList[0].username),
                subtitle: Text(usersList[0].name),
              ),
            ),
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
  List<Post> postList;

  UserCardFull(this.id, this.user, this.postList, {Key? key});

  @override
  State<UserCardFull> createState() => _UserCardFullState();
}

class _UserCardFullState extends State<UserCardFull> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.user.username),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: UserTab(widget.user, widget.postList),
    );
  }
}

class ListUsersTab extends StatelessWidget {
  final List<UserCard> usersList;
  final List<Post> postList;

  ListUsersTab(this.usersList, this.postList);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return ListTile(
          leading: const Icon(Icons.account_circle),
          title: Text(
            usersList[index].username,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: Text(usersList[index].name),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        (UserCardFull(index, usersList[index], postList))));
          },
        );
      },
      itemCount: usersList.length,
    );
  }
}

class UserTab extends StatefulWidget {
  UserCard user;
  List<Post> postList;

  UserTab(this.user, this.postList);

  @override
  State<StatefulWidget> createState() => UserTabState();
}

class UserTabState extends State<UserTab> {

  bool isExpandedd = false;
  List<String> myStrings = ['View All', 'Hide'];
  late String varString;

  List<Post> myPostList = [];

  @override
  void initState() {
    super.initState();
    myPostList = definePosts(widget.user.id, widget.postList);
    print(myPostList.length);
    varString = !isExpandedd ? myStrings[0] : myStrings[1];
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        DrawerHeader(
          child: ListTile(
            leading: const FlutterLogo(), //Image.asset('UserPhoto'),
            trailing:
                IconButton(onPressed: () {}, icon: const Icon(Icons.edit)),
            title: Text(
              widget.user.username,
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w800,
              ),
            ),
            subtitle: Text(widget.user.name),
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
                      title: const Text('E-mail'),
                      subtitle: Text(widget.user.email),
                    ),
                    ListTile(
                      title: const Text('Adress'),
                      subtitle: Text(widget.user.adress),
                    ),
                    ListTile(
                      title: const Text('Phone'),
                      subtitle: Text(widget.user.phone),
                    ),
                    ListTile(
                      title: const Text('Website'),
                      subtitle: Text(widget.user.website),
                    ),
                  ],
                ),
                isExpanded: isExpandedd,
              ),
            ],
          ),
        ),

        Container(
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: myPostList.length > 3 ? 3 : myPostList.length,
              itemBuilder: (BuildContext context, int index){
                return  Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: ListTile(
                    leading: const Icon(Icons.account_circle),
                    title: Text(myPostList[index].title),
                    subtitle: Row(children: [
                      Text(myPostList[index].description),
                    ]),
                  ),
                );
              }
          ),
        ),


        // Column(
        //   children: [
        //
        //     Container(
        //       padding: EdgeInsets.symmetric(vertical: 10),
        //       child: ListTile(
        //         leading: Icon(Icons.account_circle),
        //         title: Text(''),
        //         subtitle: Row(children: const [
        //           Text('Text of Post. A lot of text. many many many texts'),
        //         ]),
        //       ),
        //     ),
        //     Container(
        //       padding: EdgeInsets.symmetric(vertical: 10),
        //       child: ListTile(
        //         leading: Icon(Icons.account_circle),
        //         title: Text('Username'),
        //         subtitle: Row(children: const [
        //           Text('Text of Post. A lot of text. many many many texts'),
        //         ]),
        //       ),
        //     ),
        //     TextButton(
        //         onPressed: () {
        //           Navigator.push(
        //               context,
        //               MaterialPageRoute(
        //                   builder: (context) => AllPostWidget(
        //                       widget.user.id, widget.user, widget.postList)));
        //         },
        //         child: Text('View All'))
        //   ],
        // ),
      ],
    );
  }
}

class AllPostWidget extends StatefulWidget {
  int id;
  UserCard user;
  List<Post> postList;

  AllPostWidget(this.id, this.user, this.postList, {Key? key});

  @override
  State<StatefulWidget> createState() => _AllPostWidgetState();
}

class _AllPostWidgetState extends State<AllPostWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.user.username),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: PostScreen(widget.user.id, widget.postList),
    );
  }
}

class PostScreen extends StatefulWidget {
  int id;
  List<Post> postList;

  PostScreen(
    this.id,
    this.postList, {
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => PostScreenState();
}

class PostScreenState extends State<PostScreen> {
  List<Post> myListPost = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myListPost = definePosts(widget.id, widget.postList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.separated(
          padding: const EdgeInsets.all(8),
          itemCount: myListPost.length,
          separatorBuilder: (BuildContext context, int index) => Divider(),
          itemBuilder: (BuildContext context, int index) {
            return Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: ListTile(
                  leading: Icon(Icons.account_circle),
                  title: Text(myListPost[index].title),
                  subtitle: Container(
                    child: Text(myListPost[index].description),
                  ),
                ));
          }),
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
            title: const Text('Info'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
