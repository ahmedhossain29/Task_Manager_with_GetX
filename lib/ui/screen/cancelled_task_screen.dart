import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskmanagerwithgetx/data_network_caller/models/task_list_model.dart';
import 'package:taskmanagerwithgetx/ui/controllers/cancelled_task_controller.dart';

import '../widgets/profile_widget.dart';
import '../widgets/task_item_card.dart';

class CancelledTaskScreen extends StatefulWidget {
  const CancelledTaskScreen({super.key});

  @override
  State<CancelledTaskScreen> createState() => _CancelledTaskScreenState();
}

class _CancelledTaskScreenState extends State<CancelledTaskScreen> {
    TaskListModel taskListModel = TaskListModel();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Get.find<CancelledTaskController>().getCancelledTaskList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const ProfileSummaryCard(),
            Expanded(
              child: GetBuilder<CancelledTaskController>(
                  builder: (cancelledTaskController) {
                return Visibility(
                  visible: cancelledTaskController.getCancelledTaskInProgress ==
                      false,
                  replacement: const Center(child: CircularProgressIndicator()),
                  child: RefreshIndicator(
                    onRefresh: cancelledTaskController.getCancelledTaskList,
                    child: ListView.builder(
                      itemCount: cancelledTaskController
                              .taskListModel.taskList?.length ??
                          0,
                      itemBuilder: (context, index) {
                        return TaskItemCard(
                          task: cancelledTaskController
                              .taskListModel.taskList![index],
                          onStatusChange: () {
                            cancelledTaskController.getCancelledTaskList();
                          },
                          showProgress: (inProgress) {},
                        );
                      },
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
//
