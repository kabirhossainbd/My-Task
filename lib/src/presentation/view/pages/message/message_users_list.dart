import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:my_task/main.dart';
import 'package:my_task/model/response/chatuser_model.dart';
import 'package:my_task/model/response/message_model.dart';
import 'package:my_task/services/apis.dart';
import 'package:my_task/src/presentation/view/pages/message/message_box_screen.dart';
import 'package:my_task/src/presentation/view/pages/message/suggestion_list_screen.dart';
import 'package:my_task/src/utils/constants/m_colors.dart';
import 'package:my_task/src/utils/constants/m_data_utils.dart';
import 'package:my_task/src/utils/constants/m_dimensions.dart';
import 'package:my_task/src/utils/constants/m_styles.dart';

class ChatHomeScreen extends StatefulWidget {
  const ChatHomeScreen({super.key});

  @override
  State<ChatHomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<ChatHomeScreen> {
  // for storing all users
  List<ChatUser> _list = [];

  // for storing searched items
  final List<ChatUser> _searchList = [];
  // for storing search status
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    APIs.getSelfInfo();

    //for updating user active status according to lifecycle events
    //resume -- active or online
    //pause  -- inactive or offline
    SystemChannels.lifecycle.setMessageHandler((message) {
      log('Message: $message');

      if (APIs.auth.currentUser != null) {
        if (message.toString().contains('resume')) {
          APIs.updateActiveStatus(true);
        }
        if (message.toString().contains('pause')) {
          APIs.updateActiveStatus(false);
        }
      }

      return Future.value(message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //for hiding keyboard when a tap is detected on screen
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        //if search is on & back button is pressed then close search
        //or else simple close current screen on back button click
        onWillPop: () {
          if (_isSearching) {
            setState(() {
              _isSearching = !_isSearching;
            });
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
        child: Scaffold(
          backgroundColor: MyColor.getBackgroundColor(),
          body: SafeArea(
            child: Column(
              children: [
                /// for search
                InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  focusColor: Colors.transparent,
                   onTap: () => Get.to(const SuggestionListScreen()),
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                    decoration: BoxDecoration(
                        color: MyColor.colorSecondary,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [BoxShadow(
                            color: Color(0x1018280D),
                            spreadRadius: 0.1,
                            blurRadius: 0.1,
                            offset: Offset(0.5, 0.5)
                        )
                        ]
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8),
                          child: Icon(CupertinoIcons.search,size: 20, color: MyColor.getGreyColor(),),
                        ),
                        Text('search'.tr,style: robotoLight.copyWith(color: MyColor.getGreyColor()),)
                      ],
                    ),
                  ),
                ),


              //  const SizedBox(height: MySizes.marginSizeMiniSmall,),

                Expanded(
                  child: StreamBuilder(
                    stream: APIs.getMyUsersId(),

                    //get id of only known users
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                      //if data is loading
                        case ConnectionState.waiting:
                        case ConnectionState.none:
                          return const Center(child: CircularProgressIndicator());

                      //if some or all data is loaded then show it
                        case ConnectionState.active:
                        case ConnectionState.done:
                          return StreamBuilder(
                            stream: APIs.getAllUsers(snapshot.data?.docs.map((e) => e.id).toList() ?? []),

                            //get only those user, who's ids are provided
                            builder: (context, snapshot) {
                              switch (snapshot.connectionState) {
                              //if data is loading
                                case ConnectionState.waiting:
                                case ConnectionState.none:
                                // return const Center(
                                //     child: CircularProgressIndicator());

                                //if some or all data is loaded then show it
                                case ConnectionState.active:
                                case ConnectionState.done:
                                  final data = snapshot.data?.docs;
                                  _list = data?.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];

                                  if (_list.isNotEmpty) {
                                    return ListView.builder(
                                        itemCount: _isSearching
                                            ? _searchList.length
                                            : _list.length,
                                        padding: EdgeInsets.only(top: mq.height * .01),
                                        physics: const BouncingScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          return ChatUserCard(
                                              user: _isSearching
                                                  ? _searchList[index]
                                                  : _list[index]);
                                        });
                                  } else {
                                    return  Center(
                                      child: Column( mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text('No Connections Found!', style: robotoRegular.copyWith(fontSize: 20, color: Colors.black)),
                                          const SizedBox(height:8),
                                          GestureDetector(
                                            child: Container(
                                                padding: const EdgeInsets.all(12),
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(16),
                                                    color: MyColor.getSecondaryColor()
                                                ),
                                                child: const Text('Go to suggestion')), onTap: ()=> Get.to(const SuggestionListScreen()),),
                                        ],
                                      ),
                                    );
                                  }
                              }
                            },
                          );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



//card to represent a single user in home screen
class ChatUserCard extends StatefulWidget {
  final ChatUser user;

  const ChatUserCard({super.key, required this.user});

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  //last message info (if null --> no message)
  Message? _message;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: mq.width * .04, vertical: 4),
       color: MyColor.getBackgroundColor(),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => ChatScreen(user: widget.user)));
          },
          child: StreamBuilder(
            stream: APIs.getLastMessage(widget.user),
            builder: (context, snapshot) {
              final data = snapshot.data?.docs;
              final list = data?.map((e) => Message.fromJson(e.data())).toList() ?? [];
              if (list.isNotEmpty) _message = list[0];

              return ListTile(
                leading: InkWell(
                  onTap: () {
                    // showDialog(
                    //     context: context,
                    //     builder: (_) => ProfileDialog(user: widget.user));
                    //
                    },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(mq.height * .03),
                    child: CachedNetworkImage(
                      width: mq.height * .055,
                      height: mq.height * .055,
                      imageUrl: widget.user.image,
                      errorWidget: (context, url, error) => const CircleAvatar(child: Icon(CupertinoIcons.person)),
                    ),
                  ),
                ),
                title: Text((widget.user.name == 'null' || widget.user.name.isEmpty) ? widget.user.email : widget.user.name, style: robotoBold.copyWith(color: MyColor.getTextColor().withOpacity(0.6), fontSize: MySizes.fontSizeLarge),),
                subtitle: Text(_message != null ? _message!.type == Type.image ? 'image' : _message!.msg : widget.user.about,style: robotoRegular.copyWith(color: MyColor.getGreyColor(), fontSize: MySizes.fontSizeDefault), maxLines: 1),
                trailing: _message == null
                    ? null //show nothing when no message is sent
                    : _message!.read.isEmpty &&
                    _message!.fromId != APIs.user.uid
                    ?
                //show for unread message
                Container(
                  width: 15,
                  height: 15,
                  decoration: BoxDecoration(
                      color: Colors.greenAccent.shade400,
                      borderRadius: BorderRadius.circular(10)),
                ) :
                //message sent time
                Text(
                  MyDateUtil.getLastMessageTime(context: context, time: _message!.sent),
                  style: robotoRegular.copyWith(color: MyColor.getTextColor(), fontSize: MySizes.fontSizeDefault)
                ),
              );
            },
          )),
    );
  }
}
