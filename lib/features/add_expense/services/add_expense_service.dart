import 'package:flutter/material.dart';

class AddExpenseService {
  Map<String, Map<String, dynamic>> categoryIconData = {
    // Expense Categories
    "foodAndDining": {
      "icon": Icons.restaurant,
      "color": Colors.orange,
      "bgColor": Color(0xFFFFF4E5),
    },
    "groceries": {
      "icon": Icons.shopping_basket,
      "color": Colors.green,
      "bgColor": Color(0xFFE9FBEF),
    },
    "transport": {
      "icon": Icons.directions_car,
      "color": Colors.blue,
      "bgColor": Color(0xFFE8F0FF),
    },
    "healthAndFitness": {
      "icon": Icons.fitness_center,
      "color": Colors.red,
      "bgColor": Color(0xFFFFEBEB),
    },
    "shopping": {
      "icon": Icons.shopping_cart,
      "color": Colors.purple,
      "bgColor": Color(0xFFEFF1FF),
    },
    "entertainment": {
      "icon": Icons.movie,
      "color": Colors.deepPurple,
      "bgColor": Color(0xFFF3F3F3),
    },
    "utilities": {
      "icon": Icons.lightbulb,
      "color": Colors.amber,
      "bgColor": Color(0xFFFFF9E5),
    },
    "rent": {
      "icon": Icons.home,
      "color": Colors.teal,
      "bgColor": Color(0xFFE0F7FA),
    },
    "travel": {
      "icon": Icons.flight,
      "color": Colors.indigo,
      "bgColor": Color(0xFFE8EAF6),
    },
    "education": {
      "icon": Icons.school,
      "color": Colors.blueGrey,
      "bgColor": Color(0xFFECEFF1),
    },
    "subscriptions": {
      "icon": Icons.subscriptions,
      "color": Colors.pink,
      "bgColor": Color(0xFFFFEBEF),
    },
    "insurance": {
      "icon": Icons.security,
      "color": Colors.brown,
      "bgColor": Color(0xFFEFEBE9),
    },
    "personalCare": {
      "icon": Icons.spa,
      "color": Colors.cyan,
      "bgColor": Color(0xFFE0F7FA),
    },
    "giftsAndDonations": {
      "icon": Icons.card_giftcard,
      "color": Colors.redAccent,
      "bgColor": Color(0xFFFFEBEB),
    },
    "othersCategory": {
      "icon": Icons.category,
      "color": Colors.grey,
      "bgColor": Color(0xFFF3F3F3),
    },
    // Income Categories
    "salary": {
      "icon": Icons.attach_money,
      "color": Colors.green,
      "bgColor": Color(0xFFE9FBEF),
    },
    "freelance": {
      "icon": Icons.work,
      "color": Colors.blue,
      "bgColor": Color(0xFFE8F0FF),
    },
    "interest": {
      "icon": Icons.percent,
      "color": Colors.deepOrange,
      "bgColor": Color(0xFFFFF4E5),
    },
    "investments": {
      "icon": Icons.trending_up,
      "color": Colors.teal,
      "bgColor": Color(0xFFE0F7FA),
    },
    "gifts": {
      "icon": Icons.card_giftcard,
      "color": Colors.purple,
      "bgColor": Color(0xFFEFF1FF),
    },
    "rentalIncome": {
      "icon": Icons.home_work,
      "color": Colors.indigo,
      "bgColor": Color(0xFFE8EAF6),
    },
    "refunds": {
      "icon": Icons.reply,
      "color": Colors.lightGreen,
      "bgColor": Color(0xFFE9FBEF),
    },
    "otherIncome": {
      "icon": Icons.account_balance_wallet,
      "color": Colors.grey,
      "bgColor": Color(0xFFF3F3F3),
    },
  };

  Map<String, dynamic> getCategoryIconAndColor(String category) {
    return categoryIconData[category] ??
        {"icon": Icons.category, "color": Colors.grey};
  }
}
