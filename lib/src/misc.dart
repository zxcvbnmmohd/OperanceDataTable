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
/// - `filters` (Map<String, dynamic>?): An optional map specifying filters.
///
/// The function returns a `Future` that completes with a tuple containing:
/// - A list of fetched items.
/// - A boolean indicating if there are more items to fetch.
typedef OnFetch<T> = Future<PageData<T>> Function(
  int limit,
  Map<String, SortDirection> sort, {
  bool isInitial,
  Map<String, dynamic>? filters,
});

/// An enum representing the sort direction.
enum SortDirection {
  /// Sort in ascending order.
  ascending,

  /// Sort in descending order.
  descending,
}

/// An enum representing the position of the search bar.
enum SearchPosition {
  /// Search bar is positioned on the left.
  left,

  /// Search bar is positioned on the right.
  right,
}
