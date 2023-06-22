import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../../../res/global/media_query.dart';
import '../data/models/user_model.dart';
import '../res/constants/app_colors.dart';
import '../utils/utils.dart';

class ProfileScreen extends StatefulWidget {
  final File? image;
  const ProfileScreen({Key? key, this.image}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore firebaseFireStore = FirebaseFirestore.instance;
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  final storageRef = FirebaseStorage.instance.ref();

  UserModel userModel = UserModel();
  Utils utils = Utils();

  final ImagePicker picker = ImagePicker();
  XFile? image;
  File? imageFile;

  getUser() {
    CollectionReference users = firebaseFireStore.collection("user");
    users.doc(firebaseAuth.currentUser!.uid).get().then((value) {
      debugPrint("User Added successfully  --------> ${jsonEncode(value.data())}");
      userModel = userModelFromJson(jsonEncode(value.data()));
    }).catchError((error) {
      debugPrint("Failed to get user  : $error");
    });
    setState(() {});
  }

  pickImage() async {
    image = await picker.pickImage(source: ImageSource.gallery);
    imageFile = File(image!.path);
    storeImage();
    setState(() {});
  }

  storeImage() async {
    try {
      UploadTask uploadTask = firebaseStorage.ref().child("image").child("profile_1.jpg").putFile(imageFile!);

      uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) {
        switch (taskSnapshot.state) {
          case TaskState.running:
            final progress = 100.0 * (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
            debugPrint("upload is $progress% complete.");
            break;
          case TaskState.paused:
            debugPrint("upload  is paused");
            break;
          case TaskState.success:
            debugPrint("upload was success");
            break;
          case TaskState.canceled:
            debugPrint("upload was canceled");
            break;
          case TaskState.error:
            debugPrint("upload was error");
            break;
        }
      });
    } on FirebaseException catch (e) {
      utils.showSnackBar(context, message: e.message);
    }
  }

  downloadImage() async {
    final islandRef = storageRef.child("images/island.jpg");
    final gsReference = FirebaseStorage.instance.refFromURL("gs://YOUR_BUCKET/images/stars.jpg");

    final httpsReference = FirebaseStorage.instance.refFromURL("gs: //remotely-application.appspot.com/image/profile_1.jpg");

    final appDocDir = await getApplicationDocumentsDirectory();
    final filePath = "${appDocDir.absolute}/images/island.jpg";
    final file = File(filePath);

    final downloadTask = islandRef.writeToFile(file);
    downloadTask.snapshotEvents.listen((taskSnapshot) {
      switch (taskSnapshot.state) {
        case TaskState.running:
          debugPrint("Download in progress -->");
          break;
        case TaskState.paused:
          debugPrint("Download Paused -->");
          break;
        case TaskState.success:
          debugPrint("Downloaded Successfully -->");
          break;
        case TaskState.canceled:
          debugPrint("Download Canceled -->");
          break;
        case TaskState.error:
          debugPrint("Download Error -->");
          break;
      }
    });
  }

  @override
  void initState() {
    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.homeBg,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: 180,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: AppColors.dividerColor,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.elliptical(300, 100),
                  bottomLeft: Radius.elliptical(300, 100),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: height(context) / 20,
                ),
                const Text(
                  "jigar",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.white),
                ),
                SizedBox(
                  height: height(context) / 10,
                ),
                Stack(
                  children: [
                    Image.asset(
                      "assets/images/Group 184.png",
                      height: width(context) / 3.5,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(7),
                        decoration: const BoxDecoration(
                          color: AppColors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Color(0x40000000),
                              offset: Offset(0, 2),
                              blurRadius: 4,
                            )
                          ],
                        ),
                        child: const Icon(
                          Icons.camera_alt_outlined,
                          color: AppColors.dividerColor,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: height(context) / 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Aasma Shrestha",
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                    ),
                    SizedBox(
                      width: width(context) / 80,
                    ),
                    const Icon(
                      Icons.verified,
                      color: AppColors.dividerColor,
                    )
                  ],
                ),
                const Text(
                  "aasma@gmail.com",
                  style: TextStyle(color: AppColors.textColor),
                ),
                SizedBox(height: height(context) / 40),
                SizedBox(
                  height: height(context) / 18,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Text(
                            "20",
                          ),
                          Text(
                            "Donation",
                          ),
                        ],
                      ),
                      VerticalDivider(
                        color: AppColors.dividerGray,
                        thickness: 1,
                      ),
                      Column(
                        children: [
                          Text(
                            "B+",
                          ),
                          Text(
                            "Blood Group",
                          ),
                        ],
                      ),
                      VerticalDivider(
                        color: AppColors.dividerGray,
                        thickness: 1,
                      ),
                      Column(
                        children: [
                          Text(
                            "5",
                          ),
                          Text(
                            "Campaigns",
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 7,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          ListTile(
                            onTap: () {},
                            leading: const Icon(Icons.ac_unit),
                            title: const Text("settings"),
                            titleTextStyle: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: index == 6 ? AppColors.red : AppColors.textColor,
                            ),
                          ),
                          index == 6
                              ? const SizedBox()
                              : const Divider(
                                  height: 1,
                                  thickness: 1,
                                  endIndent: 10,
                                  indent: 10,
                                ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
