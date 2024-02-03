import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_task/model/repo/home_repo.dart';
import 'package:my_task/model/response/task_model.dart';
import 'package:my_task/model/response/today_task_model.dart';

class HomeController extends GetxController implements GetxService {
  final HomeRequest homeRequest;
  HomeController({required this.homeRequest});


  List<TaskModel> _taskList = [];
  List<TaskModel> get taskList => _taskList;

  void getTaskList() async{
    Response response  = await homeRequest.getTaskList();
    if(response.statusCode == 200){
      _taskList = [];
      _taskList.addAll(response.body);
    }else{
      debugPrint(response.statusText);
    }
    update();
  }


  List<TodayModel> _todayTaskList = [];
  List<TodayModel> get todayTaskList => _todayTaskList;

  void getTodayTaskList() async{
    Response response  = await homeRequest.getTodayTaskList();
    if(response.statusCode == 200){
      _todayTaskList = [];
      _todayTaskList.addAll(response.body);
    }else{
      debugPrint(response.statusText);
    }
    update();
  }


  DateTime? _selectDate;
  DateTime? get selectDate => _selectDate;

  updateDate(DateTime? value, bool notify) {
    _selectDate = value;
    if (notify) {
      update();
    }
  }


  int _categoryIndex = -1;
  int get categoryIndex => _categoryIndex;

  setCategoryIndex(int index, bool notify){
    _categoryIndex = index;
    if(notify){
      update();
    }
  }

}
