import 'package:dio/dio.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_exceptions.dart';
import '../models/client.dart';
import '../models/client_contact.dart';
import '../models/client_detail.dart';
import '../models/create_client_request.dart';
import '../models/create_contact_request.dart';
import '../models/update_client_request.dart';
import '../models/update_contact_request.dart';

class ClientRepository {
  final Dio _dio;

  ClientRepository(this._dio);

  Future<List<Client>> listClients() async {
    try {
      final response = await _dio.get(ApiConstants.clients);
      return (response.data as List).map((e) => Client.fromJson(e)).toList();
    } on DioException catch (e) {
      throw ApiException.fromResponse(e.response?.statusCode ?? 500, e.response?.data);
    }
  }

  Future<ClientDetail> getClient(String id) async {
    try {
      final response = await _dio.get(ApiConstants.clientById(id));
      return ClientDetail.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiException.fromResponse(e.response?.statusCode ?? 500, e.response?.data);
    }
  }

  Future<void> createClient(CreateClientRequest request) async {
    try {
      await _dio.post(ApiConstants.clients, data: request.toJson());
    } on DioException catch (e) {
      throw ApiException.fromResponse(e.response?.statusCode ?? 500, e.response?.data);
    }
  }

  Future<void> updateClient(String id, UpdateClientRequest request) async {
    try {
      await _dio.put(ApiConstants.clientById(id), data: request.toJson());
    } on DioException catch (e) {
      throw ApiException.fromResponse(e.response?.statusCode ?? 500, e.response?.data);
    }
  }

  Future<void> deleteClient(String id) async {
    try {
      await _dio.delete(ApiConstants.clientById(id));
    } on DioException catch (e) {
      throw ApiException.fromResponse(e.response?.statusCode ?? 500, e.response?.data);
    }
  }

  Future<List<ClientContact>> listContacts(String clientId) async {
    try {
      final response = await _dio.get(ApiConstants.clientContacts(clientId));
      return (response.data as List).map((e) => ClientContact.fromJson(e)).toList();
    } on DioException catch (e) {
      throw ApiException.fromResponse(e.response?.statusCode ?? 500, e.response?.data);
    }
  }

  Future<ClientContact> addContact(String clientId, CreateContactRequest request) async {
    try {
      final response = await _dio.post(
        ApiConstants.clientContacts(clientId),
        data: request.toJson(),
      );
      return ClientContact.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiException.fromResponse(e.response?.statusCode ?? 500, e.response?.data);
    }
  }

  Future<ClientContact> updateContact(String clientId, String contactId, UpdateContactRequest request) async {
    try {
      final response = await _dio.put(
        ApiConstants.clientContactById(clientId, contactId),
        data: request.toJson(),
      );
      return ClientContact.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiException.fromResponse(e.response?.statusCode ?? 500, e.response?.data);
    }
  }

  Future<void> removeContact(String clientId, String contactId) async {
    try {
      await _dio.delete(ApiConstants.clientContactById(clientId, contactId));
    } on DioException catch (e) {
      throw ApiException.fromResponse(e.response?.statusCode ?? 500, e.response?.data);
    }
  }
}
