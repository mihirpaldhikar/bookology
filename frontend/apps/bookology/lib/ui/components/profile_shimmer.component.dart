import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget profileShimmer() {
  return ListView.builder(
      padding: EdgeInsets.only(top: 20, left: 10, right: 10),
      scrollDirection: Axis.vertical,
      physics: BouncingScrollPhysics(),
      itemCount: 6,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Shimmer.fromColors(
            enabled: true,
            baseColor: Color(0xFFE0E0E0),
            highlightColor: Color(0xFFF5F5F5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(100)),
                    ),
                    SizedBox(
                      width: 100,
                    ),
                    Column(
                      children: [
                        Container(
                          width: 40,
                          height: 15,
                          color: Colors.white,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: 60,
                          height: 15,
                          color: Colors.white,
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: 15,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 150,
                        height: 15,
                        color: Colors.white,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: 200,
                        height: 15,
                        color: Colors.white,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        width: 100,
                        height: 15,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
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
      });
}
