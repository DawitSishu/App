import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:health_app/Pages/paymentPage.dart';
import 'package:health_app/util/components.dart';
import 'package:health_app/util/my_flutter_app_icons.dart';
import 'package:health_app/Services/general-controller.dart';

class OrganizationInfo2 extends StatefulWidget {
  const OrganizationInfo2({super.key});

  @override
  State<OrganizationInfo2> createState() => _OrganizationInfo2State();
}

class _OrganizationInfo2State extends State<OrganizationInfo2> {
  String fileName = '';
  PlatformFile? file;
  UploadTask? task;

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          leadingWidth: 30,
          title: const Text(
            'Legal Documents',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        body: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.fromLTRB(15, 50, 15, 15),
          children: [
            const Text(
              'Attach All Necessary Legal Documents',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
              textAlign: TextAlign.start,
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: Text(
                'Upload Organizational Health License given by government authority, Business license certificate, Commercial register certificate and Tin certificate.',
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 11,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            InkWell(
              // borderRadius: BorderRadius.circular(5),
              onTap: () async {
                final result = await FilePicker.platform.pickFiles(
                  type: FileType.custom,
                  allowedExtensions: ['pdf', 'zip'],
                );
                if (result != null) {
                  file = result.files.first;
                  int maxSizeInBytes = 5 * 1024 * 1024;
                  if (file!.size! <= maxSizeInBytes) {
                    setState(() {
                      fileName = file!.name;
                    });
                  } else {
                    showSnackbar(context,
                        text: "File size exceeds the limit of 5 MB");
                    setState(() {
                      fileName = '';
                    });
                  }
                } else {
                  setState(() {
                    fileName = '';
                  });
                  return;
                }
              },
              child: Container(
                // color: Colors.grey,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: Colors.grey.shade300,
                  ),
                  color: Colors.grey.shade100,
                ),
                height: 190,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Image.asset('assets/images/ImportPdf.png'),

                    IconButton(
                      onPressed: () {},
                      icon: const Icon(MyFlutterApp.file_pdf),
                      color: const Color.fromARGB(255, 36, 107, 253),
                      iconSize: 50,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        fileName.isEmpty ? 'Browse File' : fileName,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            // i skipped the space in future add midereg nger kale we'll add it here
          ],
        ),
        bottomNavigationBar: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 40, bottom: 20),
              child: CustomButton(
                onPressed: () async {
                  try {
                    final path = 'files/organization/${file!.name}';
                    final doc = File(file!.path!);
                    final ref = FirebaseStorage.instance.ref().child(path);

                    setState(() {
                      task = ref.putFile(doc);
                    });

                    final snapshot = await task!.whenComplete(() {});

                    final urlDownload = await snapshot.ref.getDownloadURL();

                    final response = await UploadOrgDocs({
                      "documentName": "${file!.name}",
                      "documentPath": urlDownload
                    });

                    final creationStatus =
                        await updateProfileStatus("completed");

                    if (response != null && creationStatus != null) {
                      successSnackbar(context,
                          text: response['message'] ??
                              "Your Document has Been uploaded Successfully!!");
                    } else {
                      showSnackbar(context,
                          text: "ERROR Uploading: Please Try Again");
                      return;
                    }

                    setState(() {
                      task = null;
                    });

                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PaymentPage(type: 'organization'),
                      ),
                    );
                  } catch (e) {
                    // TODO
                    showSnackbar(context,
                        text: "ERROR Uploading: Please Try Again");
                    return;
                  }
                  // final result = await completeRegistration();
                  // if (result['success']) {
                  //   Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (context) => PaymentPage(type: 'organization'),
                  //     ),
                  //   );
                  // } else {
                  //   final error = result['error']
                  //       .toString()
                  //       .replaceAll(RegExp(r'\[.*\]'), '');
                  //   showSnackbar(context, text: error);
                  // }
                },
                label: 'Finish',
              ),
            ),
          ],
        ),
      );
}
