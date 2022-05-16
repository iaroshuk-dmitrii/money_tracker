import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_tracker/business_logic/auth_bloc.dart';
import 'package:money_tracker/business_logic/image_picker_bloc.dart';
import 'package:money_tracker/business_logic/login_cubit.dart';
import 'package:money_tracker/business_logic/profile_bloc.dart';
import 'package:money_tracker/ui/constants.dart';
import 'package:money_tracker/ui/navigation.dart';
import 'package:money_tracker/ui/widgets/purple_text_button.dart';

class ProfileScreen extends StatelessWidget {
  static const String route = 'profile_screen';
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticatedState) {
          Navigator.of(context).pushNamedAndRemoveUntil(Screens.login, (Route<dynamic> route) => false);
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Center(child: Text('Профиль'))),
        body: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 80,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    GestureDetector(
                      onTap: () {
                        BlocProvider.of<ImagePickerBloc>(context).add(ImagePickerSelectedEvent());
                      },
                      child: BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
                        BlocProvider.of<ImagePickerBloc>(context).add(ImagePickerResetEvent());
                        if (state is AuthAuthenticatedState) {
                          String? photo = state.user?.photoURL;
                          return BlocBuilder<ImagePickerBloc, ImagePickerState>(builder: (context, state) {
                            if (state is ImagePickerSelectedState) {
                              return _Avatar(photoUrl: photo, photoFile: File(state.image.path));
                            }
                            return _Avatar(photoUrl: photo);
                          });
                        }
                        return const _Avatar();
                      }),
                    ),
                    const SizedBox(width: 20.0),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 200),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
                            if (state is AuthAuthenticatedState) {
                              String email = state.user?.email.toString() ?? '';
                              return Text(email);
                            }
                            return const SizedBox.shrink();
                          }),
                          // const SizedBox(height: 13),
                          PurpleTextButton(
                            buttonTitle: 'Выйти',
                            onPressed: () {
                              context.read<LoginCubit>().signOut();
                            },
                          )
                        ],
                      ),
                    ),
                    // const Expanded(child: SizedBox.shrink()),
                  ],
                ),
              ),
              const _SaveButton()
            ],
          ),
        ),
      ),
    );
  }
}

class _SaveButton extends StatelessWidget {
  const _SaveButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ImagePickerBloc, ImagePickerState>(builder: (context, state) {
      if (state is ImagePickerSelectedState) {
        return TextButton(
          style: ButtonStyle(padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.zero)),
          child: const Text(
            'Сохранить',
            style: kPurpleTextStyle,
          ),
          onPressed: () {
            BlocProvider.of<ProfileBloc>(context).add(UpdatePhotoEvent(state.image));
          },
        );
      }
      return Container();
    });
  }
}

class _Avatar extends StatelessWidget {
  final String? photoUrl;
  final File? photoFile;
  const _Avatar({Key? key, this.photoUrl, this.photoFile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ImageProvider? _photo;
    if (photoFile != null) {
      _photo = FileImage(photoFile!);
    } else if (photoUrl != null) {
      _photo = NetworkImage(photoUrl!);
    }
    //
    return CircleAvatar(
      backgroundColor: kLightGray,
      radius: 40,
      foregroundImage: _photo,
      child:
          (photoUrl == null && photoFile == null) ? const Icon(Icons.photo_camera, color: kDarkGray, size: 35) : null,
    );
  }
}
