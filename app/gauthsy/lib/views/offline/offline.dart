import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:gauthsy/kernel/container/container.dart' as Kernel;
import 'package:gauthsy/kernel/event_manager/event_manager.dart';
import 'package:gauthsy/ui_data/ui_data.dart';

class Offline extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black87,
          child: new BackdropFilter(
              filter: new ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
              child: Center(
                child: Stack(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    alignment: Alignment.center,
                    children: [
                      Positioned(
                        top: 100,
                        child: Text(
                          "Offline :(",
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                      Container(
                        alignment: Alignment.topCenter,
                        margin: EdgeInsets.only(bottom: 210),
                        child: new FlareActor(UIData.images.wifi,
                            animation: "loading"),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: TextButton(
                          style: ElevatedButton.styleFrom(
                              primary: Theme.of(context).accentColor,
                              padding: EdgeInsets.only(left: 10, bottom: 0)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Refresh",
                                  style: TextStyle(color: Colors.white,fontSize: 18)),
                              Icon(Icons.refresh, color: Colors.white)
                            ],
                          ),
                          onPressed: () => _refresh(context),
                        ),
                      ),
                    ]),
              ))),
    );
  }

  final em = Kernel.Container().get<EventManager>("em");

  void _refresh(BuildContext context) {
    em.signal("authenticate");
  }
}
