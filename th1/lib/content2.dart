import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Content2Screen extends StatefulWidget {
  const Content2Screen({super.key});

  @override
  State<Content2Screen> createState() => _Content2ScreenState();
}

class _Content2ScreenState extends State<Content2Screen> {
  final TextEditingController _cityController = TextEditingController();
  final String _apiKey = '7e343d8b4f74c4d94b71fab19968bd24';
  Map<String, dynamic>? _weatherData;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadLastCity();
  }

  // Tải thành phố cuối cùng từ SharedPreferences
  Future<void> _loadLastCity() async {
    final prefs = await SharedPreferences.getInstance();
    final lastCity = prefs.getString('last_city');
    if (lastCity != null && lastCity.isNotEmpty) {
      _cityController.text = lastCity;
      _fetchWeather(lastCity);
    }
  }

  // Lưu thành phố vào SharedPreferences
  Future<void> _saveCity(String city) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('last_city', city);
  }

  // Gọi API thời tiết
  Future<void> _fetchWeather(String city) async {
    if (city.trim().isEmpty) {
      setState(() {
        _errorMessage = 'Vui lòng nhập tên thành phố';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _weatherData = null;
    });

    try {
      final url = Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$_apiKey&units=metric&lang=vi');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _weatherData = data;
          _isLoading = false;
        });
        await _saveCity(city);
      } else if (response.statusCode == 404) {
        setState(() {
          _errorMessage = 'Không tìm thấy thành phố "$city"';
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Lỗi khi tải dữ liệu thời tiết';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Lỗi kết nối mạng. Vui lòng kiểm tra internet.';
        _isLoading = false;
      });
    }
  }

  // Lấy icon thời tiết
  IconData _getWeatherIcon(String? main) {
    switch (main?.toLowerCase()) {
      case 'clear':
        return Icons.wb_sunny;
      case 'clouds':
        return Icons.cloud;
      case 'rain':
      case 'drizzle':
        return Icons.umbrella;
      case 'thunderstorm':
        return Icons.flash_on;
      case 'snow':
        return Icons.ac_unit;
      case 'mist':
      case 'fog':
        return Icons.cloud_queue;
      default:
        return Icons.wb_cloudy;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thời tiết'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // TextField nhập thành phố
            TextField(
              controller: _cityController,
              decoration: InputDecoration(
                labelText: 'Nhập tên thành phố',
                hintText: 'Ví dụ: Hanoi, Ho Chi Minh',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.location_city),
              ),
              onSubmitted: (value) => _fetchWeather(value),
            ),
            const SizedBox(height: 16),

            // Nút tìm kiếm
            ElevatedButton.icon(
              onPressed: () => _fetchWeather(_cityController.text),
              icon: const Icon(Icons.search),
              label: const Text('Tìm kiếm'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Hiển thị trạng thái
            if (_isLoading)
              const Center(
                child: CircularProgressIndicator(),
              )
            else if (_errorMessage != null)
              Card(
                color: Colors.red.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, color: Colors.red),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else if (_weatherData != null)
              _buildWeatherCard()
            else
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: Column(
                    children: [
                      Icon(Icons.cloud_outlined, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'Nhập tên thành phố để xem thời tiết',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Widget hiển thị thông tin thời tiết
  Widget _buildWeatherCard() {
    final temp = _weatherData!['main']['temp'].toStringAsFixed(1);
    final feelsLike = _weatherData!['main']['feels_like'].toStringAsFixed(1);
    final humidity = _weatherData!['main']['humidity'];
    final description = _weatherData!['weather'][0]['description'];
    final cityName = _weatherData!['name'];
    final country = _weatherData!['sys']['country'];
    final weatherMain = _weatherData!['weather'][0]['main'];
    final windSpeed = _weatherData!['wind']['speed'];
    final pressure = _weatherData!['main']['pressure'];

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Tên thành phố
            Text(
              '$cityName, $country',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            // Icon và mô tả thời tiết
            Icon(
              _getWeatherIcon(weatherMain),
              size: 80,
              color: Colors.orange,
            ),
            const SizedBox(height: 8),
            Text(
              description.toUpperCase(),
              style: const TextStyle(
                fontSize: 18,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),

            // Nhiệt độ chính
            Text(
              '$temp°C',
              style: const TextStyle(
                fontSize: 64,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            Text(
              'Cảm giác như $feelsLike°C',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 24),

            // Thông tin chi tiết
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildInfoRow(Icons.water_drop, 'Độ ẩm', '$humidity%'),
                  const Divider(height: 24),
                  _buildInfoRow(Icons.air, 'Tốc độ gió', '$windSpeed m/s'),
                  const Divider(height: 24),
                  _buildInfoRow(Icons.speed, 'Áp suất', '$pressure hPa'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget hiển thị một hàng thông tin
  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.blue),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }
}
