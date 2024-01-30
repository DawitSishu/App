import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:task_app/Models/task_model.dart';
import 'package:intl/intl.dart';

class InputBox extends StatefulWidget {
  const InputBox({
    Key? key,
    this.inputLabel,
    this.placeHolder,
    this.textArea = false,
    this.update,
    this.customController,
  }) : super(key: key);

  final inputLabel;
  final placeHolder;
  final textArea;
  final customController;
  final update;

  @override
  _InputBoxState createState() => _InputBoxState();
}

class _InputBoxState extends State<InputBox> {
  TextEditingController controller = TextEditingController();
  bool showError = false;
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    focusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    focusNode.removeListener(_handleFocusChange);
    focusNode.dispose();
    controller.dispose();
    super.dispose();
  }

  void _validateInput() {
    final inputValue = controller.text.trim();
    final hasInput = inputValue.isNotEmpty;
    setState(() {
      showError = !hasInput;
    });
  }

  void _handleFocusChange() {
    if (!focusNode.hasFocus) {
      _validateInput();
    }
  }

  @override
  Widget build(BuildContext context) => Column(
        children: <Widget>[
          TextField(
            onChanged: (value) {
              widget.update(value);
              _validateInput();
            },
            controller: controller,
            focusNode: focusNode,
            decoration: InputDecoration(
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color.fromARGB(50, 0, 0, 0)),
              ),
              border: const OutlineInputBorder(
                borderSide: BorderSide(width: 16, color: Colors.white),
              ),
              hintText: widget.placeHolder,
              hintStyle: const TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 14,
                fontFamily: 'Poppins',
              ),
              labelText: widget.inputLabel,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 14,
              ),
              errorText: showError
                  ? 'Please enter a valid  ${widget.inputLabel}'
                  : null,
            ),
            minLines: 1,
            maxLines: widget.textArea ? 6 : 1,
          ),
        ],
      );
}

class DatePicker extends StatefulWidget {
  const DatePicker({
    super.key,
    this.placeHolder,
    this.update,
    this.inputLabel,
    this.initialValue,
  });
  final placeHolder;
  final inputLabel;
  final update;
  final initialValue;
  @override
  State<StatefulWidget> createState() => _DatePicker();
}

class _DatePicker extends State<DatePicker> {
  TextEditingController dateInput = TextEditingController();

  @override
  void initState() {
    dateInput.text =
        widget.initialValue ?? ''; //set the initial value of text field
    super.initState();
  }

  @override
  Widget build(BuildContext context) => TextField(
        controller: dateInput,
        //editing controller of this TextField
        decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color.fromARGB(50, 0, 0, 0)),
          ),
          border: const OutlineInputBorder(
            borderSide: BorderSide(width: 16, color: Colors.white),
          ),
          labelText: widget.inputLabel,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 14,
          ),
          suffixIcon: const Icon(Icons.calendar_today),
        ),
        readOnly: true,
        //set it true, so that user will not able to edit text
        onTap: () async {
          final pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1950),
            //DateTime.now() - not to allow to choose before today.
            lastDate: DateTime(2120),
          );

          if (pickedDate != null) {
            print(
              pickedDate,
            ); //pickedDate output format => 2021-03-10 00:00:00.000
            // final formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
            // yyyy-MM-ddTHH:mm:ss
            //formatted date output using intl package =>  2021-03-16
            setState(() {
              dateInput.text = DateFormat('yyyy-MM-dd')
                  .format(pickedDate); //set output date to TextField value.
              //update the value;
              widget.update(pickedDate);
            });
          } else {}
        },
      );
}

class CustomButton extends StatefulWidget {
  const CustomButton({Key? key, required this.onPressed, this.label = 'Button'})
      : super(key: key);
  final onPressed;
  final String label;

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  var loading = false;
  @override
  Widget build(BuildContext context) => SizedBox(
        height: 50,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          onPressed: () async {
            if (!loading) {
              setState(() {
                loading = true;
              });
              await widget.onPressed();
              loading = false;
              setState(() {});
            }
          },
          child: Ink(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.fromARGB(255, 116, 59, 107),
                  Color.fromARGB(255, 100, 58, 97)
                ],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Container(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              constraints: const BoxConstraints(
                maxWidth: 250,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 5),
                    child: loading
                        ? LoadingAnimationWidget.threeRotatingDots(
                            color: Colors.white, size: 15)
                        : null,
                  ),
                  Text(
                    widget.label,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );
}

class TaskWidget extends StatelessWidget {
  final TaskData taskData;

  TaskWidget({required this.taskData});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              taskData.title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              taskData.description,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: Colors.blue,
                ),
                SizedBox(width: 5),
                Text(
                  _formatDeadline(taskData.deadline),
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDeadline(DateTime deadline) {
    // Customize the date format as needed
    return '${deadline.day}/${deadline.month}/${deadline.year}';
  }
}
