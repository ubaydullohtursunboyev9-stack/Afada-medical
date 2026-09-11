import 'dart:io';
import 'dart:ui';

import 'package:afada/login/login_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

import '../../provider/profile_provider.dart';

class DraverProfilPages extends StatefulWidget {
  const DraverProfilPages({super.key});

  @override
  State<DraverProfilPages> createState() => _DraverProfilPagesState();
}

class _DraverProfilPagesState extends State<DraverProfilPages> {
  static final Map<String, Map<String, String>> _localizedTexts = {
    'Uzb': {
      'profile': 'Profil',
      'full_name': 'F.I.Sh:',
      'phone': 'Telefon:',
      'role': 'Lavozim:',
      'admin': 'Admin',
      'worker': 'Ishchi',
      'seller': 'Sotuvchi',
      'camera': 'Kamera',
      'gallery': 'Galereya',
      'logout': 'Hisobdan chiqish',
      'logout_confirm': 'Hisobdan chiqmoqchimisiz?',
      'no': "Yo'q",
      'yes': 'Ha',
    },
    'Rus': {
      'profile': 'Профиль',
      'full_name': 'Ф.И.О:',
      'phone': 'Телефон:',
      'role': 'Должность:',
      'admin': 'Админ',
      'worker': 'Работник',
      'seller': 'Продавец',
      'camera': 'Камера',
      'gallery': 'Галерея',
      'logout': 'Выйти из аккаунта',
      'logout_confirm': 'Вы уверены, что хотите выйти?',
      'no': 'Нет',
      'yes': 'Да',
    },
    'Kiril': {
      'profile': 'Профил',
      'full_name': 'Ф.И.Ш:',
      'phone': 'Телефон:',
      'role': 'Лавозим:',
      'admin': 'Админ',
      'worker': 'Ишчи',
      'seller': 'Сотувчи',
      'camera': 'Камера',
      'gallery': 'Галерея',
      'logout': 'Ҳисобдан чиқиш',
      'logout_confirm': 'Ҳисобдан чиқмоқчимисиз?',
      'no': 'Йўқ',
      'yes': 'Ҳа',
    },
  };

  static String getTxt(String lang, String key) {
    return _localizedTexts[lang]?[key] ??
        _localizedTexts['Uzb']![key] ??
        key;
  }

  // ============================================================
  // PROFILE IMAGE PICKER
  // ============================================================

  void _showImagePickerSheet(BuildContext context) {
    final bool isDark =
        Theme.of(context).brightness == Brightness.dark;

    final profileProvider =
    context.read<ProfileProvider>();

    final String language =
        profileProvider.language;

    showModalBottomSheet(
      context: context,
      backgroundColor:
      isDark ? const Color(0xFF252836) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 10,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 45,
                  height: 5,
                  margin: const EdgeInsets.only(
                    bottom: 10,
                  ),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white24
                        : Colors.black12,
                    borderRadius:
                    BorderRadius.circular(10),
                  ),
                ),

                ListTile(
                  leading: Icon(
                    Icons.camera_alt,
                    color: isDark
                        ? Colors.white
                        : Colors.black,
                  ),
                  title: Text(
                    getTxt(language, 'camera'),
                    style: TextStyle(
                      color: isDark
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);

                    profileProvider.pickImage(
                      context,
                      ImageSource.camera,
                    );
                  },
                ),

                ListTile(
                  leading: Icon(
                    Icons.photo_library,
                    color: isDark
                        ? Colors.white
                        : Colors.black,
                  ),
                  title: Text(
                    getTxt(language, 'gallery'),
                    style: TextStyle(
                      color: isDark
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);

                    profileProvider.pickImage(
                      context,
                      ImageSource.gallery,
                    );
                  },
                ),

                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // LOGOUT
  // ============================================================

  void _showLogoutDialog(BuildContext context) {
    final profileProvider =
    context.read<ProfileProvider>();

    final String language =
        profileProvider.language;

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      transitionDuration:
      const Duration(milliseconds: 300),
      pageBuilder:
          (context, anim1, anim2) =>
      const SizedBox(),
      transitionBuilder:
          (context, anim1, anim2, child) {
        final bool isDark =
            Theme.of(context).brightness ==
                Brightness.dark;

        return Transform.scale(
          scale: anim1.value,
          child: FadeTransition(
            opacity: anim1,
            child: AlertDialog(
              backgroundColor:
              Colors.transparent,
              contentPadding:
              EdgeInsets.zero,
              content: ClipRRect(
                borderRadius:
                BorderRadius.circular(24),
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 10,
                    sigmaY: 10,
                  ),
                  child: Container(
                    padding:
                    const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color.fromRGBO(
                        255,
                        255,
                        255,
                        0.1,
                      )
                          : const Color.fromRGBO(
                        255,
                        255,
                        255,
                        0.85,
                      ),
                      borderRadius:
                      BorderRadius.circular(24),
                      border: Border.all(
                        color: isDark
                            ? const Color.fromRGBO(
                          255,
                          255,
                          255,
                          0.2,
                        )
                            : const Color.fromRGBO(
                          0,
                          0,
                          0,
                          0.1,
                        ),
                      ),
                    ),
                    child: Column(
                      mainAxisSize:
                      MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.logout,
                          size: 50,
                          color: Colors.redAccent,
                        ),

                        const SizedBox(height: 20),

                        Text(
                          getTxt(
                            language,
                            'logout_confirm',
                          ),
                          textAlign:
                          TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight:
                            FontWeight.bold,
                            color: isDark
                                ? Colors.white
                                : Colors.black87,
                          ),
                        ),

                        const SizedBox(height: 30),

                        Row(
                          children: [
                            Expanded(
                              child: TextButton(
                                onPressed: () =>
                                    Navigator.pop(
                                      context,
                                    ),
                                child: Text(
                                  getTxt(
                                    language,
                                    'no',
                                  ),
                                  style: TextStyle(
                                    color: isDark
                                        ? Colors.white70
                                        : Colors.black54,
                                    fontWeight:
                                    FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(
                              width: 15,
                            ),

                            Expanded(
                              child:
                              ElevatedButton(
                                onPressed:
                                    () async {
                                  Navigator.pop(
                                    context,
                                  );

                                  await profileProvider
                                      .logout();

                                  if (!mounted) {
                                    return;
                                  }

                                  Navigator
                                      .pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) =>
                                      const LoginPage(),
                                    ),
                                        (route) =>
                                    false,
                                  );
                                },
                                style:
                                ElevatedButton
                                    .styleFrom(
                                  backgroundColor:
                                  Colors.redAccent,
                                  foregroundColor:
                                  Colors.white,
                                  shape:
                                  RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius
                                        .circular(
                                      12,
                                    ),
                                  ),
                                  elevation: 0,
                                ),
                                child: Text(
                                  getTxt(
                                    language,
                                    'yes',
                                  ),
                                  style:
                                  const TextStyle(
                                    fontWeight:
                                    FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // ROLE
  // ============================================================

  String _localizedRole(
      String role,
      String language,
      ) {
    final normalized =
    role.trim().toLowerCase();

    if (normalized == 'admin') {
      return getTxt(language, 'admin');
    }

    if (normalized == 'seller' ||
        normalized == 'sotuvchi') {
      return getTxt(language, 'seller');
    }

    return getTxt(language, 'worker');
  }

  // ============================================================
  // INFO ROW
  // ============================================================

  Widget _buildInfoRow({
    required String label,
    required String value,
    required IconData icon,
    required bool isDark,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 15,
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF3C8DFF)
                  .withValues(alpha: 0.15)
                  : Colors.indigo
                  .withValues(alpha: 0.08),
              borderRadius:
              BorderRadius.circular(13),
            ),
            child: Icon(
              icon,
              size: 21,
              color: isDark
                  ? const Color(0xFF3C8DFF)
                  : Colors.indigo,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark
                        ? Colors.white54
                        : Colors.black45,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  value.isEmpty
                      ? "—"
                      : value,
                  maxLines: 2,
                  overflow:
                  TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight:
                    FontWeight.w600,
                    color: isDark
                        ? Colors.white
                        : Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final bool isDark =
        Theme.of(context).brightness ==
            Brightness.dark;

    final profile =
    context.watch<ProfileProvider>();

    final String language =
        profile.language;

    final String fullName =
    "${profile.surname} ${profile.name}"
        .trim();

    final String displayName =
    fullName.isEmpty
        ? "User"
        : fullName;

    final String displayPhone =
    profile.phone.trim();

    final String displayRole =
    _localizedRole(
      profile.role,
      language,
    );

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF181A20)
          : Colors.blue.shade100,

      // ========================================================
      // APP BAR
      // ========================================================

      appBar: AppBar(
        backgroundColor: isDark
            ? const Color(0xFF181A20)
            : Colors.indigo,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          getTxt(language, 'profile'),
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      // ========================================================
      // BODY
      // ========================================================

      body: SafeArea(
        child: SingleChildScrollView(
          physics:
          const BouncingScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(height: 28),

              // ==================================================
              // PROFILE IMAGE
              // ==================================================

              Center(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isDark
                            ? const Color(
                          0xFF2A2E38,
                        )
                            : Colors.grey.shade400,
                        border: Border.all(
                          color: isDark
                              ? const Color(
                            0xFF3A3F4B,
                          )
                              : Colors.white,
                          width: 3,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black
                                .withValues(
                              alpha: 0.15,
                            ),
                            blurRadius: 20,
                            spreadRadius: 2,
                          ),
                        ],
                        image: profile
                            .imagePath !=
                            null &&
                            profile.imagePath!
                                .isNotEmpty
                            ? DecorationImage(
                          image: FileImage(
                            File(
                              profile
                                  .imagePath!,
                            ),
                          ),
                          fit: BoxFit.cover,
                        )
                            : null,
                      ),
                      child: profile
                          .imagePath ==
                          null ||
                          profile.imagePath!
                              .isEmpty
                          ? Center(
                        child: Text(
                          displayName
                              .trim()
                              .isNotEmpty
                              ? displayName
                              .trim()
                              .substring(
                            0,
                            1,
                          )
                              .toUpperCase()
                              : "?",
                          style:
                          TextStyle(
                            fontSize: 55,
                            fontWeight:
                            FontWeight
                                .bold,
                            color: isDark
                                ? const Color(
                              0xFF3C8DFF,
                            )
                                : Colors
                                .indigo,
                          ),
                        ),
                      )
                          : null,
                    ),

                    // CAMERA BUTTON
                    Positioned(
                      right: -2,
                      bottom: -2,
                      child: GestureDetector(
                        onTap: () =>
                            _showImagePickerSheet(
                              context,
                            ),
                        child: Container(
                          width: 45,
                          height: 45,
                          decoration:
                          BoxDecoration(
                            shape:
                            BoxShape.circle,
                            color: isDark
                                ? const Color(
                              0xFF3C8DFF,
                            )
                                : Colors.indigo,
                            border: Border.all(
                              color: isDark
                                  ? const Color(
                                0xFF181A20,
                              )
                                  : Colors
                                  .white,
                              width: 3,
                            ),
                          ),
                          child: const Icon(
                            Icons
                                .camera_alt,
                            color:
                            Colors.white,
                            size: 22,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ==================================================
              // FULL NAME
              // ==================================================

              Padding(
                padding:
                const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Text(
                  displayName,
                  textAlign:
                  TextAlign.center,
                  maxLines: 2,
                  overflow:
                  TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight:
                    FontWeight.bold,
                    color: isDark
                        ? Colors.white
                        : Colors.black87,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // ROLE CHIP
              Container(
                padding:
                const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(
                    0xFF3C8DFF,
                  ).withValues(
                    alpha: 0.15,
                  )
                      : Colors.indigo
                      .withValues(
                    alpha: 0.1,
                  ),
                  borderRadius:
                  BorderRadius.circular(20),
                ),
                child: Text(
                  displayRole,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight:
                    FontWeight.w600,
                    color: isDark
                        ? const Color(
                      0xFF3C8DFF,
                    )
                        : Colors.indigo,
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // ==================================================
              // INFO CARD
              // ==================================================

              Padding(
                padding:
                const EdgeInsets.symmetric(
                  horizontal: 12,
                ),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(
                      0xFF252836,
                    )
                        : Colors.white,
                    borderRadius:
                    BorderRadius.circular(
                      20,
                    ),
                    border: Border.all(
                      color: isDark
                          ? const Color(
                        0xFF3A3F4B,
                      )
                          : Colors.black12,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black
                            .withValues(
                          alpha: 0.08,
                        ),
                        blurRadius: 15,
                        offset:
                        const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _buildInfoRow(
                        label: getTxt(
                          language,
                          'full_name',
                        ),
                        value: displayName,
                        icon:
                        Icons.person_outline,
                        isDark: isDark,
                      ),

                      Divider(
                        height: 1,
                        indent: 18,
                        endIndent: 18,
                        color: isDark
                            ? const Color(
                          0xFF3A3F4B,
                        )
                            : Colors.black12,
                      ),

                      _buildInfoRow(
                        label: getTxt(
                          language,
                          'phone',
                        ),
                        value: displayPhone,
                        icon:
                        Icons.phone_outlined,
                        isDark: isDark,
                      ),

                      Divider(
                        height: 1,
                        indent: 18,
                        endIndent: 18,
                        color: isDark
                            ? const Color(
                          0xFF3A3F4B,
                        )
                            : Colors.black12,
                      ),

                      _buildInfoRow(
                        label: getTxt(
                          language,
                          'role',
                        ),
                        value: displayRole,
                        icon:
                        Icons.badge_outlined,
                        isDark: isDark,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // ==================================================
              // LOGOUT
              // ==================================================

              Padding(
                padding:
                const EdgeInsets.symmetric(
                  horizontal: 12,
                ),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(
                      0xFF252836,
                    )
                        : Colors.white,
                    borderRadius:
                    BorderRadius.circular(
                      18,
                    ),
                    border: Border.all(
                      color: Colors.red
                          .withValues(
                        alpha: 0.25,
                      ),
                    ),
                  ),
                  child: TextButton(
                    onPressed: () =>
                        _showLogoutDialog(
                          context,
                        ),
                    style: TextButton.styleFrom(
                      padding:
                      const EdgeInsets
                          .symmetric(
                        horizontal: 18,
                        vertical: 15,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration:
                          BoxDecoration(
                            color: Colors.red
                                .withValues(
                              alpha: 0.1,
                            ),
                            borderRadius:
                            BorderRadius
                                .circular(
                              12,
                            ),
                          ),
                          child: const Icon(
                            Icons.logout,
                            color: Colors.red,
                            size: 22,
                          ),
                        ),

                        const SizedBox(
                          width: 14,
                        ),

                        Text(
                          getTxt(
                            language,
                            'logout',
                          ),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight:
                            FontWeight.w600,
                            color: isDark
                                ? Colors.white
                                : Colors.indigo,
                          ),
                        ),

                        const Spacer(),

                        Icon(
                          Icons
                              .arrow_forward_ios,
                          size: 16,
                          color: isDark
                              ? Colors.white38
                              : Colors.black38,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}