class User {
  final String name;
  final String surname;
  final String email;
  final String password;
  final String c_password;
  final int cicle_id;

  User({
    required this.name,
    required this.surname,
    required this.email,
    required this.password,
    required this.c_password,
    required this.cicle_id,
  });
}

final allUsers = [
  User(
    name: 'David',
    surname: 'Mateo',
    email: 'dmateomerino@gmail.com',
    password: '12345678',
    c_password: '12345678',
    cicle_id: 1,
  ),
];
