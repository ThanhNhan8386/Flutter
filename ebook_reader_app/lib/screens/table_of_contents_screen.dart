import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/book_settings.dart';

class TableOfContentsScreen extends StatelessWidget {
  const TableOfContentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BookSettings>(
      builder: (context, settings, child) {
        final chapters = [
          {'title': 'CHƯƠNG 1: KHỞI ĐẦU', 'page': 0},
          {'title': 'CHƯƠNG 2: CUỘC HÀNH TRÌNH', 'page': 1},
          {'title': 'CHƯƠNG 3: THÁCH THỨC', 'page': 2},
          {'title': 'CHƯƠNG 4: KHO BÁU', 'page': 3},
          {'title': 'CHƯƠNG 5: TRỞ VỀ', 'page': 4},
        ];

        return Container(
          color: settings.backgroundColor,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: chapters.length,
            itemBuilder: (context, index) {
              final chapter = chapters[index];
              final isCurrentChapter = settings.currentPage == chapter['page'];
              
              return Card(
                color: settings.backgroundColor,
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(
                    color: isCurrentChapter ? Colors.blue : settings.textColor.withOpacity(0.2),
                    width: isCurrentChapter ? 2 : 1,
                  ),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: isCurrentChapter ? Colors.blue : settings.textColor.withOpacity(0.2),
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        color: isCurrentChapter ? Colors.white : settings.textColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(
                    chapter['title'] as String,
                    style: TextStyle(
                      color: settings.textColor,
                      fontWeight: isCurrentChapter ? FontWeight.bold : FontWeight.normal,
                      fontSize: 16,
                    ),
                  ),
                  trailing: Icon(Icons.arrow_forward_ios, color: settings.textColor.withOpacity(0.5), size: 16),
                  onTap: () {
                    settings.setCurrentPage(chapter['page'] as int);
                    DefaultTabController.of(context).animateTo(0);
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }
}
