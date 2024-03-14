import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_app/pages/HomePage.dart';
import 'package:food_app/pages/LoadingDialog.dart';
// import 'package:food_app/pages/Splash.dart';
import 'package:food_app/pages/Url.dart';
import 'package:food_app/pages/phone.dart';

import 'package:image_picker/image_picker.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Details.dart';

import 'package:http/http.dart' as http;

import 'ImageView.dart';

// ignore: must_be_immutable
class profilePage extends StatefulWidget {
  Details details;
  profilePage(this.details);

  @override
  State<profilePage> createState() => _profilePageState(details);
}

class _profilePageState extends State<profilePage> {
  Details details;
  _profilePageState(this.details);

  GlobalKey<FormState> namekey = GlobalKey();
  //GlobalKey<FormState> phonekey = GlobalKey();
  GlobalKey<FormState> emailkey = GlobalKey();
  TextEditingController _name = TextEditingController();
  //TextEditingController _phone = TextEditingController();
  TextEditingController _email = TextEditingController();

  String i = '';
  File? pickedImage;
  Future pickImage(ImageSource imageType) async {
    try {
      final photo =
          await ImagePicker().pickImage(source: imageType, imageQuality: 50);
      if (photo != null) {
        final tempImage = File(photo.path);
        setState(() {
          pickedImage = tempImage;
        });
      }
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  Future createprofile(File photo, String phoneno) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const LoadingDialog();
      },
    );

    try {
      var request = http.MultipartRequest(
          "POST", Uri.parse(MyUrl.fullurl + "image_update.php"));
      request.files.add(await http.MultipartFile.fromBytes(
          'image', photo.readAsBytesSync(),
          filename: photo.path.split("/").last));
      request.fields['phoneno'] = phoneno;

      var response = await request.send();

      var responded = await http.Response.fromStream(response);
      var jsondata = jsonDecode(responded.body);
      if (jsondata['status'] == 'true') {
        var sp = await SharedPreferences.getInstance();
        sp.setString("image", jsondata['imgtitle']);
        details.image = jsondata['imgtitle'];
        setState(() {
          i = jsondata['imgtitle'];
        });
        Navigator.pop(context);
        Fluttertoast.showToast(
          gravity: ToastGravity.CENTER,
          msg: jsondata['msg'],
        );
      } else {
        Navigator.pop(context);
        Fluttertoast.showToast(
          gravity: ToastGravity.CENTER,
          msg: jsondata['msg'],
        );
      }
    } catch (e) {
      Navigator.pop(context);
      Fluttertoast.showToast(
        gravity: ToastGravity.CENTER,
        msg: e.toString(),
      );
    }
  }

  @override
  void initState() {
    x().whenComplete(() {
      setState(() {});
    });
    super.initState();
  }

  Future x() async {
    var sp = await SharedPreferences.getInstance();
    i = sp.getString("image") ?? '';
  }

  Future<void> updatename(String username) async {
    Map data = {'id': details.id, 'username': username};
    var sp = await SharedPreferences.getInstance();
    if (namekey.currentState!.validate()) {
      showDialog(
          context: context,
          builder: (context) {
            return const LoadingDialog();
          });
      try {
        var res = await http.post(
            Uri.http(MyUrl.mainurl, MyUrl.suburl + "name_update.php"),
            body: data);

        var jsondata = jsonDecode(res.body);
        if (jsondata['status'] == true) {
          Navigator.of(context).pop();
          Navigator.pop(context);
          setState(() {
            sp.setString("username", jsondata["username"]);
            details.username = jsondata["username"];
          });

          Fluttertoast.showToast(
            msg: jsondata['msg'],
          );
        } else {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
          Fluttertoast.showToast(
            msg: jsondata['msg'],
          );
        }
      } catch (e) {
        Navigator.of(context).pop();
        Fluttertoast.showToast(msg: e.toString());
      }
    }
  }

  Future<void> updateemail(String email) async {
    Map data = {'id': details.id, 'email': email};
    var sp = await SharedPreferences.getInstance();
    if (emailkey.currentState!.validate()) {
      showDialog(
          context: context,
          builder: (context) {
            return const LoadingDialog();
          });
      try {
        var res = await http.post(
            Uri.http(MyUrl.mainurl, MyUrl.suburl + "email_update.php"),
            body: data);

        var jsondata = jsonDecode(res.body);
        if (jsondata['status'] == true) {
          Navigator.of(context).pop();
          Navigator.pop(context);
          setState(() {
            sp.setString("email", jsondata["email"]);
            details.email = jsondata["email"];
          });

          Fluttertoast.showToast(
            msg: jsondata['msg'],
          );
        } else {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
          Fluttertoast.showToast(
            msg: jsondata['msg'],
          );
        }
      } catch (e) {
        Navigator.of(context).pop();
        Fluttertoast.showToast(msg: e.toString());
      }
    }
  }

  void imagePickerOption() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text(
          "Choose Profile Photo From",
          style: TextStyle(fontSize: 23, fontWeight: FontWeight.normal),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton.icon(
                icon: const Icon(
                  Icons.camera_alt_rounded,
                  color: Colors.black,
                ),
                label: const Text(
                  'Camera',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.normal),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  pickImage(ImageSource.camera).whenComplete(
                    () {
                      if (pickedImage != null) {
                        createprofile(pickedImage!, details.phoneno);
                      }
                    },
                  );
                },
              ),
              TextButton.icon(
                icon: const Icon(
                  Icons.photo,
                  color: Colors.black,
                ),
                label: const Text(
                  ' Gallery',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.normal),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  pickImage(ImageSource.gallery).whenComplete(
                    () {
                      if (pickedImage != null) {
                        createprofile(pickedImage!, details.phoneno);
                      }
                    },
                  );
                },
              ),
              TextButton.icon(
                icon: const Icon(
                  Icons.close,
                  color: Colors.black,
                ),
                label: const Text(
                  ' Cancel',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.normal),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 103, 97, 97),
        centerTitle: true,
        elevation: 0,
        title: const Text(
          'Profile View',
          style: TextStyle(
              color: Colors.orangeAccent,
              fontSize: 30,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      Container(
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ViewProfile(details)));
                          },
                          child: CircleAvatar(
                            radius: 70,
                            backgroundColor: Colors.grey,
                            child: pickedImage != null
                                ? ClipOval(
                                    child: Image.file(
                                      pickedImage!,
                                      height: 135,
                                      width: 135,
                                      fit: BoxFit.cover,
                                      
                                    ),
                                  )
                                : ClipOval(
                                    child: CachedNetworkImage(
                                      imageUrl: MyUrl.fullurl +
                                          MyUrl.imageurl +
                                          details.image,
                                      placeholder: (context, url) =>
                                          const CircularProgressIndicator(),
                                      imageBuilder: (context, imageProvider) {
                                        return Padding(
                                          padding: const EdgeInsets.all(4),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.white,
                                                image: DecorationImage(
                                                    image: imageProvider,)),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 1,
                        right: 13,
                        child: IconButton(
                          onPressed: () {
                            imagePickerOption();
                          },
                          icon: const Icon(
                            Icons.add_a_photo,
                            size: 35,
                            color: Color.fromARGB(255, 33, 142, 243),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Hello ${details.username}",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    // child: Center(
                    //     child: Text(
                    //   details.username,
                    //   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    // )),
                    child: ListTile(
                      title: Text(
                        "Username",
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        details.username,
                        style: TextStyle(fontSize: 15),
                      ),
                      leading: Icon(Icons.person),
                      trailing: IconButton(
                          onPressed: () {
                            _name.text = details.username;
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) {
                                return Container(
                                  child: AlertDialog(
                                    content: Form(
                                      key: namekey,
                                      child: TextFormField(
                                        controller: _name,
                                        keyboardType: TextInputType.name,
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        decoration: InputDecoration(
                                          labelText: "Name",
                                          hintText: "Enter your name",
                                          prefixIcon:
                                              Icon(CupertinoIcons.person),
                                        ),
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "Name Required";
                                          } else {
                                            return null;
                                          }
                                        },
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(
                                          "cancel",
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15),
                                        ),
                                      ),
                                      TextButton(
                                          onPressed: () {
                                            if (namekey.currentState!
                                                .validate()) {
                                              updatename(_name.text);
                                            } else {
                                              Fluttertoast.showToast(
                                                  msg:
                                                      "Please Enter Your Name");
                                            }
                                          },
                                          child: Text(
                                            "Save",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15),
                                          ))
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          icon: Icon(Icons.edit)),
                    ),

                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color.fromARGB(255, 220, 138, 191),
                            Colors.yellow
                          ],
                        ),
                        borderRadius: BorderRadius.circular(30)),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    // child: Center(
                    //     child: Text(
                    //   details.username,
                    //   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    // )),
                    child: ListTile(
                      title: Text(
                        "Email",
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        details.email,
                        style: TextStyle(fontSize: 15),
                      ),
                      leading: Icon(Icons.email),
                      trailing: IconButton(
                          onPressed: () {
                            _email.text = details.email;
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) {
                                return Container(
                                  child: AlertDialog(
                                    content: Form(
                                      key: emailkey,
                                      child: TextFormField(
                                        controller: _email,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        decoration: InputDecoration(
                                          labelText: "Email",
                                          hintText: "Enter your Email",
                                          prefixIcon: Icon(CupertinoIcons.mail),
                                        ),
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "Email Required";
                                          } else {
                                            return null;
                                          }
                                        },
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(
                                          "cancel",
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15),
                                        ),
                                      ),
                                      TextButton(
                                          onPressed: () {
                                            if (emailkey.currentState!
                                                .validate()) {
                                              updateemail(_email.text);
                                            } else {
                                              Fluttertoast.showToast(
                                                  msg:
                                                      "Please Enter Your Email");
                                            }
                                          },
                                          child: Text(
                                            "Save",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15),
                                          ))
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          icon: Icon(Icons.edit)),
                    ),

                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color.fromARGB(255, 220, 138, 191),
                            Colors.yellow
                          ],
                        ),
                        borderRadius: BorderRadius.circular(30)),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    // child: Center(
                    //     child: Text(
                    //   details.username,
                    //   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    // )),
                    child: ListTile(
                      title: Text(
                        "Phone Number",
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        details.phoneno,
                        style: TextStyle(fontSize: 15),
                      ),
                      leading: Icon(Icons.phone),
                    ),

                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color.fromARGB(255, 220, 138, 191),
                            Colors.yellow
                          ],
                        ),
                        borderRadius: BorderRadius.circular(30)),
                  ),
                   SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: SizedBox(
                      height: 60,
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                      onPressed: () {
                        QuickAlert.show(
                          context: context,
                          type: QuickAlertType.confirm,
                          text: 'Do you want to logout',
                          confirmBtnText: 'Yes',
                          cancelBtnText: 'No',
                          onConfirmBtnTap: () async {
                            var sp =
                                await SharedPreferences.getInstance();
                            sp.clear();
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MyPhone()),
                                (Route<dynamic> route) => false);
                          },
                          onCancelBtnTap: () {
                            Navigator.pop(context);
                          },
                        );
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Text(
                          'Log Out',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateColor.resolveWith(
                            (states) => Colors.orangeAccent),
                        shape: MaterialStatePropertyAll(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ),
                  
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
