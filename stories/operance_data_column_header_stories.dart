import 'package:flutter/material.dart';
import 'package:operance_datatable/src/widgets/operance_data_column_header.dart';

import 'main.dart';

Widget child() {
  return StoriesApp(
    initialPage: (rows, false),
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: OperanceDataColumnHeader<Person>(
        columns: columns,
        tableWidth: 800.0,
        allowColumnReorder: true,
        expandable: true,
        selectable: true,
      ),
    ),
  );
}
