import 'package:deobfercator/data/models/ai_content.dart';
import 'package:deobfercator/domain/ai_solver_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class AskAIDialog extends StatefulWidget {
  /// The provided stack trace that will be displayed in read-only mode.
  final String stackTrace;
  const AskAIDialog({
    super.key,
    required this.stackTrace,
  });

  @override
  _AskAIDialogState createState() => _AskAIDialogState();
}

class _AskAIDialogState extends State<AskAIDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool loading = false;
  late AiSolverRepository _solverRepository;

  final TextEditingController exceptionController = TextEditingController();
  final TextEditingController bugDescController = TextEditingController();
  AiContent? data;
  String? error;
  @override
  void initState() {
    super.initState();
    // Set up the animation controller for a pop-in effect.
    _solverRepository = AiSolverRepository();
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

    exceptionController.dispose();
    bugDescController.dispose();
    super.dispose();
  }

  void _submitReport() async {
    // Capture the values from the input fields.

    final exception = exceptionController.text;
    final bugDesc = bugDescController.text;
    setState(() {
      loading = true;
    });
    await _solverRepository
        .postAiRequest(
            stackTrace: widget.stackTrace,
            exception: exception,
            bugData: bugDesc)
        .then((onValue) {
      setState(() {
        data = onValue;
      });
    }).catchError((onError) {
      setState(() {
        error = onError.toString();
      });
    }).whenComplete(() {
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
                    "Ai finder",
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
                    controller: exceptionController,
                    label: Text("Exception Message"),
                    placeholder: Text("Enter your Exception Message"),
                    validator: (p0) {
                      if (p0.isEmpty || p0.length < 5) {
                        return "Please add proper exception message";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  ShadInputFormField(
                    controller: bugDescController,
                    label: Text("Bug Description"),
                    placeholder: Text("Describe the bug"),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 24),
                  if (data != null) ...[
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: data!.steps!.length,
                      itemBuilder: (context, index) {
                        final item = data!.steps![index];
                        return Column(
                          children: [
                            ShadAlert(
                              iconData: LucideIcons.bug,
                              title: Text("Finding $index"),
                              description: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: MarkdownBody(
                                  data: item.Findings ?? "",
                                  selectable: true,
                                ),
                              ),
                            ),
                            ShadAlert(
                              iconData: LucideIcons.gitBranch,
                              title: Text("Potential Cause $index"),
                              description: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: MarkdownBody(
                                  data: item.potential_cause ?? "",
                                  selectable: true,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    ShadAlert(
                      iconData: LucideIcons.terminal,
                      title: Text('Conclusion'),
                      description: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: MarkdownBody(
                          data: data!.final_answer ?? "",
                          selectable: true,
                        ),
                      ),
                    ),
                  ],
                  if (error != null) ...[
                    ShadAlert.destructive(
                      iconData: LucideIcons.terminal,
                      title: Text('error'),
                      description: Text("error generating result"),
                    ),
                  ],
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
