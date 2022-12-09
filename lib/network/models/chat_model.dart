class ChatModel {
  String? senderId;
  String? receiverId;
  String? text;
  List? messageImage;
  var time;

  ChatModel({
    required this.senderId,
    required this.receiverId,
    required this.text,
    required this.messageImage,
    required this.time,
  });

  ChatModel.fromJson(Map<String, dynamic>? json) {
    senderId = json!['senderID'];
    receiverId = json['receiverID'];
    text = json['text'];
    messageImage = json['messageImage'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['senderID'] = senderId;
    data['receiverID'] = receiverId;
    data['text'] = text;
    data['messageImage'] = messageImage;
    data['time'] = time;

    return data;
  }
}
