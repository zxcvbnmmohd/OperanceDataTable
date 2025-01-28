import 'package:flutter/material.dart';
import 'package:operance_datatable/operance_datatable.dart';
import 'package:operance_datatable/src/providers/providers.dart';

class StoriesApp extends StatelessWidget {
  const StoriesApp({
    required this.child,
    this.initialPage = const ([], false),
    super.key,
  });

  final PageData<Person> initialPage;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return OperanceDataControllerProvider<Person>(
      controller: OperanceDataController<Person>(
        initialPage: initialPage,
        columnOrder: List.generate(
          columns.length,
          (index) => index,
        ).toSet(),
      ),
      child: OperanceDataDecorationProvider(
        decoration: OperanceDataDecoration(
          icons: OperanceDataIcons(
            hiddenColumnsDropdownClearIcon: Icons.clear,
          ),
          sizes: OperanceDataSizes(
            columnHeaderHeight: 50.0,
            hiddenColumnsDropdownWidth: 250.0,
          ),
          styles: OperanceDataStyles(
            columnHeaderDecoration: BoxDecoration(
              color: Colors.grey[500],
            ),
          ),
        ),
        child: child,
      ),
    );
  }
}

class Person {
  const Person({
    required this.id,
    required this.name,
    required this.age,
  });

  final String id;
  final String name;
  final String age;
}

final columns = <OperanceDataColumn<Person>>[
  OperanceDataColumn<Person>(
    name: 'id',
    columnHeader: const Text('ID'),
    cellBuilder: (context, item) => Text(item.id),
    primary: true,
  ),
  OperanceDataColumn<Person>(
    name: 'name',
    columnHeader: const Text('Name'),
    cellBuilder: (context, item) => Text(item.name),
    primary: false,
  ),
  OperanceDataColumn<Person>(
    name: 'age',
    columnHeader: const Text('Age'),
    cellBuilder: (context, item) => Text(item.age),
    primary: false,
  ),
];

final rows = <Person>[
  Person(
    id: '1',
    name: 'John Doe',
    age: '30',
  ),
  Person(
    id: '2',
    name: 'Jane Doe',
    age: '25',
  ),
  Person(
    id: '3',
    name: 'John Smith',
    age: '40',
  ),
  Person(
    id: '4',
    name: 'Jane Smith',
    age: '35',
  ),
];
