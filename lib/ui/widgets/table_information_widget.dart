import 'package:flutter/material.dart';

class TableInformationWidget extends StatelessWidget {
  final List<Map<String, dynamic>> datas;
  const TableInformationWidget({super.key, required this.datas});

  @override
  Widget build(BuildContext context) {
    return Table(
      columnWidths: const {0: FlexColumnWidth(0.4)},
      children: List.generate(datas.length, (index) {
        return TableRow(children: [
          Text(datas[index]['key'].toString()),
          Text(
            datas[index]['value'].toString(),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ]);
      }),
    );
  }
}
