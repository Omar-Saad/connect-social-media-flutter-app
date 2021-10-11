import 'package:connect/layout/cubit/cubit.dart';
import 'package:connect/models/user_model.dart';
import 'package:connect/shared/style/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ChatPickImageScreen extends StatelessWidget {
  var messageController = TextEditingController();
  final UserModel userModel;

   ChatPickImageScreen(this.userModel) ;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.black,
          statusBarIconBrightness: Brightness.light,
          
        ),
        backgroundColor: Colors.black,
        leading: IconButton(
            icon: Icon(
              Icons.close,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            child: Image(
              image: FileImage(
                SocialCubit.get(context).chatImage,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 5.0,
                    ),
                    child: TextFormField(
                      controller: messageController,
                      validator: (String value) {
                        if (value.isEmpty)
                          return 'Message can\'t be empty';
                        return null;
                      },
                      keyboardType: TextInputType.text,
                      maxLines: null,
                      onChanged: (value) {},
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: BorderSide(
                            width: 0,
                            style: BorderStyle.none,
                          ),
                        ),
                        focusColor: Colors.white,
                        hintStyle: TextStyle(
                            fontWeight: FontWeight.normal),
                        hintText: 'Enter your message here...',
                        fillColor: Colors.white,
                        filled: true,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10.0,
                    vertical: 5.0,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: defaultColor,
                      shape: BoxShape.circle,
                    ),
                    child: MaterialButton(
                      onPressed: () {
                          SocialCubit.get(context).sendMessage(
                              receiverId: userModel.uId,
                              dateTime: DateTime.now().toString(),
                              textMessage: messageController.text);
                          // messageController.text = '';
                          Navigator.pop(context);

                      },
                      minWidth: 1.0,
                      child: Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 16.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
