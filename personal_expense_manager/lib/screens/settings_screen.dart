import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/transaction_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Cài đặt',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Column(
            children: [
              Consumer<ThemeProvider>(
                builder: (context, themeProvider, child) {
                  return SwitchListTile(
                    title: const Text('Chế độ tối'),
                    subtitle: const Text('Bật/tắt giao diện tối'),
                    value: themeProvider.isDarkMode,
                    onChanged: (value) {
                      themeProvider.toggleTheme();
                    },
                    secondary: Icon(
                      themeProvider.isDarkMode
                          ? Icons.dark_mode
                          : Icons.light_mode,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.info),
                title: const Text('Thông tin ứng dụng'),
                subtitle: const Text('Phiên bản 1.0.0'),
                onTap: () {
                  showAboutDialog(
                    context: context,
                    applicationName: 'Quản lý Chi tiêu',
                    applicationVersion: '1.0.0',
                    applicationIcon: const Icon(Icons.account_balance_wallet),
                    children: [
                      const Text(
                        'Ứng dụng quản lý chi tiêu cá nhân giúp bạn theo dõi thu chi hàng ngày.',
                      ),
                    ],
                  );
                },
              ),
              Consumer<TransactionProvider>(
                builder: (context, provider, child) {
                  return ListTile(
                    leading: const Icon(Icons.delete_forever, color: Colors.red),
                    title: const Text('Xóa tất cả dữ liệu'),
                    subtitle: const Text('Xóa toàn bộ giao dịch'),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Xác nhận xóa'),
                          content: const Text(
                            'Bạn có chắc muốn xóa tất cả dữ liệu? Hành động này không thể hoàn tác.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx),
                              child: const Text('Hủy'),
                            ),
                            TextButton(
                              onPressed: () async {
                                for (var transaction in provider.transactions) {
                                  await provider.deleteTransaction(transaction);
                                }
                                if (ctx.mounted) {
                                  Navigator.pop(ctx);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Đã xóa tất cả dữ liệu'),
                                    ),
                                  );
                                }
                              },
                              child: const Text(
                                'Xóa',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
