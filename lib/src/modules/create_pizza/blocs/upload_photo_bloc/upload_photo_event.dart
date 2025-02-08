part of 'upload_photo_bloc.dart';

sealed class UploadPhotoEvent extends Equatable {
  const UploadPhotoEvent();

  @override
  List<Object?> get props => [];
}
class UploadPhoto extends UploadPhotoEvent {
  final Uint8List file;
  final String name;

  const UploadPhoto(this.file, this.name);

  @override
  List <Object?> get props => [file];
}