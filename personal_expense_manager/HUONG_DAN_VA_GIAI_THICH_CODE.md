# BÁO CÁO ĐỒ ÁN MÔN HỌC
## ỨNG DỤNG QUẢN LÝ CHI TIÊU CÁ NHÂN

---

## PHẦN 1: GIỚI THIỆU

### 1.1. Đặt vấn đề
Trong cuộc sống hiện đại, việc quản lý tài chính cá nhân là rất quan trọng. Ứng dụng này được phát triển để giúp người dùng theo dõi thu chi hàng ngày một cách dễ dàng và trực quan.

### 1.2. Mục tiêu đồ án
- Xây dựng ứng dụng mobile quản lý chi tiêu
- Áp dụng kiến thức Flutter và Dart
- Sử dụng Provider để quản lý state
- Lưu trữ dữ liệu offline với Hive
- Hiển thị biểu đồ trực quan

### 1.3. Công nghệ sử dụng
- **Flutter 3.9.2**: Framework phát triển ứng dụng
- **Provider 6.1.5**: Quản lý trạng thái
- **Hive 2.2.3**: Database offline
- **fl_chart 0.68.0**: Vẽ biểu đồ
- **intl 0.19.0**: Định dạng tiền tệ

---

## PHẦN 2: PHÂN TÍCH VÀ THIẾT KẾ

### 2.1. Chức năng chính
1. **Quản lý giao dịch**: Thêm, xem, xóa giao dịch thu/chi
2. **Phân loại**: 8 danh mục (Ăn uống, Mua sắm, Đi lại, Giải trí, Sức khỏe, Giáo dục, Lương, Khác)
3. **Thống kê**: Hiển thị tổng số dư, thu nhập, chi tiêu
4. **Biểu đồ**: Biểu đồ tròn (chi tiêu theo danh mục) và biểu đồ cột (chi theo tháng)
5. **Cài đặt**: Chế độ sáng/tối, xóa dữ liệu

### 2.2. Cấu trúc thư mục
```
lib/
├── main.dart                    # Điểm khởi đầu
├── models/                      # Lớp dữ liệu
│   └── transaction_model.dart
├── providers/                   # Quản lý state
│   ├── transaction_provider.dart
│   └── theme_provider.dart
├── screens/                     # Các màn hình
│   ├── home_screen.dart
│   ├── add_transaction_screen.dart
│   ├── chart_screen.dart
│   └── settings_screen.dart
├── widgets/                     # Các widget tái sử dụng
│   ├── transaction_item.dart
│   ├── transaction_list.dart
│   └── chart_widget.dart
└── utils/                       # Tiện ích
    └── format_currency.dart
```


### 2.2. Cấu trúc thư mục

```
personal_expense_manager/
│
├── lib/
│   ├── main.dart                      # Điểm khởi đầu ứng dụng
│   │
│   ├── models/                        # Lớp dữ liệu
│   │   ├── transaction_model.dart     # Model giao dịch
│   │   └── transaction_model.g.dart   # File tự động sinh bởi Hive
│   │
│   ├── providers/                     # Quản lý trạng thái
│   │   ├── transaction_provider.dart  # Provider giao dịch
│   │   └── theme_provider.dart        # Provider theme
│   │
│   ├── screens/                       # Các màn hình
│   │   ├── home_screen.dart           # Màn hình chính
│   │   ├── add_transaction_screen.dart # Màn thêm giao dịch
│   │   ├── chart_screen.dart          # Màn biểu đồ
│   │   └── settings_screen.dart       # Màn cài đặt
│   │
│   ├── widgets/                       # Các widget tái sử dụng
│   │   ├── transaction_item.dart      # Widget 1 giao dịch
│   │   ├── transaction_list.dart      # Widget danh sách
│   │   └── chart_widget.dart          # Widget biểu đồ
│   │
│   └── utils/                         # Tiện ích
│       └── format_currency.dart       # Format tiền tệ
│
├── pubspec.yaml                       # File cấu hình dependencies
└── README.md                          # Tài liệu hướng dẫn
```

---

## 3. CÀI ĐẶT VÀ CẤU HÌNH

### 3.1. File pubspec.yaml

**Giải thích:**
File này chứa thông tin về dự án và các thư viện cần thiết.

```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # Quản lý trạng thái
  provider: ^6.1.1
  
  # Lưu trữ dữ liệu offline
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  
  # Vẽ biểu đồ
  fl_chart: ^0.68.0
  
  # Định dạng ngày tháng và tiền tệ
  intl: ^0.19.0

dev_dependencies:
  # Tạo code tự động cho Hive
  hive_generator: ^2.0.1
  build_runner: ^2.4.7
```

**Các bước cài đặt:**
1. Tạo project Flutter mới
2. Thêm các dependencies vào pubspec.yaml
3. Chạy lệnh: `flutter pub get`
4. Chạy build_runner: `flutter packages pub run build_runner build`

---

## 4. GIẢI THÍCH CHI TIẾT TỪNG PHẦN CODE

### 4.1. MODEL - TransactionModel (lib/models/transaction_model.dart)

**Mục đích:** Định nghĩa cấu trúc dữ liệu của một giao dịch.

```dart
import 'package:hive/hive.dart';

part 'transaction_model.g.dart';

@HiveType(typeId: 0)  // Đánh dấu class này là Hive Type với ID = 0
class TransactionModel extends HiveObject {
  @HiveField(0)  // Đánh dấu field với index 0
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  double amount;

  @HiveField(3)
  DateTime date;

  @HiveField(4)
  String category;

  @HiveField(5)
  bool isIncome;  // true = thu nhập, false = chi tiêu

  TransactionModel({
    required this.id,
    required this.name,
    required this.amount,
    required this.date,
    required this.category,
    required this.isIncome,
  });
}
```

**Giải thích chi tiết:**

1. **@HiveType(typeId: 0)**: Annotation để Hive biết đây là một kiểu dữ liệu cần lưu trữ
2. **@HiveField(index)**: Đánh số thứ tự cho mỗi thuộc tính
3. **extends HiveObject**: Kế thừa để có thể sử dụng các phương thức của Hive như delete()
4. **part 'transaction_model.g.dart'**: Liên kết với file tự động sinh

**Enum TransactionCategory:**
```dart
enum TransactionCategory {
  food('Ăn uống'),
  shopping('Mua sắm'),
  transport('Đi lại'),
  entertainment('Giải trí'),
  health('Sức khỏe'),
  education('Giáo dục'),
  salary('Lương'),
  other('Khác');

  final String displayName;
  const TransactionCategory(this.displayName);
}
```

**Giải thích:** Enum giúp định nghĩa các danh mục cố định, tránh lỗi chính tả.



### 4.2. PROVIDER - TransactionProvider (lib/providers/transaction_provider.dart)

**Mục đích:** Quản lý trạng thái và logic nghiệp vụ của giao dịch.

```dart
class TransactionProvider extends ChangeNotifier {
  late Box<TransactionModel> _transactionBox;
  List<TransactionModel> _transactions = [];

  List<TransactionModel> get transactions => _transactions;
```

**Giải thích:**
- **ChangeNotifier**: Class cha cho phép thông báo thay đổi đến UI
- **Box<TransactionModel>**: Container lưu trữ dữ liệu của Hive
- **_transactions**: Danh sách giao dịch trong bộ nhớ

**Phương thức khởi tạo:**
```dart
Future<void> initialize() async {
  // Mở box Hive với tên 'transactions'
  _transactionBox = await Hive.openBox<TransactionModel>('transactions');
  
  // Load dữ liệu từ Hive vào bộ nhớ
  _loadTransactions();
  
  // Nếu chưa có dữ liệu, thêm dữ liệu mẫu
  if (_transactions.isEmpty) {
    await _addSampleData();
  }
}
```

**Phương thức load dữ liệu:**
```dart
void _loadTransactions() {
  // Lấy tất cả giá trị từ box
  _transactions = _transactionBox.values.toList();
  
  // Sắp xếp theo ngày giảm dần (mới nhất lên đầu)
  _transactions.sort((a, b) => b.date.compareTo(a.date));
  
  // Thông báo UI cập nhật
  notifyListeners();
}
```

**Phương thức thêm giao dịch:**
```dart
Future<void> addTransaction(TransactionModel transaction) async {
  // Thêm vào Hive database
  await _transactionBox.add(transaction);
  
  // Load lại và cập nhật UI
  _loadTransactions();
}
```

**Phương thức xóa giao dịch:**
```dart
Future<void> deleteTransaction(TransactionModel transaction) async {
  // Xóa khỏi Hive (vì extends HiveObject nên có method delete())
  await transaction.delete();
  
  // Load lại và cập nhật UI
  _loadTransactions();
}
```

**Các phương thức tính toán:**
```dart
// Tính tổng số dư
double get totalBalance {
  double balance = 0;
  for (var transaction in _transactions) {
    if (transaction.isIncome) {
      balance += transaction.amount;  // Cộng thu nhập
    } else {
      balance -= transaction.amount;  // Trừ chi tiêu
    }
  }
  return balance;
}

// Tính tổng thu nhập
double get totalIncome {
  return _transactions
      .where((t) => t.isIncome)  // Lọc các giao dịch thu nhập
      .fold(0, (sum, t) => sum + t.amount);  // Cộng dồn
}

// Tính tổng chi tiêu
double get totalExpense {
  return _transactions
      .where((t) => !t.isIncome)  // Lọc các giao dịch chi tiêu
      .fold(0, (sum, t) => sum + t.amount);
}
```

**Phương thức nhóm theo danh mục:**
```dart
Map<String, double> getExpensesByCategory() {
  Map<String, double> categoryExpenses = {};
  
  for (var transaction in _transactions) {
    if (!transaction.isIncome) {  // Chỉ tính chi tiêu
      // Cộng dồn số tiền theo danh mục
      categoryExpenses[transaction.category] =
          (categoryExpenses[transaction.category] ?? 0) + transaction.amount;
    }
  }
  
  return categoryExpenses;
}
```

**Phương thức nhóm theo ngày:**
```dart
Map<String, List<TransactionModel>> getTransactionsGroupedByDate() {
  Map<String, List<TransactionModel>> grouped = {};
  
  for (var transaction in _transactions) {
    // Tạo key theo định dạng "dd/MM/yyyy"
    String dateKey =
        '${transaction.date.day}/${transaction.date.month}/${transaction.date.year}';
    
    // Khởi tạo list nếu chưa có
    if (!grouped.containsKey(dateKey)) {
      grouped[dateKey] = [];
    }
    
    // Thêm giao dịch vào nhóm
    grouped[dateKey]!.add(transaction);
  }
  
  return grouped;
}
```



### 4.3. PROVIDER - ThemeProvider (lib/providers/theme_provider.dart)

**Mục đích:** Quản lý chế độ sáng/tối của ứng dụng.

```dart
class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  late Box _settingsBox;

  bool get isDarkMode => _isDarkMode;

  ThemeProvider() {
    _loadTheme();  // Load theme khi khởi tạo
  }

  Future<void> _loadTheme() async {
    // Mở box settings
    _settingsBox = await Hive.openBox('settings');
    
    // Đọc giá trị đã lưu, mặc định là false
    _isDarkMode = _settingsBox.get('isDarkMode', defaultValue: false);
    
    notifyListeners();
  }

  void toggleTheme() {
    // Đảo ngược giá trị
    _isDarkMode = !_isDarkMode;
    
    // Lưu vào Hive
    _settingsBox.put('isDarkMode', _isDarkMode);
    
    // Cập nhật UI
    notifyListeners();
  }

  // Định nghĩa theme sáng
  ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
      );

  // Định nghĩa theme tối
  ThemeData get darkTheme => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
      );
}
```

---

### 4.4. UTILS - CurrencyFormatter (lib/utils/format_currency.dart)

**Mục đích:** Định dạng tiền tệ và ngày tháng theo chuẩn Việt Nam.

```dart
import 'package:intl/intl.dart';

class CurrencyFormatter {
  // Format tiền tệ: 1000000 -> 1.000.000₫
  static String format(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'vi_VN',      // Locale Việt Nam
      symbol: '₫',          // Ký hiệu tiền tệ
      decimalDigits: 0,     // Không có số thập phân
    );
    return formatter.format(amount);
  }

  // Format ngày: DateTime -> 25/11/2024
  static String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  // Format tháng: DateTime -> 11/2024
  static String formatMonth(DateTime date) {
    return DateFormat('MM/yyyy').format(date);
  }

  // Format ngày giờ: DateTime -> 25/11/2024 14:30
  static String formatDateWithTime(DateTime date) {
    return DateFormat('dd/MM/yyyy HH:mm').format(date);
  }
}
```

**Giải thích:**
- **NumberFormat.currency**: Class từ package intl để format tiền tệ
- **locale: 'vi_VN'**: Sử dụng định dạng Việt Nam (dấu chấm phân cách hàng nghìn)
- **DateFormat**: Class format ngày tháng với pattern tùy chỉnh

---

### 4.5. MAIN - Entry Point (lib/main.dart)

**Mục đích:** Điểm khởi đầu của ứng dụng, khởi tạo Hive và Provider.

```dart
void main() async {
  // Đảm bảo Flutter đã khởi tạo xong
  WidgetsFlutterBinding.ensureInitialized();
  
  // Khởi tạo Hive
  await Hive.initFlutter();
  
  // Đăng ký adapter cho TransactionModel
  Hive.registerAdapter(TransactionModelAdapter());
  
  // Chạy ứng dụng
  runApp(const MyApp());
}
```

**Giải thích:**
1. **WidgetsFlutterBinding.ensureInitialized()**: Bắt buộc khi dùng async trong main
2. **Hive.initFlutter()**: Khởi tạo Hive với đường dẫn mặc định
3. **registerAdapter**: Đăng ký adapter để Hive biết cách lưu/đọc TransactionModel

**Widget MyApp:**
```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Provider cho theme
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        
        // Provider cho transaction, gọi initialize() ngay khi tạo
        ChangeNotifierProvider(
          create: (_) => TransactionProvider()..initialize(),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Quản lý Chi tiêu',
            debugShowCheckedModeBanner: false,
            
            // Theme sáng
            theme: themeProvider.lightTheme,
            
            // Theme tối
            darkTheme: themeProvider.darkTheme,
            
            // Chế độ theme hiện tại
            themeMode: themeProvider.isDarkMode 
                ? ThemeMode.dark 
                : ThemeMode.light,
            
            home: const MainScreen(),
          );
        },
      ),
    );
  }
}
```

**Giải thích:**
- **MultiProvider**: Cung cấp nhiều Provider cho toàn bộ app
- **Consumer<ThemeProvider>**: Lắng nghe thay đổi từ ThemeProvider
- **themeMode**: Chuyển đổi giữa theme sáng/tối



**Widget MainScreen - Màn hình chính với BottomNavigationBar:**
```dart
class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;  // Tab hiện tại

  // Danh sách các màn hình
  final List<Widget> _screens = const [
    HomeScreen(),      // Tab 0: Trang chủ
    ChartScreen(),     // Tab 1: Biểu đồ
    SettingsScreen(),  // Tab 2: Cài đặt
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý Chi tiêu'),
        actions: [
          // Nút thêm chỉ hiện ở trang chủ
          if (_currentIndex == 0)
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddTransactionScreen(),
                  ),
                );
              },
            ),
        ],
      ),
      
      // Hiển thị màn hình tương ứng với tab
      body: _screens[_currentIndex],
      
      // Bottom Navigation Bar
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;  // Chuyển tab
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Trang chủ',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart),
            label: 'Biểu đồ',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Cài đặt',
          ),
        ],
      ),
      
      // Floating Action Button (chỉ hiện ở trang chủ)
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddTransactionScreen(),
                  ),
                );
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
```

---

### 4.6. SCREEN - HomeScreen (lib/screens/home_screen.dart)

**Mục đích:** Hiển thị tổng quan tài chính và danh sách giao dịch.

```dart
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionProvider>(
      builder: (context, provider, child) {
        return Column(
          children: [
            // Phần header hiển thị tổng quan
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                // Gradient màu
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.secondary,
                  ],
                ),
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  const Text(
                    'Tổng số dư',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  
                  // Hiển thị số dư
                  Text(
                    CurrencyFormatter.format(provider.totalBalance),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Hiển thị thu nhập và chi tiêu
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatCard(
                        'Thu nhập',
                        CurrencyFormatter.format(provider.totalIncome),
                        Icons.arrow_downward,
                        Colors.green,
                      ),
                      _buildStatCard(
                        'Chi tiêu',
                        CurrencyFormatter.format(provider.totalExpense),
                        Icons.arrow_upward,
                        Colors.red,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Tiêu đề danh sách
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Text(
                    'Giao dịch gần đây',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 8),
            
            // Danh sách giao dịch
            const Expanded(
              child: TransactionList(),
            ),
          ],
        );
      },
    );
  }

  // Widget hiển thị thẻ thống kê
  Widget _buildStatCard(
    String title, 
    String amount, 
    IconData icon, 
    Color color
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 24),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
          const SizedBox(height: 4),
          Text(
            amount,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
```

**Giải thích:**
- **Consumer<TransactionProvider>**: Lắng nghe thay đổi từ provider
- **LinearGradient**: Tạo hiệu ứng chuyển màu
- **Expanded**: Widget con chiếm hết không gian còn lại



### 4.7. SCREEN - AddTransactionScreen (lib/screens/add_transaction_screen.dart)

**Mục đích:** Màn hình thêm giao dịch mới với form validation.

```dart
class AddTransactionScreen extends StatefulWidget {
  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  // Key để quản lý form
  final _formKey = GlobalKey<FormState>();
  
  // Controllers để lấy giá trị từ TextField
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  
  // Các biến state
  String _selectedCategory = TransactionCategory.food.displayName;
  bool _isIncome = false;
  DateTime _selectedDate = DateTime.now();

  @override
  void dispose() {
    // Giải phóng bộ nhớ khi widget bị hủy
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  // Hàm chọn ngày
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // Hàm submit form
  void _submitForm() {
    // Validate form
    if (_formKey.currentState!.validate()) {
      // Tạo object giao dịch mới
      final transaction = TransactionModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        amount: double.parse(_amountController.text),
        date: _selectedDate,
        category: _selectedCategory,
        isIncome: _isIncome,
      );

      // Thêm vào provider
      Provider.of<TransactionProvider>(context, listen: false)
          .addTransaction(transaction);

      // Hiển thị thông báo
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã thêm giao dịch thành công!')),
      );

      // Reset form
      _nameController.clear();
      _amountController.clear();
      setState(() {
        _selectedDate = DateTime.now();
        _isIncome = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thêm giao dịch'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Card chọn loại giao dịch
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      // Chip Chi tiêu
                      Expanded(
                        child: ChoiceChip(
                          label: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.arrow_upward, size: 18),
                              SizedBox(width: 4),
                              Text('Chi tiêu'),
                            ],
                          ),
                          selected: !_isIncome,
                          onSelected: (selected) {
                            setState(() {
                              _isIncome = false;
                            });
                          },
                          selectedColor: Colors.red.withOpacity(0.3),
                        ),
                      ),
                      
                      const SizedBox(width: 16),
                      
                      // Chip Thu nhập
                      Expanded(
                        child: ChoiceChip(
                          label: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.arrow_downward, size: 18),
                              SizedBox(width: 4),
                              Text('Thu nhập'),
                            ],
                          ),
                          selected: _isIncome,
                          onSelected: (selected) {
                            setState(() {
                              _isIncome = true;
                            });
                          },
                          selectedColor: Colors.green.withOpacity(0.3),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // TextField tên giao dịch
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Tên giao dịch',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Vui lòng nhập tên giao dịch';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              // TextField số tiền
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: 'Số tiền',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.attach_money),
                  suffixText: '₫',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Vui lòng nhập số tiền';
                  }
                  final amount = double.tryParse(value);
                  if (amount == null || amount <= 0) {
                    return 'Số tiền phải lớn hơn 0';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              // Dropdown chọn danh mục
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Danh mục',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.category),
                ),
                items: TransactionCategory.values
                    .map((category) => DropdownMenuItem(
                          value: category.displayName,
                          child: Text(category.displayName),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value!;
                  });
                },
              ),
              
              const SizedBox(height: 16),
              
              // Chọn ngày
              InkWell(
                onTap: () => _selectDate(context),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Ngày',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  child: Text(
                    '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Nút submit
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                ),
                child: const Text(
                  'Thêm giao dịch',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

**Giải thích các thành phần:**

1. **GlobalKey<FormState>**: Quản lý trạng thái của form, dùng để validate
2. **TextEditingController**: Lấy và điều khiển giá trị của TextField
3. **ChoiceChip**: Widget để chọn 1 trong nhiều lựa chọn
4. **TextFormField**: TextField có tích hợp validation
5. **validator**: Hàm kiểm tra dữ liệu đầu vào
6. **DropdownButtonFormField**: Dropdown menu trong form
7. **InkWell + InputDecorator**: Tạo field có thể click để chọn ngày



### 4.8. WIDGET - TransactionList (lib/widgets/transaction_list.dart)

**Mục đích:** Hiển thị danh sách giao dịch được nhóm theo ngày.

```dart
class TransactionList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionProvider>(
      builder: (context, provider, child) {
        // Kiểm tra nếu chưa có giao dịch
        if (provider.transactions.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.receipt_long, size: 80, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'Chưa có giao dịch nào',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        // Lấy giao dịch đã nhóm theo ngày
        final groupedTransactions = provider.getTransactionsGroupedByDate();
        
        // Sắp xếp các ngày theo thứ tự giảm dần
        final sortedDates = groupedTransactions.keys.toList()
          ..sort((a, b) {
            // Parse string "dd/MM/yyyy" thành DateTime
            final partsA = a.split('/');
            final partsB = b.split('/');
            final dateA = DateTime(
              int.parse(partsA[2]),  // year
              int.parse(partsA[1]),  // month
              int.parse(partsA[0]),  // day
            );
            final dateB = DateTime(
              int.parse(partsB[2]),
              int.parse(partsB[1]),
              int.parse(partsB[0]),
            );
            return dateB.compareTo(dateA);  // Giảm dần
          });

        return ListView.builder(
          itemCount: sortedDates.length,
          itemBuilder: (context, index) {
            final dateKey = sortedDates[index];
            final transactions = groupedTransactions[dateKey]!;
            
            // Tính tổng của ngày
            final dayTotal = transactions.fold<double>(
              0,
              (sum, t) => sum + (t.isIncome ? t.amount : -t.amount),
            );

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header ngày
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        dateKey,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${dayTotal >= 0 ? '+' : ''}${dayTotal.toStringAsFixed(0)}₫',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: dayTotal >= 0 ? Colors.green : Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Danh sách giao dịch trong ngày
                ...transactions.map((transaction) => TransactionItem(
                      transaction: transaction,
                      onDelete: () => provider.deleteTransaction(transaction),
                    )),
              ],
            );
          },
        );
      },
    );
  }
}
```

**Giải thích:**
- **ListView.builder**: Tạo list động, chỉ render các item hiển thị trên màn hình
- **fold**: Hàm tính tổng (giống reduce nhưng có giá trị khởi tạo)
- **...transactions.map()**: Spread operator để thêm nhiều widget vào list

---

### 4.9. WIDGET - TransactionItem (lib/widgets/transaction_item.dart)

**Mục đích:** Hiển thị một giao dịch trong danh sách.

```dart
class TransactionItem extends StatelessWidget {
  final TransactionModel transaction;
  final VoidCallback onDelete;

  const TransactionItem({
    required this.transaction,
    required this.onDelete,
  });

  // Hàm lấy icon theo danh mục
  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Ăn uống':
        return Icons.restaurant;
      case 'Mua sắm':
        return Icons.shopping_bag;
      case 'Đi lại':
        return Icons.directions_car;
      case 'Giải trí':
        return Icons.movie;
      case 'Sức khỏe':
        return Icons.health_and_safety;
      case 'Giáo dục':
        return Icons.school;
      case 'Lương':
        return Icons.attach_money;
      default:
        return Icons.category;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        // Icon danh mục
        leading: CircleAvatar(
          backgroundColor: transaction.isIncome
              ? Colors.green.withOpacity(0.2)
              : Colors.red.withOpacity(0.2),
          child: Icon(
            _getCategoryIcon(transaction.category),
            color: transaction.isIncome ? Colors.green : Colors.red,
          ),
        ),
        
        // Tên giao dịch
        title: Text(
          transaction.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        
        // Danh mục và ngày
        subtitle: Text(
          '${transaction.category} • ${CurrencyFormatter.formatDate(transaction.date)}',
        ),
        
        // Số tiền và nút xóa
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${transaction.isIncome ? '+' : '-'}${CurrencyFormatter.format(transaction.amount)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: transaction.isIncome ? Colors.green : Colors.red,
              ),
            ),
            
            // Nút xóa
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                // Hiển thị dialog xác nhận
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Xác nhận xóa'),
                    content: const Text('Bạn có chắc muốn xóa giao dịch này?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text('Hủy'),
                      ),
                      TextButton(
                        onPressed: () {
                          onDelete();  // Gọi callback xóa
                          Navigator.pop(ctx);
                        },
                        child: const Text('Xóa'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
```

**Giải thích:**
- **VoidCallback**: Kiểu dữ liệu cho hàm không tham số, không trả về
- **CircleAvatar**: Widget tạo hình tròn chứa icon/ảnh
- **ListTile**: Widget chuẩn để hiển thị item trong list
- **showDialog**: Hiển thị dialog xác nhận trước khi xóa



### 4.10. WIDGET - ChartWidget (lib/widgets/chart_widget.dart)

**Mục đích:** Hiển thị biểu đồ tròn và biểu đồ cột.

#### A. Biểu đồ tròn - ExpensePieChart

```dart
class ExpensePieChart extends StatelessWidget {
  final Map<String, double> categoryExpenses;

  const ExpensePieChart({required this.categoryExpenses});

  @override
  Widget build(BuildContext context) {
    // Kiểm tra dữ liệu
    if (categoryExpenses.isEmpty) {
      return const Center(
        child: Text('Chưa có dữ liệu chi tiêu'),
      );
    }

    // Tính tổng
    final total = categoryExpenses.values.fold(0.0, (sum, val) => sum + val);
    
    // Danh sách màu
    final colors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.pink,
      Colors.amber,
    ];

    return Column(
      children: [
        // Biểu đồ tròn
        SizedBox(
          height: 250,
          child: PieChart(
            PieChartData(
              sectionsSpace: 2,  // Khoảng cách giữa các phần
              centerSpaceRadius: 40,  // Bán kính lỗ giữa
              sections: categoryExpenses.entries.toList().asMap().entries.map((entry) {
                final index = entry.key;
                final data = entry.value;
                final percentage = (data.value / total * 100);
                
                return PieChartSectionData(
                  color: colors[index % colors.length],
                  value: data.value,
                  title: '${percentage.toStringAsFixed(1)}%',
                  radius: 80,
                  titleStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        
        const SizedBox(height: 20),
        
        // Chú thích
        Wrap(
          spacing: 16,
          runSpacing: 8,
          children: categoryExpenses.entries.toList().asMap().entries.map((entry) {
            final index = entry.key;
            final data = entry.value;
            
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Ô màu
                Container(
                  width: 16,
                  height: 16,
                  color: colors[index % colors.length],
                ),
                const SizedBox(width: 8),
                // Tên danh mục và số tiền
                Text('${data.key}: ${CurrencyFormatter.format(data.value)}'),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }
}
```

**Giải thích:**
- **PieChart**: Widget từ fl_chart để vẽ biểu đồ tròn
- **PieChartSectionData**: Dữ liệu cho mỗi phần của biểu đồ
- **Wrap**: Widget tự động xuống dòng khi hết chỗ
- **asMap().entries**: Chuyển list thành map với index làm key

#### B. Biểu đồ cột - MonthlyBarChart

```dart
class MonthlyBarChart extends StatelessWidget {
  final Map<String, double> monthlyExpenses;

  const MonthlyBarChart({required this.monthlyExpenses});

  @override
  Widget build(BuildContext context) {
    if (monthlyExpenses.isEmpty) {
      return const Center(
        child: Text('Chưa có dữ liệu chi tiêu'),
      );
    }

    // Sắp xếp theo tháng
    final sortedEntries = monthlyExpenses.entries.toList()
      ..sort((a, b) {
        final partsA = a.key.split('/');
        final partsB = b.key.split('/');
        final dateA = DateTime(int.parse(partsA[1]), int.parse(partsA[0]));
        final dateB = DateTime(int.parse(partsB[1]), int.parse(partsB[0]));
        return dateA.compareTo(dateB);
      });

    // Tìm giá trị lớn nhất để làm maxY
    final maxY = sortedEntries.map((e) => e.value).reduce((a, b) => a > b ? a : b);

    return Column(
      children: [
        SizedBox(
          height: 300,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: maxY * 1.2,  // Thêm 20% để có khoảng trống phía trên
              
              // Cấu hình tooltip khi chạm vào cột
              barTouchData: BarTouchData(
                touchTooltipData: BarTouchTooltipData(
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    return BarTooltipItem(
                      CurrencyFormatter.format(rod.toY),
                      const TextStyle(color: Colors.white),
                    );
                  },
                ),
              ),
              
              // Cấu hình các trục
              titlesData: FlTitlesData(
                show: true,
                
                // Trục X (tháng)
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      if (value.toInt() >= 0 && value.toInt() < sortedEntries.length) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            sortedEntries[value.toInt()].key,
                            style: const TextStyle(fontSize: 10),
                          ),
                        );
                      }
                      return const Text('');
                    },
                  ),
                ),
                
                // Trục Y (số tiền)
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 60,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        '${(value / 1000000).toStringAsFixed(1)}M',
                        style: const TextStyle(fontSize: 10),
                      );
                    },
                  ),
                ),
                
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              
              borderData: FlBorderData(show: false),
              
              // Dữ liệu các cột
              barGroups: sortedEntries.asMap().entries.map((entry) {
                return BarChartGroupData(
                  x: entry.key,
                  barRods: [
                    BarChartRodData(
                      toY: entry.value.value,
                      color: Colors.blue,
                      width: 20,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(4)
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
```

**Giải thích:**
- **BarChart**: Widget vẽ biểu đồ cột
- **BarChartData**: Cấu hình cho biểu đồ
- **FlTitlesData**: Cấu hình các nhãn trục
- **BarChartGroupData**: Dữ liệu cho mỗi nhóm cột
- **BarChartRodData**: Dữ liệu cho mỗi cột



### 4.11. SCREEN - ChartScreen (lib/screens/chart_screen.dart)

**Mục đích:** Màn hình hiển thị các biểu đồ thống kê.

```dart
class ChartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionProvider>(
      builder: (context, provider, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tiêu đề biểu đồ tròn
              const Text(
                'Chi tiêu theo danh mục',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              
              // Card chứa biểu đồ tròn
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: ExpensePieChart(
                    categoryExpenses: provider.getExpensesByCategory(),
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Tiêu đề biểu đồ cột
              const Text(
                'Chi tiêu theo tháng',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              
              // Card chứa biểu đồ cột
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: MonthlyBarChart(
                    monthlyExpenses: provider.getMonthlyExpenses(),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
```

**Giải thích:**
- **SingleChildScrollView**: Cho phép scroll khi nội dung dài
- **Card**: Widget tạo khung với shadow
- Dữ liệu được lấy từ provider và truyền vào các widget biểu đồ

---

### 4.12. SCREEN - SettingsScreen (lib/screens/settings_screen.dart)

**Mục đích:** Màn hình cài đặt ứng dụng.

```dart
class SettingsScreen extends StatelessWidget {
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
        
        // Card chứa switch theme
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
        
        // Card chứa các tùy chọn khác
        Card(
          child: Column(
            children: [
              // Thông tin ứng dụng
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
              
              // Xóa tất cả dữ liệu
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
                                // Xóa từng giao dịch
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
```

**Giải thích:**
- **SwitchListTile**: ListTile có tích hợp switch
- **showAboutDialog**: Hiển thị dialog thông tin ứng dụng
- **ctx.mounted**: Kiểm tra context còn tồn tại trước khi sử dụng (tránh lỗi)

---

## 5. LUỒNG HOẠT ĐỘNG CỦA ỨNG DỤNG

### 5.1. Luồng khởi động ứng dụng

```
1. main() được gọi
   ↓
2. Khởi tạo Hive
   ↓
3. Đăng ký TransactionModelAdapter
   ↓
4. Chạy MyApp widget
   ↓
5. Khởi tạo MultiProvider
   - ThemeProvider: Load theme từ Hive
   - TransactionProvider: Load giao dịch từ Hive
   ↓
6. Hiển thị MainScreen với BottomNavigationBar
   ↓
7. Hiển thị HomeScreen (tab mặc định)
```

### 5.2. Luồng thêm giao dịch

```
1. User nhấn nút "+" trên HomeScreen
   ↓
2. Navigate đến AddTransactionScreen
   ↓
3. User nhập thông tin:
   - Chọn loại (Thu/Chi)
   - Nhập tên
   - Nhập số tiền
   - Chọn danh mục
   - Chọn ngày
   ↓
4. User nhấn "Thêm giao dịch"
   ↓
5. Form validation được thực hiện
   ↓
6. Nếu hợp lệ:
   - Tạo TransactionModel mới
   - Gọi provider.addTransaction()
   - Provider lưu vào Hive
   - Provider gọi notifyListeners()
   ↓
7. UI tự động cập nhật:
   - HomeScreen cập nhật danh sách
   - HomeScreen cập nhật tổng số dư
   - ChartScreen cập nhật biểu đồ
```



### 5.3. Luồng xóa giao dịch

```
1. User nhấn icon xóa trên TransactionItem
   ↓
2. Hiển thị AlertDialog xác nhận
   ↓
3. Nếu user xác nhận:
   - Gọi onDelete callback
   - Provider gọi transaction.delete()
   - Hive xóa dữ liệu
   - Provider gọi _loadTransactions()
   - Provider gọi notifyListeners()
   ↓
4. UI tự động cập nhật:
   - Item biến mất khỏi danh sách
   - Tổng số dư được cập nhật
   - Biểu đồ được cập nhật
```

### 5.4. Luồng chuyển theme

```
1. User bật/tắt switch "Chế độ tối"
   ↓
2. ThemeProvider.toggleTheme() được gọi
   ↓
3. _isDarkMode được đảo ngược
   ↓
4. Giá trị mới được lưu vào Hive
   ↓
5. notifyListeners() được gọi
   ↓
6. Consumer<ThemeProvider> trong MyApp rebuild
   ↓
7. MaterialApp áp dụng theme mới
   ↓
8. Toàn bộ UI chuyển sang theme mới
```

### 5.5. Sơ đồ luồng dữ liệu

```
┌─────────────────────────────────────────────────┐
│                    UI Layer                     │
│  (Screens & Widgets)                            │
│  - Hiển thị dữ liệu                             │
│  - Nhận input từ user                           │
└──────────────┬──────────────────────────────────┘
               │
               │ Consumer/Provider.of()
               ↓
┌─────────────────────────────────────────────────┐
│              Provider Layer                     │
│  (TransactionProvider, ThemeProvider)           │
│  - Xử lý logic nghiệp vụ                        │
│  - Quản lý state                                │
│  - notifyListeners() khi có thay đổi           │
└──────────────┬──────────────────────────────────┘
               │
               │ CRUD operations
               ↓
┌─────────────────────────────────────────────────┐
│               Data Layer                        │
│  (Hive Database)                                │
│  - Lưu trữ persistent                           │
│  - Đọc/ghi dữ liệu                              │
└─────────────────────────────────────────────────┘
```

---

## 6. HƯỚNG DẪN TẠO DỰ ÁN TỪ ĐẦU

### Bước 1: Tạo project Flutter mới

```bash
flutter create personal_expense_manager
cd personal_expense_manager
```

### Bước 2: Cấu hình pubspec.yaml

Thêm các dependencies vào file `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.1.1
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  fl_chart: ^0.68.0
  intl: ^0.19.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  hive_generator: ^2.0.1
  build_runner: ^2.4.7
```

Chạy lệnh:
```bash
flutter pub get
```

### Bước 3: Tạo cấu trúc thư mục

```
lib/
├── models/
├── providers/
├── screens/
├── widgets/
└── utils/
```

### Bước 4: Tạo Model

Tạo file `lib/models/transaction_model.dart` với nội dung đã giải thích ở phần 4.1.

### Bước 5: Generate Adapter

Chạy lệnh:
```bash
flutter packages pub run build_runner build --delete-conflicting-outputs
```

File `transaction_model.g.dart` sẽ được tạo tự động.

### Bước 6: Tạo Providers

Tạo các file:
- `lib/providers/transaction_provider.dart`
- `lib/providers/theme_provider.dart`

### Bước 7: Tạo Utils

Tạo file `lib/utils/format_currency.dart`

### Bước 8: Tạo Widgets

Tạo các file:
- `lib/widgets/transaction_item.dart`
- `lib/widgets/transaction_list.dart`
- `lib/widgets/chart_widget.dart`

### Bước 9: Tạo Screens

Tạo các file:
- `lib/screens/home_screen.dart`
- `lib/screens/add_transaction_screen.dart`
- `lib/screens/chart_screen.dart`
- `lib/screens/settings_screen.dart`

### Bước 10: Cập nhật main.dart

Cập nhật file `lib/main.dart` với code đã giải thích ở phần 4.5.

### Bước 11: Chạy ứng dụng

```bash
flutter run
```

---

## 7. CÁC KHÁI NIỆM QUAN TRỌNG

### 7.1. State Management với Provider

**Provider** là pattern quản lý trạng thái phổ biến trong Flutter:

- **ChangeNotifier**: Class cha cho các provider, cung cấp method `notifyListeners()`
- **ChangeNotifierProvider**: Widget cung cấp provider cho các widget con
- **Consumer**: Widget lắng nghe thay đổi từ provider và rebuild khi có thay đổi
- **Provider.of()**: Cách khác để truy cập provider (không rebuild)

**Ví dụ:**
```dart
// Tạo provider
ChangeNotifierProvider(
  create: (_) => TransactionProvider(),
  child: MyApp(),
)

// Lắng nghe thay đổi (rebuild khi có thay đổi)
Consumer<TransactionProvider>(
  builder: (context, provider, child) {
    return Text(provider.totalBalance.toString());
  },
)

// Truy cập không rebuild
Provider.of<TransactionProvider>(context, listen: false)
  .addTransaction(transaction);
```

### 7.2. Hive Database

**Hive** là NoSQL database nhanh và nhẹ cho Flutter:

**Ưu điểm:**
- Rất nhanh (nhanh hơn SQLite)
- Không cần SQL
- Type-safe với code generation
- Hỗ trợ encryption
- Cross-platform

**Cách hoạt động:**
1. Định nghĩa model với annotations `@HiveType` và `@HiveField`
2. Generate adapter với build_runner
3. Đăng ký adapter: `Hive.registerAdapter()`
4. Mở box: `await Hive.openBox<T>('boxName')`
5. CRUD operations:
   - Create: `box.add(item)`
   - Read: `box.values.toList()`
   - Update: `item.save()`
   - Delete: `item.delete()`

### 7.3. Form Validation

**Form** trong Flutter cung cấp validation tích hợp:

```dart
// 1. Tạo GlobalKey
final _formKey = GlobalKey<FormState>();

// 2. Wrap các field trong Form
Form(
  key: _formKey,
  child: Column(
    children: [
      TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Vui lòng nhập giá trị';
          }
          return null;  // null = hợp lệ
        },
      ),
    ],
  ),
)

// 3. Validate khi submit
if (_formKey.currentState!.validate()) {
  // Form hợp lệ, xử lý dữ liệu
}
```

### 7.4. Navigation

Flutter sử dụng Navigator để điều hướng giữa các màn hình:

```dart
// Push màn hình mới
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => NewScreen()),
);

// Pop màn hình hiện tại
Navigator.pop(context);

// Push và xóa tất cả màn hình trước
Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(builder: (context) => HomeScreen()),
  (route) => false,
);
```

