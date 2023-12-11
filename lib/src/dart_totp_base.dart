import 'dart:math';
import 'dart:typed_data';

import 'package:base32/base32.dart';
import 'package:crypto/crypto.dart';

class TOTP {
  static String generateTOTP(String secretKey,
      {int period = 30,
        int digits = 6,
        String algorithm = 'SHA1',
        int? timestamp}) {
    timestamp ??= DateTime.now().millisecondsSinceEpoch;
    final counter = (timestamp ~/ 1000) ~/ period;
    final counterBytes = _intToBytes(counter);

    final keyBytes = _base32Decode(secretKey);
    final hmac = Hmac(_getShaAlgorithm(algorithm), keyBytes);
    final hash = hmac.convert(counterBytes).bytes;

    final offset = hash[hash.length - 1] & 0xf;
    final binary = ((hash[offset] & 0x7f) << 24) |
    ((hash[offset + 1] & 0xff) << 16) |
    ((hash[offset + 2] & 0xff) << 8) |
    (hash[offset + 3] & 0xff);

    final otp = binary % pow(10, digits).toInt();
    return otp.toString().padLeft(digits, '0');
  }

  static Uint8List _intToBytes(int long) {
    final byteData = ByteData(8);
    byteData.setInt64(0, long, Endian.big);
    return byteData.buffer.asUint8List();
  }

  static Uint8List _base32Decode(String base32str) {
    return Uint8List.fromList(base32.decode(base32str));
  }

  static Hash _getShaAlgorithm(String algorithm) {
    switch (algorithm.toUpperCase()) {
      case 'SHA1':
        return sha1;
      case 'SHA256':
        return sha256;
      case 'SHA512':
        return sha512;
      default:
        throw ArgumentError('Invalid algorithm: $algorithm');
    }
  }
}
