import 'package:get/get.dart';

import '../../data_network_caller/models/task_list_model.dart';
import '../../data_network_caller/network_caller.dart';
import '../../data_network_caller/network_response.dart';
import '../../data_network_caller/utility/urls.dart';

class ProgressTaskController extends GetxController {
  bool _getProgressTaskInProgress = false;
  TaskListModel _taskListModel = TaskListModel();

  bool get getProgressTaskInProgress => _getProgressTaskInProgress;
  TaskListModel get taskListModel => _taskListModel;

  Future<bool> getProgressTaskList() async {
    bool isSuccess = false;
    _getProgressTaskInProgress = true;

    final NetworkResponse response =
        await NetworkCaller().getRequest(Urls.getProgressTasks);
    if (response.isSuccess) {
      _taskListModel = TaskListModel.fromJson(response.jsonResponse);
      isSuccess = true;
    }
    update();
    return isSuccess;
  }
}
