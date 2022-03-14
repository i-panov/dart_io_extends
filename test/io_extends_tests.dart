import 'dart:io';
import 'package:io_extends/io_extends.dart';
import 'package:test/test.dart';

void Function() _processFile(FileMode mode, void Function(RandomAccessFile file) action) => () {
  final file = File('test/outputs/data.bin').openSync(mode: mode);

  try {
    action(file);
  } finally {
    file.closeSync();
  }
};

void main() {
  print((FileWriter).toString());

  test((FileWriter).toString(), _processFile(FileMode.writeOnly, (file) {
    final writer = FileWriter(file);
  }));

  test((FileReader).toString(), _processFile(FileMode.read, (file) {
    final writer = FileReader(file);
  }));
}
