part of bars;

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Function onPressed;
  final List<Widget> actions;

  static const double kToolbarHeight = 110.0;

  const TopBar({this.title = "", this.actions, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(bottom: 18.0, left: 18, right: 18, top: 10),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
              alignment: Alignment.centerLeft,
              child: NeumorphicButton(
                padding: EdgeInsets.all(18),
                style: NeumorphicStyle(
                  boxShape: NeumorphicBoxShape.circle(),
                  shape: NeumorphicShape.flat,
                ),
                child: Icon(
                  Icons.arrow_back,
                  color: UIData.dark
                      ? Colors.white70
                      : Colors.black87,
                ),
                onPressed: () {
                  if (onPressed != null)
                    onPressed();
                  else {
                    if (Navigator.of(context).canPop())
                      Navigator.of(context).pop();
                    else {
                      if (Platform.isAndroid) {
                        SystemNavigator.pop();
                      } else{
                        exit(0);
                      }
                    }
                  }
                },
              )),
          Center(
            child: Text(
              this.title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: UIData.dark
                    ? Colors.white70
                    : Colors.black87,
              ),
            ),
          ),
          Align(
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: actions ?? [],
              )),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
