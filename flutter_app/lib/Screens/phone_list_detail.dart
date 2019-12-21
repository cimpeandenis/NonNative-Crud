
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Models/phone.dart';
import '../Utils/database_helper.dart';

class PhoneDetail extends StatefulWidget {

  final String appBarTitle;
  final Phone phone;

  PhoneDetail(this.phone, this.appBarTitle);

  @override
  State<StatefulWidget> createState() {

    return PhoneDetailState(this.phone, this.appBarTitle);
  }
}

class PhoneDetailState extends State<PhoneDetail> {

  DatabaseHelper helper = DatabaseHelper();

  String appBarTitle;
  Phone phone;

  TextEditingController phoneController = TextEditingController();
  TextEditingController accController = TextEditingController();

  PhoneDetailState(this.phone, this.appBarTitle);

  @override
  Widget build(BuildContext context) {

    TextStyle textStyle = Theme.of(context).textTheme.title;

    phoneController.text = phone.phone;
    accController.text = phone.acc;

    return WillPopScope(

        onWillPop: () {
          moveToLastScreen();
        },

        child: Scaffold(
          appBar: AppBar(
            title: Text(appBarTitle),
            leading: IconButton(icon: Icon(
                Icons.arrow_back),
                onPressed: () {
                  moveToLastScreen();
                }
            ),
          ),

          body: Padding(
            padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
            child: ListView(
              children: <Widget>[

                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextField(
                    controller: phoneController,
                    style: textStyle,
                    onChanged: (value) {
                      debugPrint('Something changed in Phone Text Field');
                      updatePhone();
                    },
                    decoration: InputDecoration(
                        labelText: 'Phone',
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0)
                        )
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextField(
                    controller: accController,
                    style: textStyle,
                    onChanged: (value) {
                      debugPrint('Something changed in Accessory Text Field');
                      updateAcc();
                    },
                    decoration: InputDecoration(
                        labelText: 'Accessory',
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0)
                        )
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: RaisedButton(
                          color: Theme.of(context).primaryColorDark,
                          textColor: Theme.of(context).primaryColorLight,
                          child: Text(
                            'Save',
                            textScaleFactor: 1.5,
                          ),
                          onPressed: () {
                            setState(() {
                              debugPrint("Save button clicked");
                              _save();
                            });
                          },
                        ),
                      ),

                      Container(width: 5.0,),

                      Expanded(
                        child: RaisedButton(
                          color: Theme.of(context).primaryColorDark,
                          textColor: Theme.of(context).primaryColorLight,
                          child: Text(
                            'Delete',
                            textScaleFactor: 1.5,
                          ),
                          onPressed: () {
                            setState(() {
                              debugPrint("Delete button clicked");
                              _delete();
                            });
                          },
                        ),
                      ),

                    ],
                  ),
                ),


              ],
            ),
          ),

        ));
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  // Update the title of book object
  void updatePhone(){
    phone.phone = phoneController.text;
  }

  // Update the author of book object
  void updateAcc() {
    phone.acc = accController.text;
  }

  // Save data to database
  void _save() async {

    moveToLastScreen();

    int result;
    if (phone.id != null) {  // Case 1: Update operation
      result = await helper.updatePhone(phone);
    } else { // Case 2: Insert Operation
      result = await helper.insertPhone(phone);
    }

    if (result != 0) {  // Success
      _showAlertDialog('Status', 'Phone Saved Successfully');
    } else {  // Failure
      _showAlertDialog('Status', 'Problem Saving Phone');
    }

    debugPrint("add");

  }


  void _delete() async {

    moveToLastScreen();

    if (phone.id == null) {
      _showAlertDialog('Status', 'No Phone was deleted');
      return;
    }

    int result = await helper.deletePhone(phone.id);
    if (result != 0) {
      _showAlertDialog('Status', 'Phone Deleted Successfully');
    } else {
      _showAlertDialog('Status', 'Error Occured while Deleting Phone');
    }
  }

  void _showAlertDialog(String title, String message) {

    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(
        context: context,
        builder: (_) => alertDialog
    );
  }

}