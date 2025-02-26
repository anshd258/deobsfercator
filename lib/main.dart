import 'package:deobfercator/presentation/screens/deobfucation_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox<String>('stackHistory');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
   return ScreenUtilInit(
      designSize: const Size(1280, 800),
      minTextAdapt: true,
      splitScreenMode: true,
      // Use builder only if you need to use library outside ScreenUtilInit context
      builder: (_, child) {
        return ShadApp.cupertino(
          title: 'Stack Trace Deobfuscator',
          theme: ShadThemeData(
              colorScheme: ShadColorScheme.fromName("gray",
                  brightness: Brightness.light),
              brightness: Brightness.dark),
          home: child,
        );
      },
      child:  DeobfuscatorPage(),
    );
  
  }
}
