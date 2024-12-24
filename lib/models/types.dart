class Types {
  final String type;
  Types({
    required this.type
  });
  factory Types.fromJson(Map<String, dynamic> json) {
    return Types(
      type: json['title']
    );
  }
   Map<String, dynamic> toJson() => {
        'type': type
      };
}