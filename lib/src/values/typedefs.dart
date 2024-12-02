// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import 'package:operance_datatable/src/values/enumerations.dart';

/// A typedef for a page of data.
///
/// This typedef represents a tuple containing:
/// - A list of items of type `T`.
/// - A boolean indicating if there are more items to fetch.
typedef PageData<T> = (List<T>, bool);

/// A typedef for a function that fetches data.
///
/// The function takes the following parameters:
/// - `limit` (int): The maximum number of items to fetch.
/// - `sort` (Map<String, SortDirection>?): An optional map specifying the sort
///    direction for each field.
/// - `isInitial` (bool): An optional named parameter indicating if this is the
///    initial fetch.
///
/// The function returns a `Future` that completes with a tuple containing:
/// - A list of fetched items.
/// - A boolean indicating if there are more items to fetch.
typedef OnFetch<T> = Future<PageData<T>> Function(
  int limit,
  Map<String, SortDirection> sort, {
  bool isInitial,
});

/// A typedef for a function that is called when the current page index changes.
///
/// The function takes the following parameter:
/// - `currentPage` (int): The new current page index.
///
/// The function does not return anything.
typedef OnCurrentPageIndexChanged = ValueChanged<int>;
