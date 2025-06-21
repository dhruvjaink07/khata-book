import 'package:hive/hive.dart';
import 'package:khata/services/khata_encryptor.dart';
part 'transaction.g.dart';

@HiveType(typeId: 0)
class Transaction extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String category;

  @HiveField(3)
  final double amount;

  @HiveField(4)
  final DateTime dateTime;

  @HiveField(5)
  final bool isIncome;

  @HiveField(6)
  final String? notes;

  @HiveField(7)
  final String currency;

  Transaction({
    required this.id,
    required this.title,
    required this.category,
    required this.amount,
    required this.dateTime,
    required this.isIncome,
    this.notes,
    this.currency = 'INR',
  });

  @override
  String toString() {
    return 'Transaction(id: $id, title: $title, category: $category, amount: $amount, dateTime: $dateTime, isIncome: $isIncome, currency: $currency)';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'amount': amount,
      'dateTime': dateTime.toIso8601String(),
      'isIncome': isIncome,
      'notes': notes,
      'currency': currency,
    };
  }

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] as String,
      title: json['title'] as String,
      category: json['category'] as String,
      amount: (json['amount'] as num).toDouble(),
      dateTime: DateTime.parse(json['dateTime'] as String),
      isIncome: json['isIncome'] as bool,
      notes: json['notes'] as String?,
      currency: json['currency'] as String? ?? 'INR',
    );
  }
}

extension TransactionEncryption on Transaction {
  Future<Map<String, dynamic>> toEncryptedJson() async {
    return {
      'id': id,
      'title': await KhataEncryptor.encrypt(title),
      'category': await KhataEncryptor.encrypt(category),
      'amount': await KhataEncryptor.encrypt(amount.toString()),
      'dateTime': dateTime.toIso8601String(), // stays plain for sorting
      'isIncome': isIncome, // boolean is safe to store as-is
      'notes': notes != null ? await KhataEncryptor.encrypt(notes!) : null,
      'currency': await KhataEncryptor.encrypt(currency),
    };
  }

  static Future<Transaction> fromEncryptedJson(Map<String, dynamic> map) async {
    return Transaction(
      id: map['id'],
      title: await KhataEncryptor.decrypt(map['title']),
      category: await KhataEncryptor.decrypt(map['category']),
      amount: double.parse(await KhataEncryptor.decrypt(map['amount'])),
      dateTime: DateTime.parse(map['dateTime']),
      isIncome: map['isIncome'],
      notes: map['notes'] != null
          ? await KhataEncryptor.decrypt(map['notes'])
          : null,
      currency: await KhataEncryptor.decrypt(map['currency']),
    );
  }
}
