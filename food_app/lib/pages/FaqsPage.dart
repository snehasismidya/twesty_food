import 'package:flutter/material.dart';



class FaqsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food Delivery App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FAQsPage(),
    );
  }
}

class FAQItem {
  final String question;
  final String answer;

  FAQItem({required this.question, required this.answer});
}

class FAQsPage extends StatelessWidget {
  final List<FAQItem> faqItems = [
    FAQItem(
      question: 'How do I place an order?',
      answer: 'You can place an order by selecting items from the menu and proceeding to checkout.',
    ),
    FAQItem(
      question: 'What payment methods are accepted?',
      answer: 'We accept various payment methods, including credit/debit cards and digital wallets.',
    ),
    FAQItem(
      question: 'How long does delivery usually take?',
      answer: 'Delivery times can vary based on location and demand, but we strive to deliver within 30-45 minutes.',
    ),
    // Add more FAQ items here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FAQs'),
      ),
      body: ListView.builder(
        itemCount: faqItems.length,
        itemBuilder: (context, index) {
          final faqItem = faqItems[index];
          return ExpansionTile(
            title: Text(faqItem.question),
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  faqItem.answer,
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
