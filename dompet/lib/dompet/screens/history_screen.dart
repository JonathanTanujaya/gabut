import 'package:flutter/material.dart';
import '../models/reimbursement.dart';
import '../utils/formatters.dart';
import 'histor_detail_screen.dart';
import '../services/database_helper.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(      appBar: AppBar(
        title: Text(
          'Catatan Reimburse',
          style: TextStyle(
            color: theme.colorScheme.secondary,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        iconTheme: IconThemeData(color: theme.colorScheme.secondary),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.scaffoldBackgroundColor,
              theme.scaffoldBackgroundColor.withOpacity(0.95),
            ],
          ),
        ),
        child: FutureBuilder<List<ReimbursementHistory>>(
          future: DatabaseHelper().getAllReimbursementHistory(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {              return Center(
                child: CircularProgressIndicator(
                  color: theme.colorScheme.secondary,
                ),
              );
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [                    Icon(
                      Icons.history,
                      size: 72,
                      color: theme.colorScheme.secondary.withOpacity(0.6),
                    ),
                    const SizedBox(height: 16),                    Text(
                      'Belum Ada Catatan Reimburse',
                      style: TextStyle(
                        fontSize: 18,
                        color: theme.colorScheme.secondary.withOpacity(0.8),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            }

            final histories = snapshot.data!
              ..sort((a, b) => b.reimbursementDate.compareTo(a.reimbursementDate));

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: histories.length,
              itemBuilder: (context, index) {
                final history = histories[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HistoryDetailScreen(history: history),
                        ),
                      ),                      splashColor: theme.colorScheme.secondary.withOpacity(0.1),
                      highlightColor: theme.colorScheme.secondary.withOpacity(0.05),
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            color: theme.cardColor,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            child: Row(
                              children: [                                Icon(
                                  Icons.currency_exchange,
                                  color: theme.colorScheme.secondary,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [                                      Text(
                                        'Reimburse ${Formatters.formatDate(history.reimbursementDate)}',
                                        style: TextStyle(
                                          color: theme.colorScheme.secondary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        '${history.transactionIds.length} Transaksi',
                                        style: TextStyle(
                                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),                                Text(
                                  Formatters.formatCurrency(history.totalAmount),
                                  style: TextStyle(
                                    color: theme.colorScheme.secondary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
