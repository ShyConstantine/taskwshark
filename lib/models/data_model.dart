class DataModel {
  final String id;
  final List<String> field;
  final Map<String, int> start;
  final Map<String, int> end;

  DataModel({
    required this.id,
    required this.field,
    required this.start,
    required this.end,
  });

  factory DataModel.fromJson(Map<String, dynamic> json) {
    return DataModel(
      id: json['id'],
      field: List<String>.from(json['field']),
      start: Map<String, int>.from(json['start']),
      end: Map<String, int>.from(json['end']),
    );
  }
}
