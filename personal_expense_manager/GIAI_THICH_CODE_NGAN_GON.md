# GIẢI THÍCH CODE - ỨNG DỤNG QUẢN LÝ CHI TIÊU

## 1. TỔNG QUAN DỰ ÁN

### Công nghệ sử dụng
- **Flutter**: Framework phát triển app
- **Provider**: Quản lý trạng thái
- **Hive**: Database offline
- **fl_chart**: Vẽ biểu đồ
- **intl**: Format tiền tệ

### Cấu trúc thư mục
```
lib/
├── models/              # Định nghĩa dữ liệu
├── providers/           # Quản lý state
├── screens/             # Các màn hình
├── widgets/             # Component tái sử dụng
└── utils/               # Hàm tiện ích
```

---

## 2. GIẢI THÍCH TỪNG FILE

### 2.1. Model - transaction_model.dart

**Chức năng:** Định nghĩa cấu trúc dữ liệu giao dịch

```dart
@HiveType(typeId: 0)  // Đánh dấu để Hive lưu trữ
class TransactionModel extends HiveObject {
  @HiveField(0) String id;           // ID duy nhất
  @HiveField(1) String name;         // Tên giao dịch
  @HiveField(2) double amount;       // Số tiền
  @HiveField(3) DateTime date;       // Ngày giao dịch
  @HiveField(4) String category;     // Danh mục
  @HiveField(5) bool isIncome;       // Thu/Chi
}
```

**Giải thích:**
- `@HiveType`: Cho Hive biết đây là kiểu dữ liệu cần lưu
- `@HiveField(index)`: Đánh số thứ tự các thuộc tính
- `extends HiveObject`: Để có method `delete()`

---

### 2.2. Provider - transaction_provider.dart

**Chức năng:** Quản lý logic và state của giao dịch

**Các thuộc tính chính:**
```dart
Box<TransactionModel> _transactionBox;  // Database Hive
List<TransactionModel> _transactions;    // Danh sách giao dịch
```

**Các phương thức quan trọng:**

1. **initialize()** - Khởi tạo và load dữ liệu
```dart
Future<void> initialize() async {
  _transactionBox = await Hive.openBox('transactions');
  _loadTransactions();
  if (_transactions.isEmpty) {
    await _addSampleData();  // Thêm dữ liệu mẫu
  }
}
```

2. **addTransaction()** - Thêm giao dịch mới
```dart
Future<void> addTransaction(TransactionModel transaction) async {
  await _transactionBox.add(transaction);  // Lưu vào Hive
  _loadTransactions();                     // Load lại
}
```

3. **deleteTransaction()** - Xóa giao dịch
```dart
Future<void> deleteTransaction(TransactionModel transaction) async {
  await transaction.delete();  // Xóa khỏi Hive
  _loadTransactions();
}
```

4. **Các getter tính toán:**
```dart
double get totalBalance => /* Tổng thu - Tổng chi */
double get totalIncome => /* Tổng thu nhập */
double get totalExpense => /* Tổng chi tiêu */
Map<String, double> getExpensesByCategory() => /* Chi theo danh mục */
```

---

### 2.3. Provider - theme_provider.dart

**Chức năng:** Quản lý chế độ sáng/tối

```dart
class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  
  void toggleTheme() {
    _isDarkMode = !_isDarkMode;           // Đảo trạng thái
    _settingsBox.put('isDarkMode', _isDarkMode);  // Lưu vào Hive
    notifyListeners();                    // Thông báo UI cập nhật
  }
}
```

---

### 2.4. Utils - format_currency.dart

**Chức năng:** Format tiền tệ và ngày tháng

```dart
class CurrencyFormatter {
  // 1000000 -> 1.000.000₫
  static String format(double amount) {
    return NumberFormat.currency(
      locale: 'vi_VN',
      symbol: '₫',
      decimalDigits: 0,
    ).format(amount);
  }
  
  // DateTime -> 25/11/2024
  static String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }
}
```

---

### 2.5. Main - main.dart

**Chức năng:** Điểm khởi đầu ứng dụng

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();                      // Khởi tạo Hive
  Hive.registerAdapter(TransactionModelAdapter()); // Đăng ký adapter
  runApp(const MyApp());
}
```

**Setup Provider:**
```dart
MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => ThemeProvider()),
    ChangeNotifierProvider(create: (_) => TransactionProvider()..initialize()),
  ],
  child: MaterialApp(...)
)
```

**MainScreen - Màn hình chính:**
```dart
class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;  // Tab hiện tại
  
  final List<Widget> _screens = [
    HomeScreen(),      // Tab 0
    ChartScreen(),     // Tab 1
    SettingsScreen(),  // Tab 2
  ];
  
  // Hiển thị màn hình theo tab
  body: _screens[_currentIndex]
}
```

---

### 2.6. Screen - home_screen.dart

**Chức năng:** Hiển thị tổng quan và danh sách giao dịch

**Cấu trúc:**
```dart
Consumer<TransactionProvider>(
  builder: (context, provider, child) {
    return Column([
      // 1. Header gradient hiển thị tổng số dư
      Container(
        gradient: LinearGradient(...),
        child: Column([
          Text('Tổng số dư'),
          Text(provider.totalBalance),  // Số dư
          Row([
            _buildStatCard('Thu nhập', provider.totalIncome),
            _buildStatCard('Chi tiêu', provider.totalExpense),
          ])
        ])
      ),
      
      // 2. Danh sách giao dịch
      TransactionList(),
    ])
  }
)
```

---

### 2.7. Screen - add_transaction_screen.dart

**Chức năng:** Form thêm giao dịch mới

**Các thành phần:**

1. **Form Key và Controllers:**
```dart
final _formKey = GlobalKey<FormState>();
final _nameController = TextEditingController();
final _amountController = TextEditingController();
```

2. **ChoiceChip - Chọn loại:**
```dart
ChoiceChip(
  label: Text('Chi tiêu'),
  selected: !_isIncome,
  onSelected: (selected) => setState(() => _isIncome = false),
)
```

3. **TextFormField - Nhập tên:**
```dart
TextFormField(
  controller: _nameController,
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập tên';
    }
    return null;
  },
)
```

4. **TextFormField - Nhập số tiền:**
```dart
TextFormField(
  controller: _amountController,
  keyboardType: TextInputType.number,
  validator: (value) {
    final amount = double.tryParse(value ?? '');
    if (amount == null || amount <= 0) {
      return 'Số tiền phải lớn hơn 0';
    }
    return null;
  },
)
```

5. **Submit Form:**
```dart
void _submitForm() {
  if (_formKey.currentState!.validate()) {
    final transaction = TransactionModel(...);
    Provider.of<TransactionProvider>(context, listen: false)
        .addTransaction(transaction);
  }
}
```

---

### 2.8. Widget - transaction_list.dart

**Chức năng:** Hiển thị danh sách giao dịch nhóm theo ngày

```dart
Consumer<TransactionProvider>(
  builder: (context, provider, child) {
    // Lấy giao dịch đã nhóm theo ngày
    final grouped = provider.getTransactionsGroupedByDate();
    
    return ListView.builder(
      itemCount: grouped.length,
      itemBuilder: (context, index) {
        final dateKey = sortedDates[index];
        final transactions = grouped[dateKey];
        
        return Column([
          // Header ngày và tổng
          Text(dateKey),
          Text(dayTotal),
          
          // Danh sách giao dịch trong ngày
          ...transactions.map((t) => TransactionItem(
            transaction: t,
            onDelete: () => provider.deleteTransaction(t),
          )),
        ]);
      },
    );
  }
)
```

---

### 2.9. Widget - transaction_item.dart

**Chức năng:** Hiển thị 1 giao dịch

```dart
Card(
  child: ListTile(
    // Icon danh mục
    leading: CircleAvatar(
      child: Icon(_getCategoryIcon(transaction.category)),
    ),
    
    // Tên giao dịch
    title: Text(transaction.name),
    
    // Danh mục và ngày
    subtitle: Text('${transaction.category} • ${formatDate}'),
    
    // Số tiền và nút xóa
    trailing: Row([
      Text('${transaction.isIncome ? '+' : '-'}${amount}'),
      IconButton(
        icon: Icon(Icons.delete),
        onPressed: () => showDialog(...),  // Xác nhận xóa
      ),
    ]),
  ),
)
```



### 2.10. Widget - chart_widget.dart

**Chức năng:** Vẽ biểu đồ tròn và biểu đồ cột

#### A. Biểu đồ tròn - ExpensePieChart

```dart
PieChart(
  PieChartData(
    sections: categoryExpenses.map((entry) {
      final percentage = (entry.value / total * 100);
      return PieChartSectionData(
        color: colors[index],
        value: entry.value,
        title: '${percentage.toFixed(1)}%',
      );
    }).toList(),
  ),
)
```

**Giải thích:** Mỗi danh mục là 1 phần của biểu đồ tròn, hiển thị % chi tiêu.

#### B. Biểu đồ cột - MonthlyBarChart

```dart
BarChart(
  BarChartData(
    barGroups: monthlyExpenses.map((entry) {
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: entry.value,  // Chiều cao cột = số tiền
            color: Colors.blue,
          ),
        ],
      );
    }).toList(),
  ),
)
```

**Giải thích:** Mỗi tháng là 1 cột, chiều cao = tổng chi tiêu.

---

### 2.11. Screen - chart_screen.dart

**Chức năng:** Màn hình hiển thị biểu đồ

```dart
Consumer<TransactionProvider>(
  builder: (context, provider, child) {
    return Column([
      // Biểu đồ tròn
      ExpensePieChart(
        categoryExpenses: provider.getExpensesByCategory(),
      ),
      
      // Biểu đồ cột
      MonthlyBarChart(
        monthlyExpenses: provider.getMonthlyExpenses(),
      ),
    ]);
  }
)
```

---

### 2.12. Screen - settings_screen.dart

**Chức năng:** Màn hình cài đặt

**1. Switch chế độ tối:**
```dart
Consumer<ThemeProvider>(
  builder: (context, themeProvider, child) {
    return SwitchListTile(
      title: Text('Chế độ tối'),
      value: themeProvider.isDarkMode,
      onChanged: (value) => themeProvider.toggleTheme(),
    );
  }
)
```

**2. Xóa tất cả dữ liệu:**
```dart
ListTile(
  title: Text('Xóa tất cả dữ liệu'),
  onTap: () {
    showDialog(
      builder: (ctx) => AlertDialog(
        title: Text('Xác nhận xóa'),
        actions: [
          TextButton(onPressed: () {
            for (var t in provider.transactions) {
              provider.deleteTransaction(t);
            }
          }),
        ],
      ),
    );
  },
)
```

---

## 3. LUỒNG HOẠT ĐỘNG

### 3.1. Khởi động app
```
main() 
→ Khởi tạo Hive 
→ Đăng ký Adapter 
→ Tạo Provider 
→ Load dữ liệu từ Hive 
→ Hiển thị UI
```

### 3.2. Thêm giao dịch
```
User nhập form 
→ Validate 
→ Tạo TransactionModel 
→ provider.addTransaction() 
→ Lưu vào Hive 
→ notifyListeners() 
→ UI tự động cập nhật
```

### 3.3. Xóa giao dịch
```
User nhấn nút xóa 
→ Hiển thị dialog xác nhận 
→ provider.deleteTransaction() 
→ Xóa khỏi Hive 
→ notifyListeners() 
→ UI tự động cập nhật
```

### 3.4. Chuyển theme
```
User bật/tắt switch 
→ themeProvider.toggleTheme() 
→ Lưu vào Hive 
→ notifyListeners() 
→ MaterialApp áp dụng theme mới
```

---

## 4. CÁC KHÁI NIỆM QUAN TRỌNG

### 4.1. Provider Pattern

**ChangeNotifier:** Class có thể thông báo thay đổi
```dart
class MyProvider extends ChangeNotifier {
  void updateData() {
    // Thay đổi dữ liệu
    notifyListeners();  // Thông báo UI cập nhật
  }
}
```

**Consumer:** Widget lắng nghe thay đổi
```dart
Consumer<MyProvider>(
  builder: (context, provider, child) {
    return Text(provider.data);  // Tự động rebuild khi có thay đổi
  }
)
```

### 4.2. Hive Database

**Cách sử dụng:**
```dart
// 1. Định nghĩa model
@HiveType(typeId: 0)
class MyModel extends HiveObject {
  @HiveField(0) String name;
}

// 2. Generate adapter
// flutter packages pub run build_runner build

// 3. Đăng ký adapter
Hive.registerAdapter(MyModelAdapter());

// 4. Mở box
var box = await Hive.openBox<MyModel>('myBox');

// 5. CRUD
box.add(item);           // Create
box.values.toList();     // Read
item.save();             // Update
item.delete();           // Delete
```

### 4.3. Form Validation

```dart
// 1. Tạo key
final _formKey = GlobalKey<FormState>();

// 2. Wrap trong Form
Form(
  key: _formKey,
  child: TextFormField(
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'Lỗi';  // Hiển thị lỗi
      }
      return null;  // Hợp lệ
    },
  ),
)

// 3. Validate
if (_formKey.currentState!.validate()) {
  // Form hợp lệ
}
```

### 4.4. Navigation

```dart
// Chuyển màn hình
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => NewScreen()),
);

// Quay lại
Navigator.pop(context);
```

---

## 5. CÁCH CHẠY DỰ ÁN

### Bước 1: Cài đặt dependencies
```bash
flutter pub get
```

### Bước 2: Generate code cho Hive
```bash
flutter packages pub run build_runner build --delete-conflicting-outputs
```

### Bước 3: Chạy app
```bash
flutter run
```

---

## 6. CẤU TRÚC DỮ LIỆU

### TransactionModel
```
{
  id: "1699999999999",
  name: "Ăn trưa",
  amount: 50000,
  date: DateTime(2024, 11, 25),
  category: "Ăn uống",
  isIncome: false
}
```

### Hive Storage
```
transactions.hive (Box)
├── Transaction 1
├── Transaction 2
└── Transaction 3

settings.hive (Box)
└── isDarkMode: true/false
```

---

## 7. TÍNH NĂNG CHÍNH

✅ **Quản lý giao dịch**
- Thêm giao dịch (thu/chi)
- Xem danh sách nhóm theo ngày
- Xóa giao dịch

✅ **Thống kê**
- Tổng số dư
- Tổng thu nhập
- Tổng chi tiêu
- Chi tiêu theo danh mục
- Chi tiêu theo tháng

✅ **Biểu đồ**
- Biểu đồ tròn (chi theo danh mục)
- Biểu đồ cột (chi theo tháng)

✅ **Khác**
- Lưu trữ offline
- Chế độ sáng/tối
- Form validation
- Dữ liệu mẫu

---

## 8. KẾT LUẬN

Ứng dụng sử dụng kiến trúc **MVVM** với **Provider** để quản lý state, **Hive** để lưu trữ offline, và **fl_chart** để hiển thị biểu đồ. Code được tổ chức rõ ràng theo từng layer, dễ bảo trì và mở rộng.

**Điểm mạnh:**
- Code sạch, dễ đọc
- Tách biệt logic và UI
- Hiệu năng tốt với Hive
- UI hiện đại với Material 3

**Có thể mở rộng:**
- Thêm tính năng tìm kiếm
- Export dữ liệu ra Excel
- Thêm nhiều loại biểu đồ
- Đồng bộ cloud
- Thêm ngân sách hàng tháng
