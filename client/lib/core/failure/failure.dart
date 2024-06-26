import 'dart:convert';

class AppFailure {
  final String message;

  AppFailure({
    required this.message,
  });

  AppFailure copyWith({
    String? message,
  }) {
    return AppFailure(
      message: message ?? this.message,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'message': message,
    };
  }

  factory AppFailure.fromMap(Map<String, dynamic> map) {
    return AppFailure(
      message: map['message'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory AppFailure.fromJson(String source) => AppFailure.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'AppFailure(message: $message)';

  @override
  bool operator ==(covariant AppFailure other) {
    if (identical(this, other)) return true;

    return other.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}
