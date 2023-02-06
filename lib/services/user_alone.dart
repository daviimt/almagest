// ignore_for_file: camel_case_types
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';

class userAlone extends StatefulWidget {
  const userAlone({Key? key}) : super(key: key);
  final storage = const FlutterSecureStorage();

  readCompany_id() async {
    return await storage.read(key: 'company_id') ?? '';
  }

  @override
  State<userAlone> createState() => _oneUserState();
}

class _oneUserState extends State<userAlone> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
