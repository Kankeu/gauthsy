part of notifications;

class SlidableNotification extends StatefulWidget {
  final Model.Notification notification;

  SlidableNotification({Key key, @required this.notification})
      : super(key: key);

  @override
  _SlidableNotificationState createState() => _SlidableNotificationState();
}

class _SlidableNotificationState extends State<SlidableNotification> {
  Model.Notification notification;

  bool loading = false;
  var completer = Completer<bool>();
  bool can = true;
  bool lock = false;

  @override
  Widget build(BuildContext context) {
    return loading
        ? NeumorphicProgressIndeterminate(
            style: ProgressStyle(depth: 0),
          )
        : new Slidable(
            key: Key('notification' + notification.id.toString()),
            actionPane: SlidableDrawerActionPane(),
            dismissal: SlidableDismissal(
              child: SlidableDrawerDismissal(),
              dismissThresholds: <SlideActionType, double>{
                SlideActionType.primary: 1.0
              },
              onWillDismiss: (actionType) {
                print(actionType);
                if (actionType == SlideActionType.secondary) return call();
                return false;
              },
            ),
            actionExtentRatio: 1,
            child: NeumorphicButton(
              style: NeumorphicStyle(boxShape: NeumorphicBoxShape.rect()),
              padding: EdgeInsets.zero,
              onPressed: navigate,
              child: ListTile(
                contentPadding: EdgeInsets.all(10),
                trailing: widget.notification.navigable
                    ? Icon(Icons.navigate_next)
                    : null,
                title: Row(
                  children: [
                    Text(notification.typeText),
                    Spacer(),
                    TimeAgo(date:notification.createdAt, textStyle: TextStyle(fontSize: 12))
                  ],
                ),
                subtitle: Text(notification.message),
              ),
            ),
            secondaryActions: <Widget>[
              new IconSlideAction(
                caption: 'Delete',
                color: Colors.red,
                icon: Icons.delete,
                onTap: call,
              ),
            ],
          );
  }

  FutureOr<bool> call() {
    if (!lock) {
      lock = true;
      if (completer.isCompleted) completer = Completer();
      MFlushBar.flushBarUndo(onTap: () {
        MToast.success("Undo");
        can = false;
      });
      Future.delayed(Duration(seconds: 3), () async {
        completer.complete(can);
        if (can) deleteNotification();
        can = true;
        lock = false;
      });
      return completer.future;
    }
    return false;
  }

  navigate() {
    if (!widget.notification.navigable) return;
      Navigator.of(context).push(PageTransition(
          type: PageTransitionType.rightToLeftWithFade,
          child: Home(),
          duration: Duration(milliseconds: 300)));

  }

  @override
  void initState() {
    super.initState();
    notification = widget.notification;
  }

  GraphQl get graphql => Kernel.Container().get<GraphQl>("graphql");

  void deleteNotification() async {
    setState(() {
      loading = true;
    });
    print(widget.notification.id);

    await graphql.mutate(NotificationSchema.deleteNotification, variables: {
      "data": {"id": widget.notification.id}
    }, update: (cache, result) {
      if (!result.hasException && result.data['deleteNotification']) {
        MToast.success("Deleted");
       final queryRequest = Operation(document: NotificationSchema.notifications).asRequest(

        );

        var user = cache.readQuery(queryRequest);
        user["notifications"]["data"] = user["notifications"]["data"]
            .where((e) => e["id"] != widget.notification.id);
        cache.writeQuery(queryRequest, data:user);
      }
    });
    setState(() {
      loading = false;
    });
  }
}
