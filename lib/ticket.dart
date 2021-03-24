import 'package:flutter/material.dart';

class Ticket extends StatefulWidget {
  final double width;
  final EdgeInsets padding;
  final double punchRadius;
  final double borderRadius;
  // final double height;
  // final Widget child;
  final Widget top;
  final Widget bottom;
  final Color color;
  final bool isCornerRounded;

  Ticket(
      {@required this.width,
      // @required this.height,
      // @required this.child,
      @required this.top,
      @required this.bottom,
      @required this.borderRadius,
      @required this.punchRadius,
      this.padding = const EdgeInsets.all(5.0),
      this.color = Colors.white,
      this.isCornerRounded = false});

  @override
  _TicketState createState() => _TicketState();
}

class _TicketState extends State<Ticket> {
  @override
  Widget build(BuildContext context) {
    bool testFlag = true;
    double oldOpacity = testFlag ? 1.0 : 0.0;
    double newOpacity = testFlag ? 0.0 : 1.0;

    Widget newChild = Stack(
      children: <Widget>[
        ClipPath(
          clipper: FullTicketClipper(widget.punchRadius, 203, 3),
          child: Container(
            width: widget.width,
            decoration: BoxDecoration(
                color: widget.color,
                borderRadius: BorderRadius.circular(widget.borderRadius)),
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 150, 20, 10),
              child: Dash(
                width: 5,
                height: 3,
                color: Colors.grey[300],
              ),
            ),
          ),
        ),
      ],
    );

    Widget oldChild = Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ClipPath(
          clipper: TicketClipper(widget.punchRadius),
          child: Column(
            children: <Widget>[
              Container(
                // duration: Duration(seconds: 1),
                // width: widget.width,
                // minHeight: widget.height,
                child: widget.top,
                decoration: BoxDecoration(
                    color: widget.color,
                    borderRadius: BorderRadius.circular(widget.borderRadius)),
              ),
              SizedBox(
                // width: widget.width,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  color: Colors.white,
                  child: Dash(
                    width: 5,
                    height: 3,
                    color: Colors.grey[300],
                  ),
                ),
              ),
            ],
          ),
        ),

        // CustomPaint(painter: MyLinePainter()),
        ClipPath(
          clipper: TicketClipperBottom(widget.punchRadius),
          child: Container(
            // duration: Duration(seconds: 1),
            // width: widget.width,
            // minHeight: widget.height,
            child: widget.bottom,
            decoration: BoxDecoration(
                color: widget.color,
                borderRadius: BorderRadius.circular(widget.borderRadius)),
          ),
        )
      ],
    );

    return Material(
      type: MaterialType.transparency,
      // color: Colors.transparent,
      // elevation: 0,
      child: Container(
        padding: widget.padding,
        decoration: new BoxDecoration(
            // color: Colors.transparent,
            boxShadow: [
              new BoxShadow(
                color: Colors.black.withOpacity(.04),
                blurRadius: 20,
                offset: new Offset(0.0, 0.0),
              ),
              new BoxShadow(
                  color: Colors.black.withOpacity(.05),
                  blurRadius: 20,
                  offset: new Offset(0.0, 10.0),
                  spreadRadius: -15)
            ]),
        child: Stack(
          children: <Widget>[
            Opacity(
              opacity: oldOpacity,
              child: oldChild,
            ),
            Opacity(
              opacity: newOpacity,
              child: newChild,
            ),
          ],
        ),
      ),
    );
  }
}

class FullTicketClipper extends CustomClipper<Path> {
  final double punchRadius;
  final double top;
  final double middle;
  FullTicketClipper(this.punchRadius, this.top, this.middle);

  @override
  Path getClip(Size size) {
    Path path = Path();

    // path.lineTo(0.0, size.height);
    // path.lineTo(size.width, size.height);
    // path.lineTo(size.width, 0.0);

    // path.addOval(
    //     Rect.fromCircle(center: Offset(0.0, top), radius: punchRadius));
    // path.addOval(
    //     Rect.fromCircle(center: Offset(size.width, top), radius: punchRadius));

    path.lineTo(0.0, top - punchRadius);
    path.conicTo(punchRadius, top - punchRadius, punchRadius, top, 1.0);
    path.conicTo(punchRadius, top + punchRadius, 0, top + punchRadius, 1.0);

    path.lineTo(0.0, size.height);
    path.lineTo(size.width, size.height);

    path.lineTo(size.width, top + punchRadius);
    path.conicTo(size.width - punchRadius, top + punchRadius,
        size.width - punchRadius, top, 1.0);
    path.conicTo(size.width - punchRadius, top - punchRadius, size.width,
        top - punchRadius, 1.0);

    path.lineTo(size.width, 0);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

class TicketClipper extends CustomClipper<Path> {
  double punchRadius;
  TicketClipper(this.punchRadius);

  @override
  Path getClip(Size size) {
    Path path = Path();

    path.lineTo(0.0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0.0);

    path.addOval(
        Rect.fromCircle(center: Offset(0.0, size.height), radius: punchRadius));
    path.addOval(Rect.fromCircle(
        center: Offset(size.width, size.height), radius: punchRadius));

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

class TicketClipperBottom extends CustomClipper<Path> {
  double punchRadius;
  TicketClipperBottom(this.punchRadius);

  @override
  Path getClip(Size size) {
    Path path = Path();

    path.lineTo(0.0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0.0);

    path.addOval(Rect.fromCircle(center: Offset(0.0, 0), radius: punchRadius));
    path.addOval(
        Rect.fromCircle(center: Offset(size.width, 0), radius: punchRadius));

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

class Dash extends StatelessWidget {
  final double height;
  final double width;
  final Color color;

  const Dash({this.height = 1, this.width = 3, this.color = Colors.black});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        final dashWidth = width;
        final dashHeight = height;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(color: color),
              ),
            );
          }),
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
        );
      },
    );
  }
}
