import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiException implements Exception {
  final int statusCode;
  final String message;
  final String? body;

  ApiException({required this.statusCode, required this.message, this.body});

  @override
  String toString() => 'ApiException: $statusCode - $message\nBody: $body';
}

class ApiService {
  static const String baseUrl = 'https://ortopro.farsoft.uz/api';

  // =========================================================
  // TELEFONNI API UCHUN NORMALIZATSIYA
  // Har qanday holatda:
  //
  // ++998991234567
  // +998991234567
  // 998991234567
  // 0991234567
  // 99 123 45 67
  //
  // natija:
  // +998991234567
  // =========================================================

  String _normalizePhone(String phone) {
    // Faqat raqamlarni qoldiramiz.
    // + va bo'sh joylar ham olib tashlanadi.
    String digits = phone.replaceAll(RegExp(r'\D'), '');

    // Agar 9 ta raqam bo'lsa (masalan: 991234567), 998 qo'shamiz.
    if (digits.length == 9) {
      digits = '998$digits';
    }

    // Backend + belgisini xohlamasligi mumkin (500 xato beryapti).
    // Shuning uchun faqat 12 ta raqamni (998XXXXXXXXX) qaytaramiz.
    return digits;
  }

  // =========================================================
  // OTP YUBORISH
  // POST /api/auth/send-code
  // =========================================================

  Future<Map<String, dynamic>> sendCode(String phone) async {
    // OTP uchun ham telefonni normalizatsiya qilamiz.
    final String normalizedPhone = _normalizePhone(phone);

    final url = Uri.parse('$baseUrl/auth/send-code');

    final body = {
      'phone': normalizedPhone,
    };

    print('================ SEND CODE ================');
    print('URL: $url');
    print('PHONE: $normalizedPhone');
    print('BODY: ${jsonEncode(body)}');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(body),
    );

    print('STATUS: ${response.statusCode}');
    print('RESPONSE: ${response.body}');
    print('===========================================');

    if (response.statusCode >= 200 &&
        response.statusCode < 300) {
      return jsonDecode(response.body)
      as Map<String, dynamic>;
    }

    throw ApiException(
      statusCode: response.statusCode,
      message: 'Kod yuborishda xatolik',
      body: response.body,
    );
  }

  // =========================================================
  // OTP TEKSHIRISH
  // POST /api/auth/verify-code
  // =========================================================

  Future<Map<String, dynamic>> verifyCode({
    required String phone,
    required String code,
  }) async {
    final String normalizedPhone = _normalizePhone(phone);

    final response = await http.post(
      Uri.parse('$baseUrl/auth/verify-code'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'phone': normalizedPhone,
        'code': code,
      }),
    );

    print(
      '================ VERIFY CODE ================',
    );
    print('PHONE: $normalizedPhone');
    print('STATUS: ${response.statusCode}');
    print('RESPONSE: ${response.body}');
    print('==============================================');

    if (response.statusCode >= 200 &&
        response.statusCode < 300) {
      final data =
      jsonDecode(response.body) as Map<String, dynamic>;

      final token = data['access_token'];

      print('TOKEN OLINDI: ${token != null}');

      return data;
    }

    throw ApiException(
      statusCode: response.statusCode,
      message: 'Kod tasdiqlashda xatolik',
      body: response.body,
    );
  }

  // =========================================================
  // HOZIRGI USER
  // GET /api/auth/me
  // =========================================================

  Future<Map<String, dynamic>> getMe(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/auth/me'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print('================ GET ME ================');
    print('STATUS: ${response.statusCode}');
    print('RESPONSE: ${response.body}');
    print('=========================================');

    if (response.statusCode >= 200 &&
        response.statusCode < 300) {
      return jsonDecode(response.body)
      as Map<String, dynamic>;
    }

    throw Exception(
      'User ma\'lumotlarini olishda xatolik: '
          '${response.statusCode} ${response.body}',
    );
  }

  // =========================================================
  // MAHSULOTLARNI OLISH
  // GET /api/products
  // =========================================================

  Future<List<dynamic>> getProducts(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/products'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode >= 200 &&
        response.statusCode < 300) {
      return jsonDecode(response.body) as List<dynamic>;
    }

    throw Exception(
      'Mahsulotlarni yuklashda xatolik yuz berdi',
    );
  }

  // =========================================================
  // MAHSULOT QO'SHISH
  // POST /api/products
  // =========================================================

  Future<Map<String, dynamic>> addProduct({
    required String token,
    required String name,
    required double priceClient,
    required double priceDoctor,
    required double cashback,
    required String status,
    String? filePath,
  }) async {
    final url = Uri.parse('$baseUrl/products');

    final request =
    http.MultipartRequest('POST', url);

    request.headers.addAll({
      'Authorization': 'Bearer $token',
    });

    request.fields['name'] = name;
    request.fields['categoryId'] = "1";
    request.fields['price_client'] =
        priceClient.toString();
    request.fields['price_doctor'] =
        priceDoctor.toString();
    request.fields['cashback'] =
        cashback.toString();
    request.fields['status'] = status;

    if (filePath != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'picture',
          filePath,
        ),
      );
    }

    final streamedResponse =
    await request.send();

    final response =
    await http.Response.fromStream(
      streamedResponse,
    );

    if (response.statusCode >= 200 &&
        response.statusCode < 300) {
      return jsonDecode(response.body)
      as Map<String, dynamic>;
    }

    throw Exception(
      'Mahsulotni saqlashda xatolik yuz berdi',
    );
  }

  // =========================================================
  // MAHSULOT TAHRIRLASH
  // PUT /api/products/:id
  // =========================================================

  Future<Map<String, dynamic>> updateProduct({
    required String token,
    required int id,
    required String name,
    required double priceClient,
    required double priceDoctor,
    required double cashback,
    required String status,
    String? filePath,
  }) async {
    final url =
    Uri.parse('$baseUrl/products/$id');

    final request =
    http.MultipartRequest('PUT', url);

    request.headers.addAll({
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    });

    request.fields['name'] = name;
    request.fields['categoryId'] = "1";
    request.fields['price_client'] =
        priceClient.toString();
    request.fields['price_doctor'] =
        priceDoctor.toString();
    request.fields['cashback'] =
        cashback.toString();
    request.fields['status'] = status;

    if (filePath != null &&
        !filePath.startsWith('http')) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'picture',
          filePath,
        ),
      );
    }

    final streamedResponse =
    await request.send();

    final response =
    await http.Response.fromStream(
      streamedResponse,
    );

    if (response.statusCode >= 200 &&
        response.statusCode < 300) {
      return jsonDecode(response.body)
      as Map<String, dynamic>;
    }

    throw Exception(
      'Mahsulotni tahrirlashda xatolik yuz berdi: '
          '${response.statusCode} ${response.body}',
    );
  }

  // =========================================================
  // MAHSULOTNI O'CHIRISH
  // DELETE /api/products/:id
  // =========================================================

  Future<void> deleteProduct(
      String token,
      int id,
      ) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/products/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode < 200 ||
        response.statusCode >= 300) {
      throw Exception(
        'Mahsulotni o\'chirishda xatolik yuz berdi',
      );
    }
  }

  // =========================================================
  // MIJOZLARNI OLISH
  // GET /api/clients
  // =========================================================

  Future<List<dynamic>> getClients(
      String token,
      ) async {
    final response = await http.get(
      Uri.parse('$baseUrl/clients'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode >= 200 &&
        response.statusCode < 300) {
      return jsonDecode(response.body)
      as List<dynamic>;
    }

    throw Exception(
      'Mijozlarni yuklashda xatolik yuz berdi',
    );
  }

  // =========================================================
  // MIJOZ QO'SHISH
  // POST /api/clients
  // =========================================================

  Future<Map<String, dynamic>> addClient({
    required String token,
    required Map<String, dynamic> clientData,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/clients'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(clientData),
    );

    if (response.statusCode >= 200 &&
        response.statusCode < 300) {
      return jsonDecode(response.body)
      as Map<String, dynamic>;
    }

    throw Exception(
      'Mijozni saqlashda xatolik yuz berdi',
    );
  }

  // =========================================================
  // MIJOZNI O'CHIRISH
  // DELETE /api/clients/:id
  // =========================================================

  Future<void> deleteClient(
      String token,
      int id,
      ) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/clients/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode < 200 ||
        response.statusCode >= 300) {
      throw Exception(
        'Mijozni o\'chirishda xatolik yuz berdi',
      );
    }
  }

  // =========================================================
  // MIJOZNI TAHRIRLASH
  // PUT /api/clients/:id
  // =========================================================

  Future<Map<String, dynamic>> updateClient({
    required String token,
    required int id,
    required Map<String, dynamic> clientData,
  }) async {
    final response = await http.put(
      Uri.parse('$baseUrl/clients/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(clientData),
    );

    if (response.statusCode >= 200 &&
        response.statusCode < 300) {
      return jsonDecode(response.body)
      as Map<String, dynamic>;
    }

    throw Exception(
      'Mijozni tahrirlashda xatolik yuz berdi',
    );
  }

  // =========================================================
  // TAYYOR MAHSULOTLARNI OLISH
  // GET /api/finished-products
  // =========================================================

  Future<List<dynamic>> getFinishedProducts(
      String token,
      ) async {
    final response = await http.get(
      Uri.parse('$baseUrl/finished-products'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode >= 200 &&
        response.statusCode < 300) {
      return jsonDecode(response.body)
      as List<dynamic>;
    }

    throw Exception(
      'Tayyor mahsulotlarni yuklashda xatolik yuz berdi',
    );
  }

  // =========================================================
  // TAYYOR MAHSULOT QO'SHISH
  // POST /api/finished-products
  // =========================================================

  Future<Map<String, dynamic>> addFinishedProduct({
    required String token,
    required int productId,
    required int quantity,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/finished-products'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'productId': productId,
        'quantity': quantity,
      }),
    );

    if (response.statusCode >= 200 &&
        response.statusCode < 300) {
      return jsonDecode(response.body)
      as Map<String, dynamic>;
    }

    final errorData =
    jsonDecode(response.body);

    throw Exception(
      errorData['message'] ??
          'Tayyor mahsulotni saqlashda xatolik yuz berdi',
    );
  }

  // =========================================================
  // SOTUVLARNI OLISH
  // GET /api/sales
  // =========================================================

  Future<List<dynamic>> getSales(
      String token,
      ) async {
    final response = await http.get(
      Uri.parse('$baseUrl/sales'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode >= 200 &&
        response.statusCode < 300) {
      return jsonDecode(response.body)
      as List<dynamic>;
    }

    throw Exception(
      'Sotuvlarni yuklashda xatolik yuz berdi',
    );
  }

  // =========================================================
  // YANGI SOTUV YARATISH
  // POST /api/sales
  // =========================================================

  Future<Map<String, dynamic>> createSale({
    required String token,
    required int productId,
    required String saleType,
    required int quantity,
    required double paid,
    int? customerId,
    int? referrerId,
    String? phoneNumber,
    double? discount,
  }) async {
    final body = <String, dynamic>{
      'productId': productId,
      'saleType': saleType,
      'quantity': quantity,
      'paid': paid,
    };

    if (customerId != null) {
      body['customerId'] = customerId;
    }

    if (referrerId != null) {
      body['referrerId'] = referrerId;
    }

    if (phoneNumber != null) {
      body['phone_number'] = phoneNumber;
    }

    if (discount != null) {
      body['discount'] = discount;
    }

    final response = await http.post(
      Uri.parse('$baseUrl/sales'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode >= 200 &&
        response.statusCode < 300) {
      return jsonDecode(response.body)
      as Map<String, dynamic>;
    }

    final errorData =
    jsonDecode(response.body);

    throw Exception(
      errorData['message'] ??
          'Sotuvni saqlashda xatolik yuz berdi',
    );
  }

  // =========================================================
  // SOTUVNI O'CHIRISH
  // DELETE /api/sales/:id
  // =========================================================

  Future<void> deleteSale(
      String token,
      int id,
      ) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/sales/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode < 200 ||
        response.statusCode >= 300) {
      throw Exception(
        'Sotuvni o\'chirishda xatolik yuz berdi',
      );
    }
  }

  // =========================================================
  // SOTUVNI TAHRIRLASH
  // PUT /api/sales/:id
  // =========================================================

  Future<Map<String, dynamic>> updateSale({
    required String token,
    required int id,
    required int productId,
    required String saleType,
    required int quantity,
    required double paid,
    int? customerId,
    int? referrerId,
    String? phoneNumber,
    double? discount,
  }) async {
    final body = <String, dynamic>{
      'productId': productId,
      'saleType': saleType,
      'quantity': quantity,
      'paid': paid,
    };

    if (customerId != null) {
      body['customerId'] = customerId;
    }

    if (referrerId != null) {
      body['referrerId'] = referrerId;
    }

    if (phoneNumber != null) {
      body['phone_number'] = phoneNumber;
    }

    if (discount != null) {
      body['discount'] = discount;
    }

    final response = await http.put(
      Uri.parse('$baseUrl/sales/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode >= 200 &&
        response.statusCode < 300) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }

    final errorData = jsonDecode(response.body);
    throw Exception(
      errorData['message'] ?? 'Sotuvni yangilashda xatolik yuz berdi',
    );
  }

  // =========================================================
  // FOYDALANUVCHILARNI OLISH
  // GET /api/users
  // =========================================================

  Future<List<dynamic>> getUsers(
      String token,
      ) async {
    final response = await http.get(
      Uri.parse('$baseUrl/users'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode >= 200 &&
        response.statusCode < 300) {
      return jsonDecode(response.body)
      as List<dynamic>;
    }

    throw Exception(
      'Foydalanuvchilarni yuklashda xatolik yuz berdi',
    );
  }

  // =========================================================
  // FOYDALANUVCHI QO'SHISH
  // POST /api/users
  // =========================================================

  Future<Map<String, dynamic>> addUser({
    required String token,
    required Map<String, dynamic> userData,
  }) async {
    // userData nusxasini olamiz.
    final Map<String, dynamic> data =
    Map<String, dynamic>.from(userData);

    // Telefon bo'lsa, uni majburiy normalizatsiya qilamiz.
    if (data['phone_number'] != null) {
      data['phone_number'] =
          _normalizePhone(
            data['phone_number'].toString(),
          );
    }

    print('================ ADD USER ================');
    print('USER DATA: ${jsonEncode(data)}');
    print('PHONE: ${data['phone_number']}');
    print('==========================================');

    final response = await http.post(
      Uri.parse('$baseUrl/users'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode >= 200 &&
        response.statusCode < 300) {
      return jsonDecode(response.body)
      as Map<String, dynamic>;
    }

    final errorData =
    jsonDecode(response.body);

    throw Exception(
      errorData['message'] ??
          'Foydalanuvchini saqlashda xatolik yuz berdi',
    );
  }

  // =========================================================
  // FOYDALANUVCHINI YANGILASH
  // PUT /api/users/:id
  // =========================================================

  Future<Map<String, dynamic>> updateUser({
    required String token,
    required int id,
    required Map<String, dynamic> userData,
  }) async {
    // userData nusxasini olamiz.
    final Map<String, dynamic> data =
    Map<String, dynamic>.from(userData);

    // Telefonni majburiy normalizatsiya qilamiz.
    if (data['phone_number'] != null) {
      data['phone_number'] =
          _normalizePhone(
            data['phone_number'].toString(),
          );
    }

    print(
      '================ UPDATE USER ================',
    );
    print('ID: $id');
    print('USER DATA: ${jsonEncode(data)}');
    print('PHONE: ${data['phone_number']}');
    print('==============================================');

    final response = await http.put(
      Uri.parse('$baseUrl/users/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode >= 200 &&
        response.statusCode < 300) {
      return jsonDecode(response.body)
      as Map<String, dynamic>;
    }

    throw Exception(
      'Foydalanuvchini yangilashda xatolik: '
          '${response.statusCode} ${response.body}',
    );
  }

  // =========================================================
  // FOYDALANUVCHINI O'CHIRISH
  // DELETE /api/users/:id
  // =========================================================

  Future<void> deleteUser(
      String token,
      int id,
      ) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/users/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode < 200 ||
        response.statusCode >= 300) {
      throw Exception(
        'Foydalanuvchini o\'chirishda xatolik yuz berdi',
      );
    }
  }
}