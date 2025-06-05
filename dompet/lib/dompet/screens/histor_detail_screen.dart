import 'package:flutter/material.dart';
import 'package:try2/dompet/models/reimbursement.dart';
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

    // Generate consistent colors based on theme
    final theme = Theme.of(context);
    final baseColor = theme.colorScheme.secondary;
    
    // Create color variations based on secondary color
    final colors = [
      baseColor,
      baseColor.withOpacity(0.8),
      baseColor.withOpacity(0.6),
      baseColor.withOpacity(0.4),
      baseColor.withOpacity(0.2),
      baseColor.withOpacity(0.1),
    ];

    int colorIndex = 0;
    return totals.entries.map((entry) {
        final double percentage = (entry.value / sum) * 100;
        final color = colors[colorIndex % colors.length];
        colorIndex++;
        
        return {
          'category': entry.key,
          'amount': entry.value,
          'percentage': percentage,
          'color': color,
        };
      }).toList()
      ..sort(
        (a, b) => (b['amount'] as double).compareTo(a['amount'] as double),
      );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(      appBar: AppBar(
        title: Text(
          'Detail Pencairan',
          style: TextStyle(
            color: theme.colorScheme.secondary,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        iconTheme: IconThemeData(color: theme.colorScheme.secondary),
      ),
      body: _transactions.isEmpty          ? Center(
              child: CircularProgressIndicator(
                color: theme.colorScheme.secondary,
              ),
            )
          : CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: theme.scaffoldBackgroundColor,
                      boxShadow: [
                        BoxShadow(
                          color: theme.shadowColor.withOpacity(0.1),
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
                                color: theme.cardColor,
                                borderRadius: BorderRadius.circular(12),
                              ),                              child: Icon(
                                Icons.calendar_today,
                                color: theme.colorScheme.secondary,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [                                  Text(
                                    'Tanggal Pencairan',
                                    style: TextStyle(
                                      color: theme.colorScheme.secondary.withOpacity(0.7),
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    Formatters.formatDate(widget.history.reimbursementDate),
                                    style: TextStyle(
                                      color: theme.colorScheme.secondary,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
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
                                color: theme.cardColor,
                                borderRadius: BorderRadius.circular(12),
                              ),                              child: Icon(
                                Icons.account_balance_wallet,
                                color: theme.colorScheme.secondary,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [                                  Text(
                                    'Total Pengeluaran',
                                    style: TextStyle(
                                      color: theme.colorScheme.secondary.withOpacity(0.7),
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Rp ${Formatters.formatCurrency(widget.history.totalAmount)}',
                                    style: TextStyle(
                                      color: theme.colorScheme.secondary,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        if (_transactions.isNotEmpty) ...[
                          const SizedBox(height: 32),                          Text(
                            'Distribusi Pengeluaran',
                            style: TextStyle(
                              color: theme.colorScheme.secondary,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            height: 200,                            child: PieChart(
                              PieChartData(
                                sectionsSpace: 2,
                                centerSpaceRadius: 40,
                                sections: getCategoryPercentages().map((data) {
                                  return PieChartSectionData(
                                    color: data['color'] as Color,
                                    value: data['percentage'] as double,
                                    title: '${(data['percentage'] as double).toStringAsFixed(1)}%',
                                    radius: 100,
                                    titleStyle: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          ...getCategoryPercentages().map((data) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Row(
                              children: [
                                Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: data['color'] as Color,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(                                  child: Text(
                                    Formatters.getCategoryDisplayName(data['category'] as String),
                                    style: TextStyle(
                                      color: theme.colorScheme.secondary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Text(
                                  'Rp ${Formatters.formatCurrency(data['amount'] as double)}',
                                  style: TextStyle(
                                    color: theme.colorScheme.secondary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          )).toList(),
                        ],
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([                      Text(
                        'Daftar Transaksi',
                        style: TextStyle(
                          color: theme.colorScheme.secondary,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ..._transactions.map((transaction) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Card(
                          clipBehavior: Clip.antiAlias,
                          child: Container(
                            color: theme.cardColor,
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.secondary.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),child: Icon(
                                      Formatters.getCategoryIcon(transaction.category),
                                      color: theme.colorScheme.secondary,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [                                        Text(
                                          Formatters.getCategoryDisplayName(transaction.category),
                                          style: TextStyle(
                                            color: theme.colorScheme.secondary,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        if (transaction.customDescription != null)
                                          Text(
                                            transaction.customDescription!,
                                            style: TextStyle(
                                              color: theme.colorScheme.secondary.withOpacity(0.7),
                                              fontSize: 12,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),                                  Text(
                                    'Rp ${Formatters.formatCurrency(transaction.amount)}',
                                    style: TextStyle(
                                      color: theme.colorScheme.secondary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )).toList(),
                    ]),
                  ),
                ),
              ],
            ),
    );
  }
}
