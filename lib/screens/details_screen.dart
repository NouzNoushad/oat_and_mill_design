import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:oat_and_mill_design/screens/home_screen.dart';

import '../data/database.dart';
import '../model/ice_cream.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({super.key, required this.iceCream});
  final IceCream iceCream;

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  int count = 1;
  MyDb myDb = MyDb();

  @override
  void initState() {
    myDb.open();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Column(
        children: [
          Expanded(
              flex: 9,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  children: [
                    buildDetailsHeader(),
                    const SizedBox(
                      height: 10,
                    ),
                    Expanded(
                        child: Align(
                      child: Image.asset(
                        'assets/${widget.iceCream.image}',
                        height: MediaQuery.of(context).size.height * 0.42,
                      ),
                    ))
                  ],
                ),
              )),
          Expanded(flex: 3, child: buildDetailsCounter()),
          Expanded(flex: 2, child: buildDetailsButton()),
        ],
      )),
    );
  }

  Widget buildDetailsButton() => GestureDetector(
        onTap: () async {
          // add product to cart
          await myDb.db!.rawInsert(
              'INSERT INTO carts (image, title, subTitle, price) VALUES (?, ?, ?, ?)',
              [
                widget.iceCream.image,
                widget.iceCream.title,
                widget.iceCream.subTitle,
                widget.iceCream.price! * count
              ]).then((value) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                backgroundColor: Colors.white,
                content: Text(
                  'Product Added to Cart',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    letterSpacing: 1,
                  ),
                )));
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          decoration: const ShapeDecoration(
              color: Color.fromRGBO(115, 1, 47, 1), shape: StadiumBorder()),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 20.0),
                child: Text(
                  'Add To Cart',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.08,
                width: MediaQuery.of(context).size.width * 0.2,
                decoration: const ShapeDecoration(
                    color: Color.fromRGBO(255, 199, 147, 1),
                    shape: StadiumBorder()),
                child: const Icon(Icons.local_mall_outlined,
                    color: Color.fromRGBO(115, 1, 47, 1)),
              ),
            ],
          ),
        ),
      );

  Widget buildDetailsCounter() => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Expanded(
                child: GestureDetector(
              onTap: () {
                if (count < 10) {
                  setState(() {
                    count++;
                  });
                }
              },
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: CustomPaint(
                  painter: LeftButtonPainter(color: widget.iceCream.color!),
                  child: Transform(
                    transform: Matrix4.translationValues(-20, 0, 0),
                    child: const Icon(
                      Icons.add,
                      size: 30,
                    ),
                  ),
                ),
              ),
            )),
            Expanded(
                flex: 2,
                child: Column(
                  children: [
                    Text(
                      count.toString().padLeft(2, '0'),
                      style: const TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 10,
                      ),
                      decoration: const ShapeDecoration(
                          color: Color.fromRGBO(255, 199, 147, 1),
                          shape: StadiumBorder()),
                      child: Text(
                        '\$${widget.iceCream.price! * count}.00',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                )),
            Expanded(
                child: GestureDetector(
              onTap: () {
                if (count > 1) {
                  setState(() {
                    count--;
                  });
                }
              },
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: CustomPaint(
                  painter: RightButtonPainter(color: widget.iceCream.color!),
                  child: Transform(
                    transform: Matrix4.translationValues(20, 0, 0),
                    child: const Icon(
                      Icons.remove,
                      size: 30,
                    ),
                  ),
                ),
              ),
            )),
          ],
        ),
      );

  Widget buildDetailsHeader() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const HomeScreen())),
            child: CircleAvatar(
              backgroundColor: widget.iceCream.color,
              child: const Padding(
                padding: EdgeInsets.only(left: 8),
                child: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                  size: 18,
                ),
              ),
            ),
          ),
          Text(
            widget.iceCream.title ?? '',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color.fromRGBO(95, 70, 89, 1),
            ),
          ),
          const SizedBox(
            width: 18,
          ),
        ],
      );
}

class RightButtonPainter extends CustomPainter {
  RightButtonPainter({
    required this.color,
  });
  final Color color;
  @override
  void paint(Canvas canvas, Size size) {
    double h = size.height;
    double w = size.width;

    canvas.drawPath(
        Path()
          ..moveTo(w, 0)
          ..quadraticBezierTo(w * -0.4, h * 0.5, w, h),
        Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class LeftButtonPainter extends CustomPainter {
  LeftButtonPainter({
    required this.color,
  });
  final Color color;
  @override
  void paint(Canvas canvas, Size size) {
    double h = size.height;
    double w = size.width;

    canvas.drawPath(
        Path()
          ..moveTo(0, 0)
          ..quadraticBezierTo(w * 1.4, h * 0.5, 0, h),
        Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
