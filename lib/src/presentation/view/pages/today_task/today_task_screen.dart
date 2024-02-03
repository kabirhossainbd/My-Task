import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:my_task/controller/home_controller.dart';
import 'package:my_task/src/utils/constants/m_colors.dart';
import 'package:my_task/src/utils/constants/m_dimensions.dart';
import 'package:my_task/src/utils/constants/m_styles.dart';

class TodayTaskScreen extends StatefulWidget {
  const TodayTaskScreen({super.key});

  @override
  State<TodayTaskScreen> createState() => _TodayTaskScreenState();
}

class _TodayTaskScreenState extends State<TodayTaskScreen> {

  @override
  void initState() {
   Get.find<HomeController>().getTodayTaskList();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (today) => Scaffold(
        backgroundColor: MyColor.getPrimaryColor(),
        appBar: AppBar(
          toolbarHeight: 0,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: MyColor.getPrimaryColor(),
            statusBarBrightness: Brightness.dark,
            statusBarIconBrightness: Brightness.light
          ),
        ),
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16,12,16,12),
              child: Text('Today', style: robotoRegular.copyWith(color: MyColor.colorWhite, fontSize: MySizes.fontSizeExtraOverLarge),),
            ),

            Builder(
              builder: (context){
                return EasyDateTimeLine(
                  initialDate: DateTime.now(),
                  onDateChange: (selectedDate) {},
                  headerProps: const EasyHeaderProps(
                    padding: EdgeInsets.only(bottom: 12),
                    monthPickerType: MonthPickerType.switcher,
                    dateFormatter: DateFormatter.fullDateDMY(),
                  ),
                  dayProps:  EasyDayProps(
                    height: 80,
                    dayStructure: DayStructure.dayStrDayNum,
                    inactiveDayStyle: DayStyle(
                      dayStrStyle: robotoLight.copyWith(color: MyColor.colorWhite, fontSize: MySizes.fontSizeDefault),
                      dayNumStyle: robotoBold.copyWith(color: MyColor.colorWhite, fontSize: MySizes.fontSizeLarge),
                    ),
                    todayStyle: DayStyle(
                      dayStrStyle: robotoLight.copyWith(color: MyColor.colorWhite, fontSize: MySizes.fontSizeDefault),
                      dayNumStyle: robotoBold.copyWith(color: MyColor.colorWhite, fontSize: MySizes.fontSizeLarge),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(8)),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            const Color(0xFF8FDDDE).withOpacity(0.3),
                            const Color(0xFFF4BDE5).withOpacity(0.3),
                          ],
                        ),
                      ),
                    ),
                    activeDayStyle: DayStyle(
                      dayStrStyle: robotoLight.copyWith(color: MyColor.colorWhite, fontSize: MySizes.fontSizeDefault),
                      dayNumStyle: robotoBold.copyWith(color: MyColor.colorWhite, fontSize: MySizes.fontSizeLarge),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xff3371FF),
                            Color(0xff8426D6),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            )
          ],
        ),
        bottomSheet: Container(
          color: MyColor.getPrimaryColor(),
          child: Container(
            height: Get.height * 0.55,
            decoration: BoxDecoration(
              color: MyColor.getBackgroundColor(),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(40))
            ),
            child: Column(
              children: [
                if(today.todayTaskList.isNotEmpty)...[
                  const SizedBox(height: 14),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16,0,16,8),
                      itemCount: today.todayTaskList.length,
                      itemBuilder: (_, index){
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          padding: const EdgeInsets.only(right: 12),
                          decoration: BoxDecoration(
                              color: MyColor.getBackgroundColor(),
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                    color: MyColor.getBorderColor(),
                                    spreadRadius: 5,
                                    blurRadius: 5,
                                    offset: const Offset(2,2)
                                )
                              ]
                          ),
                          child: Row( crossAxisAlignment: CrossAxisAlignment.center, mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                height: Get.height * 0.09,
                                width: 8,
                                decoration: BoxDecoration(
                                    color: today.todayTaskList[index].color,
                                  borderRadius: const BorderRadius.horizontal(left: Radius.circular(8))
                                ),
                              ),
                              const SizedBox(width: 12,),
                              Expanded(
                                child: Column( crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(today.todayTaskList[index].name ?? '', style: robotoRegular.copyWith(color: MyColor.getTextColor(), fontSize: MySizes.fontSizeLarge), overflow: TextOverflow.ellipsis, maxLines: 1,),
                                    const SizedBox(height: 4),
                                    SizedBox(
                                      height: 26,
                                      child: ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: today.todayTaskList[index].users!.length > 3 ? 3 : today.todayTaskList[index].users!.length,
                                          scrollDirection: Axis.horizontal,
                                          physics: const NeverScrollableScrollPhysics(),
                                          itemBuilder: (_, idx){
                                            return Padding(
                                              padding: const EdgeInsets.all(2.0),
                                              child: ClipOval(child: Image.asset(today.todayTaskList[index].users![idx].photo ?? '',height: 24, width: 24, fit: BoxFit.cover)),
                                            );
                                          }),
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(today.todayTaskList[index].createAt ?? '', style: robotoRegular.copyWith(color: MyColor.getGreyColor(), fontSize: MySizes.fontSizeLarge),),
                              const SizedBox(width: 6)
                            ],
                          ),
                        );
                      },
                    ),
                  )
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }
}
