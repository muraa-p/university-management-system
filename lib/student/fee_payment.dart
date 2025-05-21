import 'package:flutter/material.dart';

class FeePayment extends StatefulWidget {
  const FeePayment({super.key});

  @override
  _FeePaymentState createState() => _FeePaymentState();
}

class _FeePaymentState extends State<FeePayment> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  final TextEditingController _accountNumberController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _walletIdController = TextEditingController();
  final TextEditingController _otherBankController = TextEditingController();

  String selectedMethod = '';
  String? selectedBank;
  bool showOtherBankField = false;
  List<String> receiptHistory = [];

  // List of banks for the dropdown
  List<String> banks = [
    'Premier Bank',
    'Amal Bank',
    'Salam Somali Bank',
    'Other'
  ];

  void generateReceipt() {
    setState(() {
      String paymentDetails = '';
      if (selectedMethod == 'Online Bank Transfer') {
        String beneficiaryBank = selectedBank == 'Other'
            ? _otherBankController.text.isNotEmpty
            ? _otherBankController.text
            : 'Not Specified'
            : selectedBank ?? 'Not Selected';
        paymentDetails = 'Beneficiary Bank: $beneficiaryBank';
      } else if (selectedMethod == 'EVC Plus') {
        paymentDetails = 'Phone Number: ${_phoneNumberController.text}';
      } else if (selectedMethod == 'Mastercard') {
        paymentDetails = 'Card Number: ${_cardNumberController.text}';
      } else if (selectedMethod == 'Premier Wallet') {
        paymentDetails = 'Wallet ID: ${_walletIdController.text}';
      } else {
        paymentDetails = 'Payment Details: Entered';
      }

      String newReceipt = '''
      Payment Method: $selectedMethod
      Amount: \$${_amountController.text}
      $paymentDetails
      Date: ${DateTime.now().toLocal().toString().substring(0, 19)}
      Status: Successful
      ''';
      receiptHistory.add(newReceipt);
    });
  }

  Widget getPaymentFields() {
    switch (selectedMethod) {
      case 'Mastercard':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _cardNumberController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'Card Number',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.credit_card),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _expiryDateController,
              keyboardType: TextInputType.datetime,
              decoration: const InputDecoration(
                hintText: 'Expiry Date (MM/YY)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.date_range),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _cvvController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'CVV',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
            ),
          ],
        );
      case 'Online Bank Transfer':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _accountNumberController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'Account Number',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.account_balance),
              ),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: selectedBank,
              items: banks.map((String bank) {
                return DropdownMenuItem<String>(
                  value: bank,
                  child: Text(bank),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedBank = value;
                  showOtherBankField = (selectedBank == 'Other');
                });
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.business),
                hintText: 'Select Bank',
              ),
            ),
            if (showOtherBankField) ...[
              const SizedBox(height: 10),
              TextField(
                controller: _otherBankController,
                decoration: const InputDecoration(
                  hintText: 'Enter Bank Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.account_balance),
                ),
              ),
            ],
          ],
        );
      case 'EVC Plus':
        return TextField(
          controller: _phoneNumberController,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(
            hintText: 'Phone Number',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.phone_android),
          ),
        );
      case 'Premier Wallet':
        return TextField(
          controller: _walletIdController,
          keyboardType: TextInputType.text,
          decoration: const InputDecoration(
            hintText: 'Wallet ID',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.wallet),
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pay Fees')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text(
            'Enter Amount:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          TextField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: 'Enter fee amount',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.attach_money),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Select Payment Method:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    selectedMethod = 'Mastercard';
                  });
                },
                icon: const Icon(Icons.credit_card),
                label: const Text('Mastercard'),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    selectedMethod = 'Online Bank Transfer';
                  });
                },
                icon: const Icon(Icons.account_balance),
                label: const Text('Bank Transfer'),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    selectedMethod = 'EVC Plus';
                  });
                },
                icon: const Icon(Icons.phone_android),
                label: const Text('EVC Plus'),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    selectedMethod = 'Premier Wallet';
                  });
                },
                icon: const Icon(Icons.wallet),
                label: const Text('Premier Wallet'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (selectedMethod.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Enter $selectedMethod Details:',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                getPaymentFields(),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: generateReceipt,
                  child: const Text('Confirm Payment'),
                ),
              ],
            ),
          const SizedBox(height: 20),
          if (receiptHistory.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: receiptHistory.map((receipt) => Card(
                color: Colors.grey[100],
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    receipt,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              )).toList(),
            ),
        ],
      ),
    );
  }
}
