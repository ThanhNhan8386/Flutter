import 'package:flutter/material.dart';

// ---------------------- MODEL ----------------------
class Recipe {
  final String name;
  final String image;
  final String description;
  final List<String> ingredients;
  final List<String> steps;

  Recipe({
    required this.name,
    required this.image,
    required this.description,
    required this.ingredients,
    required this.steps,
  });
}

// ---------------------- DỮ LIỆU MẪU ----------------------
final List<Recipe> recipes = [
  Recipe(
    name: 'Phở Bò Truyền Thống',
    image: 'image/photruyenthong.jpg',
    description: 'Món ăn quốc hồn quốc túy của Việt Nam, thơm ngon, đậm đà.',
    ingredients: [
      '500g thịt bò',
      '1kg xương bò',
      'Bánh phở',
      'Gừng, hành tím, quế, hồi',
      'Nước mắm, muối, tiêu'
    ],
    steps: [
      'Hầm xương bò với gừng và hành trong 2 giờ để lấy nước dùng.',
      'Chần bánh phở và thịt bò.',
      'Cho phở, thịt vào tô và chan nước dùng nóng lên.',
      'Thêm hành, tiêu, chanh và ớt theo khẩu vị.'
    ],
  ),
  Recipe(
    name: 'Cơm Chiên Dương Châu',
    image: 'image/comchienduogndau.jpg',
    description: 'Món cơm chiên thơm ngon, đủ vị với trứng, tôm, xúc xích.',
    ingredients: [
      '2 chén cơm nguội',
      '2 quả trứng gà',
      'Tôm bóc vỏ',
      'Xúc xích, cà rốt, đậu Hà Lan',
      'Dầu ăn, nước tương'
    ],
    steps: [
      'Phi thơm hành, cho tôm và xúc xích vào xào.',
      'Cho cơm và rau củ vào đảo đều.',
      'Thêm trứng và nước tương, chiên đến khi vàng đều.',
      'Dọn ra đĩa, rắc hành lá.'
    ],
  ),
  Recipe(
    name: 'Bánh Pancake Mật Ong',
    image: 'image/banhpancakematong.jpg',
    description: 'Bánh mềm xốp, thơm vị bơ và mật ong, phù hợp bữa sáng.',
    ingredients: [
      '200g bột mì',
      '2 quả trứng gà',
      '200ml sữa tươi',
      '1 muỗng cà phê bơ chảy',
      'Mật ong'
    ],
    steps: [
      'Trộn bột mì, trứng và sữa thành hỗn hợp mịn.',
      'Đun chảo chống dính, cho bơ chảy vào.',
      'Đổ bột vào chảo, chiên vàng hai mặt.',
      'Rưới mật ong lên và thưởng thức.'
    ],
  ),
];

// ---------------------- MÀN HÌNH DANH SÁCH ----------------------
class RecipeListScreen extends StatelessWidget {
  const RecipeListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Công thức Nấu ăn')),
      body: ListView.builder(
        itemCount: recipes.length,
        itemBuilder: (context, index) {
          final recipe = recipes[index];
          return RecipeCard(recipe: recipe);
        },
      ),
    );
  }
}

// ---------------------- WIDGET RECIPE ITEM ----------------------
class RecipeCard extends StatelessWidget {
  final Recipe recipe;

  const RecipeCard({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(recipe.image,
              width: 60, height: 60, fit: BoxFit.cover),
        ),
        title:
            Text(recipe.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(recipe.description,
            maxLines: 2, overflow: TextOverflow.ellipsis),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => RecipeDetailScreen(recipe: recipe),
            ),
          );
        },
      ),
    );
  }
}

// ---------------------- MÀN HÌNH CHI TIẾT ----------------------
class RecipeDetailScreen extends StatelessWidget {
  final Recipe recipe;

  const RecipeDetailScreen({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(recipe.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(recipe.image),
            ),
            const SizedBox(height: 16),
            Text(recipe.name,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            const Text("Nguyên liệu:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            ...recipe.ingredients.map((ing) => Text('• $ing')),
            const SizedBox(height: 16),
            const Text("Các bước thực hiện:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            ...recipe.steps
                .asMap()
                .entries
                .map((e) => Text('${e.key + 1}. ${e.value}'))
                .toList(),
          ],
        ),
      ),
    );
  }
}
