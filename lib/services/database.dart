import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {

  final String uid;
  DatabaseService({ required this.uid });

  // collection reference
  final CollectionReference consumerCollection = FirebaseFirestore.instance.collection('consumers');
  final CollectionReference detailsCollection = FirebaseFirestore.instance.collection('details');

  // create a document in the database with the  just empty fields when the user is created
  Future<void> updateConsumerData( String name,List<String> currentImageUrls) async {
    return await consumerCollection.doc(uid).set({
      'name': name,
      'imageUrl': [],
    });
  }

  // create a document in the database with text when the user is created
  Future<void> updateUserDetails(String consumerId) async{
    return await detailsCollection.doc(uid).set({
      'shopName':'RIYAZ CHICKEN',
      'vendorName':'RIYAZ',
      'address':'#22,ABC building,BTM layout,NS palya,5th main,560006,Bengaluru',
      'vendorCode':'111111-222',
      'consumerId':consumerId,
    });
  }

  // updating the cloud storage with currently saved image
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

  // fetching saved image urls
  Future<List<String>> getUserImageUrls() async {
    DocumentSnapshot snapshot = await consumerCollection.doc(uid).get();
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return List<String>.from(data['imageUrls'] ?? []);
  }

}