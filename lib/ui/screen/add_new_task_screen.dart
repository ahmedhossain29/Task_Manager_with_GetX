import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data_network_caller/network_caller.dart';
import '../../data_network_caller/network_response.dart';
import '../../data_network_caller/utility/urls.dart';
import '../controllers/new_task_controller.dart';
import '../widgets/body_background.dart';
import '../widgets/profile_widget.dart';
import '../widgets/snack_message.dart';

class AddNewTaskScreen extends StatefulWidget {
  const AddNewTaskScreen({super.key});

  @override
  State<AddNewTaskScreen> createState() => _AddNewTaskScreenState();
}

class _AddNewTaskScreenState extends State<AddNewTaskScreen> {
  final TextEditingController _subjectTEController = TextEditingController();
  final TextEditingController _descriptionTEController =
      TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _createTaskInProgress = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(children: [
          const ProfileSummaryCard(),
          Expanded(
            child: BodyBackground(
              child: SingleChildScrollView(
                  child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 32,
                      ),
                      Text(
                        'Add New Task',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      TextFormField(
                        controller: _subjectTEController,
                        decoration: const InputDecoration(
                          hintText: 'Subject',
                        ),
                        validator: (String? value) {
                          if (value?.trim().isEmpty ?? true) {
                            return 'Enter your subject';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: _descriptionTEController,
                        maxLines: 5,
                        decoration: const InputDecoration(
                          hintText: 'Description',
                        ),
                        validator: (String? value) {
                          if (value?.trim().isEmpty ?? true) {
                            return 'Enter your subject';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: Visibility(
                          visible: _createTaskInProgress == false,
                          replacement: const Center(
                            child: CircularProgressIndicator(),
                          ),
                          child: ElevatedButton(
                            onPressed: createTask,
                            child:
                                const Icon(Icons.arrow_circle_right_outlined),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )),
            ),
          ),
        ]),
      ),
    );
  }

  //Add New Task

  Future<void> createTask() async {
    if (_formKey.currentState!.validate()) {
      _createTaskInProgress = true;
      if (mounted) {
        setState(() {});
      }
      final NetworkResponse response =
          await NetworkCaller().postRequest(Urls.createNewTask, body: {
        "title": _subjectTEController.text.trim(),
        "description": _descriptionTEController.text.trim(),
        "status": "New"
      });
      _createTaskInProgress = false;
      if (mounted) {
        setState(() {});
      }
      if (response.isSuccess) {
        _subjectTEController.clear();
        _descriptionTEController.clear();
        Get.find<NewTaskController>().getNewTaskList();
        if (mounted) {
          showSnackMessage(context, 'New task added!');
        }
      } else {
        if (mounted) {
          showSnackMessage(context, 'Create new Task failed! Try Again', true);
        }
      }
    }
  }

  @override
  void dispose() {
    _subjectTEController.dispose();
    _descriptionTEController.dispose();
    super.dispose();
  }
}
