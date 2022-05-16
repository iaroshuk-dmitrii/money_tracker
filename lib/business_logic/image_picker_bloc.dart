import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerBloc extends Bloc<ImagePickerEvent, ImagePickerState> {
  final ImagePicker _picker = ImagePicker();
  User? user;

  ImagePickerBloc() : super(ImagePickerInitialState()) {
    on<ImagePickerSelectedEvent>((event, emit) async {
      XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        emit(ImagePickerSelectedState(pickedFile));
      }
    });
    on<ImagePickerResetEvent>((event, emit) async {
      emit(ImagePickerInitialState());
    });
  }
}

//------------------------------
abstract class ImagePickerEvent {}

class ImagePickerSelectedEvent extends ImagePickerEvent {}

class ImagePickerResetEvent extends ImagePickerEvent {}

//------------------------------
abstract class ImagePickerState {}

class ImagePickerInitialState extends ImagePickerState {}

class ImagePickerSelectedState extends ImagePickerState {
  XFile image;
  ImagePickerSelectedState(this.image);
}

class UserImageUpdatedState extends ImagePickerState {
  User? user;
  UserImageUpdatedState(this.user);
}
