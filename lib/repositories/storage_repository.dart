import 'dart:developer';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class StorageRepository {
  final FirebaseStorage _firebaseStorage;
  StorageRepository({FirebaseStorage? firebaseStorage})
      : _firebaseStorage = firebaseStorage ?? FirebaseStorage.instance;

  Future<String?> uploadFile({
    required XFile file,
    String? newFileName,
    String? folderName,
  }) async {
    folderName = folderName ?? '';
    String fileName = newFileName ?? file.name;
    try {
      UploadTask uploadTask = _firebaseStorage.ref('$folderName/$fileName').putFile(File(file.path));
      String fileUrl = await (await uploadTask).ref.getDownloadURL();
      log('File available at $fileUrl');
      return fileUrl;
    } catch (e) {
      log(e.toString());
    }
    return null;
  }
}
