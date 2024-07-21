import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// import 'package:untitled2/pages/content_state.dart';

class VictimContent extends StatefulWidget {
  final String? profilePicUrl;
  final String name;
  final String? priorityLevel;
  final String mobilenumber;
  final String item;
  final String? headcount;
  final String location;
  final String content;
  final String? imageUrl;
  final String? role;
  final String id;
  final String? foodItems;
  final String? quantity;
  final String? medicineName;

  VictimContent({
    this.profilePicUrl,
    required this.name,
    this.priorityLevel,
    required this.mobilenumber,
    required this.item,
    this.headcount,
    required this.location,
    required this.content,
    this.imageUrl,
    this.role,
    required this.id,
    this.quantity,
    this.medicineName,
    this.foodItems,
  });

  @override
  _VictimContentState createState() => _VictimContentState();
}

class _VictimContentState extends State<VictimContent> {
  bool isExpanded = false;
  User? user;
  String? userId;
  bool isLiked = false;
  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      userId = user!.uid;
    } else {
      print('User is not logged in');
    }
  }

  Future<void> _createChat() async {
    if (userId == null) {
      print('User ID is null');
      return;
    }

    Map<String,dynamic> newPost = {
      'volunteerId': userId,
      'victimId': widget.id,
      'victimName': widget.name,
      'victimLocation': widget.location,
      'message': widget.content,
      'priorityLevel': widget.priorityLevel,
      'victimMobileNumber': widget.mobilenumber,
      'item': widget.item,
      'headcount': widget.headcount,
      'timestamp': Timestamp.now(),
    };
    // newPost['timestamp'] = FieldValue.serverTimestamp();



    try {
      await FirebaseFirestore.instance.collection('chats').doc(userId).set({
        'chats':FieldValue.arrayUnion([newPost])},SetOptions(merge: true)
      );

      await FirebaseFirestore.instance
          .collection('victims')
          .doc(widget.id)
          .set({
        'volunteerId': userId,
        'chatAccepted': true,
      });
      await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.id)
          .update({
        'posts': FieldValue.arrayRemove([
          {
            'name': widget.name,
            'area': widget.location,
            'postcontent': widget.content,
            'prioritylevel': widget.priorityLevel,
            'phonenumber': widget.mobilenumber,
            'headcount': widget.headcount,
            'item': widget.item,
            'role': widget.role,
            'uid': widget.id
          }
        ])
      });

      print('Chat created successfully');
    } catch (e) {
      print('Error creating chat: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    print(widget.medicineName);
    return Padding(
      padding: const EdgeInsets.only(left: 0, right: 0, bottom: 16.0),
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 20.0,
                    backgroundImage: widget.profilePicUrl != null &&
                        widget.profilePicUrl!.isNotEmpty
                        ? NetworkImage(widget.profilePicUrl!)
                        : AssetImage('assets/images/default_profile.jpg')
                    as ImageProvider,
                  ),
                  SizedBox(width: 10.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.name,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        widget.location,
                        style: TextStyle(fontSize: 14, color: Colors.grey[800]),
                      ),
                    ],
                  ),
                  Spacer(),
                  if (widget.role == 'victim') ...[
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.cancel_outlined, color: Colors.red[700]),
                    ),
                    IconButton(
                      onPressed: _createChat,
                      icon: Icon(Icons.check_circle_outline,
                          color: Colors.green[700]),
                    ),
                  ],
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Container(
                    height: 30,
                    // width: 100,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(218, 159, 7, 1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      child: Text(
                        widget.item,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(width: 5),
                  if (widget.priorityLevel != null &&
                      widget.priorityLevel!.isNotEmpty)
                    Container(
                      height: 30,
                      // width: 85,
                      decoration: BoxDecoration(
                        color: Colors.green[500],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        child: Text(
                          "Open",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  SizedBox(width: 5),
                  Container(
                    height: 30,
                    width: 60,
                    decoration: BoxDecoration(
                      color: Colors.purple[400],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Center(
                      child: Text(
                        widget.role!,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(width: 5),
                ],
              ),
              SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "PriorityLevel : " + widget.priorityLevel!,
                    maxLines: isExpanded ? null : 4,
                    overflow: isExpanded
                        ? TextOverflow.visible
                        : TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                  SizedBox(height: 10,),
                  Text(
                    "MobileNumber : " + widget.mobilenumber,
                    maxLines: isExpanded ? null : 4,
                    overflow: isExpanded
                        ? TextOverflow.visible
                        : TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                  if (widget.quantity != null && widget.quantity!.isNotEmpty) ...[
                    SizedBox(height: 10),
                    Text(
                      'Quantity : ${widget.quantity}',
                      maxLines: isExpanded ? null : 4,
                      overflow: isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                  ],
                  if (widget.foodItems != null && widget.foodItems!.isNotEmpty) ...[
                    SizedBox(height: 10),
                    Text(
                      'FoodItems : ${widget.foodItems}',
                      maxLines: isExpanded ? null : 4,
                      overflow: isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                  ],
                  if(widget.medicineName != null && widget.medicineName!.isNotEmpty) ...[
                    SizedBox(height: 10),
                    Text(
                      'Medicine Name : ${widget.medicineName}',
                      maxLines: isExpanded ? null : 4,
                      overflow: isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                  ],
                  SizedBox(height: 10,),
                  Text(
                    "Content : " + widget.content,
                    maxLines: isExpanded ? null : 4,
                    overflow: isExpanded
                        ? TextOverflow.visible
                        : TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),

                  InkWell(
                    onTap: () {
                      setState(() {
                        isExpanded = !isExpanded;
                      });
                    },
                    child: Text(
                      isExpanded ? 'Read less' : 'Read more',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              if (widget.imageUrl != null && widget.imageUrl!.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Image.network(
                    widget.imageUrl!,
                    height: 200.0,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              SizedBox(height: 5),
              Row(
                children: [
                  Padding(padding: EdgeInsets.only(left: 8.0)),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        isLiked = !isLiked;
                      });
                    },
                    icon: Icon(
                      isLiked ? Icons.favorite : Icons.favorite_border,
                      color: isLiked ? Colors.red : Colors.black,
                    ),
                  ),
                  Spacer(),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.cached, color: Colors.black),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.messenger_outline_rounded,
                        color: Colors.black),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
