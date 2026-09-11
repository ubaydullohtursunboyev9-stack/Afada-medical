import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:afada/provider/ishchilar_Provider/ishchilar_provider.dart';
import '../provider/profile_provider.dart';
import '../model/ishchi_modeli.dart';
import 'dart:ui';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class IshchilarPages extends StatefulWidget {
  const IshchilarPages({super.key});

  @override
  State<IshchilarPages> createState() => _IshchilarPagesState();

  static final Map<String, Map<String, String>> _localizedTexts = {
    "Uzb": {
      "Ma'lumot kiritilmagan": "Ma'lumot kiritilmagan",
      "Texnik xodim": "Texnik xodim",
      "Shifokorlar": "Shifokorlar",
      "Barchasi": "Barchasi",
      "Tahrirlash": "Tahrirlash",
      "Ishchi qo'shish": "Ishchi qo'shish",
      "Kamera": "Kamera",
      "Galereya": "Galereya",
      "F.I.Sh": "F.I.Sh",
      "Admin": "Admin",
      "Ishchi": "Ishchi",
      "Sotuvchi": "Sotuvchi",
      "Shifokor": "Shifokor",
      "Bekor qilish": "Bekor qilish",
      "Yangilash": "Yangilash",
      "Saqlash": "Saqlash",
      "Asosiy ma'lumotlarni to'ldiring":
      "Asosiy ma'lumotlarni to'ldiring",
      "Login Parol kiriting": "Login Parol kiriting",
      "Login": "Login",
      "Parol": "Parol",
      "Login va parolni kiriting": "Login va parolni kiriting",
      "Bu Login yoki Parol allaqachon ishlatilgan.":
      "Bu Login yoki Parol allaqachon ishlatilgan.",
    },
    "Rus": {
      "Ma'lumot kiritilmagan": "Данные не введены",
      "Texnik xodim": "Технический персонал",
      "Shifokorlar": "Врачи",
      "Barchasi": "Все",
      "Tahrirlash": "Редактировать",
      "Ishchi qo'shish": "Добавить сотрудника",
      "Kamera": "Камера",
      "Galereya": "Галерея",
      "F.I.Sh": "Ф.И.О",
      "Admin": "Админ",
      "Ishchi": "Работник",
      "Sotuvchi": "Продавец",
      "Shifokor": "Врач",
      "Bekor qilish": "Отмена",
      "Yangilash": "Обновить",
      "Saqlash": "Сохранить",
      "Asosiy ma'lumotlarni to'ldiring":
      "Заполните основные данные",
      "Login Parol kiriting": "Введите логин и пароль",
      "Login": "Логин",
      "Parol": "Пароль",
      "Login va parolni kiriting":
      "Введите логин и пароль",
      "Bu Login yoki Parol allaqachon ishlatilgan.":
      "Этот логин или пароль уже используется.",
    },
    "Kiril": {
      "Ma'lumot kiritilmagan": "Маълумот киритилмаган",
      "Texnik xodim": "Техник ходим",
      "Shifokorlar": "Шифокорлар",
      "Barchasi": "Барчаси",
      "Tahrirlash": "Таҳрирлаш",
      "Ishchi qo'shish": "Ишчи қўшиш",
      "Kamera": "Камера",
      "Galereya": "Галерея",
      "F.I.Sh": "Ф.И.Ш",
      "Admin": "Админ",
      "Ishchi": "Ишчи",
      "Sotuvchi": "Сотувчи",
      "Shifokor": "Шифокор",
      "Bekor qilish": "Бекор қилиш",
      "Yangilash": "Янгилаш",
      "Saqlash": "Сақлаш",
      "Asosiy ma'lumotlarni to'ldiring":
      "Асосий маълумотларни тўлдиринг",
      "Login Parol kiriting": "Логин Парол киритинг",
      "Login": "Логин",
      "Parol": "Парол",
      "Login va parolni kiriting":
      "Логин ва паролни киритинг",
      "Bu Login yoki Parol allaqachon ishlatilgan.":
      "Бу Login ёки Парол аллақачон ишлатилган.",
    },
  };

  static String getTxt(BuildContext context, String key) {
    return _localizedTexts[
    Provider.of<ProfileProvider>(
      context,
      listen: false,
    ).language]?[key] ??
        key;
  }
}

class _IshchilarPagesState extends State<IshchilarPages> {
  final maskFormatter =
  MaskTextInputFormatter(mask: '## ### ## ##');

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<IshchiProvider>().fetchIshchilar();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<IshchiProvider>();
    final profile = context.watch<ProfileProvider>();

    final bool isDark =
        Theme.of(context).brightness == Brightness.dark;

    final bool hasEmployees =
        provider.ishchilar.isNotEmpty;

    // FAQAT ADMIN
    final bool isAdmin =
        profile.role.trim().toLowerCase() == 'admin';

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF181A20)
          : Colors.blue.shade100,

      // + tugma faqat Admin uchun
      floatingActionButton:
      isAdmin ? _buildAddButton(context) : null,

      body: SafeArea(
        child: provider.isLoading &&
            provider.ishchilar.isEmpty
            ? const Center(
          child: CircularProgressIndicator(),
        )
            : !hasEmployees
            ? Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment:
              MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.assignment_outlined,
                  size: 80,
                  color: isDark
                      ? Colors.white38
                      : Colors.black26,
                ),
                const SizedBox(height: 10),
                Text(
                  IshchilarPages.getTxt(
                    context,
                    "Ma'lumot kiritilmagan",
                  ),
                  style: TextStyle(
                    fontSize: 18,
                    color: isDark
                        ? Colors.white38
                        : Colors.black26,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (provider.error != null)
                  Padding(
                    padding:
                    const EdgeInsets.all(16.0),
                    child: Text(
                      provider.error!,
                      style: const TextStyle(
                        color: Colors.red,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],
            ),
          ),
        )
            : RefreshIndicator(
          onRefresh: () =>
              provider.fetchIshchilar(),
          child: LayoutBuilder(
            builder:
                (context, constraints) {
              return SingleChildScrollView(
                physics:
                const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding:
                  const EdgeInsets.all(10),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth:
                        constraints.maxWidth >
                            1000
                            ? 1000
                            : constraints
                            .maxWidth,
                      ),
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          if (provider.error !=
                              null)
                            Container(
                              padding:
                              const EdgeInsets
                                  .all(8),
                              margin:
                              const EdgeInsets
                                  .only(
                                bottom: 10,
                              ),
                              decoration:
                              BoxDecoration(
                                color: Colors.red
                                    .withValues(
                                  alpha: 0.1,
                                ),
                                borderRadius:
                                BorderRadius
                                    .circular(
                                  8,
                                ),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons
                                        .error_outline,
                                    color:
                                    Colors.red,
                                  ),
                                  const SizedBox(
                                      width: 8),
                                  Expanded(
                                    child: Text(
                                      provider.error!,
                                      style:
                                      const TextStyle(
                                        color:
                                        Colors.red,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          IshchiGuruhi(
                            title:
                            IshchilarPages
                                .getTxt(
                              context,
                              "Texnik xodim",
                            ),
                            kasb: "Texnik xodim",
                          ),

                          const SizedBox(
                              height: 10),

                          IshchiGuruhi(
                            title:
                            IshchilarPages
                                .getTxt(
                              context,
                              "Shifokorlar",
                            ),
                            kasb: "Shifokor",
                          ),

                          const SizedBox(
                              height: 200),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildAddButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom:
        MediaQuery.of(context).size.height * 0.07,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 15,
            sigmaY: 15,
          ),
          child: Container(
            width: 65,
            height: 65,
            decoration: BoxDecoration(
              color:
              Colors.white.withValues(alpha: 0.12),
              borderRadius:
              BorderRadius.circular(25),
              border: Border.all(
                color:
                Colors.white.withValues(alpha: 0.3),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.indigo
                      .withValues(alpha: 0.25),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius:
                BorderRadius.circular(25),
                onTap: () {
                  context
                      .read<IshchiProvider>()
                      .tozalash();

                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) =>
                        IshchiQoshishDialog(
                          maskFormatter:
                          maskFormatter,
                        ),
                  );
                },
                child: const Center(
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 35,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class IshchiGuruhi extends StatelessWidget {
  final String title;
  final String kasb;

  const IshchiGuruhi({
    super.key,
    required this.title,
    required this.kasb,
  });

  Future<void> _makePhoneCall(
      String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );

    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    }
  }

  void _showDetailDialog(
      BuildContext context,
      IshchiModel ishchi,
      int realIndex,
      ) {
    final bool isDark =
        Theme.of(context).brightness ==
            Brightness.dark;

    // ADMINNI TEKSHIRISH
    final profile =
    context.read<ProfileProvider>();

    final bool isAdmin =
        profile.role.trim().toLowerCase() ==
            'admin';

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding:
        const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 15,
            sigmaY: 15,
          ),
          child: Container(
            constraints:
            const BoxConstraints(
              maxWidth: 400,
            ),
            padding:
            const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF252836)
                  .withValues(alpha: 0.9)
                  : Colors.white
                  .withValues(alpha: 0.9),
              borderRadius:
              BorderRadius.circular(20),
              border: Border.all(
                color: isDark
                    ? const Color(0xFF3A3F4B)
                    : Colors.indigo
                    .withValues(alpha: 0.3),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black
                      .withValues(alpha: 0.2),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize:
                MainAxisSize.min,
                children: [
                  Text(
                    "Ishchi ma'lumotlari",
                    style: TextStyle(
                      color: isDark
                          ? Colors.white
                          : Colors.indigo,
                      fontWeight:
                      FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),

                  const SizedBox(height: 24),

                  CircleAvatar(
                    radius: 55,
                    backgroundColor: isDark
                        ? const Color(0xFF2A2E38)
                        : Colors.grey.shade200,
                    backgroundImage:
                    (ishchi.rasm != null &&
                        ishchi.rasm!
                            .isNotEmpty)
                        ? (ishchi.rasm!
                        .startsWith(
                        'http')
                        ? NetworkImage(
                      ishchi.rasm!,
                    )
                        : FileImage(
                      File(
                        ishchi.rasm!,
                      ),
                    ) as ImageProvider)
                        : null,
                    child:
                    (ishchi.rasm == null ||
                        ishchi.rasm!.isEmpty)
                        ? Text(
                      (ishchi.familya
                          .trim()
                          .isNotEmpty
                          ? ishchi.familya
                          .trim()
                          : ishchi.ism
                          .trim())[0]
                          .toUpperCase(),
                      style:
                      const TextStyle(
                        fontSize: 45,
                        fontWeight:
                        FontWeight.bold,
                        color:
                        Colors.indigo,
                      ),
                    )
                        : null,
                  ),

                  const SizedBox(height: 24),

                  _buildDetailItem(
                    "F.I.Sh",
                    "${ishchi.familya} ${ishchi.ism}",
                    isDark,
                  ),

                  _buildDetailItem(
                    "Telefon",
                    ishchi.telefon
                        .startsWith('+')
                        ? ishchi.telefon
                        : "+${ishchi.telefon}",
                    isDark,
                  ),

                  _buildDetailItem(
                    "Lavozim",
                    ishchi.lavozim,
                    isDark,
                  ),

                  _buildDetailItem(
                    "Kasbi",
                    ishchi.kasb,
                    isDark,
                  ),

                  if (ishchi.login != null &&
                      ishchi.login!.isNotEmpty)
                    _buildDetailItem(
                      "Login",
                      ishchi.login!,
                      isDark,
                    ),

                  const SizedBox(height: 30),

                  // FAQAT ADMIN UCHUN
                  if (isAdmin) ...[
                    Row(
                      children: [
                        Expanded(
                          child:
                          ElevatedButton.icon(
                            style:
                            ElevatedButton.styleFrom(
                              backgroundColor:
                              Colors.red.withValues(
                                alpha: 0.1,
                              ),
                              foregroundColor:
                              Colors.red,
                              elevation: 0,
                              side:
                              const BorderSide(
                                color: Colors.red,
                                width: 0.5,
                              ),
                              shape:
                              RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius
                                    .circular(
                                  12,
                                ),
                              ),
                            ),
                            onPressed: () {
                              Navigator.pop(
                                  context);

                              _showDeleteDialog(
                                context,
                                realIndex,
                              );
                            },
                            icon: const Icon(
                              Icons.delete_outline,
                              size: 20,
                            ),
                            label: const Text(
                              "O'chirish",
                            ),
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child:
                          ElevatedButton.icon(
                            style:
                            ElevatedButton.styleFrom(
                              backgroundColor:
                              Colors.blue.withValues(
                                alpha: 0.1,
                              ),
                              foregroundColor:
                              Colors.blue,
                              elevation: 0,
                              side:
                              const BorderSide(
                                color: Colors.blue,
                                width: 0.5,
                              ),
                              shape:
                              RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius
                                    .circular(
                                  12,
                                ),
                              ),
                            ),
                            onPressed: () {
                              Navigator.pop(
                                  context);

                              context
                                  .read<
                                  IshchiProvider>()
                                  .tahrirlashUchunYuklash(
                                realIndex,
                              );

                              showDialog(
                                context: context,
                                barrierDismissible:
                                false,
                                builder:
                                    (context) =>
                                    IshchiQoshishDialog(
                                      maskFormatter:
                                      MaskTextInputFormatter(
                                        mask:
                                        '## ### ## ##',
                                      ),
                                      isEditing: true,
                                    ),
                              );
                            },
                            icon: const Icon(
                              Icons.edit_outlined,
                              size: 20,
                            ),
                            label: const Text(
                              "Tahrirlash",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],

                  const SizedBox(height: 12),

                  TextButton(
                    onPressed: () =>
                        Navigator.pop(context),
                    child: Text(
                      "Yopish",
                      style: TextStyle(
                        color: isDark
                            ? Colors.white70
                            : Colors.black54,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(
      String label,
      String value,
      bool isDark,
      ) {
    return Padding(
      padding:
      const EdgeInsets.symmetric(
        vertical: 10.0,
      ),
      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Text(
            "$label: ",
            style: TextStyle(
              fontWeight:
              FontWeight.bold,
              color: isDark
                  ? Colors.white70
                  : Colors.black54,
              fontSize: 16,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: isDark
                    ? Colors.white
                    : Colors.black87,
                fontWeight:
                FontWeight.w500,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(
      BuildContext context,
      int realIndex,
      ) {
    final bool isDark =
        Theme.of(context).brightness ==
            Brightness.dark;

    showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            backgroundColor: isDark
                ? const Color(0xFF252836)
                : Colors.white,
            surfaceTintColor:
            Colors.transparent,
            shape:
            RoundedRectangleBorder(
              borderRadius:
              BorderRadius.circular(20),
              side: isDark
                  ? const BorderSide(
                color:
                Color(0xFF3A3F4B),
              )
                  : BorderSide.none,
            ),
            title: Text(
              "O'chirish",
              style: TextStyle(
                color: isDark
                    ? Colors.white
                    : Colors.black,
              ),
            ),
            content: Text(
              "Haqiqatan ham ushbu ishchini o'chirmoqchimisiz?",
              style: TextStyle(
                color: isDark
                    ? Colors.white70
                    : Colors.black,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () =>
                    Navigator.pop(context),
                child:
                const Text("Yo'q"),
              ),
              TextButton(
                onPressed: () async {
                  final success =
                  await context
                      .read<IshchiProvider>()
                      .ochirish(realIndex);

                  if (context.mounted) {
                    Navigator.pop(context);

                    if (!success) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(
                        SnackBar(
                          content: Text(
                            context
                                .read<
                                IshchiProvider>()
                                .error ??
                                "Xatolik yuz berdi",
                          ),
                        ),
                      );
                    }
                  }
                },
                child: const Text(
                  "Ha",
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider =
    context.watch<IshchiProvider>();

    final bool isDark =
        Theme.of(context).brightness ==
            Brightness.dark;

    final filteredIshchilar =
    provider.ishchilar
        .where(
          (ishchi) =>
      ishchi.kasb == kasb,
    )
        .toList();

    if (filteredIshchilar.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      elevation: 10,
      surfaceTintColor:
      Colors.transparent,
      shadowColor:
      isDark ? Colors.black26 : null,
      color: isDark
          ? const Color(0xFF252836)
          : Colors.white,
      shape:
      RoundedRectangleBorder(
        borderRadius:
        BorderRadius.circular(12),
        side: isDark
            ? const BorderSide(
          color:
          Color(0xFF3A3F4B),
        )
            : BorderSide.none,
      ),
      clipBehavior:
      Clip.antiAlias,
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.end,
        children: [
          const SizedBox(height: 10),

          Row(
            children: [
              const SizedBox(width: 10),

              Text(
                title,
                style: TextStyle(
                  fontWeight:
                  FontWeight.bold,
                  fontSize: 16,
                  color: isDark
                      ? Colors.white
                      : Colors.black,
                ),
              ),

              const Spacer(),

              Text(
                IshchilarPages.getTxt(
                  context,
                  "Barchasi",
                ),
                style: TextStyle(
                  fontWeight:
                  FontWeight.bold,
                  fontSize: 14,
                  color: isDark
                      ? const Color(
                    0xFF3C8DFF,
                  )
                      : Colors.indigo,
                ),
              ),

              const SizedBox(width: 10),
            ],
          ),

          Divider(
            color: isDark
                ? const Color(0xFF3A3F4B)
                : Colors.indigo,
          ),

          ListView.builder(
            shrinkWrap: true,
            physics:
            const NeverScrollableScrollPhysics(),
            itemCount:
            filteredIshchilar.length,
            itemBuilder:
                (context, index) {
              final ishchi =
              filteredIshchilar[index];

              final realIndex =
              provider.ishchilar
                  .indexOf(ishchi);

              return Column(
                children: [
                  ListTile(
                    onTap: () =>
                        _showDetailDialog(
                          context,
                          ishchi,
                          realIndex,
                        ),

                    leading:
                    CircleAvatar(
                      radius: 25,
                      backgroundColor:
                      isDark
                          ? const Color(
                        0xFF2A2E38,
                      )
                          : Colors.grey,
                      backgroundImage:
                      (ishchi.rasm !=
                          null &&
                          ishchi.rasm!
                              .isNotEmpty)
                          ? (ishchi.rasm!
                          .startsWith(
                        'http',
                      )
                          ? NetworkImage(
                        ishchi.rasm!,
                      )
                          : FileImage(
                        File(
                          ishchi.rasm!,
                        ),
                      ) as ImageProvider)
                          : null,
                      child:
                      (ishchi.rasm ==
                          null ||
                          ishchi.rasm!
                              .isEmpty)
                          ? (
                          ishchi.familya
                              .trim()
                              .isNotEmpty ||
                              ishchi.ism
                                  .trim()
                                  .isNotEmpty
                              ? Text(
                            (ishchi.familya
                                .trim()
                                .isNotEmpty
                                ? ishchi
                                .familya
                                .trim()
                                : ishchi
                                .ism
                                .trim())[0]
                                .toUpperCase(),
                            style:
                            const TextStyle(
                              fontSize: 25,
                              fontWeight:
                              FontWeight
                                  .bold,
                              color: Colors
                                  .white,
                            ),
                          )
                              : const Icon(
                            Icons.person,
                            color:
                            Colors.white,
                          )
                      )
                          : null,
                    ),

                    title: Text(
                      "${ishchi.familya} ${ishchi.ism}",
                      style: TextStyle(
                        fontWeight:
                        FontWeight.bold,
                        color: isDark
                            ? Colors.white
                            : Colors.black,
                      ),
                      maxLines: 1,
                      overflow:
                      TextOverflow.ellipsis,
                    ),

                    subtitle: Text(
                      ishchi.telefon
                          .startsWith('+')
                          ? ishchi.telefon
                          : "+${ishchi.telefon}",
                      style: TextStyle(
                        color: isDark
                            ? Colors.white60
                            : Colors.black54,
                      ),
                    ),

                    trailing:
                    IconButton(
                      onPressed: () =>
                          _makePhoneCall(
                            "+${ishchi.telefon.replaceAll(
                              ' ',
                              '',
                            )}",
                          ),
                      icon:
                      const Icon(
                        Icons.phone,
                        color:
                        Colors.green,
                        size: 20,
                      ),
                    ),
                  ),

                  Divider(
                    color: isDark
                        ? const Color(
                      0xFF3A3F4B,
                    )
                        : Colors.black12,
                    height: 1,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class IshchiQoshishDialog
    extends StatefulWidget {
  final MaskTextInputFormatter
  maskFormatter;

  final bool isEditing;

  const IshchiQoshishDialog({
    super.key,
    required this.maskFormatter,
    this.isEditing = false,
  });

  @override
  State<IshchiQoshishDialog>
  createState() =>
      _IshchiQoshishDialogState();
}

class _IshchiQoshishDialogState
    extends State<IshchiQoshishDialog> {
  late TextEditingController
  fullNameController;

  @override
  void initState() {
    super.initState();

    final provider =
    context.read<IshchiProvider>();

    if (widget.isEditing) {
      fullNameController =
          TextEditingController(
            text:
            "${provider.familyaController.text} ${provider.ismController.text}"
                .trim(),
          );
    } else {
      fullNameController =
          TextEditingController();
    }
  }

  @override
  void dispose() {
    fullNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider =
    context.watch<IshchiProvider>();

    final bool isDark =
        Theme.of(context).brightness ==
            Brightness.dark;

    return AlertDialog(
      backgroundColor: isDark
          ? const Color(0xFF252836)
          : Colors.white,
      surfaceTintColor:
      Colors.transparent,
      shape:
      RoundedRectangleBorder(
        borderRadius:
        BorderRadius.circular(20),
        side: isDark
            ? const BorderSide(
          color:
          Color(0xFF3A3F4B),
        )
            : BorderSide.none,
      ),

      title: Center(
        child: Text(
          widget.isEditing
              ? IshchilarPages.getTxt(
            context,
            "Tahrirlash",
          )
              : IshchilarPages.getTxt(
            context,
            "Ishchi qo'shish",
          ),
          style: TextStyle(
            fontSize: 24,
            fontWeight:
            FontWeight.bold,
            color: isDark
                ? Colors.white
                : Colors.indigo,
          ),
        ),
      ),

      content: SingleChildScrollView(
        child: Container(
          width:
          MediaQuery.of(context)
              .size
              .width *
              0.9,
          constraints:
          const BoxConstraints(
            maxWidth: 400,
          ),
          child: Column(
            mainAxisSize:
            MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    backgroundColor:
                    isDark
                        ? const Color(
                      0xFF252836,
                    )
                        : Colors.white,
                    builder: (context) =>
                        Container(
                          height: 150,
                          decoration:
                          BoxDecoration(
                            color: isDark
                                ? const Color(
                              0xFF252836,
                            )
                                : Colors.white,
                            borderRadius:
                            const BorderRadius
                                .vertical(
                              top: Radius
                                  .circular(20),
                            ),
                          ),
                          child: Column(
                            children: [
                              ListTile(
                                leading: Icon(
                                  Icons.camera_alt,
                                  color: isDark
                                      ? Colors
                                      .white70
                                      : Colors
                                      .black,
                                ),
                                title: Text(
                                  IshchilarPages
                                      .getTxt(
                                    context,
                                    "Kamera",
                                  ),
                                  style: TextStyle(
                                    color: isDark
                                        ? Colors
                                        .white
                                        : Colors
                                        .black,
                                  ),
                                ),
                                onTap: () {
                                  provider
                                      .rasmTanlash(
                                    context,
                                    ImageSource
                                        .camera,
                                  );
                                  Navigator.pop(
                                      context);
                                },
                              ),
                              ListTile(
                                leading: Icon(
                                  Icons.photo,
                                  color: isDark
                                      ? Colors
                                      .white70
                                      : Colors
                                      .black,
                                ),
                                title: Text(
                                  IshchilarPages
                                      .getTxt(
                                    context,
                                    "Galereya",
                                  ),
                                  style: TextStyle(
                                    color: isDark
                                        ? Colors
                                        .white
                                        : Colors
                                        .black,
                                  ),
                                ),
                                onTap: () {
                                  provider
                                      .rasmTanlash(
                                    context,
                                    ImageSource
                                        .gallery,
                                  );
                                  Navigator.pop(
                                      context);
                                },
                              ),
                            ],
                          ),
                        ),
                  );
                },
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor:
                  isDark
                      ? const Color(
                    0xFF2A2E38,
                  )
                      : Colors.blue
                      .shade100,
                  backgroundImage:
                  provider.imageFile !=
                      null
                      ? FileImage(
                    provider.imageFile!,
                  )
                      : null,
                  child:
                  provider.imageFile ==
                      null
                      ? ValueListenableBuilder<
                      TextEditingValue>(
                    valueListenable:
                    fullNameController,
                    builder:
                        (
                        context,
                        value,
                        child,
                        ) {
                      final String
                      name =
                      value.text
                          .trim();

                      if (name
                          .isEmpty) {
                        return Icon(
                          Icons
                              .add_a_photo,
                          color: isDark
                              ? Colors
                              .white38
                              : Colors
                              .white,
                          size: 40,
                        );
                      }

                      return Text(
                        name[0]
                            .toUpperCase(),
                        style:
                        const TextStyle(
                          fontSize: 40,
                          fontWeight:
                          FontWeight
                              .bold,
                          color: Colors
                              .white,
                        ),
                      );
                    },
                  )
                      : null,
                ),
              ),

              const SizedBox(height: 10),

              _buildTextField(
                fullNameController,
                IshchilarPages.getTxt(
                  context,
                  "F.I.Sh",
                ),
                isDark,
              ),

              const SizedBox(height: 10),

              _buildTextField(
                provider.telefonController,
                "90 123 45 67",
                isDark,
                prefix: "+998 ",
                keyboardType:
                TextInputType.phone,
                mask: widget.maskFormatter,
              ),

              const SizedBox(height: 10),

              _buildDropdown(
                context,
                provider.lavozim,
                [
                  "Admin",
                  "Ishchi",
                  "Sotuvchi",
                ],
                    (val) =>
                    provider.lavozimTanlash(
                      val,
                    ),
                isDark,
              ),

              const SizedBox(height: 10),

              _buildDropdown(
                context,
                provider.kasb,
                [
                  "Shifokor",
                  "Texnik xodim",
                ],
                    (val) =>
                    provider.kasbTanlash(
                      val,
                    ),
                isDark,
              ),

              if (provider.isLoading)
                const Padding(
                  padding:
                  EdgeInsets.all(8.0),
                  child:
                  CircularProgressIndicator(),
                ),
            ],
          ),
        ),
      ),

      actions: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                style:
                ElevatedButton.styleFrom(
                  backgroundColor:
                  isDark
                      ? const Color(
                    0xFF3A3F4B,
                  )
                      : Colors.grey,
                  elevation: 0,
                ),
                onPressed: () =>
                    Navigator.pop(context),
                child: Text(
                  IshchilarPages.getTxt(
                    context,
                    "Bekor qilish",
                  ),
                  style:
                  const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 10),

            Expanded(
              child: ElevatedButton(
                style:
                ElevatedButton.styleFrom(
                  backgroundColor:
                  isDark
                      ? const Color(
                    0xFF3C8DFF,
                  )
                      : Colors.indigo,
                  elevation: 0,
                ),
                onPressed:
                provider.isLoading
                    ? null
                    : () async {
                  String full =
                  fullNameController
                      .text
                      .trim();

                  int firstSpace =
                  full.indexOf(
                      ' ');

                  if (firstSpace !=
                      -1) {
                    provider
                        .familyaController
                        .text = full
                        .substring(
                      0,
                      firstSpace,
                    );

                    provider
                        .ismController
                        .text = full
                        .substring(
                      firstSpace + 1,
                    );
                  } else {
                    provider
                        .familyaController
                        .text = full;

                    provider
                        .ismController
                        .text = " ";
                  }

                  if (provider
                      .tekshirAsosiy()) {
                    final success =
                    await provider
                        .qoshish();

                    if (context
                        .mounted) {
                      if (success) {
                        Navigator.pop(
                            context);
                      } else {
                        ScaffoldMessenger
                            .of(
                          context,
                        ).showSnackBar(
                          SnackBar(
                            content:
                            Text(
                              provider
                                  .error ??
                                  "Xatolik yuz berdi",
                            ),
                          ),
                        );
                      }
                    }
                  } else {
                    ScaffoldMessenger
                        .of(context)
                        .showSnackBar(
                      SnackBar(
                        content: Text(
                          IshchilarPages
                              .getTxt(
                            context,
                            "Asosiy ma'lumotlarni to'ldiring",
                          ),
                        ),
                      ),
                    );
                  }
                },
                child: Text(
                  widget.isEditing
                      ? IshchilarPages.getTxt(
                    context,
                    "Yangilash",
                  )
                      : IshchilarPages.getTxt(
                    context,
                    "Saqlash",
                  ),
                  style:
                  const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTextField(
      TextEditingController controller,
      String hint,
      bool isDark, {
        String? prefix,
        TextInputType? keyboardType,
        MaskTextInputFormatter? mask,
      }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters:
      mask != null ? [mask] : null,
      style: TextStyle(
        color: isDark
            ? Colors.white
            : Colors.black,
      ),
      decoration:
      InputDecoration(
        prefixText: prefix,
        prefixStyle:
        TextStyle(
          color: isDark
              ? Colors.white
              : Colors.black,
        ),
        hintText: hint,
        hintStyle:
        TextStyle(
          color: isDark
              ? Colors.white38
              : Colors.grey,
        ),
        filled: true,
        fillColor: isDark
            ? const Color(
          0xFF2A2E38,
        )
            : Colors.grey.shade100,
        enabledBorder:
        OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(
            20,
          ),
          borderSide:
          BorderSide(
            color: isDark
                ? const Color(
              0xFF3A3F4B,
            )
                : Colors
                .grey.shade300,
          ),
        ),
        focusedBorder:
        OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(
            20,
          ),
          borderSide:
          BorderSide(
            color: isDark
                ? const Color(
              0xFF3C8DFF,
            )
                : Colors.indigo,
          ),
        ),
        border:
        OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(
            20,
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown(
      BuildContext context,
      String current,
      List<String> items,
      Function(String) onSelected,
      bool isDark,
      ) {
    return Container(
      width: double.infinity,
      height: 50,
      padding:
      const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      decoration:
      BoxDecoration(
        color: isDark
            ? const Color(
          0xFF2A2E38,
        )
            : Colors.transparent,
        borderRadius:
        BorderRadius.circular(
          10,
        ),
        border: Border.all(
          color: isDark
              ? const Color(
            0xFF3A3F4B,
          )
              : Colors.grey,
        ),
      ),
      child: Row(
        children: [
          Text(
            IshchilarPages.getTxt(
              context,
              current,
            ),
            style: TextStyle(
              fontWeight:
              FontWeight.bold,
              color: isDark
                  ? Colors.white
                  : Colors.black,
            ),
          ),

          const Spacer(),

          Theme(
            data:
            Theme.of(context)
                .copyWith(
              canvasColor: isDark
                  ? const Color(
                0xFF252836,
              )
                  : Colors.white,
            ),
            child:
            PopupMenuButton<String>(
              icon: Icon(
                Icons
                    .arrow_drop_down,
                color: isDark
                    ? Colors.white70
                    : Colors.black54,
              ),
              onSelected:
              onSelected,
              itemBuilder:
                  (context) =>
                  items
                      .map(
                        (e) =>
                        PopupMenuItem(
                          value: e,
                          child: Text(
                            IshchilarPages
                                .getTxt(
                              context,
                              e,
                            ),
                            style:
                            TextStyle(
                              color: isDark
                                  ? Colors
                                  .white
                                  : Colors
                                  .black,
                            ),
                          ),
                        ),
                  )
                      .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class LoginParolDialog
    extends StatelessWidget {
  final bool isEditing;

  const LoginParolDialog({
    super.key,
    this.isEditing = false,
  });

  @override
  Widget build(BuildContext context) {
    final provider =
    context.watch<IshchiProvider>();

    final bool isDark =
        Theme.of(context).brightness ==
            Brightness.dark;

    return AlertDialog(
      backgroundColor: isDark
          ? const Color(0xFF252836)
          : Colors.white,
      surfaceTintColor:
      Colors.transparent,
      shape:
      RoundedRectangleBorder(
        borderRadius:
        BorderRadius.circular(20),
        side: isDark
            ? const BorderSide(
          color:
          Color(0xFF3A3F4B),
        )
            : BorderSide.none,
      ),

      title: Center(
        child: Text(
          IshchilarPages.getTxt(
            context,
            "Login Parol kiriting",
          ),
          style: TextStyle(
            color: isDark
                ? Colors.white
                : Colors.indigo,
            fontWeight:
            FontWeight.bold,
          ),
        ),
      ),

      content: SingleChildScrollView(
        child: Container(
          width:
          MediaQuery.of(context)
              .size
              .width *
              0.9,
          constraints:
          const BoxConstraints(
            maxWidth: 400,
          ),
          child: Column(
            mainAxisSize:
            MainAxisSize.min,
            children: [
              _buildDialogField(
                provider.loginController,
                IshchilarPages.getTxt(
                  context,
                  "Login",
                ),
                isDark,
              ),

              const SizedBox(
                  height: 15),

              _buildDialogField(
                provider.parolController,
                IshchilarPages.getTxt(
                  context,
                  "Parol",
                ),
                isDark,
                obscure: true,
              ),
            ],
          ),
        ),
      ),

      actions: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                style:
                ElevatedButton.styleFrom(
                  backgroundColor:
                  isDark
                      ? const Color(
                    0xFF3A3F4B,
                  )
                      : Colors.grey,
                  elevation: 0,
                ),
                onPressed: () =>
                    Navigator.pop(context),
                child: Text(
                  IshchilarPages.getTxt(
                    context,
                    "Bekor qilish",
                  ),
                  style:
                  const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 10),

            Expanded(
              child: ElevatedButton(
                style:
                ElevatedButton.styleFrom(
                  backgroundColor:
                  isDark
                      ? const Color(
                    0xFF3C8DFF,
                  )
                      : Colors.indigo,
                  elevation: 0,
                ),
                onPressed: () {
                  if (provider
                      .tekshirLogin()) {
                    final login =
                        provider.loginController
                            .text;

                    final parol =
                        provider.parolController
                            .text;

                    bool exists = false;

                    for (var ishchi
                    in provider
                        .ishchilar) {
                      if (isEditing) {
                        if (provider
                            .ishchilar
                            .indexOf(
                            ishchi) ==
                            provider
                                .tahrirlashIndex) {
                          continue;
                        }
                      }

                      if ((ishchi.login !=
                          null &&
                          ishchi.login ==
                              login) ||
                          (ishchi.parol !=
                              null &&
                              ishchi.parol ==
                                  parol)) {
                        exists = true;
                        break;
                      }
                    }

                    if (exists) {
                      _showDuplicateErrorDialog(
                          context);
                    } else {
                      provider.qoshish();

                      Navigator.pop(
                          context);

                      Navigator.pop(
                          context);
                    }
                  } else {
                    ScaffoldMessenger
                        .of(context)
                        .showSnackBar(
                      SnackBar(
                        content: Text(
                          IshchilarPages
                              .getTxt(
                            context,
                            "Login va parolni kiriting",
                          ),
                        ),
                      ),
                    );
                  }
                },
                child: Text(
                  isEditing
                      ? IshchilarPages.getTxt(
                    context,
                    "Yangilash",
                  )
                      : IshchilarPages.getTxt(
                    context,
                    "Saqlash",
                  ),
                  style:
                  const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDialogField(
      TextEditingController controller,
      String hint,
      bool isDark, {
        bool obscure = false,
      }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      style: TextStyle(
        color: isDark
            ? Colors.white
            : Colors.black,
      ),
      decoration:
      InputDecoration(
        hintText: hint,
        hintStyle:
        TextStyle(
          color: isDark
              ? Colors.white38
              : Colors.grey,
        ),
        filled: true,
        fillColor: isDark
            ? const Color(
          0xFF2A2E38,
        )
            : Colors.grey.shade100,
        enabledBorder:
        OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(
            15,
          ),
          borderSide:
          BorderSide(
            color: isDark
                ? const Color(
              0xFF3A3F4B,
            )
                : Colors
                .grey.shade300,
          ),
        ),
        focusedBorder:
        OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(
            15,
          ),
          borderSide:
          BorderSide(
            color: isDark
                ? const Color(
              0xFF3C8DFF,
            )
                : Colors.indigo,
          ),
        ),
        border:
        OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(
            15,
          ),
        ),
      ),
    );
  }

  void _showDuplicateErrorDialog(
      BuildContext context) {
    final bool isDark =
        Theme.of(context).brightness ==
            Brightness.dark;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        Future.delayed(
          const Duration(seconds: 3),
              () {
            if (context.mounted) {
              Navigator.of(context).pop();
            }
          },
        );

        return Center(
          child: Container(
            margin:
            const EdgeInsets.symmetric(
              horizontal: 40,
            ),
            child: ClipRRect(
              borderRadius:
              BorderRadius.circular(20),
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 15,
                  sigmaY: 15,
                ),
                child: Container(
                  padding:
                  const EdgeInsets.all(20),
                  decoration:
                  BoxDecoration(
                    color: isDark
                        ? const Color(
                      0xFF252836,
                    ).withValues(
                      alpha: 0.8,
                    )
                        : Colors.white
                        .withValues(
                      alpha: 0.8,
                    ),
                    borderRadius:
                    BorderRadius.circular(
                      20,
                    ),
                    border: Border.all(
                      color: isDark
                          ? const Color(
                        0xFF3A3F4B,
                      ).withValues(
                        alpha: 0.5,
                      )
                          : Colors.indigo
                          .withValues(
                        alpha: 0.2,
                      ),
                    ),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: Column(
                      mainAxisSize:
                      MainAxisSize.min,
                      children: [
                        Icon(
                          Icons
                              .warning_amber_rounded,
                          color: isDark
                              ? Colors
                              .orangeAccent
                              : Colors.orange,
                          size: 50,
                        ),

                        const SizedBox(
                            height: 15),

                        Text(
                          IshchilarPages
                              .getTxt(
                            context,
                            "Bu Login yoki Parol allaqachon ishlatilgan.",
                          ),
                          textAlign:
                          TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight:
                            FontWeight.bold,
                            color: isDark
                                ? Colors.white
                                : Colors.black87,
                          ),
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
}