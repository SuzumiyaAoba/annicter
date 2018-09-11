import 'package:annicter/api/models/program.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import "package:intl/intl.dart";
import 'package:intl/date_symbol_data_local.dart';

class ProgramItemWidget extends StatefulWidget {
  ProgramItemWidget({
    Key key,
    @required this.program,
  }) : super(key: key);

  final Program program;

  @override
  State<StatefulWidget> createState() => ProgramItemWidgetState();
}

class ProgramItemWidgetState extends State<ProgramItemWidget> {
  @override
  Widget build(BuildContext context) {
    final Program program = widget.program;

    if (program == null) {
      return Center(
          child: Container(
              padding: EdgeInsets.all(25.0),
              child: CircularProgressIndicator()
          ),
      );
    }

    String url = program.work.images.twitter?.imageUrl;
    if (url == null || url.isEmpty) {
      url = program.work.images.recommendedUrl;
    }

    return Container(
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _buildTimeline(program.startedAt),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(10.0),
                child: Row(
                  children: <Widget>[
                    _buildImageIcon(url),
                    _buildProgramInfo(program),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeline(DateTime startedAt) {
    Color color = Colors.indigo[100];
    if (startedAt.isBefore(DateTime.now())) {
      color = Colors.indigoAccent[200];
    }
    return Container(
      padding: EdgeInsets.only(
        left: 18.0,
        right: 12.0,
      ),
      child: Stack(
        children: [
          Container(
            width: 6.0,
            height: double.infinity,
            child: Container(
              padding: EdgeInsets.only(
                left: 3.0,
              ),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: color,
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(
              top: 42.0,
            ),
            child: SizedBox(
              width: 10.0,
              height: 10.0,
              child: DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color,
                  ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageIcon(String url) {
    double diameter = 60.0;
    return Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.grey,
          width: 1.0,
        ),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: CachedNetworkImageProvider(
            url,
            // placeholder: Center(child: CircularProgressIndicator()),
          ),
        ),
      ),
    );
  }

  Widget _buildProgramInfo(Program program) {
    initializeDateFormatting("ja_JP");
    DateFormat formatter = DateFormat("yyyy/MM/dd(E) HH:mm", "ja_JP");
    return Expanded(
      child: Container(
        padding: EdgeInsets.only(
          top: 12.0,
          left: 18.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(
                bottom: 6.0,
              ),
              child: Text(
                program.work?.title,
              ),
            ),
            Text(
              program.episode?.numberText,
            ),
            Text(
              program.episode?.title ?? "",
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                top: 6.0,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(formatter.format(program.startedAt)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
