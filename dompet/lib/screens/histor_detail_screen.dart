import 'package:flutter/material.dart';
import 'package:try2/models/reimbursement.dart';
import '../models/trans.dart';
import '../services/database_helper.dart';
import '../utils/formatters.dart';
import 'package:fl_chart/fl_chart.dart';

class HistoryDetailScreen extends StatefulWidget {
  final ReimbursementHistory history;

  const HistoryDetailScreen({super.key, required this.history});

  @override
  State<HistoryDetailScreen> createState() => _HistoryDetailScreenState();
}

class _HistoryDetailScreenState extends State<HistoryDetailScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Trans> _transactions = [];

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    final result = await _dbHelper.getTransactionsByIds(
      widget.history.transactionIds,
    );
    setState(() {
      _transactions = result.cast<Trans>();
    });
  }

  Map<String, double> getCategoryTotals() {
    final Map<String, double> data = {};
    for (var tx in _transactions) {
      final category = tx.category;
      data[category] = (data[category] ?? 0) + tx.amount;
    }
    return data;
  }

  // Calculate percentages for pie chart
  List<Map<String, dynamic>> getCategoryPercentages() {
    final Map<String, double> totals = getCategoryTotals();
    final double sum = totals.values.fold(0, (a, b) => a + b);

    return totals.entries.map((entry) {
        final double percentage = (entry.value / sum) * 100;
        return {
          'category': entry.key,
          'amount': entry.value,
          'percentage': percentage,
          'color': Formatters.getCategoryColor(entry.key),
        };
      }).toList()
      ..sort(
        (a, b) => (b['amount'] as double).compareTo(a['amount'] as double),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Pencairan'), elevation: 0),
      body:
          _transactions.isEmpty
              ? const Center(
                child: CircularProgressIndicator(color: Color(0xFFD4AF37)),
              )
              : CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF2A2A2A),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.calendar_today,
                                  color: Color(0xFFD4AF37),
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Tanggal Pencairan',
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      Formatters.formatDate(
                                        widget.history.reimbursementDate,
                                      ),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF2A2A2A),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.attach_money,
                                  color: Color(0xFFD4AF37),
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Total Dana Dicairkan',
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Rp ${Formatters.formatCurrency(widget.history.totalAmount)}',
                                      style: const TextStyle(
                                        color: Color(0xFFD4AF37),
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          const Divider(),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Detail Transaksi',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${_transactions.length} Item',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),

                  /// ==== VISUAL CHART SECTION ====
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Visualisasi Penggunaan Dana',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Category Legend
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Distribusi Kategori',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 12),
                              ...getCategoryPercentages().map(
                                (item) => Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 16,
                                        height: 16,
                                        decoration: BoxDecoration(
                                          color: item['color'],
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          Formatters.getCategoryDisplayName(
                                            item['category'],
                                          ),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        '${item['percentage'].toStringAsFixed(1)}%',
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 40),

                          // Pie Chart
                          AspectRatio(
                            aspectRatio: 1.4,
                            child: PieChart(
                              PieChartData(
                                sections:
                                    getCategoryPercentages().map((item) {
                                      return PieChartSectionData(
                                        value: item['amount'],
                                        title:
                                            '${item['percentage'].toStringAsFixed(0)}%',
                                        color: item['color'],
                                        radius: 110,
                                        titleStyle: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        badgeWidget: null,
                                        showTitle: true,
                                      );
                                    }).toList(),
                                sectionsSpace: 2,
                                centerSpaceRadius: 60,
                                startDegreeOffset: 180,
                              ),
                            ),
                          ),

                          const SizedBox(height: 56),

                          // Horizontal Bar Chart
                          const Text(
                            'Distribusi Nominal per Kategori',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 16),

                          ...getCategoryPercentages().map(
                            (item) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        Formatters.getCategoryDisplayName(
                                          item['category'],
                                        ),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        'Rp ${Formatters.formatCurrency(item['amount'])}',
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: LinearProgressIndicator(
                                      value: item['percentage'] / 100,
                                      minHeight: 12,
                                      backgroundColor: Colors.grey.shade800,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        item['color'],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ),

                  /// ==== TRANSACTION LIST ====
                  SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final tx = _transactions[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Card(
                          elevation: 2,
                          margin: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: Formatters.getCategoryColor(
                                      tx.category,
                                    ).withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    Formatters.getCategoryIcon(tx.category),
                                    color: Formatters.getCategoryColor(
                                      tx.category,
                                    ),
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        tx.customDescription ??
                                            Formatters.getCategoryDisplayName(
                                              tx.category,
                                            ),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        Formatters.formatDate(tx.date),
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  'Rp ${Formatters.formatCurrency(tx.amount)}',
                                  style: const TextStyle(
                                    color: Color(0xFFD4AF37),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }, childCount: _transactions.length),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 24)),
                ],
              ),
    );
  }
}
