import 'package:get/get.dart';
import 'package:taskmanagerwithgetx/data_network_caller/models/task_count_summary_model.dart';
import 'package:taskmanagerwithgetx/data_network_caller/network_caller.dart';
import 'package:taskmanagerwithgetx/data_network_caller/network_response.dart';
import 'package:taskmanagerwithgetx/data_network_caller/utility/urls.dart';

class GetTaskCountSummaryListController extends GetxController {
  TaskCountSummaryListModel taskCountSummaryListModel =
      TaskCountSummaryListModel();
  bool _getTaskCountSummaryInProgress = true;
  bool get getTaskCountSummaryInProgress => _getTaskCountSummaryInProgress;

  Future<void> getTaskCountSummaryList() async {
    _getTaskCountSummaryInProgress = true;
    update();
    final NetworkResponse response =
        await NetworkCaller().getRequest(Urls.getTaskStatusCount);
    if (response.isSuccess) {
      taskCountSummaryListModel =
          TaskCountSummaryListModel.fromJson(response.jsonResponse);
    }
    _getTaskCountSummaryInProgress = false;
    update();
  }
}
