import 'package:circles_yes_no/controllers/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/pass_rate_controller.dart';

class SettingsScreen extends StatefulWidget {
  final UserController userController;
  const SettingsScreen({super.key, required this.userController});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final PassRateController _passRateController = Get.put(PassRateController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          ElevatedButton(
              onPressed: () {
                widget.userController.deleteFireStoreCollection();
              },
              child: const Text('Voting End'))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28.0),
        child: Obx(
          () => Column(
            children: [
              Text(
                'Total Voters: ${widget.userController.users.length}',
                style:
                    const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                child: CheckboxListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 22),
                  title: const Text(
                    'Pass Count',
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                  ),
                  subtitle: widget.userController.showPassRate.value
                      ? Text(
                          widget.userController.passRate.value.toString(),
                          style: const TextStyle(fontSize: 40),
                        )
                      : null,
                  value: widget.userController.showPassRate.value,
                  onChanged: (val) {
                    widget.userController.showPassRate.value = val ?? true;
                  },
                ),
              ),
              Slider(
                value: widget.userController.sliderPercentage.value.toDouble(),
                min: 0.0,
                max: 100.0,
                onChanged: (val) {
                  widget.userController.sliderPercentage.value =
                      double.parse(val.toStringAsFixed(0));
                  widget.userController.outOrIn();
                },
                onChangeEnd: (val) {
                  _passRateController.updatePercentageValue(
                      double.parse(val.toStringAsFixed(0)));
                },
              ),
              Text(
                "${widget.userController.sliderPercentage.value}%",
                style:
                    const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.userController.users.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Text(
                      '${widget.userController.users[index].name}: ${widget.userController.users[index].vote}',
                      style: const TextStyle(
                          fontSize: 40, fontWeight: FontWeight.bold),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
