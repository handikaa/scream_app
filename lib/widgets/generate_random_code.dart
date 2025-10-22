import 'dart:math';

String generateUniqCode() {
  const letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  const numbers = '0123456789';
  final random = Random();

  // Ambil 3 huruf acak
  String randomLetters =
      List.generate(3, (_) => letters[random.nextInt(letters.length)]).join();

  // Ambil 3 angka acak
  String randomNumbers =
      List.generate(3, (_) => numbers[random.nextInt(numbers.length)]).join();

  return '$randomLetters$randomNumbers';
}
