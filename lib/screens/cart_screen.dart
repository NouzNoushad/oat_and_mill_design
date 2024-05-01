import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../data/database.dart';
import 'home_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  MyDb myDb = MyDb();
  List<Map> cartItems = [];
  int deliveryCharge = 20;

  @override
  void initState() {
    myDb.open();
    getCartItems();
    super.initState();
  }

  getCartItems() {
    Future.delayed(const Duration(seconds: 1), () async {
      cartItems = await myDb.db!.rawQuery('SELECT * FROM carts');
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    num total = cartItems.fold(
        0, (previousValue, element) => previousValue + element['price']);
    final grandTotal = deliveryCharge + total;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Column(
        children: [
          Expanded(
            child: buildCartHeader(),
          ),
          Expanded(
            flex: 8,
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                  color: Color.fromRGBO(155, 1, 47, 1),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  )),
              child: CustomPaint(
                painter: CartSheetPainter(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 25,
                    vertical: 10,
                  ),
                  child: Column(
                    children: [
                      Expanded(flex: 4, child: buildCartList()),
                      Expanded(flex: 2, child: buildCartTotal(grandTotal)),
                      Expanded(child: buildCartButton()),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      )),
    );
  }

  Widget buildCartButton() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration:
            const ShapeDecoration(color: Colors.white, shape: StadiumBorder()),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                'Make Payment',
                style: TextStyle(
                  fontSize: 18,
                  color: Color.fromRGBO(95, 70, 89, 1),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.08,
              width: MediaQuery.of(context).size.width * 0.2,
              decoration: const ShapeDecoration(
                  color: Color.fromRGBO(255, 199, 147, 1),
                  shape: StadiumBorder()),
              child: const Icon(
                Icons.keyboard_double_arrow_right,
                color: Color.fromRGBO(155, 1, 47, 1),
              ),
            ),
          ],
        ),
      );

  Widget buildCartTotal(grandTotal) => Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: const Color.fromRGBO(253, 222, 221, 1)),
        child: CustomPaint(
          painter: TotalAmountPainter(),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Delivery Charge',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black54,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '\$$deliveryCharge.00',
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                const Divider(
                  thickness: 1.5,
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total Amount',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '\$$grandTotal.00',
                      style: const TextStyle(
                        fontSize: 23,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      );

  Widget buildCartList() => Padding(
        padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
        child: ListView.separated(
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              final cart = cartItems[index];
              return Stack(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 35,
                            backgroundColor: Colors.white30,
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Image.asset('assets/${cart['image']}'),
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                cart['title'],
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(
                                height: 3,
                              ),
                              Text(
                                cart['subTitle'],
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              await myDb.db!.rawDelete(
                                  'DELETE FROM carts WHERE id = ?',
                                  [cart['id']]).then((value) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                        backgroundColor: Colors.white,
                                        content: Text(
                                          'Product Removed from Cart',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black,
                                            letterSpacing: 1,
                                          ),
                                        )));
                              });

                              getCartItems();
                            },
                            child: const CircleAvatar(
                              radius: 12,
                              backgroundColor: Colors.white38,
                              child: Icon(
                                Icons.close,
                                size: 18,
                                color: Color.fromRGBO(155, 1, 47, 1),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Container(
                            decoration: const ShapeDecoration(
                                color: Colors.white, shape: StadiumBorder()),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 5,
                            ),
                            child: Text('\$${cart['price']}.00',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                )),
                          )
                        ],
                      )
                    ],
                  )
                ],
              );
            },
            separatorBuilder: (context, index) {
              return const SizedBox(
                height: 15,
              );
            },
            itemCount: cartItems.length),
      );

  Widget buildCartHeader() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                GestureDetector(
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const HomeScreen())),
                    child: const Icon(Icons.arrow_back_ios)),
                const SizedBox(
                  width: 10,
                ),
                const Text(
                  'Cart',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(95, 70, 89, 1),
                  ),
                )
              ],
            ),
            CircleAvatar(
              backgroundColor: const Color.fromRGBO(255, 199, 147, 1),
              child: Text(
                cartItems.length.toString(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(155, 1, 47, 1),
                ),
              ),
            )
          ],
        ),
      );
}

class TotalAmountPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double h = size.height;
    double w = size.width;
    Offset offset = Offset(w * 0.5, h * 0.5);

    canvas.drawPath(
        Path()
          ..moveTo(offset.dx - w * 0.16, offset.dy - h * 0.54)
          ..lineTo(offset.dx - w * 0.1, offset.dy - h * 0.42)
          ..lineTo(offset.dx + w * 0.1, offset.dy - h * 0.42)
          ..lineTo(offset.dx + w * 0.16, offset.dy - h * 0.54),
        Paint()..color = const Color.fromRGBO(155, 1, 47, 1));

    canvas.drawPath(
        Path()
          ..moveTo(offset.dx - w * 0.16, offset.dy + h * 0.54)
          ..lineTo(offset.dx - w * 0.1, offset.dy + h * 0.42)
          ..lineTo(offset.dx + w * 0.1, offset.dy + h * 0.42)
          ..lineTo(offset.dx + w * 0.16, offset.dy + h * 0.54),
        Paint()..color = const Color.fromRGBO(155, 1, 47, 1));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class CartSheetPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double h = size.height;
    double w = size.width;
    Offset offset = Offset(w * 0.5, h * 0.5);
    Paint paint = Paint()
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..color = const Color.fromRGBO(218, 218, 218, 1);

    canvas.drawPath(
        Path()
          ..moveTo(offset.dx - w * 0.16, offset.dy - h * 0.505)
          ..lineTo(offset.dx - w * 0.1, offset.dy - h * 0.48)
          ..lineTo(offset.dx + w * 0.1, offset.dy - h * 0.48)
          ..lineTo(offset.dx + w * 0.16, offset.dy - h * 0.505),
        Paint()..color = Colors.white);

    canvas.drawLine(Offset(offset.dx - w * 0.08, offset.dy - h * 0.5),
        Offset(offset.dx + w * 0.08, offset.dy - h * 0.5), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
