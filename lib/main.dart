import 'package:flutter/material.dart';

void main() {
  runApp(PostApp());
}

class PostApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Four directions swiping through 2D array',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PostScreen(),
    );
  }
}

class PostScreen extends StatefulWidget {
  @override
  State createState() => _PostScreenState();
}

enum SwipeDirection {
  up,
  down,
  left,
  right,
}

class _PostScreenState extends State<PostScreen> {
  final List<String> posts = [
    'Post 1',
    'Post 2',
    'Post 3',
  ];

  final List<String> relatedPosts = [
    'Related post 1',
    'Related post 2',
    'Related post 3',
  ];

  int horizontalIndex = 0;
  int verticalIndex = 0;
  SwipeDirection type = SwipeDirection.down;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Posts'),
        ),

        // vertical scrolling
        body: PageView.builder(itemBuilder: (context, index) {
          // horizontal scrolling for some post in vertical
          return GestureDetector(onVerticalDragEnd: (details) {
            if (details.primaryVelocity! < 0 &&
                verticalIndex < posts.length - 1) {
              // Swiped downwards
              type = SwipeDirection.down;
              setState(() {
                verticalIndex++;
              });
            } else if (details.primaryVelocity! > 0 && verticalIndex > 0) {
              // Swiped upwards
              type = SwipeDirection.up;
              setState(() {
                verticalIndex -= 1;
              });
            }
          }, onHorizontalDragEnd: (details) {
            if (details.primaryVelocity! < 0) {
              // Swiped to the right
              type = SwipeDirection.right;
              setState(() {
                horizontalIndex++;
                horizontalIndex = horizontalIndex % relatedPosts.length;
              });
            } else if (details.primaryVelocity! > 0) {
              // Swiped to the left
              type = SwipeDirection.left;
              setState(() {
                horizontalIndex--;
                horizontalIndex = horizontalIndex % relatedPosts.length;
              });
            }
          }, child: Builder(builder: (context) {
            if ((type == SwipeDirection.up || type == SwipeDirection.down) &&
                (horizontalIndex == 0)) {
              return Container(child: Text(posts[verticalIndex]));
            } else
              return Container(child: Text(relatedPosts[horizontalIndex]));
          }));
        }));
  }
}
