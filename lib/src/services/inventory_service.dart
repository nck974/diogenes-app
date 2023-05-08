import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:diogenes/src/exceptions/unauthenticated_exception.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart' as http;
import 'package:logger/logger.dart';
import 'package:oauth2/oauth2.dart' as oauth2;

import 'package:diogenes/src/exceptions/custom_timeout_exception.dart';
import 'package:diogenes/src/exceptions/invalid_response_code_exception.dart';
import 'package:diogenes/src/models/filter_inventory.dart';
import 'package:diogenes/src/models/item.dart';
import 'package:diogenes/src/models/request.dart';
import 'package:diogenes/src/models/sort_inventory_options.dart';

Map<SortInventoryOptions, String> _sortMapping = {
  SortInventoryOptions.idASC: "&sortDirection=ASC&sort=ID",
  SortInventoryOptions.idDESC: "&sortDirection=DESC&sort=ID",
  SortInventoryOptions.nameASC: "&sortDirection=ASC&sort=NAME",
  SortInventoryOptions.nameDESC: "&sortDirection=DESC&sort=NAME",
  SortInventoryOptions.numberASC: "&sortDirection=ASC&sort=NUMBER",
  SortInventoryOptions.numberDESC: "&sortDirection=DESC&sort=NUMBER",
};

class ItemService {
  static const itemPath = '/diogenes/api/v1/item/';
  late String baseUrl;
  // final String accessToken;
  final oauth2.Credentials credentials;
  var logger = Logger();

  ItemService({required backendUrl, required this.credentials}) {
    baseUrl = "$backendUrl$itemPath";
  }

  /// Return the client with a set timeout and the authentication and
  /// management of refresh tokens included
  oauth2.Client _client() {
    final ioClient = HttpClient();
    ioClient.connectionTimeout = const Duration(seconds: 30);
    return oauth2.Client(credentials, httpClient: http.IOClient(ioClient));
  }

  /// Fetch all items of the inventory
  Future<PaginatedResponseData<Item>> fetchAllItems(
      {required int offset,
      required int pageSize,
      SortInventoryOptions? sort,
      FilterInventory? filter}) async {
    String url = "$baseUrl?pageSize=$pageSize&offset=$offset";

    // Sort the data
    if (sort == null) {
      url += _sortMapping[SortInventoryOptions.idDESC]!;
    } else {
      url += _sortMapping[sort]!;
    }

    // Filter results
    if (filter != null) {
      url += filter.buildFilterUrl();
    }

    logger.d("Fetching data from $url");
    http.Response response;
    try {
      response = await _client().get(Uri.parse(url));
    } on SocketException {
      logger.e("Timeout reaching the server");
      throw CustomTimeoutException();
    } on oauth2.ExpirationException {
      throw UnauthenticatedException();
    } on oauth2.AuthorizationException {
      throw UnauthenticatedException();
    } on FormatException {
      throw UnauthenticatedException();
    }

    if (response.statusCode != 200) {
      logger.e("Error fetching all data. ${response.statusCode}");
      throw InvalidResponseCodeException(
        response.statusCode,
      );
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
    http.Response response;
    try {
      response = await _client().delete(Uri.parse(url));
    } on SocketException {
      logger.e("Timeout reaching the server");
      throw CustomTimeoutException();
    } on oauth2.ExpirationException {
      throw UnauthenticatedException();
    } on oauth2.AuthorizationException {
      throw UnauthenticatedException();
    } on FormatException {
      throw UnauthenticatedException();
    }
    if (response.statusCode != 204) {
      throw Exception(
          "Error trying to delete the item. (${response.statusCode})");
    }
  }

  /// Add an item
  Future<void> addItem(Item item) async {
    final headers = {'Content-Type': 'application/json'};
    final url = baseUrl;
    logger.d("Adding item on $url");
    http.Response response;
    try {
      response = await _client().post(
        Uri.parse(url),
        headers: headers,
        body: json.encode(item.toJson()),
      );
    } on SocketException {
      logger.e("Timeout reaching the server");
      throw CustomTimeoutException();
    } on oauth2.ExpirationException {
      throw UnauthenticatedException();
    } on oauth2.AuthorizationException {
      throw UnauthenticatedException();
    } on FormatException {
      throw UnauthenticatedException();
    }

    if (response.statusCode != 201) {
      throw InvalidResponseCodeException(response.statusCode);
    }
  }

  /// Edit an item
  Future<void> editItem(Item item) async {
    final headers = {'Content-Type': 'application/json'};
    final url = "$baseUrl${item.id}";
    logger.d("Editing item on $url");
    http.Response response;
    try {
      response = await _client().put(
        Uri.parse(url),
        headers: headers,
        body: json.encode(item.toJson()),
      );
    } on SocketException {
      logger.e("Timeout reaching the server");
      throw CustomTimeoutException();
    } on oauth2.ExpirationException {
      throw UnauthenticatedException();
    } on oauth2.AuthorizationException {
      throw UnauthenticatedException();
    } on FormatException {
      throw UnauthenticatedException();
    }

    if (response.statusCode != 200) {
      throw InvalidResponseCodeException(response.statusCode);
    }
  }
}
