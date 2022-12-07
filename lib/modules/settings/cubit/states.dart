abstract class SettingsStates {}

class SettingsInitialState extends SettingsStates {}

class GetUserDataLoadingState extends SettingsStates {}

class GetUserDataSuccessState extends SettingsStates {}

class GetUserDataErrorState extends SettingsStates {}

class ProfileImagePickedSuccess extends SettingsStates {}

class ProfileImagePickedError extends SettingsStates {}

class CoverImagePickedSuccess extends SettingsStates {}

class CoverImagePickedError extends SettingsStates {}

class UploadProfileImageSuccess extends SettingsStates {}

class UploadProfileImageError extends SettingsStates {}

class UploadCoverImageSuccess extends SettingsStates {}

class UploadCoverImageError extends SettingsStates {}

class UpdateUserDataLoading extends SettingsStates {}

class UpdateUserDataSuccess extends SettingsStates {}

class UpdateUserDataError extends SettingsStates {}
