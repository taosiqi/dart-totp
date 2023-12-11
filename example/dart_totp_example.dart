import 'package:dart_totp/dart_totp.dart';

void main() {
  String totp = TOTP.generateTOTP('KVARB3JSYG6RNYY7HJX2N6ZTUSOXU5RK');
  print('awesome: $totp'); //277911
}
