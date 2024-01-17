import 'package:circles_yes_no/controllers/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsScreen extends StatefulWidget {
  final UserController userController;
  const SettingsScreen({super.key, required this.userController});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Obx(() => Text(_userController.users.length.toString())),
        actions: [
          ElevatedButton(
              onPressed: () {
                widget.userController.deleteFireStoreCollection();
              },
              child: const Text('Reset'))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28.0),
        child: Obx(
          () => Column(
            children: [
              Text('Total Voters: ${widget.userController.users.length}'),
              Slider(
                  value:
                      widget.userController.sliderPercentage.value.toDouble(),
                  min: 0.0,
                  max: 100.0,
                  onChanged: (val) {
                    widget.userController.sliderPercentage.value =
                        double.parse(val.toStringAsFixed(1));
                    widget.userController.outOrIn();
                  }),
              Text("${widget.userController.sliderPercentage.value}%"),
              SizedBox(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.userController.users.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Text(
                        '${widget.userController.users[index].name}: ${widget.userController.users[index].vote}');
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
