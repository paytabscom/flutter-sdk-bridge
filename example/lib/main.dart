import 'package:flutter/material.dart';
import 'models/payment_form_model.dart';
import 'widgets/credentials_section.dart';
import 'widgets/payment_config_section.dart';
import 'widgets/billing_section.dart';
import 'widgets/shipping_section.dart';
import 'widgets/card_approval_section.dart';
import 'widgets/payment_methods_section.dart';

void main() {
  runApp(MyApp());
}

/// Main widget for the app
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Form key for validation
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();
  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  // Payment form model
  final PaymentFormModel _model = PaymentFormModel();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: _scaffoldMessengerKey,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('PayTabs Plugin Example'),
          elevation: 0,
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            controller: _scrollController,
            padding: EdgeInsets.all(16),
            children: [
              CredentialsSection(
                model: _model,
                onChanged: (model) => setState(() {}),
              ),
              PaymentConfigSection(
                model: _model,
                onChanged: (model) => setState(() {}),
                onDateSelected: (date) {
                  setState(() {
                    _model.receiptDate = date;
                  });
                },
              ),
              BillingSection(
                model: _model,
                onChanged: (model) => setState(() {}),
              ),
              ShippingSection(
                model: _model,
                onChanged: (model) => setState(() {}),
              ),
              CardApprovalSection(
                model: _model,
                onChanged: (model) => setState(() {}),
              ),
              PaymentMethodsSection(
                model: _model,
                onChanged: (model) => setState(() {}),
                formKey: _formKey,
                onTransactionEvent: _processTransactionEvent,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Processes transaction event responses.
  void _processTransactionEvent(dynamic event) {
    setState(() {
      if (event["status"] == "success") {
        final transactionDetails = event["data"];
        _logTransaction(transactionDetails);
        if (transactionDetails["isSuccess"]) {
          if (transactionDetails["isPending"]) {
            _showSnackBar("Transaction pending", Colors.orange);
          } else {
            _showSnackBar("Transaction successful!", Colors.green);
          }
        } else {
          // Transaction was processed but failed
          final reason = transactionDetails["payResponseReturn"] ?? 
                        transactionDetails["responseMessage"] ?? 
                        transactionDetails["message"] ?? 
                        "Unknown error";
          final responseCode = transactionDetails["responseCode"] ?? "";
          final errorMessage = responseCode.isNotEmpty 
              ? "Transaction failed (Code: $responseCode): $reason"
              : "Transaction failed: $reason";
          _showSnackBar(errorMessage, Colors.red);
        }
      } else if (event["status"] == "error") {
        final errorMessage = event["message"] ?? "An error occurred";
        debugPrint("Error occurred in transaction: $errorMessage");
        debugPrint("Full error event: $event");
        _showSnackBar("Error: $errorMessage", Colors.red);
      } else if (event["status"] == "event") {
        final eventMessage = event["message"] ?? "Event occurred";
        debugPrint("Event occurred: $eventMessage");
        _showSnackBar("Event: $eventMessage", Colors.orange);
      }
    });
  }

  /// Shows a snackbar message
  void _showSnackBar(String message, Color color) {
    _scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: Duration(seconds: 4),
        action: SnackBarAction(
          label: 'Dismiss',
          textColor: Colors.white,
          onPressed: () {
            _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  /// Logs transaction details.
  void _logTransaction(dynamic transactionDetails) {
    debugPrint("=== Transaction Details ===");
    debugPrint("Full transaction data: $transactionDetails");
    
    if (transactionDetails["isSuccess"]) {
      debugPrint("✓ Transaction successful");
      if (transactionDetails["isPending"]) {
        debugPrint("⚠ Transaction is pending");
      }
      debugPrint("Transaction Reference: ${transactionDetails["transactionReference"] ?? "N/A"}");
      debugPrint("Response Code: ${transactionDetails["responseCode"] ?? "N/A"}");
    } else {
      debugPrint("✗ Transaction failed");
      debugPrint("Response Code: ${transactionDetails["responseCode"] ?? "N/A"}");
      debugPrint("Response Message: ${transactionDetails["responseMessage"] ?? "N/A"}");
      debugPrint("Pay Response Return: ${transactionDetails["payResponseReturn"] ?? "N/A"}");
      debugPrint("Message: ${transactionDetails["message"] ?? "N/A"}");
      debugPrint("Transaction Reference: ${transactionDetails["transactionReference"] ?? "N/A"}");
    }
    debugPrint("===========================");
  }
}
