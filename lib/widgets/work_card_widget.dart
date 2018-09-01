import 'dart:async';

import 'package:annicter/api/models/work.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:cached_network_image/cached_network_image.dart';

class WorkCardWidget extends StatefulWidget {

  WorkCardWidget({
    Key key,
    @required this.work,
    @required this.onPressed,
  }) : super(key: key);

  final Work work;
  final VoidCallback onPressed;

  @override
  State<StatefulWidget> createState() => WorkCardWidgetState();
}

class WorkCardWidgetState extends State<WorkCardWidget> {

  @override
  Widget build(BuildContext context) {
    final Work work = widget.work;

    if(work == null || work.images.recommendedUrl == null) {
      return Center(child: CircularProgressIndicator());
    }

    return Container(
      child: Card(
        child: Stack(
          children: <Widget>[
            _buildWorkCard(work),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {},
                onLongPress: _showTitle(work),
                highlightColor: Colors.pink.shade300,
                splashColor: Colors.pink.shade100,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkCard(Work work) {
    final String url = work.images.recommendedUrl;

    if (url == null) {
      return Center(child: CircularProgressIndicator());
    }

    List<Widget> children = <Widget>[];

    if (url.isNotEmpty) {
      children = [
        Positioned.fill(
          child: CachedNetworkImage(
            imageUrl: url,
            placeholder: Center(child: CircularProgressIndicator()),
            fit: BoxFit.cover,
          ),
        ),
      ];
    }

    children.add(
      Positioned.fill(
        child: Container(
          decoration: _buildGradientBackground(),
          padding: EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _buildTitleText(work)
            ],
          ),
        ),
      ),
    );

    return Positioned.fill(
      child: Stack(
        children: children,
      ),
    );
  }

  BoxDecoration _buildGradientBackground() {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
        stops: [0.1, 0.4, 0.7, 1.0],
        colors: <Color>[
          Colors.black87,
          Colors.black26,
          Colors.black12,
          Colors.transparent,
        ],
      ),
    );
  }

  Widget _buildTitleText(Work work) {
    return Text(
      work.title,
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  VoidCallback _showTitle(Work work) {
    return () => Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(work.title),
    ));
  }
}