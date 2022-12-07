abstract class FeedsStates {}

class FeedsInitialState extends FeedsStates {}

class GetPostsLoadingState extends FeedsStates {}

class GetPostsSuccessState extends FeedsStates {}

class GetPostsErrorState extends FeedsStates {}

class LikePostSuccessState extends FeedsStates {}

class LikePostErrorState extends FeedsStates {}

class CommentLoadingState extends FeedsStates {}

class CommentSuccessState extends FeedsStates {}

class CommentsErrorState extends FeedsStates {}

class GetCommentsState extends FeedsStates {}
