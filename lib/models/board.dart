class Board {
  final String id;
  final int boardNum;
  final String title;
  final String content;
  final String writer;
  final int readCount;
  final bool isNotice;
  final DateTime timestamp;

  Board({
    required this.id,
    required this.boardNum,
    required this.title,
    required this.content,
    required this.writer,
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
      boardNum: (map['boardNum'] ?? 0) as int,
      title: (map['title'] ?? '') as String,
      content: (map['content'] ?? '') as String,
      writer: (map['writer'] ?? '') as String,
      readCount: (map['readCount'] ?? 0) as int,
      isNotice: (map['isNotice'] ?? false) as bool,
      timestamp: timestamp,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'boardNum':boardNum,
      'content': content,
      'writer': writer,
      'readCount': readCount,
      'isNotice': isNotice,
      'timestamp': timestamp,
    };
  }
}