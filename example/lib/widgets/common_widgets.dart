import 'package:flutter/material.dart';

/// Common reusable widgets for the payment form

/// Builds a section header with title
Widget buildSectionHeader(String title) {
  return Padding(
    padding: EdgeInsets.only(bottom: 12, top: 8),
    child: Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.blue[700],
      ),
    ),
  );
}

/// Builds a text field with common styling
Widget buildTextField({
  required String label,
  required String value,
  required ValueChanged<String> onChanged,
  IconData? icon,
  bool obscureText = false,
  TextInputType? keyboardType,
  int? maxLength,
}) {
  return TextFormField(
    initialValue: value,
    decoration: InputDecoration(
      labelText: label,
      prefixIcon: icon != null ? Icon(icon) : null,
      filled: true,
      fillColor: Colors.grey[50],
    ),
    obscureText: obscureText,
    keyboardType: keyboardType,
    maxLength: maxLength,
    onChanged: onChanged,
  );
}

/// Builds a checkbox with common styling
Widget buildCheckbox({
  required String label,
  required bool value,
  required ValueChanged<bool?> onChanged,
}) {
  return CheckboxListTile(
    title: Text(label),
    value: value,
    onChanged: onChanged,
    controlAffinity: ListTileControlAffinity.leading,
    contentPadding: EdgeInsets.symmetric(horizontal: 4),
  );
}

/// Builds a custom toggle switch with label
Widget buildCustomSwitch({
  required String label,
  required bool value,
  required ValueChanged<bool> onChanged,
}) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 4),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Colors.grey[900],
          ),
        ),
        CustomSwitch(
          value: value,
          onChanged: onChanged,
        ),
      ],
    ),
  );
}

/// Custom switch widget
class CustomSwitch extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const CustomSwitch({
    Key? key,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  _CustomSwitchState createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    if (widget.value) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(CustomSwitch oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      if (widget.value) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onChanged(!widget.value);
      },
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Container(
            width: 51,
            height: 31,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.5),
              color: Color.lerp(
                Color(0xFFE5E5EA), // iOS gray when off
                Color(0xFF34C759), // iOS green when on
                _animation.value,
              ),
            ),
            child: Stack(
              children: [
                AnimatedPositioned(
                  duration: Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  left: _animation.value * 20 + 2,
                  top: 2,
                  child: Container(
                    width: 27,
                    height: 27,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Builds a section with header and switch
class CollapsibleSection extends StatelessWidget {
  final String title;
  final bool isEnabled;
  final ValueChanged<bool>? onSwitchChanged;
  final List<Widget> children;

  const CollapsibleSection({
    Key? key,
    required this.title,
    required this.isEnabled,
    this.onSwitchChanged,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[700],
                  ),
                ),
              ),
              if (onSwitchChanged != null)
                CustomSwitch(
                  value: isEnabled,
                  onChanged: onSwitchChanged!,
                ),
            ],
          ),
        ),
        if (isEnabled) ...children,
      ],
    );
  }
}

/// Builds a simple section header without switch (always visible)
class SimpleSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const SimpleSection({
    Key? key,
    required this.title,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.blue[200]!, width: 1),
          ),
          child: Row(
            children: [
              Icon(Icons.label_important, color: Colors.blue[700], size: 24),
              SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[700],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16),
        ...children,
      ],
    );
  }
}

