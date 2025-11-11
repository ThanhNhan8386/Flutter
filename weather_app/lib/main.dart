import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ứng dụng Thời tiết',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const WeatherScreen(),
    );
  }
}

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final TextEditingController _controller = TextEditingController();
  Map<String, dynamic>? _weatherData;
  bool _isLoading = false;
  String? _errorMessage;
  String apiKey = '7e343d8b4f74c4d94b71fab19968bd24'; // 🔑 API Key OpenWeatherMap

  @override
  void initState() {
    super.initState();
    _loadLastCity();
  }

  // 👉 Load lại thành phố đã lưu bằng SharedPreferences
  Future<void> _loadLastCity() async {
    final prefs = await SharedPreferences.getInstance();
    final lastCity = prefs.getString('last_city');
    if (lastCity != null) {
      _controller.text = lastCity;
      _fetchWeather(lastCity);
    }
  }

  // 👉 Gọi API OpenWeatherMap
  Future<void> _fetchWeather(String cityName) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final url =
        'https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiKey&units=metric&lang=vi';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _weatherData = data;
        });

        // Lưu lại thành phố
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('last_city', cityName);
      } else if (response.statusCode == 404) {
        setState(() {
          _errorMessage = 'Không tìm thấy thành phố "$cityName".';
        });
      } else {
        setState(() {
          _errorMessage = 'Lỗi máy chủ (${response.statusCode}).';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Lỗi mạng: không thể tải dữ liệu.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // 👉 Giao diện
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🌤️ Ứng dụng Thời tiết')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Ô nhập tên thành phố
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Nhập tên thành phố',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            // Nút tìm kiếm
            ElevatedButton(
              onPressed: () {
                FocusScope.of(context).unfocus();
                _fetchWeather(_controller.text.trim());
              },
              child: const Text('Xem thời tiết'),
            ),
            const SizedBox(height: 20),

            // FutureBuilder giả lập
            if (_isLoading)
              const CircularProgressIndicator()
            else if (_errorMessage != null)
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red),
              )
            else if (_weatherData != null)
              _buildWeatherInfo(),
          ],
        ),
      ),
    );
  }

  // 👉 Hiển thị thông tin thời tiết
  Widget _buildWeatherInfo() {
    final city = _weatherData!['name'];
    final temp = _weatherData!['main']['temp'];
    final humidity = _weatherData!['main']['humidity'];
    final description = _weatherData!['weather'][0]['description'];
    final iconCode = _weatherData!['weather'][0]['icon'];

    return Card(
      margin: const EdgeInsets.only(top: 10),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(city,
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Image.network(
              'https://openweathermap.org/img/wn/$iconCode@2x.png',
              width: 100,
              height: 100,
            ),
            Text('$temp°C',
                style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
            Text(description,
                style: const TextStyle(fontSize: 18, color: Colors.grey)),
            const SizedBox(height: 10),
            Text('Độ ẩm: $humidity%', style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
