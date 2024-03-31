import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class InputBox extends StatefulWidget {
  const InputBox({
    Key? key,
    this.inputLabel,
    this.placeHolder,
    this.isPassword = false,
    this.textArea = false,
    this.update,
    this.initialValue,
    this.customController,
    this.isPhone = false,
    this.isCountry = false,
  }) : super(key: key);

  final inputLabel;
  final placeHolder;
  final isPassword;
  final textArea;
  final customController;
  final update; // Change the type of update function
  final isPhone;
  final isCountry;
  final String? initialValue;

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
    if (widget.customController != null) {
      controller.text = widget.customController.text;
    } else {
      controller.text = widget.initialValue ?? '';
    }
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
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextField(
          onChanged: (value) {
            if (widget.isCountry) {
              widget.update("+251$value");
            } else {
              widget.update(value);
            }
            _validateInput();
          },
          controller: widget.customController ?? controller,
          focusNode: focusNode,
          obscureText: widget.isPassword,
          keyboardType:
              widget.isPhone ? TextInputType.phone : TextInputType.text,
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
            errorText:
                showError ? 'Please enter a valid  ${widget.inputLabel}' : null,
            prefixIcon: widget.isCountry
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('🇪🇹', style: TextStyle(fontSize: 24)),
                        SizedBox(width: 4),
                        Text('+251', style: TextStyle(fontSize: 14)),
                        SizedBox(width: 8),
                      ],
                    ),
                  )
                : null,
          ),
          minLines: 1,
          maxLines: widget.textArea ? 6 : 1,
        ),
      ],
    );
  }
}

class WidgetSpace extends StatelessWidget {
  const WidgetSpace({Key? key, this.child, this.space = 0.0}) : super(key: key);
  final child;
  final double space;
  @override
  Widget build(BuildContext context) => Column(
        children: <Widget>[
          child,
          SizedBox(
            height: space,
          )
        ],
      );
}

// for the dropdowns
class DropDownBtn extends StatefulWidget {
  const DropDownBtn({
    Key? key,
    required this.items,
    this.label = 'Select Items',
    this.update,
  }) : super(key: key);
  final List<String> items;
  final label;
  final update;

  @override
  State<DropDownBtn> createState() => _DropDownBtnState();
}

class _DropDownBtnState extends State<DropDownBtn> {
  List<String> selectedItems = [];
  @override
  Widget build(BuildContext context) => DropdownButtonHideUnderline(
        child: DropdownButton2(
          // isExpanded: true,
          dropdownStyleData: DropdownStyleData(
            elevation: 0,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: const Color.fromARGB(50, 0, 0, 0),
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
          ),
          // isExpanded: true,
          hint: Container(
            padding: const EdgeInsets.only(left: 11),
            child: Align(
              alignment: AlignmentDirectional.center,
              child: Text(
                widget.label,
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 14,
                  color: Theme.of(context).hintColor,
                ),
              ),
            ),
          ),
          items: widget.items
              .map(
                (item) => DropdownMenuItem<String>(
                  value: item,
                  //disable default onTap to avoid closing menu when selecting an item
                  enabled: false,
                  child: StatefulBuilder(
                    builder: (context, menuSetState) {
                      final isSelected = selectedItems.contains(item);
                      return InkWell(
                        onTap: () {
                          isSelected
                              ? selectedItems.remove(item)
                              : selectedItems.add(item);

                          //This rebuilds the StatefulWidget to update the button's text
                          setState(() {
                            widget.update(selectedItems);
                          });
                          //This rebuilds the dropdownMenu Widget to update the check mark
                          menuSetState(() {});
                        },
                        child: Container(
                          height: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [
                              if (isSelected)
                                const Icon(
                                  Icons.check_box_outlined,
                                  color: Colors.green,
                                )
                              else
                                const Icon(Icons.check_box_outline_blank),
                              const SizedBox(width: 16),
                              Text(
                                item,
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              )
              .toList(),
          //Use last selected item as the current value so if we've limited menu height, it scroll to last item.
          value: selectedItems.isEmpty ? null : selectedItems.last,
          onChanged: (value) {
            print('$value in multi');
          },
          selectedItemBuilder: (context) => widget.items
              .map(
                (item) => Container(
                  alignment: AlignmentDirectional.center,
                  padding: const EdgeInsets.symmetric(horizontal: 11),
                  child: Text(
                    selectedItems.join(', '),
                    style: const TextStyle(
                      fontSize: 15,
                      overflow: TextOverflow.ellipsis,
                    ),
                    maxLines: 1,
                  ),
                ),
              )
              .toList(),
          // buttonStyleData: const ButtonStyleData(
          //   height: 40,
          //   width: 140,
          // ),
          menuItemStyleData: const MenuItemStyleData(
            height: 40,
            padding: EdgeInsets.zero,
          ),
          // dropdownStyleData: ,
          buttonStyleData: ButtonStyleData(
            height: 60,
            width: double.infinity,
            padding: const EdgeInsets.only(right: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color: Colors.grey.shade300,
              ),
            ),
          ),
        ),
      );
}

class SingleSelectDropDownBtn extends StatefulWidget {
  SingleSelectDropDownBtn({
    Key? key,
    required this.items,
    this.label = 'Select Items',
    this.update,
    this.initialValue,
  }) : super(key: key);
  final List<String> items;
  final label;
  final update;
  final initialValue;

  @override
  State<SingleSelectDropDownBtn> createState() =>
      _SingleSelectDropDownBtnState();
}

class _SingleSelectDropDownBtnState extends State<SingleSelectDropDownBtn> {
  String selectedItem = '';
  List<Function> dropDownItemStates = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedItem = widget.initialValue ?? '';
  }

  @override
  Widget build(BuildContext context) {
    //send the selected item when selected
    widget.update(selectedItem);

    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        dropdownStyleData: DropdownStyleData(
          elevation: 0,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: const Color.fromARGB(50, 0, 0, 0),
            ),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
        ),
        // isExpanded: true,
        hint: Container(
          padding: const EdgeInsets.only(left: 11),
          child: Align(
            alignment: AlignmentDirectional.center,
            child: Text(
              widget.label,
              style: TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 14,
                color: Theme.of(context).hintColor,
              ),
            ),
          ),
        ),
        items: widget.items
            .map(
              (item) => DropdownMenuItem<String>(
                value: item,
                //disable default onTap to avoid closing menu when selecting an item
                enabled: false,
                child: CustomStateBuilder(
                  dispose: () {
                    dropDownItemStates = [];
                  },
                  builder: (context, menuSetState) {
                    if (!dropDownItemStates.contains(menuSetState)) {
                      dropDownItemStates.add(menuSetState);
                    }
                    final isSelected = selectedItem == item;
                    return InkWell(
                      onTap: () {
                        isSelected ? selectedItem = '' : selectedItem = item;

                        //This rebuilds the StatefulWidget to update the button's text
                        setState(() {});
                        //This rebuilds the dropdownMenu Widget to update the check mark
                        for (final state in dropDownItemStates) {
                          state(() {});
                        }
                      },
                      child: Container(
                        height: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            if (isSelected)
                              const Icon(
                                Icons.check_box_outlined,
                                color: Colors.green,
                              )
                            else
                              const Icon(Icons.check_box_outline_blank),
                            const SizedBox(width: 16),
                            Text(
                              item,
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            )
            .toList(),
        //Use last selected item as the current value so if we've limited menu height, it scroll to last item.
        value: selectedItem == '' ? null : selectedItem,
        onChanged: (value) {},
        selectedItemBuilder: (context) => widget.items
            .map(
              (item) => Container(
                alignment: AlignmentDirectional.center,
                padding: const EdgeInsets.symmetric(horizontal: 11),
                child: Text(
                  selectedItem,
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                    overflow: TextOverflow.ellipsis,
                  ),
                  maxLines: 1,
                ),
              ),
            )
            .toList(),
        // buttonStyleData: const ButtonStyleData(
        //   height: 40,
        //   width: 140,
        // ),
        menuItemStyleData: const MenuItemStyleData(
          height: 40,
          padding: EdgeInsets.zero,
        ),
        // dropdownStyleData: ,
        buttonStyleData: ButtonStyleData(
          height: 60,
          width: double.infinity,
          padding: const EdgeInsets.only(right: 14),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(5),
              topLeft: Radius.circular(5),
            ),
            border: Border.all(
              color: Colors.grey.shade300,
            ),
          ),
        ),
      ),
    );
  }
}

typedef Disposer = void Function();

class CustomStateBuilder extends StatefulWidget {
  const CustomStateBuilder({
    Key? key,
    required this.builder,
    required this.dispose,
  }) : super(key: key);
  final StatefulWidgetBuilder builder;
  final Disposer dispose;
  @override
  _CustomStateBuilderState createState() => _CustomStateBuilderState();
}

class _CustomStateBuilderState extends State<CustomStateBuilder> {
  @override
  Widget build(BuildContext context) => widget.builder(context, setState);

  @override
  void dispose() {
    super.dispose();
    widget.dispose();
  }
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

class Headlines extends StatelessWidget {
  const Headlines({super.key, required this.text, this.end = false});
  final text;
  final end;

  @override
  Widget build(BuildContext context) => Text(
        text,
        textAlign: end ? TextAlign.end : TextAlign.start,
        style: const TextStyle(
          fontSize: 14,
          height: 1.6,
          fontWeight: FontWeight.w600,
          color: Colors.grey,
        ),
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
                  Color.fromARGB(255, 36, 107, 253),
                  Color.fromARGB(255, 80, 137, 255)
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
                    margin: EdgeInsets.only(right: 5),
                    child: loading
                        ? LoadingAnimationWidget.dotsTriangle(
                            color: Colors.white, size: 15)
                        : null,
                  ),
                  Text(
                    widget.label,
                    style: TextStyle(
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

void showSnackbar(BuildContext context,
    {String text = 'Please Enter All Required Fields!'}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.fromLTRB(35, 5, 35, 25),
      backgroundColor: const Color(0xFFC72C41),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      content: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
        ),
        textAlign: TextAlign.center,
      ),
    ),
  );
}

void successSnackbar(BuildContext context,
    {String text = 'Your data is Saved Successfully!!'}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.fromLTRB(35, 5, 35, 25),
      backgroundColor: Color.fromARGB(255, 75, 199, 44),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      content: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
        ),
        textAlign: TextAlign.center,
      ),
    ),
  );
}

Future showConfirmationDialog(
    BuildContext context, String title, String content) async {
  return await showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true); // User confirmed
            },
            child: Text('Yes'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false); // User canceled
            },
            child: Text('No'),
          ),
        ],
      );
    },
  );
}
