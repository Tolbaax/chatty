class ChatModel {
  String? senderId;
  String? receiverId;
  var time;
  String? text;

  ChatModel({
    required this.senderId,
    required this.receiverId,
    required this.time,
    required this.text,
  });

  ChatModel.fromJson(Map<String, dynamic>? json) {
    senderId = json!['senderID'];
    receiverId = json['receiverID'];
    time = json['time'];
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['senderID'] = senderId;
    data['receiverID'] = receiverId;
    data['time'] = time;
    data['text'] = text;
    return data;
  }
}
