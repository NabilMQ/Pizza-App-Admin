import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pizza_repository/pizza_repository.dart';

part 'upload_photo_event.dart';
part 'upload_photo_state.dart';

class UploadPhotoBloc extends Bloc<UploadPhotoEvent, UploadPhotoState> {
  final  PizzaRepo _pizzaRepo;
  
  UploadPhotoBloc(
    this._pizzaRepo
  ) : super(UploadPhotoProcess()) {
    on <UploadPhoto> ((event, emit) async {
      emit(UploadPhotoProcess());
      try {
        String url = await _pizzaRepo.sendImage(event.file, event.name);
        emit(UploadPhotoSuccess(url));
      } catch (e) {
        emit(UploadPhotoFailure());
      }
    });
  }
}