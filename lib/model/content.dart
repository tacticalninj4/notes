class NoteContent {
  final String type;
  String? text;
  bool? checked;

  NoteContent({required this.type, required this.text, required this.checked});

  factory NoteContent.fromJson(Map<String, dynamic> json) {
    return NoteContent(
      type: json['type'],
      text: json['text'],
      checked: json['checked'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'text': text,
      'checked': checked,
    };
  }
}
