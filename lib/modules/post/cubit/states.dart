abstract class AddPostStates {}

class AddPostInitialState extends AddPostStates {}

class GetUserDataLoadingState extends AddPostStates {}

class GetUserDataSuccessState extends AddPostStates {}

class GetUserDataErrorState extends AddPostStates {
  final String error;
  GetUserDataErrorState({required this.error});
}

class PostImagePickedSuccessState extends AddPostStates {}

class PostImagePickedErrorState extends AddPostStates {}

class CreatePostLoadingState extends AddPostStates {}

class CreatePostSuccessState extends AddPostStates {}

class CreatePostErrorState extends AddPostStates {}

class RemovePostImageState extends AddPostStates {}
