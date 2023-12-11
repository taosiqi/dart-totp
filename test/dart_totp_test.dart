import 'package:dart_totp/dart_totp.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
    late String totp;
    setUp(() {
      totp = TOTP.generateTOTP('KVARB3JSYG6RNYY7HJX2N6ZTUSOXU5RK');
    });

    test('First Test', () {
      expect(totp, '359816');
    });
  });
}
