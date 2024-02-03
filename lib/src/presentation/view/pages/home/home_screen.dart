import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:my_task/controller/auth_controller.dart';
import 'package:my_task/controller/home_controller.dart';
import 'package:my_task/model/response/task_model.dart';
import 'package:my_task/services/apis.dart';
import 'package:my_task/src/utils/constants/m_colors.dart';
import 'package:my_task/src/utils/constants/m_dimensions.dart';
import 'package:my_task/src/utils/constants/m_styles.dart';

class HomeScreen extends StatefulWidget {
  final User? user;
  const HomeScreen({Key? key, this.user}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  @override
  void initState() {
    Get.find<HomeController>().getTaskList();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: MyColor.getBackgroundColor(),
        appBar: AppBar(
          toolbarHeight: 0,
          backgroundColor: MyColor.getBackgroundColor(),
          systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: MyColor.getBackgroundColor(),
              statusBarBrightness: Brightness.dark,
              statusBarIconBrightness: Brightness.dark
          ),
        ),
        body: SafeArea(
          child: GetBuilder<AuthController>(
            builder: (auth) => GetBuilder<HomeController>(
              builder: (home) => RefreshIndicator(
                backgroundColor: Colors.white,
                color: const Color(0xFF434345),
                onRefresh: () async {},
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [

                    /// for app bar
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      child: Row(
                        children: [
                          ClipOval(
                            child: Container(
                              decoration: BoxDecoration(
                                color: MyColor.getSecondaryColor()
                              ),
                              child: CachedNetworkImage(
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                                imageUrl: APIs.me.image,
                                placeholder: (url, error) => const Icon(CupertinoIcons.person, size: 40,),
                                errorWidget: (context, url, error) => const Icon(CupertinoIcons.person, size: 40,),
                              ),
                            ),
                          ),

                          Expanded(
                              child: Column(
                                children: [
                                  Text(APIs.me.name.isNotEmpty ? APIs.me.name : APIs.me.email, style: robotoBold.copyWith(color: MyColor.getTextColor(), fontSize: MySizes.fontSizeExtraLarge),),
                                  Text(APIs.me.about, style: robotoRegular.copyWith(color: MyColor.getTextColor(), fontSize: MySizes.fontSizeSmall),),
                                ],
                              ),
                          ),

                          GestureDetector(
                            child: Container(
                              height: 40,
                              width: 40,
                              decoration:  BoxDecoration(
                                color: MyColor.getPrimaryColor(),
                                shape: BoxShape.circle
                              ),
                              child: const Icon(CupertinoIcons.bell),
                            ),
                          )
                        ],
                      ),
                    ),


                    /// for search
                    InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      // onTap: () => Navigator.push(context, PageTransition(type: PageTransitionType.bottomToTop, child: const SearchScreen(isActiveSearch: true))),
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

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text('Project', style: robotoRegular.copyWith(color: MyColor.getTextColor(), fontSize: MySizes.fontSizeExtraLarge)),
                    ),

                    const SizedBox(height: MySizes.marginSizeMiniSmall,),

                    /// for tasks list
                    AspectRatio(
                      aspectRatio: 1/0.5,
                      child: ListView.builder(
                          padding: const EdgeInsets.symmetric(vertical: MySizes.paddingSizeExtraSmall, horizontal: 16),
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: home.taskList.length,
                          itemBuilder: (context, index) => _buildItem(home.taskList[index]),
                      ),
                    ),


                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column( crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: MySizes.marginSizeLarge,),
                          Text('My Task', style: robotoRegular.copyWith(color: MyColor.getTextColor(), fontSize: MySizes.fontSizeExtraLarge)),

                          const SizedBox(height: MySizes.marginSizeMiniSmall,),
                          _myTaskItem(Icons.menu, 'To Do', '10 Task', '1 started'),
                          const SizedBox(height: MySizes.paddingSizeDefault),
                          _myTaskItem(Icons.loop_outlined, 'On Progress', '10 Task', '3 progress'),
                          const SizedBox(height: MySizes.paddingSizeDefault),
                          _myTaskItem(Icons.check, 'Done', '10 Task', '10 complete'),
                        ],
                      ),
                    )

                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _myTaskItem(IconData icon, String title, String value, String statusName){
    return Row(
      children: [
        Container(
            height: 40,
            width: 40,
            decoration:  BoxDecoration(
                color: MyColor.getPrimaryColor(),
                shape: BoxShape.circle
            ),
            child: Icon(icon)),
        const SizedBox(width: 12),
        Expanded(
            child: Column( crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: robotoExtraBold.copyWith(color: MyColor.getPrimaryColor(), fontSize: MySizes.fontSizeExtraLarge, fontWeight: FontWeight.w900),),
                const SizedBox(height: 2,),
                Row(
                  children: [
                    Text(value, style: robotoRegular.copyWith(color: MyColor.getTextColor(), fontSize: MySizes.fontSizeDefault),),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      width: 10,
                      height: 2,
                      color: MyColor.getGreyColor(),
                    ),
                    Text(statusName, style: robotoRegular.copyWith(color: MyColor.getGreyColor(), fontSize: MySizes.fontSizeDefault),),
                  ],
                ),
              ],
            )),

      ],
    );
  }

  Widget _buildItem(TaskModel taskModel){
    return InkWell(
      onTap: (){},
      child: Container(
        width: 155,
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: taskModel.color,
          boxShadow:  [BoxShadow(color: taskModel.color!.withOpacity(0.2), spreadRadius: 2, blurRadius: 2, offset: const Offset(2,2))]
        ),
        child: Column( mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('${taskModel.taskNo} Task', style: robotoLight.copyWith(color: MyColor.getBackgroundColor().withOpacity(0.5), fontSize: 12), textAlign: TextAlign.center,),
            const SizedBox(height: 6),
            Text(taskModel.name ?? '', style:  robotoBold.copyWith(color: MyColor.colorWhite, fontSize: MySizes.fontSizeLarge), textAlign: TextAlign.center,),
            const SizedBox(height: 6),
            Text(taskModel.createAt ?? '', style:  robotoLight.copyWith(color: MyColor.getBackgroundColor().withOpacity(0.5), fontSize: 12), textAlign: TextAlign.center,),
            const SizedBox(height: 6),
            SizedBox(
              height: 32,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: taskModel.users!.length > 3 ? 3 : taskModel.users!.length,
                  scrollDirection: Axis.horizontal,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (_, index){
                return Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: ClipOval(child: Image.asset(taskModel.users![index].photo ?? '',height: 30, width: 30, fit: BoxFit.cover)),
                );
              }),
            )
          ],
        ),
      ),
    );
  }

}



class SlideItem extends StatefulWidget {
  final String image;
  const SlideItem({Key? key, required this.image}) : super(key: key);

  @override
  State<SlideItem> createState() => _SlideItemState();
}

class _SlideItemState extends State<SlideItem> {

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: MyColor.colorWhite,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: MyColor.colorWhite, width: 0.5)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: CachedNetworkImage(
            imageUrl: '',
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
            fadeInDuration: const Duration(seconds: 1),
            errorWidget: (context, exception, stacktrace) =>  Image.asset(widget.image, fit: BoxFit.cover,),
            placeholder: (_, name)=> Image.asset(widget.image, fit: BoxFit.cover,)
        ),
      ),
    );
  }
}

