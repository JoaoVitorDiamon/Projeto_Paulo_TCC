class Guests {
  String? userID, name, contact, sexy, id;
  int age;

  Guests({
    this.userID,
    required this.name,
    required this.contact,
    required this.sexy,
    required this.age,
    this.id,
  });

  factory Guests.fromJson(Map<String, dynamic> json) {
    return Guests(
      userID: json['userID'] ?? '',
      name: json['name'] ?? '',
      contact: json['contact'] ?? '',
      sexy: json['sexy'] ?? '',
      age: json['age'] ?? 0,
      id: json['id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userID': userID,
      'name': name,
      'contact': contact,
      'sexy': sexy,
      'age': age,
      'id': id,
    };
  }
}
