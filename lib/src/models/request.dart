/// Representation of a request that can obtain data in chunks
class PaginatedResponseData<T> {
  final List<dynamic> items;
  final int totalElements;
  final int pageNumber;
  final int numberElements;
  final bool lastPage;

  const PaginatedResponseData({
    required this.items,
    required this.totalElements,
    required this.pageNumber,
    required this.numberElements,
    required this.lastPage,
  });
}
