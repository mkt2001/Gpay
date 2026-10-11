import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:intl/intl.dart';
import 'dart:math';

void main() {
  runApp(const GPayPrankApp());
}

class GPayPrankApp extends StatelessWidget {
  const GPayPrankApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Google Pay Prank',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212),
        primaryColor: Colors.blue,
      ),
      home: const GPayHomeScreen(),
    );
  }
}

class GPayHomeScreen extends StatefulWidget {
  const GPayHomeScreen({super.key});

  @override
  State<GPayHomeScreen> createState() => _GPayHomeScreenState();
}

class _GPayHomeScreenState extends State<GPayHomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomeDashboard(),
    const HistoryScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        backgroundColor: const Color(0xFF1E1E1E),
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'You'),
        ],
      ),
    );
  }
}

// 1. HOME DASHBOARD (GPay Style)
class HomeDashboard extends StatelessWidget {
  const HomeDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFF2C2C2C),
            borderRadius: BorderRadius.circular(30),
          ),
          child: const Row(
            children: [
              Icon(Icons.search, color: Colors.grey),
              SizedBox(width: 10),
              Text('Pay anyone on UPI', style: TextStyle(color: Colors.grey, fontSize: 16)),
            ],
          ),
        ),
        actions: [
          CircleAvatar(
            backgroundColor: Colors.blue.shade800,
            child: const Text('M', style: TextStyle(color: Colors.white)),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildActionButton(context, Icons.qr_code_scanner, 'Scan any QR code', () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const QRScanScreen()));
                }),
                _buildActionButton(context, Icons.currency_rupee, 'Pay anyone', () {}),
                _buildActionButton(context, Icons.account_balance, 'Bank transfer', () {}),
                _buildActionButton(context, Icons.phone_android, 'Mobile recharge', () {}),
              ],
            ),
            const SizedBox(height: 24),
            const Text('Manage your money', style: TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            
            Card(
              color: const Color(0xFF1E1E1E),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.history, color: Colors.blueAccent),
                    title: const Text('See transaction history'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const HistoryScreen()));
                    },
                  ),
                  const Divider(height: 1, color: Colors.grey),
                  ListTile(
                    leading: const Icon(Icons.account_balance_wallet, color: Colors.blueAccent),
                    title: const Text('Check bank balance'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      _showBankBalanceDialog(context);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade900.withOpacity(0.3),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(icon, color: Colors.blueAccent, size: 28),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: 75,
            child: Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 11, color: Colors.white70)),
          ),
        ],
      ),
    );
  }

  void _showBankBalanceDialog(BuildContext context) {
    final random = Random();
    int bobBalance = 12450 + random.nextInt(5000);
    int sbiBalance = 45200 + random.nextInt(10000);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2C2C2C),
        title: const Text('Bank Accounts Balance'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Bank of Baroda A/c ***4589'),
              subtitle: Text('₹ $bobBalance', style: const TextStyle(color: Colors.greenAccent, fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            const Divider(color: Colors.grey),
            ListTile(
              title: const Text('State Bank of India A/c ***9120'),
              subtitle: Text('₹ $sbiBalance', style: const TextStyle(color: Colors.greenAccent, fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Done', style: TextStyle(color: Colors.blueAccent))),
        ],
      ),
    );
  }
}

// 2. QR SCANNER SCREEN
class QRScanScreen extends StatelessWidget {
  const QRScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan QR Code')),
      body: MobileScanner(
        onDetect: (capture) {
          final List<Barcode> barcodes = capture.barcodes;
          for (final barcode in barcodes) {
            final scannedData = barcode.rawValue ?? 'Unknown Merchant / UPI';
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => PaymentAmountScreen(merchantName: scannedData),
              ),
            );
            break;
          }
        },
      ),
    );
  }
}

// 3. ENTER AMOUNT SCREEN
class PaymentAmountScreen extends StatefulWidget {
  final String merchantName;
  const PaymentAmountScreen({super.key, required this.merchantName});

  @override
  State<PaymentAmountScreen> createState() => _PaymentAmountScreenState();
}

class _PaymentAmountScreenState extends State<PaymentAmountScreen> {
  final TextEditingController _amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pay to ${widget.merchantName.substring(0, min(15, widget.merchantName.length))}')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white),
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                hintText: '₹0',
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
              ),
              onPressed: () {
                if (_amountController.text.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PinEnterScreen(
                        merchantName: widget.merchantName,
                        amount: _amountController.text,
                      ),
                    ),
                  );
                }
              },
              child: const Text('Proceed to Pay', style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

// 4. UPI PIN SCREEN
class PinEnterScreen extends StatefulWidget {
  final String merchantName;
  final String amount;
  const PinEnterScreen({super.key, required this.merchantName, required this.amount});

  @override
  State<PinEnterScreen> createState() => _PinEnterScreenState();
}

class _PinEnterScreenState extends State<PinEnterScreen> {
  String pin = '';

  void _onKeyPressed(String val) {
    setState(() {
      if (val == 'C') {
        if (pin.isNotEmpty) pin = pin.substring(0, pin.length - 1);
      } else if (val == '✓') {
        if (pin.length >= 4) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => SuccessScreen(
                merchantName: widget.merchantName,
                amount: widget.amount,
              ),
            ),
          );
        }
      } else {
        if (pin.length < 4) pin += val;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2C2C2C),
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Text('Enter 4-Digit UPI PIN', style: TextStyle(fontSize: 18, color: Colors.white70)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(4, (index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: index < pin.length ? Colors.white : Colors.transparent,
                  border: Border.all(color: Colors.white),
                ),
              );
            }),
          ),
          const SizedBox(height: 40),
          Container(
            color: const Color(0xFF1E1E1E),
            child: Column(
              children: [
                for (var row in [['1', '2', '3'], ['4', '5', '6'], ['7', '8', '9'], ['C', '0', '✓']])
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: row.map((val) {
                      return TextButton(
                        onPressed: () => _onKeyPressed(val),
                        child: Text(val, style: const TextStyle(fontSize: 24, color: Colors.white)),
                      );
                    }).toList(),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// 5. SUCCESS REAL-TIME SCREEN
class SuccessScreen extends StatelessWidget {
  final String merchantName;
  final String amount;
  const SuccessScreen({super.key, required this.merchantName, required this.amount});

  @override
  Widget build(BuildContext context) {
    String currentTime = DateFormat('dd MMM yyyy, hh:mm a').format(DateTime.now());

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 40,
                backgroundColor: Colors.green,
                child: Icon(Icons.check, size: 50, color: Colors.white),
              ),
              const SizedBox(height: 20),
              const Text('Paid successfully', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 10),
              Text('₹$amount', style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.greenAccent)),
              const SizedBox(height: 20),
              Text('Paid to: $merchantName', textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey, fontSize: 16)),
              const SizedBox(height: 5),
              Text(currentTime, style: const TextStyle(color: Colors.grey, fontSize: 14)),
              const SizedBox(height: 40),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
                onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
                child: const Text('Done', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 6. HISTORY SCREEN
class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Transaction History')),
      body: ListView(
        children: const [
          ListTile(
            leading: CircleAvatar(backgroundColor: Colors.green, child: Icon(Icons.arrow_downward, color: Colors.white)),
            title: Text('Paid to Chai Tapri'),
            subtitle: Text('11 Oct 2026, 04:30 PM'),
            trailing: Text('-₹50', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
          ),
          ListTile(
            leading: CircleAvatar(backgroundColor: Colors.green, child: Icon(Icons.arrow_downward, color: Colors.white)),
            title: Text('Paid to Super Market'),
            subtitle: Text('10 Oct 2026, 01:15 PM'),
            trailing: Text('-₹420', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Profile')),
      body: const Center(child: Text('Google Pay Prank User Profile', style: TextStyle(color: Colors.grey))),
    );
  }
}
