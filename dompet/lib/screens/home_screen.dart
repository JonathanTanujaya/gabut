import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:try2/models/reimbursement.dart';
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
        SnackBar(
          content: const Text('Tidak ada transaksi untuk dicairkan'),
          backgroundColor: Colors.grey[900],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }

    final total = _transactions.fold(0.0, (sum, t) => sum + t.amount);

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: const Color(0xFF1A1A1A),
            title: const Text(
              'Konfirmasi Pencairan',
              style: TextStyle(
                color: Color(0xFFD4AF37),
                fontWeight: FontWeight.bold,
              ),
            ),
            content: SizedBox(
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    color: const Color(0xFF252525),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          const Text(
                            'Total Dana',
                            style: TextStyle(color: Colors.white70),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Rp ${Formatters.formatCurrency(total)}',
                            style: const TextStyle(
                              color: Color(0xFFD4AF37),
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(color: Color(0xFF333333)),
                  const SizedBox(height: 8),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Daftar Transaksi',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _transactions.length,
                      itemBuilder: (context, index) {
                        final t = _transactions[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: Formatters.getCategoryColor(
                                    t.category,
                                  ).withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Formatters.getCategoryIcon(t.category),
                                  color: Formatters.getCategoryColor(
                                    t.category,
                                  ),
                                  size: 18,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  t.customDescription ??
                                      Formatters.getCategoryDisplayName(
                                        t.category,
                                      ),
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              Text(
                                'Rp ${Formatters.formatCurrency(t.amount)}',
                                style: const TextStyle(
                                  color: Color(0xFFD4AF37),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Batal'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final history = ReimbursementHistory(
                    reimbursementDate: DateTime.now(),
                    totalAmount: total,
                    transactionIds: _transactions.map((t) => t.id!).toList(),
                  );

                  await _dbHelper.insertReimbursementHistory(history);
                  await _dbHelper.markAsReimbursed(
                    _transactions.map((t) => t.id!).toList(),
                  );

                  Navigator.popUntil(context, (route) => route.isFirst);
                  await _loadTransactions();

                  // Show confirmation
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Dana berhasil dicairkan'),
                      backgroundColor: Colors.grey[900],
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      action: SnackBarAction(
                        label: 'Lihat Riwayat',
                        textColor: const Color(0xFFD4AF37),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HistoryScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
                child: const Text('Konfirmasi'),
              ),
            ],
          ),
    );
  }

  double _calculateTotal() {
    if (_transactions.isEmpty) return 0;
    return _transactions.fold(0.0, (sum, tx) => sum + tx.amount);
  }

  @override
  Widget build(BuildContext context) {
    final total = _calculateTotal();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dompet Premium'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HistoryScreen(),
                  ),
                ),
          ),
        ],
      ),
      body: Expanded(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 24,
                ),
                decoration: const BoxDecoration(
                  color: Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Saldo Tersedia',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Rp ${Formatters.formatCurrency(total)}',
                      style: const TextStyle(
                        color: Color(0xFFD4AF37),
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.add, size: 18),
                            label: const Text('Tambah'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFD4AF37),
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                _isFormVisible = !_isFormVisible;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.currency_exchange, size: 18),
                            label: const Text('Cairkan'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              foregroundColor: const Color(0xFFD4AF37),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: const BorderSide(
                                  color: Color(0xFFD4AF37),
                                ),
                              ),
                            ),
                            onPressed: _handleReimburse,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: _isFormVisible ? null : 0,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: _isFormVisible ? 1.0 : 0.0,
                  child:
                      _isFormVisible
                          ? Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF1E1E1E),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              'Tambah Transaksi Baru',
                                              style: TextStyle(
                                                color: Color(0xFFD4AF37),
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            IconButton(
                                              icon: const Icon(
                                                Icons.close,
                                                color: Colors.white54,
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  _isFormVisible = false;
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 16),
                                        DropdownButtonFormField<String>(
                                          value: _selectedCategory,
                                          decoration: const InputDecoration(
                                            labelText: 'Kategori Transaksi',
                                            border: OutlineInputBorder(),
                                            prefixIcon: Icon(Icons.category),
                                          ),
                                          items:
                                              _categories.map((category) {
                                                return DropdownMenuItem(
                                                  value: category,
                                                  child: Text(
                                                    Formatters.getCategoryDisplayName(
                                                      category,
                                                    ),
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                );
                                              }).toList(),
                                          onChanged: (value) {
                                            setState(() {
                                              _selectedCategory = value!;
                                              _showCustomDescription =
                                                  (value == 'Lainnya');
                                            });
                                          },
                                          dropdownColor: const Color(
                                            0xFF2A2A2A,
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        if (_showCustomDescription)
                                          Column(
                                            children: [
                                              TextFormField(
                                                decoration:
                                                    const InputDecoration(
                                                      labelText:
                                                          'Keterangan Detail',
                                                      border:
                                                          OutlineInputBorder(),
                                                      prefixIcon: Icon(
                                                        Icons.description,
                                                      ),
                                                    ),
                                                validator: (value) {
                                                  if (_showCustomDescription &&
                                                      (value == null ||
                                                          value.isEmpty)) {
                                                    return 'Keterangan harus diisi';
                                                  }
                                                  return null;
                                                },
                                                onSaved:
                                                    (value) =>
                                                        _customDescription =
                                                            value,
                                              ),
                                              const SizedBox(height: 16),
                                            ],
                                          ),
                                        TextFormField(
                                          controller: _amountController,
                                          keyboardType: TextInputType.number,
                                          decoration: const InputDecoration(
                                            labelText: 'Jumlah Dana',
                                            border: OutlineInputBorder(),
                                            prefixIcon: Icon(
                                              Icons.attach_money,
                                            ),
                                            prefixText: 'Rp ',
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Jumlah dana harus diisi';
                                            }
                                            final cleaned = value.replaceAll(
                                              '.',
                                              '',
                                            );
                                            if (int.tryParse(cleaned) == null ||
                                                int.parse(cleaned) <= 0) {
                                              return 'Jumlah dana harus lebih dari 0';
                                            }
                                            return null;
                                          },
                                        ),
                                        const SizedBox(height: 16),
                                        SizedBox(
                                          width: double.infinity,
                                          child: ElevatedButton.icon(
                                            icon: const Icon(Icons.save),
                                            label: const Text(
                                              'Simpan Transaksi',
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: const Color(
                                                0xFFD4AF37,
                                              ),
                                              foregroundColor: Colors.black,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 16,
                                                  ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                            ),
                                            onPressed: _submitTransaction,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                          : const SizedBox(),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Aktivitas Terkini',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
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
              ),
              const SizedBox(height: 12),
              if (_transactions.isEmpty)
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.account_balance_wallet,
                        size: 64,
                        color: Colors.grey.withOpacity(0.5),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Belum Ada Transaksi',
                        style: TextStyle(
                          color: Colors.grey.withOpacity(0.7),
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tekan tombol "Tambah" untuk memulai',
                        style: TextStyle(
                          color: Colors.grey.withOpacity(0.5),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _transactions.length,
                  itemBuilder: (context, index) {
                    final transaction = _transactions[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Card(
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
                                    transaction.category,
                                  ).withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Formatters.getCategoryIcon(
                                    transaction.category,
                                  ),
                                  color: Formatters.getCategoryColor(
                                    transaction.category,
                                  ),
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      transaction.customDescription ??
                                          Formatters.getCategoryDisplayName(
                                            transaction.category,
                                          ),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      Formatters.formatDate(transaction.date),
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                'Rp ${Formatters.formatCurrency(transaction.amount)}',
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
                  },
                ),
              if (_transactions.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.currency_exchange),
                    label: const Text('Cairkan Dana Sekarang'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD4AF37),
                      foregroundColor: Colors.black,
                      minimumSize: const Size(double.infinity, 54),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    onPressed: _handleReimburse,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
