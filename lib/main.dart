import 'package:flutter/material.dart';
import 'dart:collection';

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
  LinkedHashMap<String, List<String>> posts =
      LinkedHashMap<String, List<String>>.from({
    'Post 1': [
      'Post 1',
      'Related to Post 1: 1',
      'Related to Post 1: 2',
      'Related to Post 1: 3',
    ],
    'Post 2': [
      'Post 2',
      'Related to Post 2: 1',
      'Related to Post 2: 2',
      'Related to Post 2: 3',
    ],
    'Post 3': [
      'Post 3',
      'Related to Post 3: 1',
      'Related to Post 3: 2',
      'Related to Post 3: 3',
    ],
  });

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
                verticalIndex < posts.length - 1 &&
                horizontalIndex == 0) {
              // Swiped downwards
              type = SwipeDirection.down;
              setState(() {
                verticalIndex++;
              });
            } else if (details.primaryVelocity! > 0 &&
                verticalIndex > 0 &&
                horizontalIndex == 0) {
              // Swiped upwards
              type = SwipeDirection.up;
              setState(() {
                verticalIndex -= 1;
              });
            }
          }, onHorizontalDragEnd: (details) {
            int numRelatedPosts =
                posts[posts.keys.toList()[verticalIndex]]!.length;
            if (details.primaryVelocity! < 0 &&
                horizontalIndex < numRelatedPosts - 1) {
              // Swiped to the right
              type = SwipeDirection.right;
              setState(() {
                horizontalIndex++;
                if (posts[verticalIndex] != null) {
                  horizontalIndex =
                      horizontalIndex % posts[verticalIndex]!.length;
                }
              });
            } else if (details.primaryVelocity! > 0 && horizontalIndex > 0) {
              // Swiped to the left
              type = SwipeDirection.left;
              setState(() {
                horizontalIndex--;
                if (posts[verticalIndex] != null) {
                  horizontalIndex =
                      horizontalIndex % posts[verticalIndex]!.length;
                }
              });
            }
          }, child: Builder(builder: (context) {
            if (posts[posts.keys.toList()[verticalIndex]] != null) {
              return Container(
                  child: Text(posts[posts.keys.toList()[verticalIndex]]![
                      horizontalIndex]));
            }
            return Text("Error.");
          }));
        }));
  }
}
