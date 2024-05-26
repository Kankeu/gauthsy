library notifications;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:gauthsy/views/home/home.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gauthsy/components/flash_msg/flash_msg.dart';
import 'package:gauthsy/components/time/times.dart';
import 'package:gauthsy/graphql/graphql.dart';
import 'package:gauthsy/models/notification.dart' as Model;
import 'package:gauthsy/kernel/container/container.dart' as Kernel;


part 'slidable_notification.dart';