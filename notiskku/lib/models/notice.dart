class Notice {
  final String id;
  final String category;
  final String title;
  final String date;
  final String uploader;
  final String views;
  final String link;

  Notice({
    required this.id,
    required this.category,
    required this.title,
    required this.date,
    required this.uploader,
    required this.views,
    required this.link,
  });

  factory Notice.fromSheet(List<String> row) {
    return Notice(
      id: row.isNotEmpty ? row[0] : "",
      category: row.length > 1 ? row[1] : "",
      title: row.length > 2 ? row[2] : "",
      date: row.length > 3 ? row[3] : "",
      uploader: row.length > 4 ? row[4] : "",
      views: row.length > 5 ? row[5] : "",
      link: row.length > 6 ? row[6] : "",
    );
  }
}
