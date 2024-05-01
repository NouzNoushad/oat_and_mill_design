import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:oat_and_mill_design/data/database.dart';
import 'package:oat_and_mill_design/data/lists.dart';
import 'package:oat_and_mill_design/screens/details_screen.dart';

import 'cart_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  int selectedTab = 0;
  MyDb myDb = MyDb();
  List<Map> cartItems = [];

  @override
  void initState() {
    myDb.open();
    getCartItems();
    tabController = TabController(length: 5, vsync: this);
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Column(
        children: [
          Expanded(
              flex: 6,
              child: Column(
                children: [
                  Expanded(flex: 3, child: buildHeader()),
                  Expanded(flex: 2, child: buildCategories()),
                  Expanded(
                      flex: 12,
                      child: TabBarView(controller: tabController, children: [
                        buildIceCreams(),
                        const Center(
                          child: Text(
                            'Ice cream',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                        const Center(
                          child: Text(
                            'Cone',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                        const Center(
                          child: Text(
                            'Stick',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                        const Center(
                          child: Text(
                            'Sweets',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ])),
                ],
              )),
          const SizedBox(
            height: 10,
          ),
          Expanded(
              child: GestureDetector(
            onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const CartScreen())),
            child: Container(
              height: MediaQuery.of(context).size.height,
              margin: const EdgeInsets.only(bottom: 4),
              decoration: const ShapeDecoration(
                  color: Color.fromRGBO(115, 1, 47, 1), shape: StadiumBorder()),
              child: CustomPaint(
                painter: BottomSheetPainter(),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                  child: Row(
                    children: [
                      Expanded(
                          child: IntrinsicHeight(
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor:
                                  const Color.fromRGBO(255, 199, 147, 1),
                              child: Text(
                                cartItems.length.toString(),
                                style: const TextStyle(
                                  color: Color.fromRGBO(115, 1, 47, 1),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Cart',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  '${cartItems.length} Items',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white60,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      )),
                      Expanded(
                          child: Align(
                        alignment: Alignment.centerRight,
                        child: ListView.builder(
                            itemCount: cartItems.length,
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return CircleAvatar(
                                backgroundColor: Colors.white38,
                                child: Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Image.asset(
                                    'assets/${cartItems[index]['image']}',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              );
                            }),
                      ))
                    ],
                  ),
                ),
              ),
            ),
          )),
        ],
      )),
    );
  }

  Widget buildIceCreams() => Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 25,
              vertical: 10,
            ),
            child: Row(
              children: [
                Expanded(
                    child: Text(
                  'Flavor of the week',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Color.fromRGBO(95, 70, 89, 1),
                  ),
                )),
                SizedBox(
                  width: 10,
                ),
                Icon(
                  Icons.arrow_forward,
                  color: Color.fromRGBO(95, 70, 89, 1),
                )
              ],
            ),
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
            child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  final iceCream = iceCreams[index];
                  return Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width * 0.9,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        color: iceCream.color),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: Stack(
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        DetailsScreen(iceCream: iceCream))),
                            child: Align(
                              alignment: const Alignment(2, -1),
                              child: Transform(
                                transform: Matrix4.rotationZ(pi * 0.1),
                                child: Image.asset(
                                  'assets/${iceCream.image}',
                                  height:
                                      MediaQuery.of(context).size.height * 0.42,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 25, vertical: 35),
                                    width:
                                        MediaQuery.of(context).size.width / 2,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          iceCream.title ?? '',
                                          style: const TextStyle(
                                            fontSize: 32,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 25, vertical: 8),
                                          decoration: const ShapeDecoration(
                                              color: Colors.white60,
                                              shape: StadiumBorder()),
                                          child: Text(
                                            iceCream.subTitle ?? '',
                                            style: const TextStyle(
                                              fontSize: 15,
                                              color:
                                                  Color.fromRGBO(95, 70, 89, 1),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    )),
                                Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: ClipRRect(
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(
                                        sigmaX: 5,
                                        sigmaY: 5,
                                      ),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 8),
                                        decoration: const ShapeDecoration(
                                            color: Colors.white38,
                                            shape: StadiumBorder()),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10),
                                              child: Text(
                                                '\$ ${iceCream.price}.00',
                                                style: const TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.08,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.2,
                                              decoration: const ShapeDecoration(
                                                  color: Color.fromRGBO(
                                                      115, 1, 47, 1),
                                                  shape: StadiumBorder()),
                                              child: const Icon(
                                                Icons.local_mall_outlined,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(
                    width: 15,
                  );
                },
                itemCount: iceCreams.length),
          ))
        ],
      );

  Widget buildCategories() => TabBar(
        controller: tabController,
        isScrollable: true,
        dividerHeight: 0,
        padding: const EdgeInsets.only(left: 20),
        labelPadding: const EdgeInsets.symmetric(horizontal: 5),
        indicatorColor: Colors.transparent,
        overlayColor: MaterialStateProperty.all(Colors.transparent),
        onTap: (index) {
          setState(() {
            selectedTab = index;
          });
        },
        tabs: categories.map((e) {
          final index = categories.indexOf(e);
          return Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 15,
            ),
            decoration: ShapeDecoration(
                color: selectedTab == index
                    ? const Color.fromRGBO(255, 206, 222, 1)
                    : const Color.fromRGBO(255, 236, 243, 1),
                shape: const StadiumBorder()),
            child: Text(
              e,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black,
              ),
            ),
          );
        }).toList(),
      );

  Widget buildHeader() => Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 25,
        ),
        child: Row(
          children: [
            const Expanded(
              child: Text.rich(TextSpan(
                  text: 'Better',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                    color: Color.fromRGBO(95, 70, 89, 1),
                  ),
                  children: [
                    TextSpan(
                        text: ' Ice Cream ',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        children: [
                          TextSpan(
                            text: 'better planet',
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w500,
                              color: Color.fromRGBO(95, 70, 89, 1),
                            ),
                          ),
                        ]),
                  ])),
            ),
            const SizedBox(
              width: 8,
            ),
            CircleAvatar(
              radius: 25,
              backgroundColor: Colors.grey.shade200,
              child: Image.asset(
                'assets/profile.png',
              ),
            ),
          ],
        ),
      );
}

class BottomSheetPainter extends CustomPainter {
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
          ..moveTo(offset.dx - w * 0.15, offset.dy - h * 0.52)
          ..lineTo(offset.dx - w * 0.1, offset.dy - h * 0.38)
          ..lineTo(offset.dx + w * 0.1, offset.dy - h * 0.38)
          ..lineTo(offset.dx + w * 0.15, offset.dy - h * 0.52),
        Paint()..color = Colors.white);

    canvas.drawLine(Offset(offset.dx - w * 0.08, offset.dy - h * 0.5),
        Offset(offset.dx + w * 0.08, offset.dy - h * 0.5), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
