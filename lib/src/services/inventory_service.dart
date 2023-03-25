import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

import 'package:diogenes/src/exceptions/custom_timeout_exception.dart';
import 'package:diogenes/src/models/item.dart';
import 'package:diogenes/src/models/request.dart';

class ItemService {
  static const String baseUrl = 'http://10.0.2.2:8080/api/v1/item/';
  var logger = Logger();

  /// Fetch all items of the inventory
  Future<PaginatedResponseData<Item>> fetchAllItems({
    required int offset,
    required int pageSize,
  }) async {
    final String url =
        "$baseUrl?pageSize=$pageSize&offset=$offset&sortDirection=DESC";
    logger.d("Fetching data from $url");

    http.Response response;
    try {
      response =
          await http.get(Uri.parse(url)).timeout(const Duration(seconds: 30));
    } on TimeoutException {
      logger.e("Timeout reaching the server");
      throw const CustomTimeoutException("Timeout trying to reach the server.");
    }

    if (response.statusCode != 200) {
      logger.e("Error fetching all data. ${response.statusCode}");
      throw Exception(
          "Error trying to fetch the inventory. (${response.statusCode})");
    }

    final responseData = json.decode(response.body) as Map<String, dynamic>;
    final List<dynamic> itemList = responseData['content'];
    final int totalElements = responseData['totalElements'];
    final int pageNumber = responseData['pageable']['pageNumber'];
    final bool lastPage = responseData['last'];
    final int numberElements = responseData['number'];

    return PaginatedResponseData(
      items: itemList,
      totalElements: totalElements,
      pageNumber: pageNumber,
      lastPage: lastPage,
      numberElements: numberElements,
    );
  }

  /// Delete an item
  Future<void> deleteItem(int id) async {
    final url = "$baseUrl$id";
    logger.d("Deleting item on $url");
    final response = await http.delete(Uri.parse(url));

    if (response.statusCode != 204) {
      throw Exception(
          "Error trying to delete the item. (${response.statusCode})");
    }
  }

  /// Add an item
  Future<void> addItem(Item item) async {
    final headers = {'Content-Type': 'application/json'};
    const url = baseUrl;
    logger.d("Adding item on $url");
    http.Response response;
    try {
      response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: json.encode(item.toJson()),
      );
    } on TimeoutException {
      logger.e("Timeout reaching the server");
      throw const CustomTimeoutException("Timeout trying to reach the server.");
    }

    if (response.statusCode != 201) {
      throw Exception(
          "Error trying to create the item. (${response.statusCode})");
    }
  }

  /// Edit an item
  Future<void> editItem(Item item) async {
    final headers = {'Content-Type': 'application/json'};
    final url = "$baseUrl${item.id}";
    logger.d("Editing item on $url");
    http.Response response;
    try {
      response = await http.put(
        Uri.parse(url),
        headers: headers,
        body: json.encode(item.toJson()),
      );
    } on TimeoutException {
      logger.e("Timeout reaching the server");
      throw const CustomTimeoutException("Timeout trying to reach the server.");
    }

    if (response.statusCode != 200) {
      throw Exception(
          "Error trying to create the item. (${response.statusCode})");
    }
  }
}
