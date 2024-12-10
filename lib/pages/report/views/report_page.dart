
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:url_launcher/url_launcher.dart';

class ReportPage extends StatefulWidget {

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  var _formKey = GlobalKey<FormBuilderState>();
  bool isLoading = false;

  void reportIncident() async {

    try {

    if (!_formKey.currentState!.saveAndValidate()) {
      return;
    } 

    final formData = _formKey.currentState!.value;

    setState(() {
      isLoading = true;
    });

    await FirebaseFirestore.instance
        .collection('incidents')
        .add({
          'title': formData['title'],
          'department': formData['department'],
          'name': formData['name'],
          'email': formData['email'],
          'phone': formData['phone'],
          'date_of_incident': formData['date'], 
          'time_of_incident': formData['time'], 
          'incident_description': formData['description'], 
          'timestamp': FieldValue.serverTimestamp(),
        });


     showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Text('Incident Submitted Successfully!'),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        )
      );

    setState(() {
      _formKey.currentState!.reset();
      isLoading = false;
    });

   } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Text(e.toString()),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        )
      );

      setState(() {
        isLoading = false;
      });
    }
    
  }

  void _launchPhoneNumber(String phoneNumber) async {
    final url = Uri.parse('tel:$phoneNumber');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: FormBuilder(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.report, color: Colors.red, size: 70,),
                          SizedBox(width: 10),
                          Text('Report an Incident', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),)
                        ],
                      ),
                      const Divider(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('For immediate emergency services call: ', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                            SizedBox(height: 10),
                            InkWell(
                              onTap: () {
                                _launchPhoneNumber('4044133333');
                              },
                              child: Text('404-413-3333', style: TextStyle(fontSize: 25),)),
                            Text('tap to call'),
                            Divider(),
                            SizedBox(height: 10),
                            Text('Report Incident', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),),
                            const SizedBox(height: 20),
                            FormBuilderTextField(
                              name: 'title',
                              validator: FormBuilderValidators.required(),
                              decoration: const InputDecoration(
                                labelText: 'Title',
                                border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black))
                              ),
                            ),
                            const SizedBox(height: 15),
                            FormBuilderTextField(
                              name: 'department',
                              decoration: const InputDecoration(
                                labelText: 'Department',
                                border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black))
                              ),
                            ),
                            const SizedBox(height: 15),
                            FormBuilderTextField(
                              name: 'name',
                              validator: FormBuilderValidators.required(),
                              decoration: const InputDecoration(
                                labelText: 'Name of person reporting incident',
                                border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black))
                              ),
                            ),
                            const SizedBox(height: 15),
                            FormBuilderTextField(
                              name: 'email',
                              validator: FormBuilderValidators.required(),
                              decoration: const InputDecoration(
                                labelText: 'Email',
                                border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black))
                              ),
                            ),
                            const SizedBox(height: 15),
                            FormBuilderTextField(
                              name: 'phone',
                              validator: FormBuilderValidators.required(),
                              decoration: const InputDecoration(
                                labelText: 'Phone',
                                border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black))
                              ),
                            ),
                            const SizedBox(height: 15),
                            FormBuilderTextField(
                              name: 'date',
                              validator: FormBuilderValidators.required(),
                              decoration: const InputDecoration(
                                labelText: 'Date of Incident',
                                border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black))
                              ),
                            ),
                            const SizedBox(height: 15),
                            FormBuilderTextField(
                              name: 'time',
                              validator: FormBuilderValidators.required(),
                              decoration: const InputDecoration(
                                labelText: 'Time of Incident',
                                border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black))
                              ),
                            ),
                            const SizedBox(height: 15),
                            SizedBox(
                              height: 120,
                              child: FormBuilderTextField(
                                maxLines: 20,
                                name: 'description',
                                validator: FormBuilderValidators.required(),
                                decoration: const InputDecoration(
                                  labelText: 'Incident Description',
                                  border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black))
                                ),
                              ),
                            ),
                            const SizedBox(height: 25),
                            InkWell(
                              onTap: reportIncident,
                              child: Container(
                                  height: 45,
                                  decoration: const BoxDecoration(
                                    color: Color.fromARGB(255, 0, 58, 166),
                                  ),
                                  child: Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: isLoading ? Container(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white)) : Text('SUBMIT INCIDENT', style: TextStyle(letterSpacing: 2, color: Colors.white),)
                                    ),
                                  ),
                                ),
                            ),
                            const SizedBox(height: 80),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}