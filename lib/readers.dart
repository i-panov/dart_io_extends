import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:io_extends/exceptions.dart';

abstract class Reader {
  int _offset = -1;

  /// Текущее смещение от начала
  int get offset => _offset;

  int _length = -1;

  /// Общее количество байт
  int get length => throw UnimplementedError();

  /// Осталось байт до конца
  int get left => max(length - offset, 0);

  /// Достигнут ли конец
  bool get eof => offset < length;

  Uint8List readBytes(int count) {
    _requireGreaterThenZero(count);
    return Uint8List.fromList(List.generate(count, (_) => readUint8()));
  }

  int readUint8();
  int readInt8() => ByteData.view(readBytes(1).buffer).getInt8(0);
  int readUint16([Endian endian = Endian.big]) => ByteData.view(readBytes(2).buffer).getUint16(0, endian);
  int readInt16([Endian endian = Endian.big]) => ByteData.view(readBytes(2).buffer).getInt16(0, endian);
  int readUint32([Endian endian = Endian.big]) => ByteData.view(readBytes(4).buffer).getUint32(0, endian);
  int readInt32([Endian endian = Endian.big]) => ByteData.view(readBytes(4).buffer).getInt32(0, endian);
  int readUint64([Endian endian = Endian.big]) => ByteData.view(readBytes(8).buffer).getUint64(0, endian);
  int readInt64([Endian endian = Endian.big]) => ByteData.view(readBytes(8).buffer).getInt64(0, endian);
  double readFloat32([Endian endian = Endian.big]) => ByteData.view(readBytes(4).buffer).getFloat32(0, endian);
  double readFloat64([Endian endian = Endian.big]) => ByteData.view(readBytes(8).buffer).getFloat64(0, endian);

  String readString(int length, [Encoding? encoding]) {
    if (encoding != null) {
      if (encoding is! Utf8Codec) {
        // TODO: I don't know how to get encoding size in bytes
        throw UnimplementedError();
      }

      return encoding.decode(readBytes(length));
    }

    // default UTF-16
    return String.fromCharCodes(readBytes(length * 2));
  }

  DateTime readDateTime([Endian endian = Endian.big]) => DateTime.fromMillisecondsSinceEpoch(readUint32(endian));

  void _requireNotEof() {
    if (eof) {
      throw StreamEndReachedException();
    }
  }

  void _requireGreaterThenZero(int value) {
    if (value <= 0) {
      throw ArgumentError.value(value);
    }
  }
}
class MemoryReader extends Reader {
  final Uint8List _input;

  MemoryReader(this._input) {
    _length = _input.length;
  }

  @override
  int get length => _length;

  @override
  int readUint8() {
    _requireNotEof();
    return _input[++_offset];
  }
}

class FileReader extends Reader {
  final RandomAccessFile _input;

  FileReader(this._input) {
    _length = _input.lengthSync();
  }

  @override
  int get offset => _input.positionSync();

  @override
  int get length => _length;

  @override
  Uint8List readBytes(int count) {
    _requireGreaterThenZero(count);
    return _input.readSync(count);
  }

  @override
  int readUint8() {
    _requireNotEof();
    return _input.readByteSync();
  }
}
