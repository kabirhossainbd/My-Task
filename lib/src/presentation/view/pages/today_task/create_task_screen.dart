import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_task/controller/home_controller.dart';
import 'package:my_task/src/presentation/view/component/custom_text_field.dart';
import 'package:my_task/src/presentation/view/component/m_button.dart';
import 'package:my_task/src/utils/constants/m_colors.dart';
import 'package:my_task/src/utils/constants/m_custom_date_converter.dart';
import 'package:my_task/src/utils/constants/m_dimensions.dart';
import 'package:my_task/src/utils/constants/m_images.dart';
import 'package:my_task/src/utils/constants/m_styles.dart';
import 'package:time_picker_spinner/time_picker_spinner.dart';

class CreateTaskScreen extends StatefulWidget {
  const CreateTaskScreen({super.key});

  @override
  State<CreateTaskScreen> createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {

  final TextEditingController _titleController = TextEditingController();
  final FocusNode _titleFocus = FocusNode();

  final TextEditingController _desController = TextEditingController();
  final FocusNode _desFocus = FocusNode();

  DateTime dateTime = DateTime.now();
  DateTime setTime = DateTime.now();

  final List<String> _categoryList = ['Meeting', 'Discussion', 'Briefing'];
  final List<String> _teamList = [MyImage.image2, MyImage.image5, MyImage.image3];

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (home) => Scaffold(
        backgroundColor: MyColor.getBackgroundColor(),
        body: SafeArea(
          child: GestureDetector(
            onTap: ()=> FocusScope.of(context).unfocus(),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.all(16),
                      children: [

                        const SizedBox(height: MySizes.paddingSizeLarge,),
                        Text('New Task', style: robotoRegular.copyWith(color: MyColor.getTextColor(), fontSize: MySizes.fontSizeExtraLarge),),


                        /// for address
                        const SizedBox(height: MySizes.paddingSizeLarge,),
                        CustomTextFieldWithLevel(
                          controller: _titleController,
                          focusNode: _titleFocus,
                          hintText: 'Title',
                          fillColor: MyColor.colorWhite,
                          inputAction: TextInputAction.next,
                          inputType: TextInputType.text,
                          backgroundColor: MyColor.colorWhite,
                          alignment: TextAlign.start,
                          isPassword: true,
                          isShowSuffixIcon: true,
                          onSuffixIcon: _titleController.text.isNotEmpty ? IconButton(onPressed: (){
                            setState(() {
                              _titleController.clear();
                            });
                          }, icon: const Icon(Icons.clear),) : null,
                          borderRadius: BorderRadius.circular(8),
                          onChanged: (text)=>setState(() {}),
                        ),
                        const SizedBox(height: MySizes.paddingSizeLarge,),

                        Row(
                          children: [
                            Expanded(
                              child: Column( crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Date', style: robotoRegular.copyWith(color: MyColor.getTextColor(), fontSize: MySizes.fontSizeDefault),),
                                  const SizedBox(height: 10),
                                  GestureDetector(
                                    onTap: () async{
                                      DateTime? dateTime = await getDate(context);
                                      if(dateTime != null) {
                                        home.updateDate(dateTime, true);
                                      }
                                    },
                                    child: Row(
                                      children: [
                                        Expanded(child:  Text(home.selectDate != null ? MyDateConverter.convertTaskTime(home.selectDate!) : 'Select date', style: robotoRegular.copyWith(color: MyColor.getGreyColor(), fontSize: MySizes.fontSizeDefault),)),
                                        Icon(CupertinoIcons.calendar_today, color: MyColor.getSecondaryColor(),)
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    height: 2,width: double.infinity,
                                    color: MyColor.getGreyColor(),
                                  )

                                ],
                              ),
                            ),
                            const SizedBox(width: 30),
                            Expanded(
                              child: Column( crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Time', style: robotoRegular.copyWith(color: MyColor.getTextColor(), fontSize: MySizes.fontSizeDefault),),
                                  const SizedBox(height: 10),
                                  GestureDetector(
                                    onTap: (){
                                      _timeDialog(home);
                                    },
                                    child: Row(
                                      children: [
                                        Expanded(child: Text(MyDateConverter.isoStringToLocalTimeOnly(setTime), style: robotoRegular.copyWith(color: MyColor.getGreyColor(), fontSize: MySizes.fontSizeDefault),)),
                                        Icon(CupertinoIcons.timer, color: MyColor.getSecondaryColor(),)
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    height: 2,width: double.infinity,
                                    color: MyColor.getGreyColor(),
                                  )

                                ],
                              ),
                            ),
                          ],
                        ),


                        const SizedBox(height: MySizes.fontSizeExtraOverLarge,),
                        CustomTextFieldWithLevel(
                          controller: _desController,
                          focusNode: _desFocus,
                          hintText: 'Description',
                          fillColor: MyColor.colorWhite,
                          inputAction: TextInputAction.next,
                          inputType: TextInputType.text,
                          backgroundColor: MyColor.colorWhite,
                          alignment: TextAlign.start,
                          isPassword: true,
                          isShowSuffixIcon: true,
                          onSuffixIcon: _desController.text.isNotEmpty ? IconButton(onPressed: (){
                            setState(() {
                              _desController.clear();
                            });
                          }, icon: const Icon(Icons.clear),) : null,
                          borderRadius: BorderRadius.circular(8),
                          onChanged: (text)=>setState(() {}),
                        ),


                        /// for category
                        const SizedBox(height: MySizes.fontSizeExtraOverLarge,),
                        Text('Categories', style: robotoRegular.copyWith(color: MyColor.getTextColor(), fontSize: MySizes.fontSizeDefault),),
                        const SizedBox(height: MySizes.paddingSizeSmall,),
                        Row(
                          children: _categoryList.map((item){
                            int index = _categoryList.indexOf(item);
                            return GestureDetector(
                              onTap: ()=> home.setCategoryIndex(index, true),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                margin: const EdgeInsets.only(right: 12),
                                decoration: BoxDecoration(
                                  color: home.categoryIndex == index ? MyColor.getPrimaryColor() : MyColor.getGreyColor(),
                                  borderRadius: BorderRadius.circular(16)
                                ),
                                child: Text(item, style: robotoRegular.copyWith(color: home.categoryIndex == index ? MyColor.colorWhite : MyColor.getBorderColor(), fontSize: MySizes.fontSizeDefault),),
                              ),
                            );
                          }).toList(),
                        ),


                        /// for team
                        const SizedBox(height: MySizes.fontSizeExtraOverLarge,),
                        Text('Teams', style: robotoRegular.copyWith(color: MyColor.getTextColor(), fontSize: MySizes.fontSizeDefault),),
                        const SizedBox(height: MySizes.paddingSizeSmall,),
                        Row(
                          children: _teamList.map((item){
                            int index = _teamList.indexOf(item);
                            return GestureDetector(
                              onTap: ()=> home.setCategoryIndex(index, true),
                              child: Padding(
                                padding: const EdgeInsets.only(right: 12.0),
                                child: ClipOval(child: Image.asset(item, width: 60, height: 60, fit: BoxFit.cover,)),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                  /// for button
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: CustomButton(text: 'CREATE TASK', onTap: (){}),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// for date
  Future<DateTime?> getDate(BuildContext context) {
    return showDatePicker(

      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      selectableDayPredicate: (DateTime val) => true,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
              datePickerTheme: DatePickerThemeData(
                backgroundColor: Colors.white,
                headerBackgroundColor: MyColor.getPrimaryColor(),
                headerForegroundColor: MyColor.colorWhite,

              ),
              colorScheme: ColorScheme(
                  background: Colors.cyanAccent,
                  onBackground: Colors.cyanAccent,
                  brightness: Brightness.light,
                  primary: MyColor.getPrimaryColor(),
                  onPrimary: MyColor.colorWhite,
                  onPrimaryContainer: Colors.white,
                  secondary: Colors.pink,
                  onSecondary: Colors.pink,
                  error: Colors.red,
                  onError: Colors.red,
                  surface: MyColor.getTextColor(),
                  onSurface: MyColor.getTextColor())
          ),
          child: child!,
        );
      },
    );
  }

  _timeDialog(HomeController controller){
    return Get.dialog(Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      backgroundColor: MyColor.getBackgroundColor(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: ()=> Get.back(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
              child: Container(alignment: Alignment.center,width: 40, height: 3,decoration: BoxDecoration(color: MyColor.getGreyColor(), borderRadius: BorderRadius.circular(10))),
            ),
          ),

          const SizedBox(height: 16),
          Text('Set time', style: robotoBold.copyWith(color: MyColor.getTextColor(), fontSize: MySizes.fontSizeDefault),),

          const SizedBox(height: 16),
          TimePickerSpinner(
            locale: const Locale('en', ''),
            time: dateTime,
            is24HourMode: false,
            isShowSeconds: false,
            itemHeight: 80,
            alignment: Alignment.center,
            normalTextStyle: robotoRegular.copyWith(color: MyColor.getTextColor(), fontSize: MySizes.fontSizeSmall),
            highlightedTextStyle: robotoBold.copyWith(color: MyColor.getTextColor(), fontSize: MySizes.fontSizeSmall),
            isForce2Digits: true,
            onTimeChange: (time) {
              setState(() {
                dateTime = time;
              });
            },
          ),

          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Divider(color: MyColor.getBorderColor(), thickness: 1,),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(child: GestureDetector(
                  onTap: Get.back,
                  child: Container(
                    height: 44,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color:MyColor.getBackgroundColor(),
                        border: Border.all(color: MyColor.getGreyColor().withOpacity(0.5)),
                        borderRadius: BorderRadius.circular(50)
                    ),
                    child: Text('Cancel',
                      style: robotoBold.copyWith(
                          fontSize: MySizes.fontSizeDefault,
                          color: MyColor.getTextColor()
                      ), textAlign: TextAlign.center,),
                  ),
                )),

                const SizedBox(width: 20),

                Expanded(child: CustomButton(text: 'Set', onTap: (){
                  setState(() {
                    setTime = dateTime;
                  });
                  Get.back();
                },
                )),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    ));
  }

}
