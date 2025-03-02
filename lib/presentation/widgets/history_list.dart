import 'package:deobfercator/data/models/bug_model.dart';
import 'package:deobfercator/presentation/widgets/ask_ai_dialog.dart';
import 'package:deobfercator/presentation/widgets/bug_post_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class HistoryList extends StatelessWidget {
  ValueListenable<Box<String>> listenable;
  void Function() clearHistory;
  final Future<void> Function(BugModel bug) onSubmit;
  HistoryList(
      {super.key,
      required this.listenable,
      required this.clearHistory,
      required this.onSubmit});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0.sp),
      child: Column(
        children: [
          ShadIconButton.destructive(
            onPressed: () {
              clearHistory.call();
            },
            icon: const Icon(LucideIcons.x),
          ),
          Expanded(
            child: ShadCard(
              child: ValueListenableBuilder(
                valueListenable: listenable,
                builder: (context, Box<String> box, _) {
                  if (box.isEmpty) {
                    return Center(
                        child: Text(
                      'No history available yet.',
                      style: GoogleFonts.urbanist(fontSize: 16.sp),
                    ));
                  }
                  final history = box.values.toList().reversed.toList();
                  return ListView.separated(
                    itemCount: history.length,
                    separatorBuilder: (_, __) => Divider(),
                    itemBuilder: (context, index) {
                      final trace = history[index];
                      return ListTile(
                        title: Text(
                          'Trace ${index + 1}',
                          style: GoogleFonts.urbanist(fontSize: 16.sp),
                        ),
                        subtitle: Text(
                          trace,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.urbanist(fontSize: 12.sp),
                        ),
                        onTap: () {
                          showShadDialog(
                            context: context,
                            builder: (context) => Padding(
                              padding: EdgeInsets.all(16.sp),
                              child: ShadDialog.raw(
                                padding: EdgeInsets.all(16.sp),
                                constraints:
                                    BoxConstraints.loose(Size(1000.w, 500.h)),
                                variant: ShadDialogVariant.primary,
                                actions: [
                                  ShadButton.outline(
                                    onPressed: () {
                                      showShadDialog(
                                        context: context,
                                        builder: (context) => BugReportDialog(
                                          stackTrace: trace,
                                          onSubmit: onSubmit,
                                        ),
                                      );
                                    },
                                    child: Text("Add in Sheet"),
                                  ),
                                  ShadButton(
                                    onPressed: () {
                                      showShadDialog(
                                        context: context,
                                        builder: (context) => AskAIDialog(
                                          stackTrace: trace,
                                        ),
                                      );
                                    },
                                    child: Text("Solve via AI"),
                                  )
                                ],
                                closeIcon: TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text(
                                    'Close',
                                    style:
                                        GoogleFonts.urbanist(fontSize: 14.sp),
                                  ),
                                ),
                                title: Text(
                                  'Deobfuscated Stack Trace',
                                  style: GoogleFonts.urbanist(fontSize: 24.sp),
                                ),
                                child: SingleChildScrollView(
                                    child: SelectableText(
                                  trace,
                                  style: GoogleFonts.urbanist(fontSize: 16.sp),
                                )),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
