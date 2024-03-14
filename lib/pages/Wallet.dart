import 'package:flutter/material.dart';

class Wallet {
  double balance;
  List<Transaction> transactions;

  Wallet({required this.balance, required this.transactions});
}

class Transaction {
  String description;
  double amount;
  bool isDeposit;

  Transaction({required this.description, required this.amount, required this.isDeposit});
}

class WalletPage extends StatefulWidget {
  final Wallet wallet;

  WalletPage({required this.wallet});

  @override
  _WalletPageState createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Wallet'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Current Balance: \$${widget.wallet.balance.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Transaction History',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.wallet.transactions.length,
              itemBuilder: (context, index) {
                final transaction = widget.wallet.transactions[index];
                return ListTile(
                  leading: transaction.isDeposit
                      ? Icon(Icons.add, color: Colors.green)
                      : Icon(Icons.remove, color: Colors.red),
                  title: Text(transaction.description),
                  subtitle: Text(
                    transaction.isDeposit
                        ? '+\$${transaction.amount.toStringAsFixed(2)}'
                        : '-\$${transaction.amount.toStringAsFixed(2)}',
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  Wallet wallet = Wallet(
    balance: 150.0,
    transactions: [
      Transaction(description: 'Deposit', amount: 200.0, isDeposit: true),
      Transaction(description: 'Pizza Order', amount: 15.0, isDeposit: false),
      // Add more transactions here
    ],
  );

  runApp(MaterialApp(
    home: WalletPage(wallet: wallet),
  ));
}
