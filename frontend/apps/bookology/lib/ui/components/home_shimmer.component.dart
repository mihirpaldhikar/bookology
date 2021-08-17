import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget homeShimmer() {
  return ListView.builder(
    physics: BouncingScrollPhysics(),
    itemCount: 5,
    padding: EdgeInsets.only(
      left: 10,
      right: 10,
      top: 10,
    ),
    itemBuilder: (context, index) {
      if (index == 0) {
        return Container(
          margin: EdgeInsets.only(
            top: 10,
            bottom: 10,
          ),
          child: Chip(
            padding: EdgeInsets.all(10),
            backgroundColor: Colors.white,
            side: BorderSide(
              color: Colors.grey,
              width: 1,
            ),
            label: Shimmer.fromColors(
              enabled: true,
              baseColor: Color(0xFFE0E0E0),
              highlightColor: Color(0xFFF5F5F5),
              child: Row(
                children: [
                  Icon(
                    Icons.place_outlined,
                    color: Colors.grey,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    width: 150,
                    height: 15,
                    color: Colors.white,
                  )
                ],
              ),
            ),
          ),
        );
      } else {
        return Container(
          height: 250,
          width: double.infinity,
          padding: EdgeInsets.all(8),
          margin: EdgeInsets.only(
            bottom: 20,
          ),
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(
              color: Colors.grey,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Shimmer.fromColors(
              enabled: true,
              baseColor: Color(0xFFE0E0E0),
              highlightColor: Color(0xFFF5F5F5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 150,
                    height: MediaQuery.of(context).size.height,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: 150,
                          height: 15,
                          color: Colors.white,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          width: 120,
                          height: 15,
                          color: Colors.white,
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          width: 140,
                          height: 10,
                          color: Colors.white,
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Row(
                          children: [
                            Container(
                              width: 40,
                              height: 10,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              width: 30,
                              height: 10,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              width: 30,
                              height: 10,
                              color: Colors.white,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          width: 100,
                          height: 10,
                          color: Colors.white,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: 170,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              )),
        );
      }
    },
  );
}
