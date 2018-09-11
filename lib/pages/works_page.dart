import 'package:annicter/api/annict_api.dart';
import 'package:annicter/api/annict_api_impl.dart';
import 'package:annicter/api/models/work.dart';
import 'package:annicter/bloc/works_bloc.dart';
import 'package:annicter/widgets/work_card_widget.dart';
import 'package:flutter/material.dart';

class WorksPage extends StatefulWidget {
  final AnnictApi api;

  WorksPage({Key key, AnnictApi api})
      : this.api = api ?? AnnictApiImpl.singleton,
        super(key: key);

  @override
  State<StatefulWidget> createState() => _WorksPageState();
}

class _WorksPageState extends State<WorksPage> {
  WorksBloc _bloc;
  int _totalWorks;

  @override
  void initState() {
    super.initState();

    _bloc = WorksBloc(widget.api);
    _totalWorks = 0;

    _bloc.outTotalWorks.listen((totalWorks) =>
      setState(() => _totalWorks = totalWorks)
    );

    _bloc.inWorkIndex.add(0);
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Work>>(
      stream: _bloc.outWorksList,
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return Center(
              child: CircularProgressIndicator()
          );
        }
        return GridView.builder(
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200.0,
            childAspectRatio: 1.0,
          ),
          itemCount: _totalWorks,
          itemBuilder: (context, index) {
            return _buildWorkCard(context, index, snapshot.data);
          },
        );
      },
    );
  }

  Widget _buildWorkCard(BuildContext context, int index, List<Work> works) {
    _bloc.inWorkIndex.add(index);

    final Work work =
    (works != null && works.length > index) ? works[index] : null;

    return WorkCardWidget(
      work: work,
      onPressed: () {},
    );
  }
}
