library router;

import 'package:flutter/material.dart';
import 'fluro/fluro.dart' show TransitionType;
import 'fluro/fluro.dart' as Fluro;

part 'interfaces/router_interface.dart';

class Router implements RouterInterface {
  final Fluro.Router _router = new Fluro.Router();

  Function get generator => _router.generator;
  Widget Function(Widget) _interceptor;

  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  NavigatorState get navigator => _navigatorKey.currentState;

  @override
  bool define(String path, Fun callback,
      {TransitionType transition, List<String> guards}) {
    _router.define(path, transitionType: transition, handler: new Fluro.Handler(
        handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      return hasInterceptor()
          ? getInterceptor()(callback(context, params))
          : callback(context, params);
    }));
    return true;
  }

  @override
  dynamic navigateTo(String path,
      {bool withDrawer = false, bool replace = false}) {
    return withDrawer
        ? _pushAndPopIfExistWithDrawer(path, replace: replace)
        : _pushAndPopIfExist(path, replace: replace);
  }

  void _pushAndPopIfExist(String value, {bool replace = false}) {
    navigator.popUntil((Route route) => !ModalRoute.withName(value)(route));
    if (replace)
      navigator.pushReplacementNamed(value);
    else
      navigator.pushNamed(value);
  }

  void _pushAndPopIfExistWithDrawer(String value, {bool replace = false}) {
    navigator.pop();
    if (navigator.canPop())
      navigator.popUntil((Route route) => !ModalRoute.withName(value)(route));
    if (replace)
      navigator.pushReplacementNamed(value);
    else
      navigator.pushNamed(value);
  }

  bool hasInterceptor() {
    return _interceptor != null;
  }

  void setInterceptor(Widget Function(Widget) interceptor) {
    _interceptor = interceptor;
  }

  Widget Function(Widget) getInterceptor() {
    return _interceptor;
  }

  @override
  push(Widget widget, {bool skipInterceptor = false, PageRoute Function(Widget) pageRoute}) {
    widget = skipInterceptor ? widget : getInterceptor()(widget);
    var page = pageRoute == null
        ? MaterialPageRoute(builder: (_) => widget)
        : pageRoute(widget);
    return navigator.push(page);
  }

  @override
  pushAndRemoveUntil(Route newRoute, RoutePredicate predicate){
    navigator.pushAndRemoveUntil(newRoute, predicate);
  }
}
