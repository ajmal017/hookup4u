import 'package:hookup4u/app.dart';
import 'package:hookup4u/models/thread_model.dart';
import 'package:hookup4u/restapi/restapi.dart';

import 'chat_screen.dart';

class SocialChatScreenViewModel{
  SocialChatScreenState state;
  MessageElement messageElement;

  SocialChatScreenViewModel(this.state) {
    printUserData();
    getChatDetails();
  }

  printUserData(){
    print("User Id: ${state.widget.threadAllData.recipient}");
    print("Thread Id: ${state.widget.threadAllData.threadId}");
    // print("Match Id: ${state.widget.matchId}");
    // print("Sender: ${state.widget.sender.name}");
  }

  getChatDetails() async {
    if(state.widget.threadAllData.threadId != null){
      List temp = await databaseHelper.checkThreadDatabase(int.parse(state.widget.threadAllData.threadId));
      print('--- ${temp.length} ---');
      if( temp.isNotEmpty){
        print("Contain Messages");
        messageElement = MessageElement();
        messageElement.messages = [];
       messageElement.messages = await databaseHelper.getSingleUserMessages(int.parse(state.widget.threadAllData.threadId));
       await Future.delayed(Duration(seconds: 1));

        messageElement.messages = messageElement.messages.reversed.toList();
        if (!state.mounted) return;

        state.setState(() {
          state.isLoading = false;
        });

        messageElement = await RestApi.getThreadMessages(state.widget.threadAllData.threadId);

        await databaseHelper.clearThreadMessageDatabase(int.parse(state.widget.threadAllData.threadId));

        for(int i = 0; i<messageElement.messages.length ; i++){
          await databaseHelper.insert(messageElement.messages[i]);
        }

        messageElement.messages = messageElement.messages.reversed.toList();
        if (!state.mounted) return;
        state.setState(() {});

      }else{
        print("Not Contain Messages");
        messageElement = await RestApi.getThreadMessages(state.widget.threadAllData.threadId);

        await databaseHelper.clearThreadMessageDatabase(int.parse(state.widget.threadAllData.threadId));

        for(int i = 0; i<messageElement.messages.length ; i++){
          await databaseHelper.insert(messageElement.messages[i]);
        }

        messageElement.messages = messageElement.messages.reversed.toList();
        state.setState(() {
          state.isLoading = false;
        });
      }
    } else {
      if (!state.mounted) return;
      state.setState(() {
        state.isLoading = false;
      });
    }
  }

  sendMessage(String message) async {
    ThreadModel temp = ThreadModel(senderId: appState.id,message: MessageMessage(raw: message),dateSent: DateTime.now());
    if(state.widget.threadAllData.threadId!=null) {
      if (!state.mounted) return;
      state.setState(() {
        messageElement.messages.insert(0,temp);
      });
      temp.threadId = int.parse(state.widget.threadAllData.threadId);
      await databaseHelper.insert(temp);
      print("Sending Message");
      await RestApi.sendThreadMessage(state.widget.threadAllData.recipient, message,state.widget.threadAllData.threadId);
    } else {
      if (!state.mounted) return;
      state.setState(() {
        messageElement = MessageElement();
        messageElement.messages = [];
        messageElement.messages.insert(0,temp);
      });
      print("Sending First Message");
      String threadId = await RestApi.createThreadMessage(state.widget.threadAllData.recipient, message,state.widget.threadAllData.threadId);
      state.widget.threadAllData.threadId = threadId;
      temp.threadId = int.parse(state.widget.threadAllData.threadId);
      await databaseHelper.insert(temp);
    }
  }
}