import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gauthsy/auth_manager/auth_manager.dart';
import 'package:gauthsy/config/config.dart';
import 'package:gauthsy/database/database.dart';
import 'package:gauthsy/deep_link_manager/deep_link_manager.dart';
import 'package:gauthsy/file_manager/file_manager.dart';
import 'package:gauthsy/graphql/graphql.dart';
import 'package:gauthsy/http/http.dart';
import 'package:gauthsy/kernel/container/container.dart' as Kernel;
import 'package:gauthsy/kernel/event_manager/event_manager.dart';
import 'package:gauthsy/localization/app_localization.dart';
import 'package:gauthsy/notification_manager/notification_manager.dart';
import 'package:gauthsy/shared_prefs/shared_prefs.dart';
import 'package:gauthsy/ui_data/ui_data.dart';
import 'package:gauthsy/views/splash/splash.dart';
import 'package:gauthsy/kernel/router/router.dart' as Kernel;
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void run() {
  WidgetsFlutterBinding.ensureInitialized();

  final container = Kernel.Container();
  final eventManager = new EventManager();
  container.set("em", () => eventManager);
  container.set("router", () => new Kernel.Router());
  GraphQl.init();
  DeepLinkManager.init();
  // load preferences and ui_data
  SharedPrefs.init();
  runApp(App());
  NotificationManager.init();
  // the auth manager must be initialized before the Database because of the event binding
  AuthManager.init();
  Database.init();
  Http.init();
  WidgetsBinding.instance
      .addPostFrameCallback((_) => FileManager.init());


}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  Kernel.Router get router => Kernel.Container().get<Kernel.Router>("router");
  GraphQl get graphql => Kernel.Container().get<GraphQl>("graphql");

  EventManager get em => Kernel.Container().get("em");

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
        client: graphql.clientNotifier,
        child: CacheProvider(
        child:UIData(
      builder: (BuildContext context, ThemeData theme) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: Config.appName,
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            AppLocalizationsDelegate()
          ],
          supportedLocales: Config.locales,
          localeResolutionCallback:
              (Locale locale, Iterable<Locale> supportedLocales) {

            Config.lang="en";
            return Locale("en","US");
            for (Locale supportedLocale in supportedLocales) {
              if (supportedLocale.languageCode == locale.languageCode ||
                  supportedLocale.countryCode == locale.countryCode) {
                Config.lang = supportedLocale.languageCode;
                return supportedLocale;
              }
            }
            Config.lang = supportedLocales.first.languageCode;
            return supportedLocales.first;
          },
          navigatorKey: router.navigatorKey,
          onGenerateRoute: router.generator,
          home: NeumorphicTheme(
              themeMode: ThemeMode.light,
              theme: NeumorphicThemeData(
                accentColor: UIData.colors.primary,
                variantColor: UIData.colors.primary,
                baseColor: Color(0xFFFFFFFF),
                intensity: 0.5,
                lightSource: LightSource.topLeft,
                depth: 10,
              ),
              darkTheme: NeumorphicThemeData(
                baseColor: Color(0xFF3E3E3E),
                intensity: 0.5,
                lightSource: LightSource.topLeft,
                depth: 6,
              ),
              child: Splash())),
    )));
  }


  @override
  void initState() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          em.signal("router.attached");
        });
      });
    });
    super.initState();
  }
}
