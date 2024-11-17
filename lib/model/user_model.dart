class UserModel {
  final String uid;
  final String email;
  final String name;
  final String gender;
  final String age;
  final String weight;
  final String height;
  final String image;

  const UserModel({
      required this.uid,
      required this.email,
      required this.name,
      required this.gender,
      required this.age,
      required this.height,
      required this.weight,
      required this.image,
  });

  // receiving data from server
  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      name: map['name'],
      gender: map['gender'],
      age: map['age'],
      height: map['height'],
      weight: map['weight'],
      image: map['image'],
    );
  }

  // sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'gender': gender,
      'age': age,
      'height': height,
      'weight': weight,
      'image': image,
    };
  }
}
