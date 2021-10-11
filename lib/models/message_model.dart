class MessageModel {
  String senderId;
  String receiverId;
  String dateTime;
  String textMessage;
  String image;

 MessageModel(
      {this.senderId,
      this.receiverId,
      this.dateTime,
      this.textMessage,
        this.image,

      });

 MessageModel.fromJson(Map<String, dynamic> json) {
    senderId = json['senderId'];
    receiverId = json['receiverId'];
    dateTime = json['dateTime'];
    textMessage = json['textMessage'];
    image = json['image'];

  }

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'dateTime': dateTime,
      'textMessage': textMessage,
      'image': image,

    };
  }
}
