import 'package:flutter/material.dart';
import 'package:operance_datatable/src/widgets/operance_data_row.dart';

import 'main.dart';

Widget child() {
  return StoriesApp(
    child: OperanceDataRow<Person>(
      columns: columns,
      row: Person(
        id: '1',
        name: 'John Doe',
        age: '30',
      ),
      index: 0,
      tableWidth: 500.0,
      onEnter: (_) {},
      onExit: (_) {},
      onChecked: (items) {},
      onRowPressed: (row) {},
      expansionBuilder: (context, row) {
        return Text('Expanded: $row');
      },
      expandable: true,
      selectable: true,
    ),
  );
}
