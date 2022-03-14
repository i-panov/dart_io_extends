import 'dart:typed_data';

extension IntExtensions on int {
  Uint8List get uint8Bytes => Uint8List(1)..buffer.asUint8List()[0] = this;
  Uint8List get int8Bytes => Uint8List(1)..buffer.asInt8List()[0] = this;
  Uint8List get uint16Bytes => Uint8List(2)..buffer.asUint16List()[0] = this;
  Uint8List get int16Bytes => Uint8List(2)..buffer.asInt16List()[0] = this;
  Uint8List get uint32Bytes => Uint8List(4)..buffer.asUint32List()[0] = this;
  Uint8List get int32Bytes => Uint8List(4)..buffer.asInt32List()[0] = this;
  Uint8List get uint64Bytes => Uint8List(8)..buffer.asUint64List()[0] = this;
  Uint8List get int64Bytes => Uint8List(8)..buffer.asInt64List()[0] = this;
}

extension DoubleExtensions on double {
  Uint8List get float32Bytes => Uint8List(4)..buffer.asFloat32List()[0] = this;
  Uint8List get float64Bytes => Uint8List(8)..buffer.asFloat64List()[0] = this;
}

extension DateTimeExtensions on DateTime {
  Uint8List get bytes => millisecondsSinceEpoch.uint32Bytes;
}
