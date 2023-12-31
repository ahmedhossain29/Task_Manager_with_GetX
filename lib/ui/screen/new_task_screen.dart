import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:taskmanagerwithgetx/ui/controllers/get_task_count_summary_list_controller.dart';
import 'package:taskmanagerwithgetx/ui/controllers/new_task_controller.dart';

import '../../data_network_caller/models/task_count.dart';
import '../../data_network_caller/models/task_count_summary_model.dart';
import '../widgets/profile_widget.dart';
import '../widgets/summary_card_widget.dart';
import '../widgets/task_item_card.dart';
import 'add_new_task_screen.dart';

class NewTasksScreen extends StatefulWidget {
  const NewTasksScreen({super.key});

  @override
  State<NewTasksScreen> createState() => _NewTasksScreenState();
}

class _NewTasksScreenState extends State<NewTasksScreen> {
  // bool getTaskCountSummaryInProgress = false;
  TaskCountSummaryListModel taskCountSummaryListModel =
      TaskCountSummaryListModel();
  final GetTaskCountSummaryListController _getTaskCountSummaryListController =
      Get.find<GetTaskCountSummaryListController>();
  Future<void> getTaskCountSummaryList() async {
    final response =
        await _getTaskCountSummaryListController.getTaskCountSummaryList();
  }

  @override
  void initState() {
    super.initState();
    getTaskCountSummaryList();
    Get.find<NewTaskController>().getNewTaskList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddNewTaskScreen(),
            ),
          );

          getTaskCountSummaryList();
          Get.find<NewTaskController>().getNewTaskList();
        },
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const ProfileSummaryCard(),
            Visibility(
              visible: _getTaskCountSummaryListController
                          .getTaskCountSummaryInProgress ==
                      false &&
                  (_getTaskCountSummaryListController.taskCountSummaryListModel
                          .taskCountList?.isNotEmpty ??
                      false),
              replacement: const LinearProgressIndicator(),
              child: SizedBox(
                height: 120,
                child: GetBuilder<GetTaskCountSummaryListController>(
                    builder: (getTaskCountSummaryList) {
                  return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: getTaskCountSummaryList
                              .taskCountSummaryListModel
                              .taskCountList
                              ?.length ??
                          0,
                      itemBuilder: (context, index) {
                        TaskCount taskCount = getTaskCountSummaryList
                            .taskCountSummaryListModel.taskCountList![index];
                        return FittedBox(
                          child: SummaryCard(
                            count: taskCount.sum.toString(),
                            title: taskCount.sId ?? '',
                          ),
                        );
                      });
                }),
              ),
            ),
            Expanded(
              child:
                  GetBuilder<NewTaskController>(builder: (newTaskController) {
                return Visibility(
                  visible: newTaskController.getNewTaskInProgress == false,
                  replacement: const Center(child: CircularProgressIndicator()),
                  child: RefreshIndicator(
                    onRefresh: () => newTaskController.getNewTaskList(),
                    child: ListView.builder(
                      itemCount:
                          newTaskController.taskListModel.taskList?.length ?? 0,
                      itemBuilder: (context, index) {
                        return TaskItemCard(
                          task:
                              newTaskController.taskListModel.taskList![index],
                          onStatusChange: () {
                            getTaskCountSummaryList();
                            newTaskController.getNewTaskList();
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
