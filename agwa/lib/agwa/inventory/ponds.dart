// This version contains draft code for the polished design
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:date_field/date_field.dart' as dateField;
import 'package:date_field/src/field.dart';
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
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

class PondsPage extends StatefulWidget {
  const PondsPage({super.key});

  @override
  State<PondsPage> createState() => _PondsPageState();
}

class _PondsPageState extends State<PondsPage> {
  //Controllers for the fields
  final _modalKey = GlobalKey<FormState>();
  final pondID_controller = TextEditingController();
  final speciesName_controller = TextEditingController();
  final initialQuantity_controller = TextEditingController();
  late var species_birth_dateValue_controller = TextEditingController();
  DateTime species_birth_dateValue_temp = DateTime.now();
  late var species_birth_dateValue = DateTime.now();
  late var target_HarvestDateController = TextEditingController();
  DateTime target_HarvestDateValue_temp = DateTime.now();
  late var target_HarvestDatealue = DateTime.now();
  final targetWeight_controller = TextEditingController();
  final idealPHController_min = TextEditingController();
  final idealPHController_max = TextEditingController();

  //Reference from the the database
  final CollectionReference _ponds =
      FirebaseFirestore.instance.collection("pond-species_inventory");

  Future<void> _create([DocumentSnapshot? documentSnapshot]) async {
    await showModalBottomSheet(
        //isScrollControlled: true,
        context: context,
        builder: ((context) {
          return Form(
            key: _modalKey,
            child: ListView(
              padding: const EdgeInsets.all(20.0),
              children: [
                TextFormField(
                  controller: pondID_controller,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Pond Name',
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
                TextFormField(
                  controller: speciesName_controller,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Species Name',
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
                TextFormField(
                  controller: initialQuantity_controller,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Initial Quantity',
                  ),
                  keyboardType: TextInputType.number,
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
                    labelText: 'Species Birthdate',
                  ),
                  mode: DateTimeFieldPickerMode.date,
                  autovalidateMode: AutovalidateMode.always,
                  onDateSelected: (DateTime value) {
                    species_birth_dateValue_temp = value;
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
                    labelText: 'Target Harvest Date',
                  ),
                  mode: DateTimeFieldPickerMode.date,
                  autovalidateMode: AutovalidateMode.always,
                  onDateSelected: (DateTime value) {
                    target_HarvestDateValue_temp = value;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: targetWeight_controller,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Target Weight',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a valid string';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: idealPHController_min,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Minimum ideal pH Level',
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
                TextFormField(
                  controller: idealPHController_max,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Maximum ideal pH Level',
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
                      final pondData = PondData(
                          pondID: pondID_controller.text,
                          species_name: speciesName_controller.text,
                          birthdate: species_birth_dateValue_temp,
                          initial_quantity:
                              int.parse(initialQuantity_controller.text),
                          pH_level_range_MIN:
                              int.parse(idealPHController_min.text),
                          pH_level_range_MAX:
                              int.parse(idealPHController_max.text),
                          target_harvest_date: target_HarvestDateValue_temp,
                          target_weight: targetWeight_controller.text);
                      createPondData(pondData);

                      pondID_controller.text = ' ';
                      speciesName_controller.text = ' ';
                      initialQuantity_controller.text = ' ';
                      species_birth_dateValue = DateTime.now();
                      target_HarvestDatealue = DateTime.now();
                      targetWeight_controller.text = ' ';
                      idealPHController_min.text = ' ';
                      idealPHController_max.text = ' ';

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
                        desc: "Pond Data Successfully added!",
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
      pondID_controller.text = documentSnapshot['Pond ID'];
      speciesName_controller.text = documentSnapshot['Species Name'];
      initialQuantity_controller.text =
          documentSnapshot['Initial Quantity'].toString();
      Timestamp timestamp = documentSnapshot['Birthdate'];
      DateTime species_birth_dateValue = timestamp.toDate();
      species_birth_dateValue_controller.text =
          species_birth_dateValue.toString();

      targetWeight_controller.text =
          documentSnapshot['Target Weight'].toString();

      Timestamp timestamp_HarvestDate = documentSnapshot['Target Harvest Date'];
      DateTime target_HarvestDateValue = timestamp_HarvestDate.toDate();
      target_HarvestDateController.text = target_HarvestDateValue.toString();

      idealPHController_min.text =
          documentSnapshot['Minimum pH Level'].toString();

      idealPHController_max.text =
          documentSnapshot["Maximum pH Level"].toString();
    }

    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return SingleChildScrollView(
            child: Padding(
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
                    controller: pondID_controller,
                    decoration: const InputDecoration(labelText: 'Pond Name'),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: speciesName_controller,
                    decoration:
                        const InputDecoration(labelText: 'Species Name'),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    controller: initialQuantity_controller,
                    decoration: const InputDecoration(
                      labelText: 'Initial Quantity',
                    ),
                  ),
                  const SizedBox(height: 10),
                  DateTimeFormField(
                    initialValue:
                        DateTime.parse(species_birth_dateValue_controller.text),
                    decoration: const InputDecoration(
                      hintStyle: TextStyle(color: Colors.black45),
                      errorStyle: TextStyle(color: Colors.redAccent),
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.event_note),
                      labelText: 'Species Birthdate',
                    ),
                    mode: DateTimeFieldPickerMode.date,
                    autovalidateMode: AutovalidateMode.always,
                    onDateSelected: (DateTime value) {
                      species_birth_dateValue_temp = value;
                    },
                  ),
                  const SizedBox(height: 10),
                  DateTimeFormField(
                    initialValue:
                        DateTime.parse(target_HarvestDateController.text),
                    decoration: const InputDecoration(
                      hintStyle: TextStyle(color: Colors.black45),
                      errorStyle: TextStyle(color: Colors.redAccent),
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.event_note),
                      labelText: 'Target Harvest Date',
                    ),
                    mode: DateTimeFieldPickerMode.date,
                    autovalidateMode: AutovalidateMode.always,
                    onDateSelected: (DateTime value) {
                      target_HarvestDateValue_temp = value;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: targetWeight_controller,
                    decoration: const InputDecoration(
                      labelText: 'Target Weight',
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    controller: idealPHController_min,
                    decoration: const InputDecoration(
                      labelText: 'Minimum pH Level',
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    controller: idealPHController_max,
                    decoration: const InputDecoration(
                      labelText: 'Max pH Level',
                    ),
                  ),
                  AnimatedButton(
                    text: "Update",
                    pressEvent: () async {
                      final String pondID_controller_temp =
                          pondID_controller.text;
                      final String speciesName_temp =
                          speciesName_controller.text;
                      final int? initialQuantity_temp =
                          int.tryParse(initialQuantity_controller.text);
                      final String targetWeight_temp =
                          targetWeight_controller.text;
                      final String idealPHController_min_temp =
                          idealPHController_min.text;
                      final String idealPHController_max_temp =
                          idealPHController_max.text;

                      if (initialQuantity_temp != null) {
                        await _ponds.doc(documentSnapshot!.id).update({
                          "Species Name": speciesName_temp,
                          "Pond ID": pondID_controller_temp,
                          "Initial Quantity": initialQuantity_temp,
                          "Birthdate": species_birth_dateValue_temp,
                          "Target Harvest Date": target_HarvestDateValue_temp,
                          "Target Weight": targetWeight_temp,
                          "Minimum pH Level": idealPHController_min_temp,
                          "Maximum pH Level": idealPHController_max_temp,
                        });
                        pondID_controller.text = ' ';
                        speciesName_controller.text = '';
                        initialQuantity_controller.text = '';
                        species_birth_dateValue_controller.text = '';
                        targetWeight_controller.text = '';
                        idealPHController_min.text = '';
                        idealPHController_max.text = '';
                      }
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
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future<void> _delete(String pondData_id) async {
    await _ponds.doc(pondData_id).delete();

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('You have successfully deleted a Pond Data')));
  }

  @override
  Widget build(BuildContext context) {
    final CollectionReference _ponds =
        FirebaseFirestore.instance.collection("pond-species_inventory");

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
            'Ponds',
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
                                records["Pond ID"],
                                style: GoogleFonts.poppins(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black),
                              ),
                              subtitle: Text("Species Name: " +
                                  records["Species Name"] +
                                  "\nInitial Quantity: " +
                                  records["Initial Quantity"].toString() +
                                  "\nBirthdate: " +
                                  records["Birthdate"].toDate().toString() +
                                  "\nTarget Harvest Date: " +
                                  records["Target Harvest Date"]
                                      .toDate()
                                      .toString() +
                                  "\nTarget Weight: " +
                                  records["Target Weight"].toString() +
                                  "\nMinimum pH Level: " +
                                  records["Minimum pH Level"].toString() +
                                  "\nMaximum pH Level:  " +
                                  records["Maximum pH Level"].toString()),
                            ),
                          ),
                        );

                        // return Container(
                        //   color: Colors.red,
                        //   height: 40,
                        //   margin: EdgeInsets.symmetric(vertical: 10),
                        // );
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

  Future createPondData(PondData pondData) async {
    //Reference to document
    final docUser =
        FirebaseFirestore.instance.collection('pond-species_inventory').doc();

    // final user = User(
    //     id: docUser.id, name: name, age: 21, birthday: DateTime(2001, 7, 28));

    pondData.id = docUser.id;
    final json = pondData.toJson();

    await docUser.set(json);
  }
}

class PondData {
  String id;
  final String pondID;
  final DateTime birthdate;
  final int initial_quantity;
  final String species_name;
  final DateTime target_harvest_date;
  final String target_weight;
  final int pH_level_range_MIN;
  final int pH_level_range_MAX;

  PondData({
    this.id = '',
    required this.pondID,
    required this.birthdate,
    required this.initial_quantity,
    required this.species_name,
    required this.target_harvest_date,
    required this.target_weight,
    required this.pH_level_range_MIN,
    required this.pH_level_range_MAX,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'Pond ID': pondID,
        'Birthdate': birthdate,
        'Initial Quantity': initial_quantity,
        'Species Name': species_name,
        'Target Harvest Date': target_harvest_date,
        'Target Weight': target_weight,
        'Minimum pH Level': pH_level_range_MIN,
        'Maximum pH Level': pH_level_range_MAX,
      };

  static PondData fromJson(Map<String, dynamic> json) => PondData(
      birthdate: (json['birthdate'] as Timestamp).toDate(),
      pondID: json['pondID'],
      initial_quantity: json['initial_quantity'],
      species_name: json['species_name'],
      target_harvest_date: (json['target_harvest_date'] as Timestamp).toDate(),
      target_weight: json['target_weight'],
      id: json['id'],
      pH_level_range_MIN: json['pH_level_range_MIN'],
      pH_level_range_MAX: json['pH_level_range_MAX']);
}
