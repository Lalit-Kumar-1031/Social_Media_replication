import 'package:flutter/material.dart';
import 'package:instagram_clone/Providers/UserProvider.dart';
import 'package:instagram_clone/Utils/colors.dart';
import 'package:instagram_clone/resources/firestore_method.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CommentCard extends StatefulWidget {
  final snap;
  final postId;
  const CommentCard({Key? key,required this.snap,required this.postId}) : super(key: key);

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).getUser;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(
                'https://images.pexels.com/photos/7135121/pexels-photo-7135121.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1'),
            radius: 18,
            child: CircleAvatar(
              backgroundImage: NetworkImage(widget.snap['profImage']),
              radius: 16,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  RichText(
                      text: TextSpan(children: [
                    TextSpan(
                        text: widget.snap['username']+" , ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white,fontSize: 15.5)),
                    TextSpan(
                        text: DateFormat.yMMMd().format(
                            widget.snap['publishDate'].toDate()),
                        style: TextStyle(color: Colors.white))
                  ])),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(top: 6,right: 3),
                    child: Text(widget.snap['commentText'],style: TextStyle(color: Colors.grey),),
                  )
                ],
              ),
            ),
          ),
          Column(
            children: [
              IconButton(icon: widget.snap['commentLike'].contains(user.uid)
                  ? Icon(
                Icons.favorite,
                color: Colors.red,
              )
                  : Icon(Icons.favorite_outline_sharp),onPressed: ()async{
                await FireStoreMethod().likeComment(widget.postId.toString(),
                    user.uid, widget.snap['commentLike'],widget.snap['commentId']);

              },),
              Text(widget.snap['commentLike'].length.toString()),
            ],
          )

        ],
      ),
    );
  }
}
