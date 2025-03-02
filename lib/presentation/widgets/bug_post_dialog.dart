import 'package:deobfercator/data/models/bug_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class BugReportDialog extends StatefulWidget {
  /// The provided stack trace that will be displayed in read-only mode.
  final String stackTrace;
  final Future<void> Function(BugModel bug) onSubmit;
  const BugReportDialog(
      {super.key, required this.stackTrace, required this.onSubmit});

  @override
  _BugReportDialogState createState() => _BugReportDialogState();
}

class _BugReportDialogState extends State<BugReportDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool loading = false;
  // Controllers for the input fields.
  final TextEditingController newrelicUrlController = TextEditingController();
  final TextEditingController userController = TextEditingController();
  final TextEditingController bugDescController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Set up the animation controller for a pop-in effect.
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.easeOutBack);
    _controller.forward(); // Begin the animation on build.
  }

  @override
  void dispose() {
    _controller.dispose();
    newrelicUrlController.dispose();
    userController.dispose();
    bugDescController.dispose();
    super.dispose();
  }

  void _submitReport() async {
    // Capture the values from the input fields.
    final newrelicUrl = newrelicUrlController.text;
    final user = userController.text;
    final bugDesc = bugDescController.text;
    setState(() {
      loading = true;
    });
    await widget
        .onSubmit(BugModel(
            dateTime: DateTime.now().toIso8601String(),
            newrelicUrl: newrelicUrl,
            bugDesc: bugDesc,
            stacktTrace: widget.stackTrace,
            user: user))
        .whenComplete(() {
      setState(() {
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: ShadDialog.raw(
          variant: ShadDialogVariant.primary,
          constraints: BoxConstraints.loose(Size.fromWidth(
            1000.w,
          )),
          radius: BorderRadius.circular(16),
          backgroundColor: Theme.of(context).cardColor,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Bug Report",
                  ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Stack Trace:",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 150,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: SingleChildScrollView(
                      child: Text(
                        widget.stackTrace,
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ShadInputFormField(
                    controller: newrelicUrlController,
                    label: Text("New Relic URL"),
                    placeholder: Text("Enter New Relic URL"),
                  ),
                  const SizedBox(height: 8),
                  ShadInputFormField(
                    controller: userController,
                    label: Text("User"),
                    placeholder: Text("Enter your username"),
                  ),
                  const SizedBox(height: 8),
                  ShadInputFormField(
                    controller: bugDescController,
                    label: Text("Bug Description"),
                    placeholder: Text("Describe the bug"),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ShadButton.destructive(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text("Cancel"),
                      ),
                      const SizedBox(width: 8),
                      ShadButton(
                        onPressed: _submitReport,
                        child: loading
                            ? CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text("Submit"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
