part of router;

typedef Fun = Widget Function(
    BuildContext context, Map<String, dynamic> params);

abstract class RouterInterface {
  bool define(String path, Fun callback,
      {TransitionType transition, List<String> guards});

  dynamic navigateTo(String path,
      {bool withDrawer = false, bool replace = false});

  dynamic push(Widget widget,
      {bool skipInterceptor = false, PageRoute Function(Widget) pageRoute});

  dynamic pushAndRemoveUntil(Route newRoute, RoutePredicate predicate);
}
