import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_task/src/utils/constants/m_colors.dart';
import 'package:my_task/src/utils/constants/m_dimensions.dart';
import 'package:my_task/src/utils/constants/m_styles.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool? isBackButtonExist, isShowCoin;
  final VoidCallback? onBackPressed;
  final VoidCallback? onTab;
  final IconData? icon;
  final String? leadingIcon, actionText;

  const CustomAppBar({Key? key, required this.title, this.isBackButtonExist = true, this.isShowCoin = true, this.onBackPressed, this.onTab, this.icon,this.leadingIcon, this.actionText }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row( crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(title.tr, style: robotoLight.copyWith(fontSize: 22, color: MyColor.colorWhite,),textDirection: TextDirection.ltr,)),

          if(isShowCoin!)...[
            InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              hoverColor: Colors.transparent,
              focusColor: Colors.transparent,
              onTap: onTab,
              child: Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.fromLTRB(6,8,10,4),
                padding: const EdgeInsets.fromLTRB(8,4,8,4),
                decoration:  BoxDecoration(
                    boxShadow: [BoxShadow(
                        color: MyColor.getGreyColor().withOpacity(0.1),
                        blurRadius: 0.1,
                        spreadRadius: 0.2,
                        offset: const Offset(0,0)
                    )],
                    borderRadius: BorderRadius.circular(4),
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                     // stops: const [1,0.2],
                      colors: [
                        const Color(0xFF25D366),
                        const Color(0xFF1BAC4B).withOpacity(0.36),
                      ],)
                ),
                child: Row(
                  children: [
                    Text('10000', style: robotoRegular.copyWith(fontSize: MySizes.fontSizeDefault,
                      color: MyColor.colorWhite,
                    )),
                    const SizedBox(width: MySizes.paddingSizeExtraSmall,),
                   // SvgPicture.asset(MyImage.star, width: 18,height: 19,),
                  ],
                ),
              ),
            ),
          ]
        ],
      ),
      leading: isBackButtonExist! ? IconButton(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        focusColor: Colors.transparent,
        icon: const Icon(Icons.arrow_back, color: MyColor.colorWhite, size: 20,),
        onPressed: () => onBackPressed != null ? onBackPressed!() : Get.back(canPop: true),
      ) : const SizedBox(),
      leadingWidth: isBackButtonExist! ? 50 : 10,
      elevation: 1,
      centerTitle: false,
      backgroundColor: MyColor.colorPrimary,
      shadowColor: MyColor.colorBlack.withOpacity(0.12),
      bottomOpacity: 0.3,
      automaticallyImplyLeading: false,
      titleSpacing: 10,
    );
  }

  @override
  Size get preferredSize => const Size(double.maxFinite, 50);
}
