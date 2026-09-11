import 'package:afada/provider/notification_provider.dart';
import 'package:afada/provider/theme_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/profile_provider.dart';

class DraverSozlamalarPages extends StatefulWidget {
  const DraverSozlamalarPages({super.key});

  @override
  State<DraverSozlamalarPages> createState() => _DraverSozlamalarPagesState();
}

class _DraverSozlamalarPagesState extends State<DraverSozlamalarPages> {
  String _selectedLanguage = "Uzb";

  final Map<String, Map<String, String>> _localizedTexts = {
    "Uzb": {
      "Sozlamalar": "Sozlamalar",
      "Ko'rinish": "Ko'rinish",
      "Til": "Til",
      "Bildirishnoma": "Bildirishnoma",
      "Yordam": "Yordam",
      "Ilova haqida": "Ilova haqida",
      "Uzb": "O'zbekcha",
      "Rus": "Ruscha",
      "Kiril": "Kirilcha",
    },
    "Rus": {
      "Sozlamalar": "Настройки",
      "Ko'rinish": "Вид",
      "Til": "Язык",
      "Bildirishnoma": "Уведомление",
      "Yordam": "Помощь",
      "Ilova haqida": "О приложении",
      "Uzb": "Узбекский",
      "Rus": "Русский",
      "Kiril": "Кириллица",
    },
    "Kiril": {
      "Sozlamalar": "Созламалар",
      "Ko'rinish": "Кўриниш",
      "Til": "Тил",
      "Bildirishnoma": "Билдиришнома",
      "Yordam": "Ёрдам",
      "Ilova haqida": "Илова ҳақида",
      "Uzb": "Ўзбекча",
      "Rus": "Русча",
      "Kiril": "Кирилча",
    },
  };

  String _getTxt(String key) {
    return _localizedTexts[_selectedLanguage]?[key] ?? key;
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final notificationProvider = Provider.of<NotificationProvider>(context);
    final profileProvider = Provider.of<ProfileProvider>(context);
    final isDark = themeProvider.isDarkMode;
    final selectedLanguage = profileProvider.language;

    String getTxt(String key) {
      return _localizedTexts[selectedLanguage]?[key] ?? key;
    }

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF181A20) : Colors.blue.shade100,
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF181A20) : Colors.indigo,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          getTxt("Sozlamalar"),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 10,
                right: 10,
                top: 20,
                bottom: 10,
              ),
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(color: Colors.transparent),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 25,
                        right: 15,
                        top: 10,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.dark_mode_outlined,
                            color: isDark ? const Color(0xFF3C8DFF) : Colors.indigo,
                            size: 22,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            getTxt("Ko'rinish"),
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black,
                            ),
                          ),
                          const Spacer(),
                          Transform.scale(
                            scale: 0.8,
                            child: CupertinoSwitch(
                              activeColor: const Color(0xFF3C8DFF),
                              value: themeProvider.isDarkMode,
                              onChanged: (value) {
                                themeProvider.toggleTheme(value);
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                    Divider(color: isDark ? const Color(0xFF3A3F4B) : Colors.black),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 25,
                        right: 15,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.language,
                            color: isDark ? const Color(0xFF3C8DFF) : Colors.indigo,
                            size: 22,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            getTxt("Til"),
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black,
                            ),
                          ),
                          const Spacer(),
                          DropdownButton<String>(
                            value: selectedLanguage,
                            underline: const SizedBox(),
                            dropdownColor: isDark ? const Color(0xFF252836) : Colors.white,
                            items: ["Uzb", "Rus", "Kiril"].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  getTxt(value),
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: isDark ? Colors.white70 : Colors.grey,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              if (newValue != null) {
                                profileProvider.updateLanguage(newValue);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    Divider(color: isDark ? const Color(0xFF3A3F4B) : Colors.black),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 25,
                        right: 15,
                        top: 10,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.notifications_active,
                            color: isDark ? const Color(0xFF3C8DFF) : Colors.indigo,
                            size: 22,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            getTxt("Bildirishnoma"),
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black,
                            ),
                          ),
                          const Spacer(),
                          Transform.scale(
                            scale: 0.8,
                            child: CupertinoSwitch(
                              activeColor: const Color(0xFF3C8DFF),
                              value: notificationProvider.isNotificationEnabled,
                              onChanged: (value) {
                                notificationProvider.toggleNotification(value);
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                    Divider(color: isDark ? const Color(0xFF3A3F4B) : Colors.black),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 25,
                        right: 15,
                        top: 10,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.help,
                            color: isDark ? const Color(0xFF3C8DFF) : Colors.indigo,
                            size: 22,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            getTxt("Yordam"),
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(color: isDark ? const Color(0xFF3A3F4B) : Colors.black),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 25,
                        right: 15,
                        top: 10,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            CupertinoIcons.book,
                            color: isDark ? const Color(0xFF3C8DFF) : Colors.indigo,
                            size: 22,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            getTxt("Ilova haqida"),
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(color: isDark ? const Color(0xFF3A3F4B) : Colors.black)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
