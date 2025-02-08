part of 'upload_photo_bloc.dart';

sealed class UploadPhotoState extends Equatable {
  const UploadPhotoState();

  @override
  List <Object> get props => [];
}

final class UploadPhotoInitial extends UploadPhotoState {}

final class UploadPhotoFailure extends UploadPhotoState {}
final class UploadPhotoProcess extends UploadPhotoState {}
final class UploadPhotoSuccess extends UploadPhotoState {
  final String url;
  
  const UploadPhotoSuccess(this.url);
}