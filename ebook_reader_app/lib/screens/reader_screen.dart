import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/book_settings.dart';
import '../services/book_service.dart';
import '../widgets/book_page_painter.dart';

class ReaderScreen extends StatefulWidget {
  const ReaderScreen({super.key});

  @override
  State<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends State<ReaderScreen> {
  List<String> _pages = [];
  bool _isLoading = true;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _loadBook();
  }

  Future<void> _loadBook() async {
    final settings = Provider.of<BookSettings>(context, listen: false);
    final bookText = await BookService.loadBook('assets/sample_book.txt');
    
    setState(() {
      _pages = BookService.splitTextToPages(
        bookText,
        fontSize: settings.fontSize,
        pageWidth: MediaQuery.of(context).size.width - 40,
        pageHeight: MediaQuery.of(context).size.height - 200,
      );
      _pageController = PageController(initialPage: settings.currentPage);
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BookSettings>(
      builder: (context, settings, child) {
        if (_isLoading) {
          return Center(child: CircularProgressIndicator(color: settings.textColor));
        }

        return Container(
          color: settings.backgroundColor,
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _pages.length,
                  onPageChanged: (index) => settings.setCurrentPage(index),
                  itemBuilder: (context, index) {
                    return CustomPaint(
                      painter: BookPagePainter(
                        text: _pages[index],
                        fontSize: settings.fontSize,
                        textColor: settings.textColor,
                        backgroundColor: settings.backgroundColor,
                      ),
                      child: Container(),
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                color: settings.backgroundColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Trang ${settings.currentPage + 1} / ${_pages.length}',
                      style: TextStyle(color: settings.textColor, fontSize: 14),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back, color: settings.textColor),
                          onPressed: settings.currentPage > 0
                              ? () => _pageController.previousPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  )
                              : null,
                        ),
                        IconButton(
                          icon: Icon(Icons.arrow_forward, color: settings.textColor),
                          onPressed: settings.currentPage < _pages.length - 1
                              ? () => _pageController.nextPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  )
                              : null,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
