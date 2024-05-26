import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:gauthsy/auth_manager/auth_manager.dart';
import 'package:gauthsy/ui_data/ui_data.dart';
import 'package:gauthsy/views/edit_profile/edit_profile.dart';
import 'package:gauthsy/views/home/home_body.dart';
import 'package:gauthsy/views/home/countries_bottom_sheet.dart';
import 'package:gauthsy/views/notifications/notifications.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  RefreshController _refreshController =
  RefreshController(initialRefresh: false);

  void _onRefresh() async{
    // monitor network fetch
    if(refetch==null) return;
    await refetch();

    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  Future Function() refetch;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: NeumorphicTheme.baseColor(context),
      body: SafeArea(
        child:
        SmartRefresher(
          enablePullDown: true,
          enablePullUp: false,
          header: WaterDropMaterialHeader(backgroundColor:  UIData.colors.primary,),
          controller: _refreshController,
          onRefresh: _onRefresh,
          child:  ListView(
            children: [
              SizedBox(height: 10),
              NeumorphicText(
                "Identity documents",
                style: NeumorphicStyle(
                  depth: 4,
                  color: Colors.black,
                ),
                textStyle: NeumorphicTextStyle(
                  fontSize: 25,
                ),
              ),
              SizedBox(height: 30),
              HomeBody(
                onReady: (Future Function() refetch){
                  this.refetch = refetch;
                },
              ),
              SizedBox(height: 10),
              NeumorphicText(
                "Scan identities documents",
                style: NeumorphicStyle(
                  depth: 4,
                  color: Colors.black,
                ),
                textStyle: NeumorphicTextStyle(
                  fontSize: 25,
                ),
              ),
              SizedBox(height: 15),
              for (int i = 0; i < 2; i++)
                Container(
                    height: 200,
                    margin: EdgeInsets.only(bottom: 10),
                    child: NeumorphicButton(
                      onPressed: () {
                        scaffoldKey.currentState.showBottomSheet((context) => CountriesBottomSheet(
                          documentType: i==0?"ID":"AR",
                        ),backgroundColor:Colors.transparent);
                      },
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      padding: EdgeInsets.all(5),
                      child: Stack(
                        children: [
                          Positioned(
                            top: 0,
                            left: 0,
                            child: Container(
                              child: Text(
                                i == 1 ? "Residence permit" : "Identity card",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            child: Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image:
                                      AssetImage(UIData.images.boarding3))),
                            ),
                          ),
                          Positioned(
                              bottom: 0,
                              right: 5,
                              child: TextButton(
                                style: ElevatedButton.styleFrom(
                                    primary: UIData.colors.primary,
                                    padding: EdgeInsets.only(left: 10)),
                                child: Row(
                                  children: [
                                    Text("Let's start",
                                        style: TextStyle(color: Colors.white)),
                                    Icon(Icons.navigate_next, color: Colors.white)
                                  ],
                                ),
                                onPressed: () {},
                              ))
                        ],
                      ),
                    )),
              SizedBox(height: 30),
              NeumorphicButton(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  padding: EdgeInsets.all(10),
                  style: NeumorphicStyle(boxShape: NeumorphicBoxShape.stadium()),
                  onPressed: () {
                    Navigator.of(context).push(PageTransition(
                        type: PageTransitionType.rightToLeftWithFade,
                        child: EditProfile(user: AuthManager.user)));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Profile", style: TextStyle(fontSize: 17)),
                      SizedBox(width: 5),
                      Icon(Icons.edit)
                    ],
                  )),
              NeumorphicButton(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 30),
                  padding: EdgeInsets.all(10),
                  style: NeumorphicStyle(boxShape: NeumorphicBoxShape.stadium()),
                  onPressed: () {
                    AuthManager.logout();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Logout", style: TextStyle(fontSize: 17)),
                      SizedBox(width: 5),
                      Icon(Icons.logout)
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
