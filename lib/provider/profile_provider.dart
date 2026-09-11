import 'package:afada/model/ishchi_modeli.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/image_picker_service.dart';

class ProfileProvider extends ChangeNotifier {
  String _name = "User";
  String _surname = "";
  String _phone = "";
  String _login = "";
  String _password = "";
  String? _imagePath;
  String _role = "Admin";
  String _language = "Uzb";

  String get name => _name;
  String get surname => _surname;
  String get phone => _phone;
  String get login => _login;
  String get password => _password;
  String? get imagePath => _imagePath;
  String get role => _role;
  String get language => _language;

  String get displayName => _name;
  String get displaySurname => _surname;

  /// F.I.Sh
  String get fullName {
    final result = "$_surname $_name".trim();
    return result.isEmpty ? "User" : result;
  }

  ProfileProvider() {
    _loadProfile();
  }

  String _normalizePhone(String value) {
    return value.replaceAll(RegExp(r'[^0-9]'), '');
  }

  String _roleFromApi(String role) {
    switch (role.toLowerCase()) {
      case "admin":
        return "Admin";
      case "seller":
      case "sotuvchi":
        return "Sotuvchi";
      case "worker":
      case "ishchi":
        return "Ishchi";
      default:
        return "Ishchi";
    }
  }

  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();

    _language = prefs.getString('user_language') ?? "Uzb";

    final savedRole = prefs.getString('user_role') ?? "";
    final currentLogin = prefs.getString('user_login') ?? "";
    final savedPhone = prefs.getString('user_phone') ?? "";

    // ---------------------------------------------------------
    // ADMIN
    // ---------------------------------------------------------
    if (savedRole.toLowerCase() == "admin") {
      _role = "Admin";

      // Login paytida API'dan kelgan F.I.Sh.
      final sessionName = prefs.getString('user_name') ?? "";

      if (sessionName.trim().isNotEmpty) {
        final parts = sessionName.trim().split(RegExp(r'\s+'));

        if (parts.length >= 2) {
          _surname = parts.first;
          _name = parts.sublist(1).join(' ');
        } else {
          _name = parts.first;
          _surname = "";
        }
      } else {
        _name = prefs.getString('profile_name') ?? "User";
        _surname = prefs.getString('profile_surname') ?? "";
      }

      // Login paytidagi telefon
      _phone = prefs.getString('profile_phone') ?? savedPhone;

      _login = currentLogin.isNotEmpty
          ? currentLogin
          : prefs.getString('profile_login') ?? "";

      _password = prefs.getString('profile_password') ?? "";

      _imagePath = prefs.getString('profile_image_admin');

      notifyListeners();
      return;
    }

    // ---------------------------------------------------------
    // ISHCHI / SOTUVCHI
    // ---------------------------------------------------------

    // Avval saqlangan login/telefonni olamiz
    final loginToFind = currentLogin;
    final phoneToFind = _normalizePhone(savedPhone);

    IshchiModel? currentEmployee;

    // 1. Avval TELEFON orqali qidiramiz
    if (phoneToFind.isNotEmpty) {
      for (final employee in IshchiDatabase.ishchilar) {
        final employeePhone = _normalizePhone(employee.telefon);

        if (employeePhone.isNotEmpty &&
            employeePhone == phoneToFind) {
          currentEmployee = employee;
          break;
        }
      }
    }

    // 2. Telefon topilmasa LOGIN orqali qidiramiz
    if (currentEmployee == null && loginToFind.isNotEmpty) {
      for (final employee in IshchiDatabase.ishchilar) {
        if (employee.login == loginToFind) {
          currentEmployee = employee;
          break;
        }
      }
    }

    // ---------------------------------------------------------
    // EMPLOYEE TOPILDI
    // ---------------------------------------------------------
    if (currentEmployee != null) {
      _name = currentEmployee.ism;
      _surname = currentEmployee.familya;
      _phone = currentEmployee.telefon;

      _login = currentEmployee.login ?? "";
      _password = currentEmployee.parol ?? "";

      _role = currentEmployee.lavozim.isNotEmpty
          ? currentEmployee.lavozim
          : "Ishchi";

      _imagePath = prefs.getString(
        'profile_image_${currentEmployee.login}',
      );

      // Agar employee rasmi bo'lsa va profile rasmi hali yo'q bo'lsa
      if ((_imagePath == null || _imagePath!.isEmpty) &&
          currentEmployee.rasm != null &&
          currentEmployee.rasm!.isNotEmpty) {
        _imagePath = currentEmployee.rasm;
      }

      // Session ma'lumotlarini ham yangilab qo'yamiz
      await prefs.setString(
        'user_name',
        "${currentEmployee.ism} ${currentEmployee.familya}".trim(),
      );

      await prefs.setString(
        'user_phone',
        currentEmployee.telefon,
      );

      if (currentEmployee.login != null) {
        await prefs.setString(
          'user_login',
          currentEmployee.login!,
        );
      }

      notifyListeners();
      return;
    }

    // ---------------------------------------------------------
    // FALLBACK
    // ---------------------------------------------------------

    final sessionName = prefs.getString('user_name') ?? "";

    if (sessionName.isNotEmpty) {
      final parts = sessionName.trim().split(RegExp(r'\s+'));

      if (parts.length >= 2) {
        _surname = parts.first;
        _name = parts.sublist(1).join(' ');
      } else {
        _name = parts.first;
      }
    }

    _phone = savedPhone;
    _login = currentLogin;

    _password = prefs.getString('user_password') ?? "";

    _role = _roleFromApi(savedRole);

    if (_login.isNotEmpty) {
      _imagePath = prefs.getString(
        'profile_image_$_login',
      );
    }

    notifyListeners();
  }

  Future<void> setSession(
      String role,
      String fullName,
      ) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('user_role', role);
    await prefs.setString('user_name', fullName);

    await _loadProfile();
  }

  Future<void> updateRole(String newRole) async {
    _role = newRole;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_role', newRole);

    notifyListeners();
  }

  Future<void> updateLanguage(String newLanguage) async {
    _language = newLanguage;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_language', newLanguage);

    notifyListeners();
  }

  // Bu funksiyalar eski kod bilan compatibility uchun qoldirildi.
  // Profile UI'da endi ularga edit tugmasi qo'yilmaydi.

  Future<void> updateProfileField(
      String key,
      String value,
      ) async {
    final prefs = await SharedPreferences.getInstance();

    if (_role == "Admin") {
      if (key == "name") {
        _name = value;
        await prefs.setString('profile_name', value);
      } else if (key == "surname") {
        _surname = value;
        await prefs.setString('profile_surname', value);
      } else if (key == "phone") {
        _phone = value;
        await prefs.setString('profile_phone', value);
      } else if (key == "login") {
        _login = value;
        await prefs.setString('profile_login', value);
      } else if (key == "password") {
        _password = value;
        await prefs.setString('profile_password', value);
      }
    } else {
      final oldLogin = _login;

      if (key == "name") {
        _name = value;
      } else if (key == "surname") {
        _surname = value;
      } else if (key == "phone") {
        _phone = value;
      } else if (key == "login") {
        _login = value;
      } else if (key == "password") {
        _password = value;
      }

      final index = IshchiDatabase.ishchilar.indexWhere(
            (e) => e.login == oldLogin,
      );

      if (index != -1) {
        final old = IshchiDatabase.ishchilar[index];

        final updated = IshchiModel(
          id: old.id,
          ism: _name,
          familya: _surname,
          telefon: _phone,
          lavozim: old.lavozim,
          kasb: old.kasb,
          rasm: old.rasm,
          login: _login,
          parol: _password,
          telegramChatId: old.telegramChatId,
        );

        IshchiDatabase.tahrirlash(
          index,
          updated,
        );
      }

      await prefs.setString(
        'user_name',
        "$_name $_surname".trim(),
      );

      await prefs.setString(
        'user_phone',
        _phone,
      );

      await prefs.setString(
        'user_login',
        _login,
      );

      await prefs.setString(
        'user_password',
        _password,
      );
    }

    notifyListeners();
  }

  Future<void> updateName(String newName) =>
      updateProfileField('name', newName);

  Future<void> updateSurname(String newSurname) =>
      updateProfileField('surname', newSurname);

  Future<void> updatePhone(String newPhone) =>
      updateProfileField('phone', newPhone);

  Future<void> pickImage(
      BuildContext context,
      ImageSource source,
      ) async {
    final path = await ImagePickerService.pickImage(
      context,
      source,
    );

    if (path == null) return;

    _imagePath = path;

    final prefs = await SharedPreferences.getInstance();

    final key = _role == "Admin"
        ? "profile_image_admin"
        : "profile_image_$_login";

    await prefs.setString(
      key,
      _imagePath!,
    );

    // Employee uchun rasmni ham yangilaymiz
    if (_role != "Admin") {
      int index = -1;

      // Avval telefon orqali
      final currentPhone = _normalizePhone(_phone);

      if (currentPhone.isNotEmpty) {
        index = IshchiDatabase.ishchilar.indexWhere(
              (e) =>
          _normalizePhone(e.telefon) == currentPhone,
        );
      }

      // Keyin login orqali
      if (index == -1 && _login.isNotEmpty) {
        index = IshchiDatabase.ishchilar.indexWhere(
              (e) => e.login == _login,
        );
      }

      if (index != -1) {
        final old = IshchiDatabase.ishchilar[index];

        final updated = IshchiModel(
          id: old.id,
          ism: old.ism,
          familya: old.familya,
          telefon: old.telefon,
          lavozim: old.lavozim,
          kasb: old.kasb,
          rasm: _imagePath,
          login: old.login,
          parol: old.parol,
          telegramChatId: old.telegramChatId,
        );

        IshchiDatabase.tahrirlash(
          index,
          updated,
        );
      }
    }

    notifyListeners();
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove('user_role');
    await prefs.remove('user_name');
    await prefs.remove('user_login');
    await prefs.remove('user_phone');
    await prefs.remove('user_password');
    await prefs.remove('access_token');

    _role = "Admin";
    _name = "User";
    _surname = "";
    _phone = "";
    _login = "";
    _password = "";
    _imagePath = null;

    await _loadProfile();
  }
}