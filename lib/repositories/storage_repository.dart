import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class StorageRepository {
  final FirebaseStorage _firebaseStorage;
  StorageRepository({FirebaseStorage? firebaseStorage})
      : _firebaseStorage = firebaseStorage ?? FirebaseStorage.instance;

  Future<String?> uploadFile({
    required User user,
    required XFile file,
    String? newFileName,
    String? folderName,
  }) async {
    folderName = (folderName ?? '');
    String fileName = newFileName ?? file.name;
    try {
      UploadTask uploadTask = _firebaseStorage.ref('$folderName${user.uid}/$fileName').putFile(File(file.path));
      String downloadURL = await (await uploadTask).ref.getDownloadURL();
      return downloadURL;
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  Future<String> getDownloadURL({
    required User user,
    required String fileName,
    String? folderName,
  }) async {
    folderName = (folderName ?? '');
    String downloadURL = await _firebaseStorage.ref('$folderName${user.uid}/$fileName').getDownloadURL();
    return downloadURL;
  }
}
