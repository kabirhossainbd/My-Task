
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:my_task/model/response/item_model.dart';
import 'package:my_task/src/utils/constants/m_colors.dart';
import 'package:my_task/src/utils/constants/m_dimensions.dart';
import 'package:my_task/src/utils/constants/m_styles.dart';

class ItemView extends StatelessWidget {
  final ItemModel itemModel;
  final int index;
  const ItemView({Key? key, required this.itemModel, this.index = 0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){

      },
      child: Container(
        height: 90,
        width: 70,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(MySizes.paddingSizeSmall),
        margin: const EdgeInsets.fromLTRB(0,0,8,0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
           color: MyColor.getSurfaceColor(),
          boxShadow: [BoxShadow(
              color: MyColor.getGreyColor().withOpacity(0.2),
              blurRadius: 0.1,
              spreadRadius: 0.2,
              offset: const Offset(0,1)
          )],
        ),
        child: Stack( clipBehavior: Clip.none,
          children: [
            Positioned(top: -50,left: 0,right: 0,child: Container(
                height: 50,
                width: 50,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFF25D366),
                        Color(0xFF00A884),
                      ]),
                ),
                child: SvgPicture.asset(itemModel.image ?? '',color: MyColor.getBackgroundColor(), height: 70, width: 60,fit: BoxFit.scaleDown,))),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(itemModel.name!.tr, style: robotoRegular.copyWith(color: MyColor.getTextColor(), fontSize: MySizes.paddingSizeDefault), textAlign: TextAlign.center,),
            ),
          ],
        ),
      ),
    );
  }
}
