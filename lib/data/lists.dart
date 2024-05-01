import 'package:flutter/material.dart';
import 'package:oat_and_mill_design/model/ice_cream.dart';

const List<String> categories = ['All', 'Ice Cream', 'Cone', 'Stick', 'Sweets'];

List<IceCream> iceCreams = [
  IceCream(
    image: 'image2.png',
    title: 'Rocky Road',
    subTitle: 'Fudge Brownie',
    price: 12,
    color: const Color.fromARGB(28, 233, 30, 98),
  ),
  IceCream(
    image: 'image1.png',
    title: 'Mint',
    subTitle: 'Chocolate Chip',
    price: 13,
    color: const Color.fromARGB(28, 19, 240, 27),
  ),
];
