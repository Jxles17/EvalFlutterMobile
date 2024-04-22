class EvalDto{
  final String name;
  final String description;
  final String duration;

  EvalDto({
    required this.name,
    required this.description,
    required this.duration
  });

  factory EvalDto.fromJson(Map<String, dynamic> json) {
    return EvalDto(
      name: json['name'],
      description: json['description'],
      duration: json['duration'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'duration': duration,
    };
  }
}