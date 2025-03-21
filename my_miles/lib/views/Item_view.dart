import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants/colors.dart';

class ItemView extends StatelessWidget {
  final String title, value;

  const ItemView({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.only(
        top: 20,
        left: 25,
        right: 25,
      ),
      decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: grey.withOpacity(0.03),
              spreadRadius: 10,
              blurRadius: 3,
              // changes position of shadow
            ),
          ]),
      child: Padding(
        padding:
            const EdgeInsets.only(top: 10, bottom: 10, right: 20, left: 20),
        child: Row(
          children: [
            Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                color: arrowbgColor,
                borderRadius: BorderRadius.circular(15),
                // shape: BoxShape.circle
              ),
              child: const Center(child: Icon(Icons.arrow_upward_rounded)),
            ),
            const SizedBox(
              width: 15,
            ),
            Expanded(
              child: SizedBox(
                width: (size.width - 90) * 0.7,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: black)
                        ,
                      ),
                    ]),
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    value,
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                        color: black),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
