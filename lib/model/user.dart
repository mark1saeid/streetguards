class User {
  String userId;
  String name;
  String email;
//  String phoneNo;
  bool gender;
  bool isExpert;
  bool isTransportationExpert;
  String date;

  String birthDate;
  String profession;
  bool carOwnership;
  int drivingExperience;

  User(
      {this.userId,
      this.name,
      this.email,
      //  this.phoneNo,
      this.birthDate,
      this.profession,
      this.carOwnership,
      this.gender,
      this.isExpert,
      this.drivingExperience,
      this.date,
      this.isTransportationExpert});

  Map<String, dynamic> toMap() {
    return {
      'userId': this.userId,
      'name': this.name,
      'email': this.email,
      'birthDate': this.birthDate,
      'profession': this.profession,
      'isExpert': this.isExpert,
      'isTransportationExpert': this.isTransportationExpert,
      'carOwnership': this.carOwnership,
      'gender': this.gender == true ? "male" : "female",
      'drivingExperience': this.drivingExperience,
      'date': this.date,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      userId: map['userId'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      birthDate: map['birthDate'] as String,
      profession: map['profession'] as String,
      carOwnership: map['carOwnership'] as bool,
      isExpert: map['isExpert'] as bool,
      isTransportationExpert: map['isTransportationExpert'] as bool,
      gender: map['gender'] == "male" ? true : false,
      drivingExperience: map['drivingExperience'] as int,
      date: map['date'] as String,
    );
  }
}
