import 'package:cloud_firestore/cloud_firestore.dart';

class Story{
  String url;
  Timestamp time;
  String name;
  String uid;
  Story(this.url,this.time,this.name,this.uid);
}