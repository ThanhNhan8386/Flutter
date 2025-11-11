import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/book_settings.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BookSettings>(
      builder: (context, settings, child) {
        return Container(
          color: settings.backgroundColor,
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
              Text('Cài đặt hiển thị',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: settings.textColor)),
              const SizedBox(height: 24),
              Text('Kích thước chữ',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: settings.textColor)),
              Row(
                children: [
                  Text('A', style: TextStyle(fontSize: 14, color: settings.textColor)),
                  Expanded(
                    child: Slider(
                      value: settings.fontSize,
                      min: 12,
                      max: 32,
                      divisions: 20,
                      label: settings.fontSize.round().toString(),
                      activeColor: settings.textColor,
                      inactiveColor: settings.textColor.withOpacity(0.3),
                      onChanged: (value) => settings.setFontSize(value),
                    ),
                  ),
                  Text('A', style: TextStyle(fontSize: 24, color: settings.textColor)),
                ],
              ),
              const SizedBox(height: 24),
              Text('Màu nền',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: settings.textColor)),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildColorOption(context, 'Trắng', 'white', Colors.white, Colors.black, settings),
                  _buildColorOption(context, 'Đen', 'black', Colors.black, Colors.white, settings),
                  _buildColorOption(context, 'Sepia', 'sepia', const Color(0xFFF4ECD8), const Color(0xFF5C4A3C), settings),
                ],
              ),
              const SizedBox(height: 24),
              Text('Xem trước',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: settings.textColor)),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: settings.backgroundColor,
                  border: Border.all(color: settings.textColor.withOpacity(0.3), width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Đây là văn bản mẫu để xem trước cài đặt của bạn. Bạn có thể điều chỉnh kích thước chữ và màu nền theo ý thích.',
                  style: TextStyle(fontSize: settings.fontSize, color: settings.textColor, height: 1.5),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildColorOption(BuildContext context, String label, String mode, Color bgColor, Color textColor, BookSettings settings) {
    final isSelected = settings.backgroundMode == mode;
    return GestureDetector(
      onTap: () => settings.setBackgroundMode(mode),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: bgColor,
              border: Border.all(color: isSelected ? Colors.blue : Colors.grey, width: isSelected ? 3 : 1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(child: Text('Aa', style: TextStyle(fontSize: 24, color: textColor, fontWeight: FontWeight.bold))),
          ),
          const SizedBox(height: 8),
          Text(label, style: TextStyle(color: settings.textColor, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }
}
