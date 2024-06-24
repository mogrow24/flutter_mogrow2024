import 'package:momentum/providers/navigation/bottom_navigation_provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class AppProviders {
  static List<SingleChildWidget> providers = [
    ChangeNotifierProvider(create: (context) => BottomNavigationProvider()),
    //ChangeNotifierProvider(create: (context) => AnotherProvider()),
  ];
}
