import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {

  final String uid;
  DatabaseService({ required this.uid });

  // collection reference
  final CollectionReference consumerCollection = FirebaseFirestore.instance.collection('consumers');
  final CollectionReference detailsCollection = FirebaseFirestore.instance.collection('details');

  Future<void> updateConsumerData( String name,List<String> currentImageUrls) async {
    return await consumerCollection.doc(uid).set({
      'name': name,
      'imageUrl': [],
    });
  }
  Future<void> updateUserDetails(String consumerId) async{
    final CollectionReference detailsCollection = FirebaseFirestore.instance.collection('details');
    return await detailsCollection.doc(uid).set({
      'shopName':'RIYAZ CHICKEN',
      'vendorName':'Riyaz',
      'address':'#22,ABC building,BTM layout,NS palya,5th main,560006,Bengaluru',
      'vendorCode':'+918074111222',
      'consumerId':consumerId,
    });
  }

  Future<void> updateConsumerDataWithImage(String imageUrl) async {
    DocumentReference userDocRef = consumerCollection.doc(uid);

    DocumentSnapshot snapshot = await userDocRef.get();
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

    List<String> currentImageUrls = List<String>.from(data['imageUrls'] ?? []);

    currentImageUrls.add(imageUrl);

    await userDocRef.update({
      'imageUrls': currentImageUrls,
    });
  }

  Future<List<String>> getUserImageUrls() async {
    DocumentSnapshot snapshot = await consumerCollection.doc(uid).get();
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return List<String>.from(data['imageUrls'] ?? []);
  }

}