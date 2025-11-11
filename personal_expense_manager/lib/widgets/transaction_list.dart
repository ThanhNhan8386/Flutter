import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/transaction_provider.dart';
import 'transaction_item.dart';

class TransactionList extends StatelessWidget {
  const TransactionList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionProvider>(
      builder: (context, provider, child) {
        if (provider.transactions.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.receipt_long, size: 80, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'Chưa có giao dịch nào',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        final groupedTransactions = provider.getTransactionsGroupedByDate();
        final sortedDates = groupedTransactions.keys.toList()
          ..sort((a, b) {
            final partsA = a.split('/');
            final partsB = b.split('/');
            final dateA = DateTime(
              int.parse(partsA[2]),
              int.parse(partsA[1]),
              int.parse(partsA[0]),
            );
            final dateB = DateTime(
              int.parse(partsB[2]),
              int.parse(partsB[1]),
              int.parse(partsB[0]),
            );
            return dateB.compareTo(dateA);
          });

        return ListView.builder(
          itemCount: sortedDates.length,
          itemBuilder: (context, index) {
            final dateKey = sortedDates[index];
            final transactions = groupedTransactions[dateKey]!;
            final dayTotal = transactions.fold<double>(
              0,
              (sum, t) => sum + (t.isIncome ? t.amount : -t.amount),
            );

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        dateKey,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${dayTotal >= 0 ? '+' : ''}${dayTotal.toStringAsFixed(0)}₫',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: dayTotal >= 0 ? Colors.green : Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
                ...transactions.map((transaction) => TransactionItem(
                      transaction: transaction,
                      onDelete: () => provider.deleteTransaction(transaction),
                    )),
              ],
            );
          },
        );
      },
    );
  }
}
