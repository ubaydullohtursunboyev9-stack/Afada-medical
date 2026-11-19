import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:ui';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../../provider/profile_provider.dart';
import '../../provider/qarz_provider.dart';
import '../../model/qarz_model.dart';

class QarzdorlikPages extends StatelessWidget {
  const QarzdorlikPages({super.key});

  static final Map<String, Map<String, String>> _localizedTexts = {
    "Uzb": {
      "valyuta": "UZS",
      "yopish": "Yopish",
      "qarz_amaliyoti": "Qarz amaliyoti",
      "mijoz_ismi": "Mijoz ismi",
      "ismni_kiriting": "Ismni kiriting",
      "telefon": "Telefon",
      "telefon_hint": "90 123 45 67",
      "telefonni_kiriting": "Telefonni kiriting",
      "amaliyot_turi": "Amaliyot turi",
      "qarz_oldi": "Qarz oldi",
      "qarz_toladi": "Qarz to'ladi",
      "summa": "Summa",
      "summani_kiriting": "Summani kiriting",
      "notogri_format": "Noto'g'ri format",
      "izoh": "Izoh (ixtiyoriy)",
      "bekor_qilish": "Bekor qilish",
      "saqlash": "Saqlash",
      "qarzdorlik_va_qarzdorlar": "Qarzdorlik va qarzdorlar",
      "qarzdorlik": "Qarzdorlik",
      "qarzdorlar": "Qarzdorlar",
      "qarzdorlar_label": "Qarzdorlar:",
      "jami_qarzdorlik": "Jami qarzdorlik:",
      "ta": "ta",
      "qarz": "Qarz:",
    },
    "Rus": {
      "valyuta": "UZS",
      "yopish": "Закрыть",
      "qarz_amaliyoti": "Долговая операция",
      "mijoz_ismi": "Имя клиента",
      "ismni_kiriting": "Введите имя",
      "telefon": "Телефон",
      "telefon_hint": "90 123 45 67",
      "telefonni_kiriting": "Введите телефон",
      "amaliyot_turi": "Тип операции",
      "qarz_oldi": "Взял в долг",
      "qarz_toladi": "Погасил долг",
      "summa": "Сумма",
      "summani_kiriting": "Введите сумму",
      "notogri_format": "Неверный формат",
      "izoh": "Примечание (необязательно)",
      "bekor_qilish": "Отмена",
      "saqlash": "Сохранить",
      "qarzdorlik_va_qarzdorlar": "Задолженность и должники",
      "qarzdorlik": "Задолженность",
      "qarzdorlar": "Должники",
      "qarzdorlar_label": "Должники:",
      "jami_qarzdorlik": "Общая задолженность:",
      "ta": "шт",
      "qarz": "Долг:",
    },
    "Kiril": {
      "valyuta": "UZS",
      "yopish": "Ёпиш",
      "qarz_amaliyoti": "Қарз амалиёти",
      "mijoz_ismi": "Мижоз исми",
      "ismni_kiriting": "Исмни киритинг",
      "telefon": "Телефон",
      "telefon_hint": "90 123 45 67",
      "telefonni_kiriting": "Телефонни киритинг",
      "amaliyot_turi": "Амалиёт тури",
      "qarz_oldi": "Қарз олди",
      "qarz_toladi": "Қарз тўлади",
      "summa": "Сумма",
      "summani_kiriting": "Суммани киритинг",
      "notogri_format": "Нотўғри формат",
      "izoh": "Изоҳ (ихтиёрий)",
      "bekor_qilish": "Бекор қилиш",
      "saqlash": "Сақлаш",
      "qarzdorlik_va_qarzdorlar": "Қарздорлик ва қарздорлар",
      "qarzdorlik": "Қарздорлик",
      "qarzdorlar": "Қарздорлар",
      "qarzdorlar_label": "Қарздорлар:",
      "jami_qarzdorlik": "Жами қарздорлик:",
      "ta": "та",
      "qarz": "Қарз:",
    },
  };

  static String getTxt(String lang, String key) {
    return _localizedTexts[lang]?[key] ?? key;
  }

  String _formatMoney(double amount) {
    return amount.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]} ',
        );
  }

  void _showQarzdorDetails(BuildContext context, QarzdorModel q) {
    showDialog(
      context: context,
      builder: (context) {
        return Consumer<ProfileProvider>(
          builder: (context, profileProvider, child) {
            final lang = profileProvider.language;
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Center(
                child: Text(
                  q.mijozIsmi,
                  style: const TextStyle(
                    color: Colors.indigo,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              content: SizedBox(
                width: 300,
                height: 350,
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: q.amaliyotlar.length,
                        itemBuilder: (context, i) {
                          final a = q.amaliyotlar[i];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              children: [
                                Text("${a.sana.day}.${a.sana.month}.${a.sana.year}"),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    getTxt(lang, a.turi == "Qarz oldi" ? "qarz_oldi" : "qarz_toladi"),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: a.turi == "Qarz oldi" ? Colors.red : Colors.green,
                                    ),
                                  ),
                                ),
                                Text(
                                  "${_formatMoney(a.summa)} ${getTxt(lang, "valyuta")}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: a.turi == "Qarz oldi" ? Colors.red : Colors.green,
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 10,
                        backgroundColor: Colors.indigo,
                        foregroundColor: Colors.white,
                        fixedSize: const Size(200, 40),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(getTxt(lang, "yopish")),
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showAddDebtDialog(BuildContext context) {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final amountController = TextEditingController();
    final descriptionController = TextEditingController();
    final maskFormatter = MaskTextInputFormatter(mask: '## ### ## ##');
    String transactionType = "Qarz oldi";
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return Consumer<ProfileProvider>(
          builder: (context, profileProvider, child) {
            final lang = profileProvider.language;
            return StatefulBuilder(builder: (context, setState) {
              return AlertDialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                title: Center(
                  child: Text(
                    getTxt(lang, "qarz_amaliyoti"),
                    style: const TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold),
                  ),
                ),
                content: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          controller: nameController,
                          decoration: InputDecoration(labelText: getTxt(lang, "mijoz_ismi")),
                          validator: (value) => (value == null || value.isEmpty) ? getTxt(lang, "ismni_kiriting") : null,
                        ),
                        TextFormField(
                          controller: phoneController,
                          decoration: InputDecoration(labelText: getTxt(lang, "telefon"), hintText: getTxt(lang, "telefon_hint")),
                          inputFormatters: [maskFormatter],
                          keyboardType: TextInputType.phone,
                          validator: (value) => (value == null || value.isEmpty) ? getTxt(lang, "telefonni_kiriting") : null,
                        ),
                        DropdownButtonFormField<String>(
                          value: transactionType,
                          decoration: InputDecoration(labelText: getTxt(lang, "amaliyot_turi")),
                          items: ["Qarz oldi", "Qarz to'ladi"]
                              .map((s) => DropdownMenuItem(value: s, child: Text(getTxt(lang, s == "Qarz oldi" ? "qarz_oldi" : "qarz_toladi"))))
                              .toList(),
                          onChanged: (val) => setState(() => transactionType = val!),
                        ),
                        TextFormField(
                          controller: amountController,
                          decoration: InputDecoration(labelText: getTxt(lang, "summa")),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) return getTxt(lang, "summani_kiriting");
                            if (double.tryParse(value) == null) return getTxt(lang, "notogri_format");
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: descriptionController,
                          decoration: InputDecoration(labelText: getTxt(lang, "izoh")),
                        ),
                      ],
                    ),
                  ),
                ),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(context), child: Text(getTxt(lang, "bekor_qilish"))),
                  ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        final qarzProvider = context.read<QarzProvider>();
                        qarzProvider.qarzQoshish(QarzAmaliyotModel(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          mijozIsmi: nameController.text,
                          telefon: phoneController.text,
                          izoh: descriptionController.text,
                          turi: transactionType,
                          summa: double.parse(amountController.text),
                          sana: DateTime.now(),
                        ));
                        Navigator.pop(context);
                      }
                    },
                    child: Text(getTxt(lang, "saqlash")),
                  ),
                ],
              );
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<ProfileProvider>().language;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: Container(
                width: 65,
                height: 65,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.indigo.withValues(alpha: 0.25),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(25),
                    onTap: () => _showAddDebtDialog(context),
                    child: const Center(
                      child: Icon(Icons.add, color: Colors.white, size: 35),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        backgroundColor: isDark ? const Color(0xFF181A20) : Colors.blue.shade100,
        appBar: AppBar(
          backgroundColor: isDark ? const Color(0xFF181A20) : Colors.indigo,
          foregroundColor: Colors.white,
          elevation: 0,
          title: Text(
            getTxt(lang, "qarzdorlik_va_qarzdorlar"),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(30),
            child: Container(
              height: 30,
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF2A2E38) : Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark ? const Color(0xFF3A3F4B) : Colors.white.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: TabBar(
                indicatorPadding: const EdgeInsets.symmetric(horizontal: -10, vertical: 2),
                dividerColor: Colors.transparent,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white70,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: isDark ? const Color(0xFF3C8DFF).withValues(alpha: 0.3) : Colors.white.withValues(alpha: 0.25),
                  border: Border.all(
                    color: isDark ? const Color(0xFF3C8DFF) : Colors.white.withValues(alpha: 0.4),
                  ),
                ),
                tabs: [
                  Tab(text: getTxt(lang, "qarzdorlik")),
                  Tab(text: getTxt(lang, "qarzdorlar")),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            _buildDebtListView(context, isDark, true, lang),
            _buildDebtListView(context, isDark, false, lang),
          ],
        ),
      ),
    );
  }

  Widget _buildDebtListView(BuildContext context, bool isDark, bool showAll, String lang) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Card(
          elevation: 10,
          shadowColor: isDark ? Colors.black26 : null,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF252836) : Colors.white,
              border: isDark ? Border.all(color: const Color(0xFF3A3F4B)) : null,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Consumer<QarzProvider>(
              builder: (context, qarzProvider, child) {
                final qarzdorlar = showAll
                    ? qarzProvider.qarzdorlar
                    : qarzProvider.qarzdorlar.where((q) => q.qarzSummasi > 0).toList();

                return Column(
                  children: [
                    _buildSummaryRow(
                      getTxt(lang, "jami_qarzdorlik"),
                      "${_formatMoney(qarzProvider.jamiQarz)} ${getTxt(lang, "valyuta")}",
                      isDark,
                      isAmount: true
                    ),
                    _buildSummaryRow(
                      getTxt(lang, "qarzdorlar_label"),
                      "${qarzdorlar.length} ${getTxt(lang, "ta")}",
                      isDark
                    ),
                    const Divider(height: 30),
                    Expanded(
                      child: ListView.builder(
                        itemCount: qarzdorlar.length,
                        itemBuilder: (context, index) {
                          final q = qarzdorlar[index];
                          final oxirgiAmaliyot = q.amaliyotlar.first;
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color: isDark ? const Color(0xFF181A20) : Colors.grey.shade200,
                              ),
                              child: Icon(Icons.person, color: isDark ? Colors.white24 : Colors.grey),
                            ),
                            title: Text(
                              q.mijozIsmi,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : Colors.black,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(q.telefon, style: TextStyle(fontSize: 12, color: isDark ? Colors.white60 : Colors.grey)),
                                Row(
                                  children: [
                                    Text(
                                      getTxt(lang, "qarz"),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: isDark ? Colors.white70 : Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      "${_formatMoney(q.qarzSummasi)} ${getTxt(lang, "valyuta")}",
                                      style: TextStyle(color: isDark ? Colors.white : Colors.black),
                                    ),
                                  ],
                                ),
                                Text(
                                  "${getTxt(lang, oxirgiAmaliyot.turi == "Qarz oldi" ? "qarz_oldi" : "qarz_toladi")}: ${_formatMoney(oxirgiAmaliyot.summa)} ${getTxt(lang, "valyuta")}",
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: oxirgiAmaliyot.turi == "Qarz oldi" ? Colors.red : Colors.green,
                                  ),
                                ),
                              ],
                            ),
                            trailing: IconButton(
                              onPressed: () => _showQarzdorDetails(context, q),
                              icon: const Icon(
                                Icons.arrow_forward_ios_outlined,
                                color: Colors.green,
                                size: 18,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, bool isDark, {bool isAmount = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: isAmount ? 14 : 18,
              color: isDark ? Colors.white70 : Colors.black87,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontSize: isAmount ? 20 : 18,
              fontWeight: FontWeight.bold,
              color: isAmount ? Colors.red : (isDark ? Colors.white : Colors.black),
            ),
          ),
        ],
      ),
    );
  }

}
