import 'package:flutter/material.dart';

import '../page/index.dart';

class MyRoutes {
  static getRoutes() {
    return {
      '/': (BuildContext context) => const IndexPage(),
    };
  }
}
