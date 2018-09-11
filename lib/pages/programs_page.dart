import 'package:annicter/api/annict_api.dart';
import 'package:annicter/api/annict_api_impl.dart';
import 'package:annicter/api/models/program.dart';
import 'package:annicter/bloc/programs_bloc.dart';
import 'package:annicter/widgets/program_item_widget.dart';
import 'package:flutter/material.dart';

class ProgramsPage extends StatefulWidget {
  final AnnictApi api;

  ProgramsPage({Key key, AnnictApi api})
      : this.api = AnnictApiImpl.singleton, super(key: key);

  @override
  State<StatefulWidget> createState() => _ProgramsPageState();
}

class _ProgramsPageState extends State<ProgramsPage> {
  ProgramsBloc _bloc;
  int _totalPrograms;

  @override
  void initState() {
    super.initState();

    _bloc = ProgramsBloc(widget.api);
    _totalPrograms = 0;

    _bloc.outTotalPrograms.listen((totalPrograms) =>
        setState(() => _totalPrograms = totalPrograms));

    _bloc.inProgramIndex.add(0);
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Program>>(
      stream: _bloc.outProgramsList,
      builder: (context, snapshot) {
        if(snapshot.data == null) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return ListView.builder(
            itemCount: _totalPrograms,
            itemBuilder: (context, index) {
              return _buildProgramItem(context, index, snapshot.data);
            }
        );
      },
    );
  }

  Widget _buildProgramItem(BuildContext context, int index, List<Program> programs) {
    _bloc.inProgramIndex.add(index);

    final Program program = (programs != null && programs.length > index) ? programs[index] : null;

    return InkWell(
      child: ProgramItemWidget(
        program: program,
      ),
      onTap: () {},
      onLongPress: () {},
      highlightColor: Colors.pink.shade300,
      splashColor: Colors.pink.shade100,
    );
  }
}