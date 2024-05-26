import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:gauthsy/components/cards/m_title.dart';
import 'package:gauthsy/ui_data/ui_data.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:gauthsy/auth_manager/auth_manager.dart';
import 'package:gauthsy/components/notifications/notifications.dart';
import 'package:gauthsy/graphql/graphql.dart';
import 'package:gauthsy/models/notification.dart' as Model;
import 'package:gauthsy/components/bars/bars.dart';
import 'package:gauthsy/components/loaders/loaders.dart';
import 'package:gauthsy/kernel/container/container.dart' as Kernel;
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'no_notifications_card.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  double get height => MediaQuery.of(context).size.height;
  List<Model.Notification> notifications;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // monitor network fetch
    if (refetch == null) return;
    await refetch();

    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  Future Function() refetch;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: NeumorphicTheme.baseColor(context),
        body: SafeArea(
            child: SmartRefresher(
                enablePullDown: true,
                enablePullUp: false,
                header: WaterDropMaterialHeader(
                  backgroundColor: UIData.colors.primary,
                ),
                controller: _refreshController,
                onRefresh: _onRefresh,
                child: Stack(children: <Widget>[
                  MQuery(NotificationSchema.notifications,
                      keysForMerge: "me.notifications",
                      scrollController: _refreshController.scrollController,
                      fetchPolicy: FetchPolicy.cacheAndNetwork, builder:
                          (QueryResult result,
                              {Function refetch, Function fetchMore}) {
                    this.refetch = refetch;
                    if (result.isLoading && result.data == null && notifications.isEmpty)
                      return Center(
                          child: NeumorphicProgressIndeterminate(
                        style: ProgressStyle(depth: 0),
                      ));
                    AuthManager.user.unreadNotificationsCount =
                        result.data["me"]["unread_notifications_count"];
                    if (AuthManager.user.unreadNotificationsCount > 0)
                      markAllNotificationsAsRead();
                    notifications = result.data["me"]["notifications"]
                        .map<Model.Notification>(
                            (json) => Model.Notification.fromJson(json))
                        .toList();

                    if (notifications.isEmpty)
                      return Center(
                        child: NoNotificationsCard(refetch: refetch),
                      );
                    return Column(children: [
                      SizedBox(height: 40),
                      MTitle(
                        text: "Notifications",
                        hint: "Swipe the notification left to delete it",
                      ),
                      SizedBox(height: 30),
                      if (result.data["me"]["unread_notifications_count"] > 0)
                        Container(
                            margin: EdgeInsets.symmetric(vertical: 5),
                            child: MTitle(
                                text: "Unread notifications",
                                fontSize: 18,
                                fontWeight: FontWeight.w700)),
                      for (int i = 0; i < notifications.length; i++)
                        Container(
                            margin: EdgeInsets.symmetric(vertical: 5),
                            child: Column(
                              children: [
                                if (result.data["me"]
                                            ["unread_notifications_count"] ==
                                        i &&
                                    i > 0)
                                  Container(
                                      margin: EdgeInsets.symmetric(vertical: 5),
                                      child: MTitle(
                                          text: "read notifications",
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700)),
                                SlidableNotification(
                                    notification: notifications[i])
                              ],
                            )),
                      if (result.isLoading)
                        Center(
                          child: NeumorphicProgressIndeterminate(
                            style: ProgressStyle(depth: 0),
                          ),
                        )
                    ]);
                  }),
                  Container(
                    alignment: Alignment.topLeft,
                    height: 110,
                    child: TopBar(),
                  )
                ]))));
  }

  @override
  void initState() {
    markAllNotificationsAsRead();
    super.initState();
  }

  GraphQl get graphql => Kernel.Container().get<GraphQl>("graphql");
  bool loading = false;

  void markAllNotificationsAsRead() async {
    if (loading) return;
    loading = true;
    if (AuthManager.user.unreadNotificationsCount > 0) {
      final QueryResult result =
          await graphql.mutate(NotificationSchema.markAllNotificationsAsRead);
      print(result.data);
      if (result.data["markAllNotificationsAsRead"]) {
        print("Notification read");
        AuthManager.user.unreadNotificationsCount = 0;
      }
    }
    loading = false;
  }
}
