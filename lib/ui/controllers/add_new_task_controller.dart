import 'package:get/get.dart';
import 'package:taskmanagerwithgetx/data_network_caller/network_caller.dart';
import 'package:taskmanagerwithgetx/data_network_caller/network_response.dart';
import 'package:taskmanagerwithgetx/data_network_caller/utility/urls.dart';
import 'package:taskmanagerwithgetx/ui/controllers/new_task_controller.dart';

class AddNewTaskController extends GetxController {
  String _message = '';
  String _errormessage = '';
  String get message => _message;
  String get errormessage => _errormessage;

  bool _createTaskInProgress = false;
  bool get createTaskInProgress => _createTaskInProgress;

  Future<void> createTask(
    String title,
    String desccription,
  ) async {
    _createTaskInProgress = false;
    update();

    final NetworkResponse response = await NetworkCaller().postRequest(
        Urls.createNewTask,
        body: {"title": title, "description": desccription, "status": "New"});
    _createTaskInProgress = false;
    update();
    if (response.isSuccess) {
      Get.find<NewTaskController>().getNewTaskList();
      _message = 'New task added!';
    } else {
      _errormessage = 'Create new Task failed! Try Again';
    }
  }
}
