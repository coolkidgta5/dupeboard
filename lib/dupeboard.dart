import 'dart:async';
import 'package:dupeboard/utils/dupe_utils.dart';
import 'package:flutter/material.dart';
import './utils/database.dart';
import 'chart_widget.dart';
import 'cooldown_widget.dart';

class Dupeboard extends StatefulWidget {
  @override
  _DupeboardState createState() => _DupeboardState();
}

class _DupeboardState extends State<Dupeboard> {
  var smallCount = 0;
  var largeCount = 0;
  var graphData = [];
  @override
  void initState() {
    super.initState();
    _getSmallCount();
    _getLargeCount();
    DupeUtils.services.getNotificationTimeAndScheduleNotification();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 100),
        child: Column(
          children: <Widget>[
            GridView.count(
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              primary: false,
              crossAxisCount: 2,
              shrinkWrap: true,
              children: <Widget>[
                DupeBoardGrid(
                  count: smallCount,
                  limit: 2,
                  label: '2 Hours',
                ),
                DupeBoardGrid(
                  count: largeCount,
                  limit: 7,
                  label: '30 Hours',
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            ChartWidget(),
            SizedBox(
              height: 10,
            ),
            CooldownWidget(),
          ],
        ),
      ),
    );
  }

  _getSmallCount() {
    DBProvider.db.getCount(2 * 60).then((value) {
      for (int i = 0; i <= value; i++) {
        Timer(Duration(milliseconds: 100 * i + 1), () {
          setState(() {
            smallCount = i;
          });
        });
      }
    });
  }

  _getLargeCount() {
    DBProvider.db.getCount(30 * 60).then((value) {
      for (int i = 0; i <= value; i++) {
        Timer(Duration(milliseconds: 100 * i + 1), () {
          setState(() {
            largeCount = i;
          });
        });
      }
    });
  }
}

class DupeBoardGrid extends StatefulWidget {
  final int count;
  final int limit;
  final String label;

  DupeBoardGrid({this.count, this.limit, this.label});

  @override
  _DupeBoardGridState createState() => _DupeBoardGridState();
}

class _DupeBoardGridState extends State<DupeBoardGrid> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: (widget.count / widget.limit) >= 1
              ? Colors.red[700]
              : Theme.of(context).primaryColor,
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.bottomRight,
                      child: Text(
                        widget.count.toString(),
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            fontSize: width * 0.25,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            height: .4),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    '/ ' + widget.limit.toString(),
                    style: TextStyle(
                        fontSize: width * 0.08,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              'DUPE SALES IN LAST',
              style: TextStyle(
                  fontSize: width * 0.025,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              widget.label,
              style: TextStyle(
                  fontSize: width * 0.05,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
