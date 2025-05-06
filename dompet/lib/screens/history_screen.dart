import 'package:flutter/material.dart';
import 'package:try2/models/reimbursement.dart';
import 'package:try2/screens/histor_detail_screen.dart';

import '../services/database_helper.dart';
import '../utils/formatters.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Catatan Reimburse'), elevation: 0),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).scaffoldBackgroundColor,
              Theme.of(context).scaffoldBackgroundColor.withOpacity(0.95),
            ],
          ),
        ),
        child: FutureBuilder<List<ReimbursementHistory>>(
          future: DatabaseHelper().getAllReimbursementHistory(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: Color(0xFFD4AF37)),
              );
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.history,
                      size: 72,
                      color: Colors.grey.withOpacity(0.5),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Belum Ada Catatan Reimburse',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              );
            }

            final histories =
                snapshot.data!..sort(
                  (a, b) => b.reimbursementDate.compareTo(a.reimbursementDate),
                );

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
                      onTap:
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                      HistoryDetailScreen(history: history),
                            ),
                          ),
                      splashColor: const Color(0xFFD4AF37).withOpacity(0.1),
                      highlightColor: const Color(0xFFD4AF37).withOpacity(0.05),
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            color: const Color(0xFF1A1A1A),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.currency_exchange,
                                  color: Color(0xFFD4AF37),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Reimburse Selesai',
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        Formatters.formatDate(
                                          history.reimbursementDate,
                                        ),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Total Dana',
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        'Rp ${Formatters.formatCurrency(history.totalAmount)}',
                                        style: const TextStyle(
                                          color: Color(0xFFD4AF37),
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF2A2A2A),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                    Icons.arrow_forward,
                                    color: Color(0xFFD4AF37),
                                    size: 20,
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
