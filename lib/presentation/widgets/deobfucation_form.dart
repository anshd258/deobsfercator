import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class DeobfuscationForm extends StatelessWidget {
  final String? stackFilePath;
  final String? debugSymbolsPath;
  final String output;
  final VoidCallback pickStackTraceFile;
  final VoidCallback pickDebugSymbolsFile;
  final Future<void> Function() removeDebugSymbolsFile;
  final Future<void> Function() deobfuscate;

  const DeobfuscationForm({
    Key? key,
    required this.stackFilePath,
    required this.debugSymbolsPath,
    required this.output,
    required this.pickStackTraceFile,
    required this.pickDebugSymbolsFile,
    required this.removeDebugSymbolsFile,
    required this.deobfuscate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.all(16.0.sp),
      child: Column(
        children: [
          Expanded(
            child: ShadButton(
              onPressed: pickStackTraceFile,
              expands: true,
              child: Text(stackFilePath == null
                  ? 'Select Stack Trace File'
                  : 'Stack File: ${stackFilePath!.split(Platform.pathSeparator).last}',  style: GoogleFonts.urbanist(fontSize: 16.sp),),
            ),
          ),
           SizedBox(height: 10.h),
          Expanded(
            child: ShadButton(
              onPressed: pickDebugSymbolsFile,
              expands: true,
              child: Text(debugSymbolsPath == null
                  ? 'Select Debug Symbols File'
                  : 'Debug Symbols: ${debugSymbolsPath!.split(Platform.pathSeparator).last}',  style: GoogleFonts.urbanist(fontSize: 16.sp),),
            ),
          ),
           SizedBox(height: 10.h),
          if (debugSymbolsPath != null)
            Expanded(
              child: ShadButton.destructive(
                onPressed: () async => await removeDebugSymbolsFile(),
                expands: true,
                child: Text('Remove Debug Symbols File', style: GoogleFonts.urbanist(fontSize: 16.sp), ),
              ),
            ),
         SizedBox(height: 10.h),
          Expanded(
            child: ShadButton(
              onPressed: () async => await deobfuscate(),
              expands: true,
              child:  Text('Deobfuscate',  style: GoogleFonts.urbanist(fontSize: 16.sp),),
            ),
          ),
          SizedBox(height: 10.h),
        ],
      ),
    );
  }
}
