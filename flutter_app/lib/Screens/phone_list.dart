

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqlite_api.dart';

import '../Models/phone.dart';
import '../Utils/database_helper.dart';
import 'phone_list_detail.dart';

class PhoneList extends StatefulWidget{
  @override
  State <StatefulWidget> createState(){
    return PhoneListState();
  }
}

class PhoneListState extends State<PhoneList>{
  DatabaseHelper databaseHelper=DatabaseHelper();
  List<Phone> phoneList;
  int count=0;

  @override
  Widget build(BuildContext context) {
    if(phoneList==null){
      phoneList=List<Phone>();
      updateListView();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Phones'),
      ),
      body: getPhoneListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          debugPrint('FAB clicked');
          navigateToDetail(Phone('', ''), 'Add Phone');
        },
        tooltip: 'Add Phone',
        child: Icon(Icons.add),
      ),
    );
  }

  ListView getPhoneListView(){
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position){
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
                backgroundColor: Colors.amber,
                child: Text(getFirstLetter(this.phoneList[position].phone),
                    style: TextStyle(fontWeight: FontWeight.bold))
            ),
            title: Text(this.phoneList[position].phone,
                style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(this.phoneList[position].acc),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                GestureDetector(
                  child: Icon(Icons.delete,color: Colors.red,),
                  onTap: () {
                    _delete(context, phoneList[position]);
                  },
                ),
              ],
            ),
            onTap: (){
              debugPrint('PhoneList Tapped');
              navigateToDetail(this.phoneList[position], 'Edit Phone');
            },
          ),
        );
      },
    );
  }
  getFirstLetter(String title){
    return title.substring(0,2);
  }

  void _delete(BuildContext context, Phone phone) async{
    int result=await databaseHelper.deletePhone(phone.id);
    if(result!=0){
      _showSnackBar(context, 'Phone deleted succesfully');
      updateListView();
    }
  }

  void _showSnackBar(BuildContext context, String message){
    final snackBar=SnackBar(content: Text(message));

    Scaffold.of(context).showSnackBar(snackBar);
  }

  void navigateToDetail(Phone phone, String ph) async{
    bool result=await Navigator.push(context, MaterialPageRoute(builder: (context){
      return PhoneDetail(phone, ph);
    }));

    if(result==true){
      updateListView();
    }
  }

  void updateListView(){
    final Future<Database> dbFuture=databaseHelper.initializeDatabase();

    dbFuture.then((database){
      Future<List<Phone>> bookListFuture = databaseHelper.getPhoneList();
      bookListFuture.then((phoneList) {
        setState(() {
          this.phoneList = phoneList;
          this.count = phoneList.length;
        });
      });
    });
  }
}