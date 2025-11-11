import 'package:flutter/services.dart';

class BookService {
  static Future<String> loadBook(String assetPath) async {
    try {
      return await rootBundle.loadString(assetPath);
    } catch (e) {
      return 'Không thể tải sách. Vui lòng thử lại.';
    }
  }

  static List<String> splitTextToPages(String text, {
    required double fontSize,
    required double pageWidth,
    required double pageHeight,
  }) {
    final pages = <String>[];
    final charsPerLine = (pageWidth / (fontSize * 0.6)).floor();
    final linesPerPage = (pageHeight / (fontSize * 1.5)).floor();
    
    var currentLines = <String>[];
    var lineCount = 0;

    for (var line in text.split('\n')) {
      final wrapped = line.isEmpty ? [''] : _wrapText(line, charsPerLine);
      for (var wrappedLine in wrapped) {
        if (lineCount >= linesPerPage) {
          pages.add(currentLines.join('\n'));
          currentLines = [];
          lineCount = 0;
        }
        currentLines.add(wrappedLine);
        lineCount++;
      }
    }

    if (currentLines.isNotEmpty) pages.add(currentLines.join('\n'));
    return pages;
  }

  static List<String> _wrapText(String text, int maxChars) {
    if (text.length <= maxChars) return [text];

    final lines = <String>[];
    var remaining = text;

    while (remaining.length > maxChars) {
      var breakPoint = maxChars;
      final lastSpace = remaining.substring(0, maxChars).lastIndexOf(' ');
      if (lastSpace > maxChars * 0.7) breakPoint = lastSpace;

      lines.add(remaining.substring(0, breakPoint).trim());
      remaining = remaining.substring(breakPoint).trim();
    }

    if (remaining.isNotEmpty) lines.add(remaining);
    return lines;
  }
}
