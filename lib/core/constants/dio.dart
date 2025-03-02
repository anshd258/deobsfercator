
import 'package:deobfercator/core/logging/talker.dart';
import 'package:dio/dio.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';

final dio = Dio(
  BaseOptions( headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  }),
)
  ..interceptors.add(TalkerDioLogger(
      talker: talker,
      settings: const TalkerDioLoggerSettings(
        printErrorMessage: true,
        printRequestData: true,
        printRequestHeaders: true,
        printResponseMessage: true,
        printResponseData: false,
      )));
