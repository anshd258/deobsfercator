import 'dart:io';
import 'package:deobfercator/data/services/prefrence_service.dart';
import 'package:deobfercator/domain/deobfucation_repository.dart';
import 'package:deobfercator/domain/google_sheets_repository.dart';
import 'package:deobfercator/presentation/widgets/ask_ai_dialog.dart';
import 'package:deobfercator/presentation/widgets/bug_post_dialog.dart';
import 'package:deobfercator/presentation/widgets/deobfucation_form.dart';
import 'package:deobfercator/presentation/widgets/history_list.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../../data/services/local_storage_service.dart';

class DeobfuscatorPage extends StatefulWidget {
  @override
  _DeobfuscatorPageState createState() => _DeobfuscatorPageState();
}

class _DeobfuscatorPageState extends State<DeobfuscatorPage> {
  String? stackFilePath;
  String? debugSymbolsPath;
  String output = '';
  final TextEditingController _controller = TextEditingController();
  late DeobfuscationRepository repository;
  late GoogleSheetsRepository _googleSheetsRepository;

  @override
  void initState() {
    super.initState();
    repository = DeobfuscationRepository(
      localStorageService: LocalStorageService(),
      preferencesService: PreferencesService(),
    );
    _googleSheetsRepository = GoogleSheetsRepository();
    _loadDebugSymbolsPath();
  }

  Future<void> _loadDebugSymbolsPath() async {
    final path = await repository.getSavedDebugSymbolsPath();
    if (path != null) {
      setState(() {
        debugSymbolsPath = path;
      });
    }
  }

  Future<void> pickStackTraceFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
      setState(() {
        stackFilePath = result.files.single.path;
      });
    }
  }

  Future<void> pickDebugSymbolsFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
      String selectedPath = result.files.single.path!;
      final Directory appDocDir = await getApplicationDocumentsDirectory();
      final String fileName = selectedPath.split(Platform.pathSeparator).last;
      final File localFile = await File(selectedPath)
          .copy('${appDocDir.path}${Platform.pathSeparator}$fileName');
      await repository.saveDebugSymbolsPath(localFile.path);
      setState(() {
        debugSymbolsPath = localFile.path;
      });
    }
  }

  Future<void> removeDebugSymbolsFile() async {
    if (debugSymbolsPath != null) {
      final file = File(debugSymbolsPath!);
      if (await file.exists()) {
        await file.delete();
      }
      await repository.removeDebugSymbolsPath();
      setState(() {
        debugSymbolsPath = null;
      });
    }
  }

  Future<void> deobfuscate() async {
    if (stackFilePath == null || debugSymbolsPath == null) {
      setState(() {
        output = 'Please select both the stack trace and debug symbols files.';
      });
      return;
    }

    if (!File(stackFilePath!).existsSync()) {
      setState(() {
        output = 'Error: Stack trace file not found!';
      });
      return;
    }

    if (!File(debugSymbolsPath!).existsSync()) {
      setState(() {
        output = 'Error: Debug symbols file not found!';
      });
      return;
    }

    try {
      final result =
          await repository.deobfuscate(stackFilePath!, debugSymbolsPath!);
      setState(() {
        output = result;
      });
    } catch (e) {
      setState(() {
        output = 'Error running flutter symbolize: $e';
      });
    }
  }

  String _filePath = '';

  // This function writes the provided text to a temporary file.
  Future<void> _saveTextToFile(String text) async {
    if (text.isNotEmpty) {
      final directory = await getTemporaryDirectory();
      final filePath = '${directory.path}/input.txt';
      final file = File(filePath);
      await file.writeAsString(text);
      stackFilePath = filePath;
      await deobfuscate();
      stackFilePath = null;
      file.delete();
    }
  }

  // Separate widgets for current output and history.
  Widget buildCurrentOutput() {
    return DeobfuscationForm(
      stackFilePath: stackFilePath,
      debugSymbolsPath: debugSymbolsPath,
      output: output,
      pickStackTraceFile: pickStackTraceFile,
      pickDebugSymbolsFile: pickDebugSymbolsFile,
      removeDebugSymbolsFile: removeDebugSymbolsFile,
      deobfuscate: deobfuscate,
    );
  }

  Widget buildHistoryList() {
    return HistoryList(
      listenable: repository.localStorageService.historyListener(),
      clearHistory: () {
        repository.clearHistory();
      },
      onSubmit: (bug) async {
        await _googleSheetsRepository.addBug(bug: bug).whenComplete(
          () {
            Navigator.pop(context);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Stack Trace Deobfuscator')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final bool isDesktop = constraints.maxWidth > 800.w;
          if (isDesktop) {
            return Center(
              child: SizedBox(
                width: constraints.maxWidth,
                child: ShadResizablePanelGroup(
                  axis: Axis.vertical,
                  children: [
                    ShadResizablePanel(
                      id: 2,
                      defaultSize: .5,
                      minSize: .2,
                      maxSize: .8,
                      child: ShadResizablePanelGroup(
                        children: [
                          ShadResizablePanel(
                            id: 0,
                            defaultSize: .3,
                            child: Column(
                              children: [
                                Expanded(
                                  child: ShadInput(
                                    controller: _controller,
                                    maxLines: null,
                                  ),
                                ),
                                SizedBox(
                                  height: 16.h,
                                ),
                                ShadButton.outline(
                                  onPressed: () =>
                                      _saveTextToFile(_controller.text),
                                  child: Text(
                                    'Convert to File',
                                    style:
                                        GoogleFonts.urbanist(fontSize: 16.sp),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ShadResizablePanel(
                              id: 3,
                              defaultSize: .3,
                              child: buildCurrentOutput()),
                          ShadResizablePanel(
                              id: 4,
                              defaultSize: .3,
                              child: buildHistoryList()),
                        ],
                      ),
                    ),
                    ShadResizablePanel(
                      id: 1,
                      defaultSize: .5,
                      minSize: .2,
                      maxSize: .8,
                      child: Padding(
                        padding: EdgeInsets.all(16.sp),
                        child: SizedBox(
                          width: double.infinity,
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: ShadCard(
                                  width: double.infinity,
                                  child: SingleChildScrollView(
                                    padding: EdgeInsets.all(12.0.sp),
                                    child: SelectableText(
                                      output,
                                      style:
                                          GoogleFonts.urbanist(fontSize: 14.sp),
                                    ),
                                  ),
                                ),
                              ),
                              if (output.isNotEmpty) ...[
                                Positioned(
                                    right: 0,
                                    child: ShadButton.outline(
                                      onPressed: () {
                                        showShadDialog(
                                          context: context,
                                          builder: (context) => BugReportDialog(
                                            stackTrace: output,
                                            onSubmit: (bug) async {
                                              await _googleSheetsRepository
                                                  .addBug(bug: bug)
                                                  .whenComplete(
                                                () {
                                                  Navigator.pop(context);
                                                },
                                              );
                                            },
                                          ),
                                        );
                                      },
                                      child: Text("Add in Sheet"),
                                    )),
                                Positioned(
                                    right: 125.w,
                                    child: ShadButton.outline(
                                      onPressed: () {
                                        showShadDialog(
                                          context: context,
                                          builder: (context) => AskAIDialog(
                                            stackTrace: output,
                                          ),
                                        );
                                      },
                                      child: Text("Solve via AI"),
                                    ))
                              ]
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  TabBar(
                    tabs: [
                      Tab(text: 'Current'),
                      Tab(text: 'History'),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        Column(
                          children: [
                            Expanded(child: buildCurrentOutput()),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.all(8.0.sp),
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: ShadInput(
                                        controller: _controller,
                                        maxLines: null,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 16.h,
                                    ),
                                    ShadButton.outline(
                                      onPressed: () =>
                                          _saveTextToFile(_controller.text),
                                      child: Text(
                                        'Convert to File',
                                        style: GoogleFonts.urbanist(
                                            fontSize: 16.sp),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        buildHistoryList(),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
