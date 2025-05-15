import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:try2/dompet/models/reimbursement.dart';
import '../models/trans.dart';
import '../services/database_helper.dart';
import '../utils/formatters.dart';
import 'history_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final MoneyMaskedTextController _amountController = MoneyMaskedTextController(
    decimalSeparator: '',
    thousandSeparator: '.',
    precision: 0,
  );

  String _selectedCategory = 'OVO';
  String? _customDescription;
  bool _showCustomDescription = false;
  List<Trans> _transactions = [];
  late TabController _tabController;
  bool _isFormVisible = false;

  final List<String> _categories = [
    'OVO',
    'Shopee',
    'Gopay',
    'UKT',
    'Kursus',
    'Lainnya',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadTransactions();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadTransactions() async {
    _transactions = (await _dbHelper.getActiveTransactions()).cast<Trans>();
    setState(() {});
  }

  Future<void> _submitTransaction() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final parsedAmount = double.parse(
        _amountController.text.replaceAll('.', ''),
      );

      final transaction = Trans(
        amount: parsedAmount,
        category: _selectedCategory,
        customDescription: _customDescription,
        date: DateTime.now(),
      );

      await _dbHelper.insertTransaction(transaction);
      await _loadTransactions();

      // Reset form
      _amountController.clear();
      setState(() {
        _selectedCategory = 'OVO';
        _customDescription = null;
        _showCustomDescription = false;
        _isFormVisible = false;
      });

      // Show snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Transaksi berhasil ditambahkan'),
          backgroundColor: Colors.grey[900],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          action: SnackBarAction(
            label: 'OK',
            textColor: const Color(0xFFD4AF37),
            onPressed: () {},
          ),
        ),
      );
    }
  }

  Future<void> _handleReimburse() async {
    if (_transactions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tidak ada transaksi untuk direimbursement'),
        ),
      );
      return;
    }

    final total = _calculateTotal();
    final history = ReimbursementHistory(
      reimbursementDate: DateTime.now(),
      totalAmount: total,
      transactionIds: _transactions.map((t) => t.id!).toList(),
    );

    await _dbHelper.insertReimbursementHistory(history);    await _dbHelper.markAsReimbursed(_transactions.map((t) => t.id!).toList());
    await _loadTransactions();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Reimbursement berhasil dicatat'),
          backgroundColor: Theme.of(context).cardColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          action: SnackBarAction(
            label: 'Lihat',
            textColor: Theme.of(context).colorScheme.primary,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HistoryScreen()),
              );
            },
          ),
        ),
      );
    }
  }

  double _calculateTotal() {
    return _transactions.fold(0, (sum, tx) => sum + tx.amount);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dompet Digital'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HistoryScreen()),
              );
            },
          ),
          if (_transactions.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.currency_exchange),
              onPressed: _handleReimburse,
              tooltip: 'Reimburse',
            ),
        ],
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
        child: Column(
          children: [
            if (_transactions.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(
                          Icons.account_balance_wallet,
                          color: theme.colorScheme.primary,
                          size: 24,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Total Pengeluaran',
                                style: TextStyle(
                                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Rp ${Formatters.formatCurrency(_calculateTotal())}',
                                style: TextStyle(
                                  color: theme.colorScheme.primary,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            TabBar(
              controller: _tabController,
              labelColor: theme.colorScheme.primary,
              unselectedLabelColor: theme.colorScheme.onSurface.withOpacity(0.6),
              indicatorColor: theme.colorScheme.primary,
              tabs: const [
                Tab(text: 'Transaksi Aktif'),
                Tab(text: 'Form Transaksi'),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildTransactionsList(theme),
                  _buildTransactionForm(theme),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _isFormVisible = !_isFormVisible;
            if (_isFormVisible) {
              _tabController.animateTo(1);
            }
          });
        },
        backgroundColor: theme.colorScheme.primary,
        child: Icon(_isFormVisible ? Icons.close : Icons.add, 
                   color: theme.colorScheme.onPrimary),
      ),
    );
  }

  Widget _buildTransactionsList(ThemeData theme) {
    return _transactions.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.account_balance_wallet,
                  size: 72,
                  color: theme.colorScheme.onSurface.withOpacity(0.5),
                ),
                const SizedBox(height: 16),
                Text(
                  'Belum Ada Transaksi',
                  style: TextStyle(
                    fontSize: 18,
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _transactions.length,
            itemBuilder: (context, index) {
              final transaction = _transactions[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () {},
                    splashColor: theme.colorScheme.primary.withOpacity(0.1),
                    highlightColor: theme.colorScheme.primary.withOpacity(0.05),
                    child: Container(
                      color: theme.cardColor,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Formatters.getCategoryColor(transaction.category).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Formatters.getCategoryIcon(transaction.category),
                                color: Formatters.getCategoryColor(transaction.category),
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    Formatters.getCategoryDisplayName(transaction.category),
                                    style: TextStyle(
                                      color: theme.colorScheme.onSurface,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  if (transaction.customDescription != null)
                                    Text(
                                      transaction.customDescription!,
                                      style: TextStyle(
                                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                                        fontSize: 12,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            Text(
                              'Rp ${Formatters.formatCurrency(transaction.amount)}',
                              style: TextStyle(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
  }

  Widget _buildTransactionForm(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Jumlah (Rp)',
                prefixIcon: Icon(Icons.attach_money, color: theme.colorScheme.primary),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Masukkan jumlah';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: InputDecoration(
                labelText: 'Kategori',
                prefixIcon: Icon(
                  Formatters.getCategoryIcon(_selectedCategory),
                  color: theme.colorScheme.primary,
                ),
                border: OutlineInputBorder(),
              ),
              items: _categories.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(Formatters.getCategoryDisplayName(category)),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value!;
                  _showCustomDescription = value == 'Lainnya';
                });
              },
            ),
            if (_showCustomDescription) ...[
              const SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Deskripsi',
                  prefixIcon: Icon(Icons.description, color: theme.colorScheme.primary),
                  border: OutlineInputBorder(),
                ),
                onSaved: (value) => _customDescription = value,
              ),
            ],
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitTransaction,
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('SIMPAN'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
