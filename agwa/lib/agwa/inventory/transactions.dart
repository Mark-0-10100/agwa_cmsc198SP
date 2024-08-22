import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:date_field/date_field.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:agwa/agwa/inventory/ponddata.dart';
import 'package:agwa/agwa/inventory/pondtile.dart';
import 'package:agwa/agwa/inventory/pondsList.dart';
import 'package:flutter/src/rendering/box.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:date_field/date_field.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:agwa/agwa/inventory/ponddata.dart';
import 'package:agwa/agwa/inventory/final_pond_dependencies/moodel_pondsData.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({super.key});

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  //For transaction page -------------------------------------------------------
  final _modalKey = GlobalKey<FormState>();
  final transactionDescription_controller = TextEditingController();
  late var transaction_DateController = TextEditingController();
  DateTime transaction_DateControllerValue_temp = DateTime.now();
  late var transaction_DateControllerValue = DateTime.now();
  final transactionAmount_controller = TextEditingController();
  //For transaction page -------------------------------------------------------

  final CollectionReference _ponds =
      FirebaseFirestore.instance.collection("transactions");

  Future<void> _create([DocumentSnapshot? documentSnapshot]) async {
    await showModalBottomSheet(
        context: context,
        builder: ((context) {
          return Form(
            key: _modalKey,
            child: ListView(
              padding: const EdgeInsets.all(20.0),
              children: [
                TextFormField(
                  controller: transactionDescription_controller,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Transaction Description',
                  ),
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a valid string';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                DateTimeFormField(
                  initialValue: DateTime.now(),
                  decoration: const InputDecoration(
                    hintStyle: TextStyle(color: Colors.black45),
                    errorStyle: TextStyle(color: Colors.redAccent),
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.event_note),
                    labelText: 'Transaction Date',
                  ),
                  mode: DateTimeFieldPickerMode.date,
                  autovalidateMode: AutovalidateMode.always,
                  onDateSelected: (DateTime value) {
                    transaction_DateControllerValue_temp = value;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: transactionAmount_controller,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Transaction Amount',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a valid integer';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                AnimatedButton(
                  text: "Add Entry",
                  pressEvent: () {
                    if (_modalKey.currentState?.validate() ?? false) {
                      final transactionsData = TransactionsData(
                        transaction_desc:
                            transactionDescription_controller.text,
                        transaction_date: transaction_DateControllerValue_temp,
                        transaction_amount:
                            int.parse(transactionAmount_controller.text),
                      );
                      createTransactionsData(transactionsData);
                      transaction_DateControllerValue_temp = DateTime.now();
                      transactionDescription_controller.text = ' ';
                      transactionAmount_controller.text = ' ';
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.success,
                        animType: AnimType.bottomSlide,
                        showCloseIcon: false,
                        dismissOnTouchOutside: true,
                        autoDismiss: true,
                        btnOkOnPress: () {
                          Navigator.pop(context);
                        },
                        title: "Success",
                        desc: "Transaction Data Successfully added!",
                      ).show();
                    }
                  },
                ),
              ],
            ),
          );
        }));
  }

  Future<void> _update([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      transactionDescription_controller.text =
          documentSnapshot['Transaction Description'];
      transactionAmount_controller.text =
          documentSnapshot['Transaction Amount'].toString();

      Timestamp timestamp = documentSnapshot['Transaction Date'];
      DateTime species_birth_dateValue = timestamp.toDate();
      transaction_DateController.text = species_birth_dateValue.toString();
    }

    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: transactionDescription_controller,
                  decoration: const InputDecoration(
                      labelText: 'Transaction Description'),
                ),
                const SizedBox(
                  height: 20,
                ),
                DateTimeFormField(
                  initialValue: DateTime.parse(transaction_DateController.text),
                  decoration: const InputDecoration(
                    hintStyle: TextStyle(color: Colors.black45),
                    errorStyle: TextStyle(color: Colors.redAccent),
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.event_note),
                    labelText: 'Transaction Date',
                  ),
                  mode: DateTimeFieldPickerMode.date,
                  autovalidateMode: AutovalidateMode.always,
                  onDateSelected: (DateTime value) {
                    transaction_DateControllerValue_temp = value;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  controller: transactionAmount_controller,
                  decoration: const InputDecoration(
                    labelText: 'Transaction Amount',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                AnimatedButton(
                    text: "Update",
                    pressEvent: () async {
                      final String transactionDescription_temp =
                          transactionDescription_controller.text;
                      final double? transactionAmount_controller_temp =
                          double.tryParse(transactionAmount_controller.text);

                      if (transactionAmount_controller_temp != null) {
                        await _ponds.doc(documentSnapshot!.id).update({
                          "Transaction Description":
                              transactionDescription_temp,
                          "Transaction Amount":
                              transactionAmount_controller_temp,
                        });
                        transactionDescription_controller.text = '';
                        transactionAmount_controller.text = '';
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.success,
                          animType: AnimType.bottomSlide,
                          showCloseIcon: false,
                          dismissOnTouchOutside: true,
                          autoDismiss: true,
                          btnOkOnPress: () {
                            Navigator.pop(context);
                          },
                          title: "Success",
                          desc: "Pond Data Successfully updated!",
                        ).show();
                      }
                    }),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          );
        });
  }

  Future<void> _delete(String transactionData_id) async {
    await _ponds.doc(transactionData_id).delete();

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('You have successfully deleted a Pond Data')));
  }

  @override
  Widget build(BuildContext context) {
    final CollectionReference _ponds =
        FirebaseFirestore.instance.collection("transactions");

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Color.fromARGB(255, 37, 162, 187),
              size: 40.0,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          titleSpacing: -10,
          title: Text(
            'Transactions',
            style: GoogleFonts.poppins(
                textStyle: Theme.of(context).textTheme.headline4,
                fontSize: 48,
                fontWeight: FontWeight.w700,
                color: Colors.black),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Center(
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 0, 163, 150),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  onPressed: () => _create(),
                  child: const Text('Add'),
                ),
                SizedBox(width: 10),
              ],
            ),
            Container(
              margin: const EdgeInsets.all(10.0),
              height: 600,
              child: StreamBuilder(
                stream: _ponds.snapshots(),
                builder: (context, AsyncSnapshot snapshots) {
                  if (snapshots.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(color: Colors.green),
                    );
                  }
                  if (snapshots.hasData) {
                    return ListView.builder(
                      itemCount: snapshots.data!.docs.length,
                      itemBuilder: (context, index) {
                        final DocumentSnapshot records =
                            snapshots.data!.docs[index];
                        return Slidable(
                          startActionPane:
                              ActionPane(motion: StretchMotion(), children: [
                            SlidableAction(
                              onPressed: (context) => _update(records),
                              icon: Icons.edit,
                              foregroundColor: Color.fromARGB(255, 0, 163, 150),
                              backgroundColor: Color.fromARGB(0, 36, 126, 199),
                            ),
                            SlidableAction(
                              onPressed: (context) => _delete(records.id),
                              icon: Icons.delete,
                              foregroundColor: Color.fromARGB(255, 0, 163, 150),
                              backgroundColor: Color.fromARGB(0, 36, 126, 199),
                            ),
                          ]),
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0)),
                            color: Color.fromARGB(138, 49, 255, 248),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(10.0),
                              title: Text(
                                records["Transaction Description"],
                                style: GoogleFonts.poppins(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black),
                              ),
                              subtitle: Text("Transaction Date: " +
                                  records["Transaction Date"]
                                      .toDate()
                                      .toString() +
                                  "\nTransaction Amount: " +
                                  records["Transaction Amount"].toString()),
                            ),
                          ),
                        );
                      },
                    );
                  }
                  return Center(
                    child: CircularProgressIndicator(color: Colors.red),
                  );
                },
              ),
            ),
          ]),
        ));
  }

  Future createTransactionsData(TransactionsData pondData) async {
    //Reference to document
    final docUser = FirebaseFirestore.instance.collection('transactions').doc();

    // final user = User(
    //     id: docUser.id, name: name, age: 21, birthday: DateTime(2001, 7, 28));

    pondData.id = docUser.id;
    final json = pondData.toJson();

    await docUser.set(json);
  }
}

class TransactionsData {
  String id;
  final String transaction_desc;
  final DateTime transaction_date;
  final int transaction_amount;

  TransactionsData(
      {this.id = '',
      required this.transaction_desc,
      required this.transaction_date,
      required this.transaction_amount});

  Map<String, dynamic> toJson() => {
        'id': id,
        'Transaction Description': transaction_desc,
        'Transaction Date': transaction_date,
        'Transaction Amount': transaction_amount
      };

  static TransactionsData fromJson(Map<String, dynamic> json) =>
      TransactionsData(
          id: json['id'],
          transaction_desc: json['transaction_desc'],
          transaction_date: (json['transaction_date'] as Timestamp).toDate(),
          transaction_amount: json['transaction_amount']);
}
