import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/restaurant_provider.dart';
import '../../widgets/restaurant_card.dart';
import '../restaurant/restaurant_detail_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nhà hàng'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthProvider>().signOut();
            },
          ),
        ],
      ),
      body: Consumer<RestaurantProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.errorMessage != null) {
            return Center(
              child: Text('Lỗi: ${provider.errorMessage}'),
            );
          }

          if (provider.restaurants.isEmpty) {
            return const Center(
              child: Text('Chưa có nhà hàng nào'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: provider.restaurants.length,
            itemBuilder: (context, index) {
              final restaurant = provider.restaurants[index];
              return RestaurantCard(
                restaurant: restaurant,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RestaurantDetailPage(restaurant: restaurant),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
