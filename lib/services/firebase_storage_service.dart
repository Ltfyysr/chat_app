import 'dart:io';

import 'package:chat_app/services/storage_base.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageService implements StorageBase{
  final FirebaseStorage _firebaseStorage=FirebaseStorage.instance;
  late Reference _storageReference;


  @override
  Future<String> uploadFile(String userID, String fileType, File document) async{



    _storageReference = _firebaseStorage.ref().child(userID).child(fileType).child("profil_photo");
    UploadTask uploadTask = _storageReference.putFile(document);

    var url=await uploadTask.then((a) =>
        a.ref.getDownloadURL());

    return url;

  }}