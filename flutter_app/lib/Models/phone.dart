
class Phone {
  int _id;
  String _phone;
  String _acc;

  Phone(this._phone, this._acc);

  Phone.withId(this._id, this._phone, this._acc);

  int get id => _id;

  String get phone => _phone;

  String get acc => _acc;

  set phone(String newPhone) {
    this._phone = newPhone;
  }

  set acc(String newAcc) {
    this._acc = newAcc;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    if (id != null) {
      map['id'] = _id;
    }

    map['phone'] = _phone;
    map['acc'] = _acc;

    return map;
  }

  Phone.fromMapObject(Map<String, dynamic> map){
    this._id = map['id'];
    this._phone = map['phone'];
    this._acc = map['acc'];
  }
}