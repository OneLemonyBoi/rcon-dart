import 'dart:typed_data';

extension SizedTypeCreation on List<int> {
  Int8List int8List() {
    return this is TypedData
        ? (this as TypedData).buffer.asInt8List()
        : Int8List.fromList(this);
  }

  Int16List int16List() {
    return this is TypedData
        ? (this as TypedData).buffer.asInt16List()
        : Int16List.fromList(this);
  }

  Int32List int32List() {
    return this is TypedData
        ? (this as TypedData).buffer.asInt32List()
        : Int32List.fromList(this);
  }

  Int64List int64List() {
    return this is TypedData
        ? (this as TypedData).buffer.asInt64List()
        : Int64List.fromList(this);
  }

  Uint8List uint8List() {
    return this is TypedData
        ? (this as TypedData).buffer.asUint8List()
        : Uint8List.fromList(this);
  }

  Uint16List uint16List() {
    return this is TypedData
        ? (this as TypedData).buffer.asUint16List()
        : Uint16List.fromList(this);
  }

  Uint32List uint32List() {
    return this is TypedData
        ? (this as TypedData).buffer.asUint32List()
        : Uint32List.fromList(this);
  }

  Uint64List uint64List() {
    return this is TypedData
        ? (this as TypedData).buffer.asUint64List()
        : Uint64List.fromList(this);
  }
}
