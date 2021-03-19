import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../constants.dart';

class premium_screen extends StatefulWidget {
  @override
  _premium_screenState createState() => _premium_screenState();
}

class _premium_screenState extends State<premium_screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                margin: EdgeInsets.all(0),
                elevation: 0,
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 2.5,
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Image.asset(
                            "assets/images/exam.png",
                            height: MediaQuery.of(context).size.height / 3.5,
                          ),
                        ),
                        SafeArea(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: Container(
                                alignment: Alignment.topCenter,
                                child: Text(
                                  "Unlock the full \nexperience",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w300,
                                      fontSize: 22.0),
                                )),
                          ),
                        ),
                      ],
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [0.4, 10],
                        colors: [
                          Colors.green[300],
                          Colors.green[500],
                        ],
                      ),
                    )),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, top: 20, bottom: 10),
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width / 3.0,
                      height: 15,
                      color: Colors.deepOrangeAccent,
                      child: Center(
                        child: Text(
                          "MOST POPULAR",
                          style: TextStyle(fontSize: 10, color: Colors.white),
                        ),
                      ),
                    ),
                    Container(
                      height: 60,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.deepOrangeAccent, width: 1),
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.black26),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: FlatButton(
                            height: 60,
                            color: Colors.green,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            onPressed: () {},
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "ANNUAL",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                                Text(
                                  "€ 7.99/MONTH",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                              ],
                            )),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black26),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: FlatButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        onPressed: () {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "MONTHLY",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 18),
                            ),
                            Text(
                              "€ 15.49/MONTH",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 18),
                            ),
                          ],
                        )),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0, left: 20, right: 20),
                child: Text(
                  "* Billed as one payment",
                  style: TextStyle(
                    color: Colors.black54,
                    letterSpacing: 1,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0, left: 20, right: 20),
                child: Text(
                  "Payment is the transfer of money or goods and services in exchange for a product or service. Payments are typically made after the terms have been agreed upon by all parties involved. A payment can be made in the form of cash, check, wire transfer, credit card, or debit card.",
                  style: TextStyle(
                    color: Colors.black54,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
