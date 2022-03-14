import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'extensions.dart';

abstract class Writer {
  void writeBytes(Uint8List data) => data.forEach(writeUint8);
  void writeUint8(int value);
  void writeInt8(int value) => writeBytes(value.int8Bytes);
  void writeUint16(int value) => writeBytes(value.uint16Bytes);
  void writeInt16(int value) => writeBytes(value.int16Bytes);
  void writeUint32(int value) => writeBytes(value.uint32Bytes);
  void writeInt32(int value) => writeBytes(value.int32Bytes);
  void writeUint64(int value) => writeBytes(value.uint64Bytes);
  void writeInt64(int value) => writeBytes(value.int64Bytes);
  void writeFloat32(double value) => writeBytes(value.float32Bytes);
  void writeFloat64(double value) => writeBytes(value.float64Bytes);

  void writeString(String value, [Encoding? encoding]) {
    if (encoding != null) {
      if (encoding is! Utf8Codec) {
        // TODO: I don't know how to get encoding size in bytes
        throw UnimplementedError();
      }

      writeBytes(Uint8List.fromList(encoding.encode(value)));
    } else {
      value.codeUnits.forEach(writeUint16);
    }
  }

  void writeDateTime(DateTime value) => writeUint32(value.millisecondsSinceEpoch);
}

class MemoryWriter extends Writer {
  final _output = <int>[];

  Uint8List get bytes => Uint8List.fromList(_output);

  @override
  void writeUint8(int value) {
    _output.add(value);
  }
}

class SinkWriter extends Writer implements Sink<int> {
  final Sink<int> _output;

  SinkWriter(this._output);

  @override
  void writeUint8(int value) {
    _output.add(value);
  }

  @override
  void add(int value) => _output.add(value);

  @override
  void close() => _output.close();
}

class FileWriter extends Writer {
  final RandomAccessFile _output;

  FileWriter(this._output);

  @override
  void writeBytes(Uint8List data) => _output.writeFromSync(data);

  @override
  void writeUint8(int value) => _output.writeByteSync(value);

  @override
  void writeString(String value, [Encoding? encoding]) => _output.writeStringSync(value, encoding: encoding ?? utf8);
}
