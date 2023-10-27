import 'package:facts/atoms/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class Popup extends StatefulWidget {
  bool show;
  Function onClose;
  Popup({Key? key, required this.show, required this.onClose})
      : super(key: key);

  @override
  _PopupState createState() => _PopupState();
}

class _PopupState extends State<Popup> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animatedLocation;

  @override
  void initState() {
    _controller = AnimationController(vsync: this);

    _animatedLocation =
        CurvedAnimation(parent: _controller, curve: Curves.easeIn)
            .drive(Tween<double>(begin: 1, end: 0));
    if (widget.show) {
      _start();
    } else {
      _hide();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _start() {
    _controller
      ..duration = const Duration(milliseconds: 250)
      ..forward();
  }

  void _hide() {
    _controller
      ..duration = const Duration(milliseconds: 250)
      ..reverse();

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onClose();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          var height = MediaQuery.of(context).size.height;
          var top = 20 + height * _animatedLocation.value; // 0 to 1
          return Positioned(
              left: 40,
              top: top,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                child: Container(
                  width: MediaQuery.of(context).size.width - 80,
                  color: Color.fromARGB(255, 109, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                          margin: EdgeInsets.fromLTRB(0, 16, 0, 0),
                          child: Column(
                            children: [
                              Text(
                                "Well Done!",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.pressStart2p(
                                    textStyle: TextStyle(
                                        color: Colors.white, fontSize: 40)),
                              ),
                              Container(
                                height: 24,
                              ),
                              Container(
                                margin: EdgeInsets.all(16),
                                child: Text(
                                  "This was great. We've seem to have stopped the spread for now. Lets get back to the message board.",
                                  textAlign: TextAlign.left,
                                  style: GoogleFonts.pressStart2p(
                                      textStyle: TextStyle(
                                          color: Colors.white, fontSize: 16)),
                                ),
                              ),
                            ],
                          )),
                      Container(
                        margin: EdgeInsets.all(20),
                        child: Button(
                            label: "    OK    ",
                            onClick: () {
                              _hide();
                            }),
                      )
                    ],
                  ),
                ),
              ));
        });
  }
}
