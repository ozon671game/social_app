import 'package:flutter/cupertino.dart';
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
  List<UserCard> usersList = [
    UserCard('adress', 'email', 1, 'name', 'phone', 'username', 'website')
  ];
  List<Post> postList = [];
  List<Album> albumList = [];
  late UserCard currentUser;

  bool isLoading = true;

  Future<void> func() async {
    usersList = await updateDataUserList();
    postList = await updateDataPostList();
    albumList = await updateDataAlbumList();
    setState(() {
      isLoading = false;
      currentUser = usersList[0];
    });
  }

  @override
  void initState() {
    super.initState();
    func();
    currentUser = usersList[0];
  }

  int _selectedIndex = 0;

  final List<Widget> _appBarList = <Widget>[
    const Text('All Users'),
    const Text('My Account: '),
    const Text('My Posts'),
    const Text('My Albums'),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _widgetOptions = <Widget>[
      ListUsersTab(usersList, postList),
      UserTab(currentUser, postList),
      AllPostWidget(currentUser.id, usersList[0], postList),
      AllAlbumsWidget(currentUser, albumList),
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
          ],
        ),
      ),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.accessibility),
            label: 'All Users',
            backgroundColor: Colors.indigoAccent,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Me',
            backgroundColor: Colors.indigoAccent,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.apps_rounded),
            label: 'My Posts',
            backgroundColor: Colors.indigoAccent,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.wallpaper),
            label: 'My Albums',
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
  List<WorkingCompany> listWC = [];
  List<WorkingCompany> myListWC = [];

  List<Album> listAlbum = [];
  List<Album> myListAlbum = [];

  Future<void> func() async {
    listWC = await updateDataWorkingCompanyList();
    listAlbum = await updateDataAlbumList();
    setState(() {
      myListWC = defineWorkingCompany(widget.user.id, listWC);
      myListAlbum = defineAlbum(widget.user.id, listAlbum);
    });
  }

  bool isExpandedd = false;
  List<String> myStrings = ['View All', 'Hide'];
  late String varString;

  List<Post> myPostList = [];

  @override
  void initState() {
    super.initState();
    myPostList = definePosts(widget.user.id, widget.postList);
    varString = !isExpandedd ? myStrings[0] : myStrings[1];
    func();
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
          IconButton(onPressed: () {}, icon: const Icon(Icons.email)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.add_a_photo)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.album)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.phone)),
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
                      title: const Text('Working Company:'),
                      subtitle: ListView.builder(
                          itemCount: myListWC.length,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            return Text('name: ${myListWC[index].name} '
                                'bs: ${myListWC[index].bs} '
                                'catchPhrase: ${myListWC[index].catchPhrase}');
                          }),
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
        if (myListAlbum.length != 0) ...[
          GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: myListAlbum.length > 3 ? 3 : myListAlbum.length,
              ),
              itemCount: myListAlbum.length > 3 ? 3 : myListAlbum.length,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  child: Center(
                    child: Text(myListAlbum[index].title),
                  ),
                );
              }),
          TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            AllAlbumsWidget(widget.user, myListAlbum)));
              },
              child: const Text('View All')),
        ],
        const Text(
          'Posts:',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Divider(
          thickness: 20,
          height: 0,
        ),
        Container(
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: myPostList.length > 3 ? 3 : myPostList.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: ListTile(
                    leading: const Icon(Icons.account_circle),
                    title: Text(myPostList[index].title),
                    subtitle: Row(children: [
                      Text(myPostList[index].description),
                    ]),
                  ),
                );
              }),
        ),
        TextButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AllPostWidget(
                          widget.user.id, widget.user, widget.postList)));
            },
            child: const Text('View All')),
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
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                SinglePost(myListPost[index])));
                  },
                  leading: const Icon(Icons.account_circle),
                  title: Text(myListPost[index].title),
                  subtitle: Container(
                    child: Text(myListPost[index].description),
                  ),
                ));
          }),
    );
  }
}

class SinglePost extends StatefulWidget {
  Post post;

  SinglePost(this.post, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SinglePostState();
}

class _SinglePostState extends State<SinglePost> {
  List<UserCard> users = [];
  List<Comment> myCommentList = [];

  Future<void> func() async {
    myCommentList = await updateDataCommentList();
    users = await updateDataUserList();
    setState(() {
      myCommentList = defineComment(widget.post.id, myCommentList);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    func();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text(widget.post.title),
            subtitle: Container(
              child: Text(widget.post.description),
            ),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            IconButton(
                onPressed: () {
                  showModalBottomSheet<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return Container(
                        height: 200,
                        // color: Colors.amber,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              const Text('Modal BottomSheet'),
                              TextFormField(
                                decoration: InputDecoration(hintText: 'BUDAaa'),
                              ),
                              ElevatedButton(
                                child: const Text('Close BottomSheet'),
                                onPressed: () => Navigator.pop(context),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                icon: const Icon(Icons.add)),
            IconButton(onPressed: () {}, icon: const Icon(Icons.announcement)),
          ]),


          if (myCommentList.isNotEmpty)
            Expanded(
              child: ListView.separated(
                  padding: const EdgeInsets.all(8),
                  itemCount: myCommentList.length,
                  separatorBuilder: (BuildContext context, int index) =>
                      Divider(),
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      leading: const Icon(Icons.account_circle),
                      title: Text(users[myCommentList[index].userId].username),
                      subtitle: Text(myCommentList[index].text),
                    );
                  }),
            ),
        ],
      ),
    );
  }
}

class AllAlbumsWidget extends StatefulWidget {
  UserCard user;
  List<Album> listAlbum;

  AllAlbumsWidget(this.user, this.listAlbum, {Key? key});

  @override
  State<StatefulWidget> createState() => _AllAlbumsWidgetState();
}

class _AllAlbumsWidgetState extends State<AllAlbumsWidget> {
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
      body: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount:
                  widget.listAlbum.length > 3 ? 3 : widget.listAlbum.length),
          itemCount: widget.listAlbum.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              PhotosWidget(widget.listAlbum[index])));
                },
                child: Center(
                  child: Text(widget.listAlbum[index].title),
                ),
              ),
            );
          }),
    );
  }
}

class PhotosWidget extends StatefulWidget {
  // int id;
  // List<Album> listAlbum;
  Album album;

  PhotosWidget(this.album, {Key? key});

  @override
  State<StatefulWidget> createState() => _PhotosWidgetState();
}

class _PhotosWidgetState extends State<PhotosWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.album.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
          ),
          itemCount: widget.album.numberPhotos,
          itemBuilder: (BuildContext context, int index) {
            return const Card(child: FlutterLogo());
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
