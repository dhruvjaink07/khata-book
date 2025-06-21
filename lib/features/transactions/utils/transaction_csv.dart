import 'dart:io';
import 'dart:isolate';

import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';

import '../domain/transaction.dart';

String transactionsToCsv(List<Transaction> transactions) {
  final headers = [
    'ID',
    'Title',
    'Category',
    'Amount',
    'Date',
    'IsIncome',
    'Notes',
    'Currency',
  ];
  final rows = [
    headers,
    ...transactions.map(
      (t) => [
        t.id,
        t.title,
        t.category,
        t.amount,
        t.dateTime.toIso8601String(),
        t.isIncome,
        t.notes ?? '',
        t.currency,
      ],
    ),
  ];
  return const ListToCsvConverter().convert(rows);
}

// Save CSV string to file and return the file path
Future<File> saveCsvToFile(
  String csvContent, {
  required String fileName,
}) async {
  final dir = await getTemporaryDirectory();
  final file = File('${dir.path}/$fileName');
  return file.writeAsString(csvContent);
}

List<Transaction> transactionsFromCsv(String csvContent) {
  final rows = const CsvToListConverter().convert(csvContent, eol: '\n');
  if (rows.isEmpty) return [];
  final dataRows = rows.skip(1);

  return dataRows.map((row) {
    return Transaction(
      id: row[0].toString(),
      title: row[1].toString(),
      category: row[2].toString(),
      amount: double.tryParse(row[3].toString()) ?? 0.0,
      dateTime: DateTime.parse(row[4].toString()),
      isIncome: row[5].toString().toLowerCase() == 'true',
      notes: row[6]?.toString(),
      currency: row.length > 7 ? row[7].toString() : 'INR',
    );
  }).toList();
}

extension TransactionCsv on Transaction {
  List<dynamic> toCsvRow() {
    return [
      id,
      title,
      category,
      amount,
      dateTime.toIso8601String(),
      isIncome,
      notes ?? '',
      currency,
    ];
  }

  static Transaction fromCsvRow(List<dynamic> row) {
    return Transaction(
      id: row[0].toString(),
      title: row[1].toString(),
      category: row[2].toString(),
      amount: double.tryParse(row[3].toString()) ?? 0.0,
      dateTime: DateTime.parse(row[4].toString()),
      isIncome: row[5].toString().toLowerCase() == 'true',
      notes: row[6]?.toString(),
      currency: row.length > 7 ? row[7].toString() : 'INR',
    );
  }
}

Future<List<List<dynamic>>> transactionsToRowsIsolate(
  List<Transaction> txns,
) async {
  final p = ReceivePort();
  await Isolate.spawn(_isolateEntry, [p.sendPort, txns]);
  return await p.first as List<List<dynamic>>;
}

void _isolateEntry(List<dynamic> args) {
  final sendPort = args[0] as SendPort;
  final txns = args[1] as List<Transaction>;
  final rows = txns.map((t) => t.toCsvRow()).toList();
  sendPort.send(rows);
}
