import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sharedidea/services/crud.dart';
import 'package:sharedidea/views/create_blog.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CrudMethods crudMethods = new CrudMethods();

  Stream blogsStream;

  Widget BlogsList() {
    return Container(
      child: Expanded(
        child: Container(
          child: blogsStream != null
              ? Column(
            children: <Widget>[
              StreamBuilder(
                stream: blogsStream,
                builder: (context, snapshot) {
                 return ListView.builder(
                   padding: EdgeInsets.symmetric(horizontal: 16),
                  itemCount: snapshot.data.documents.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return BlogsTile(
                        imgUrl: snapshot.data.documents[index].data['imgUrl'],
                        title: snapshot.data.documents[index].data['title'],
                        authorName: snapshot.data.documents[index].data['authorName'],
                        description: snapshot.data.documents[index].data['desc'],
                    );
                  });
                },
              ),
            ],
          ) : Container(
            alignment: Alignment.center,
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    crudMethods.getData().then((result) {
      setState(() {
        blogsStream = result;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Icon(Icons.menu),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Shared",
              style: TextStyle(
                fontSize: 22,
              ),
            ),
            Text(
              "!dea",
              style: TextStyle(
                fontSize: 22,
                color: Colors.blue,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
              child: Icon(Icons.search),
          ),
        ],
      ),
      body: BlogsList(),
      floatingActionButton: Container(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FloatingActionButton(
              backgroundColor: Colors.blueAccent,
              child: Icon(
                Icons.add_rounded,
              ),  
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CreateBlog()));
              },
            ),
          ],
        ),
      ),
    );
  }
}

class BlogsTile extends StatelessWidget {
  String imgUrl, title, description, authorName;

  BlogsTile({
    @required this.imgUrl,
    @required this.title,
    @required this.authorName,
    @required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      height: 150,
      child: Stack(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                  imageUrl: imgUrl,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
              ),
          ),
          Container(
            height: 170,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.black45.withOpacity(0.3),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                    title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                    description,
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400,),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(authorName,),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
