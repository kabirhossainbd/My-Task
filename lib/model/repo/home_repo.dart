import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_task/model/response/task_model.dart';
import 'package:my_task/model/response/today_task_model.dart';
import 'package:my_task/src/data/datasource/remote/http_client.dart';
import 'package:my_task/src/utils/constants/m_images.dart';

class HomeRequest {
  final ApiClient apiSource;
  HomeRequest({required this.apiSource});

  Future<Response> getTaskList() async {
    try {
      List<TaskModel> itemList = [
        TaskModel(id: 0, name: "Application Development", color: const Color(0xFF003A5D), taskNo: '4', createAt: 'January 2024',
        users: [
          Users(id: 0, name: 'Michel', photo: MyImage.image2),
          Users(id: 1, name: 'Mash', photo: MyImage.image4),
        ]),

        TaskModel(id: 1, name: "Quality Assurance", color: const Color(0xFF5C0114), taskNo: '4', createAt: 'February 2023',
            users: [
              Users(id: 0, name: 'Michel', photo: MyImage.image5),
              Users(id: 1, name: 'Mash', photo: MyImage.image6),
              Users(id: 2, name: 'Mash', photo: MyImage.image1),
            ]),


        TaskModel(id: 2, name: "UI/UX Design", color: Colors.blue, taskNo: '4', createAt: 'Jun 2023',
            users: [
              Users(id: 0, name: 'Michel', photo: MyImage.image2),
              Users(id: 1, name: 'Mash', photo: MyImage.image4),
            ]),



        TaskModel(id: 3, name: "Web Development", color: Colors.pink.withOpacity(0.5), taskNo: '4', createAt: 'December 2023',
            users: [
              Users(id: 0, name: 'Michel', photo: MyImage.image6),
              Users(id: 1, name: 'Mash', photo: MyImage.image5),
              Users(id: 2, name: 'Mash', photo: MyImage.image2),
            ])
        ];
      
      Response response = Response(body: itemList, statusCode: 200);
      return response;
    } catch (e) {
      return const Response(statusCode: 404, statusText: 'Item data not found');
    }
  }


  Future<Response> getTodayTaskList() async {
    try {
      List<TodayModel> itemList = [
        TodayModel(id: 0, name: "Ideation", color: const Color(0xFF003A5D),  createAt: 'January 2024',
            users: [
              Users(id: 0, name: 'Michel', photo: MyImage.image2),
              Users(id: 1, name: 'Mash', photo: MyImage.image4),
            ]),

        TodayModel(id: 1, name: "UI/UX Design", color: const Color(0xFF5C0114), createAt: 'February 2023',
            users: [
              Users(id: 0, name: 'Michel', photo: MyImage.image5),
              Users(id: 1, name: 'Mash', photo: MyImage.image6),
              Users(id: 2, name: 'Mash', photo: MyImage.image1),
            ]),


        TodayModel(id: 2, name: "Research", color: Colors.blue, createAt: 'Jun 2023',
            users: [
              Users(id: 0, name: 'Michel', photo: MyImage.image2),
              Users(id: 1, name: 'Mash', photo: MyImage.image4),
            ]),



        TodayModel(id: 3, name: "Validation", color: Colors.red.withOpacity(0.5), createAt: 'December 2023',
            users: [
              Users(id: 0, name: 'Michel', photo: MyImage.image6),
              Users(id: 1, name: 'Mash', photo: MyImage.image5),
              Users(id: 2, name: 'Mash', photo: MyImage.image2),
            ]),

        TodayModel(id: 2, name: "Web Development", color: const Color(0xFF00A884), createAt: 'Jun 2023',
            users: [
              Users(id: 0, name: 'Michel', photo: MyImage.image2),
              Users(id: 1, name: 'Mash', photo: MyImage.image4),
            ]),

        TodayModel(id: 1, name: "Quality Assurance", color: const Color(0xFFFACC15), createAt: 'February 2023',
            users: [
              Users(id: 0, name: 'Michel', photo: MyImage.image5),
              Users(id: 1, name: 'Mash', photo: MyImage.image6),
              Users(id: 2, name: 'Mash', photo: MyImage.image1),
            ]),

        TodayModel(id: 3, name: "Application Development", color: Colors.pink.withOpacity(0.5), createAt: 'December 2023',
            users: [
              Users(id: 0, name: 'Michel', photo: MyImage.image6),
              Users(id: 1, name: 'Mash', photo: MyImage.image5),
              Users(id: 2, name: 'Mash', photo: MyImage.image2),
            ])
      ];

      Response response = Response(body: itemList, statusCode: 200);
      return response;
    } catch (e) {
      return const Response(statusCode: 404, statusText: 'Item data not found');
    }
  }

}
