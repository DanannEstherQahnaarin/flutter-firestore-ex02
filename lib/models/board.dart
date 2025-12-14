class Board {
  final String? id;
  final String title;
  final String content;
  final String writerUid;
  final String writerNm;
  final int readCount;
  final bool isNotice;
  final DateTime timestamp;

  Board({
    this.id,
    required this.title,
    required this.content,
    required this.writerUid,
    required this.writerNm,
    this.readCount = 0,
    this.isNotice = false,
    required this.timestamp,
  });

  factory Board.fromFirestore(Map<String, dynamic> map, String id) {
    final timestamp = map['timestamp'] != null
        ? map['timestamp'].toDate()
        : DateTime.now();

    return Board(
      id: id,
      title: (map['title'] ?? '') as String,
      content: (map['content'] ?? '') as String,
      writerUid: (map['writerUid'] ?? '') as String,
      writerNm: (map['writerNm'] ?? '') as String,
      readCount: (map['readCount'] ?? 0) as int,
      isNotice: (map['isNotice'] ?? false) as bool,
      timestamp: timestamp,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'content': content,
      'writerUid': writerUid,
      'writerNm': writerNm,
      'readCount': readCount,
      'isNotice': isNotice,
      'timestamp': timestamp,
    };
  }
}
