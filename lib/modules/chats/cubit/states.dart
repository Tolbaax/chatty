abstract class ChatStates {}

class ChatInitState extends ChatStates {}

class GetAllUsersSuccessState extends ChatStates {}

class GetAllUsersErrorState extends ChatStates {}

class GetAllUsersLoadingState extends ChatStates {}

class GetMessageLoadingState extends ChatStates {}

class GetMessageSuccessState extends ChatStates {}

class SendMessageLoadingState extends ChatStates {}

class SendMessageSuccessState extends ChatStates {}

class SendMessageErrorState extends ChatStates {}

class ChatImagePickedSuccessState extends ChatStates {}

class ChatImagePickedErrorState extends ChatStates {}

class UploadMessageImageLoadingState extends ChatStates {}

class UploadMessageImageSuccessState extends ChatStates {}
