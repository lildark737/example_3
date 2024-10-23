import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ProductListScreen(),
    );
  }
}

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

// Модель товара
class Product {
  final String name;
  final double price;
  final IconData icon;
  int availableQuantity; // Доступное количество товаров в магазине
  int cartQuantity; // Количество товара в корзине

  Product({
    required this.name,
    required this.price,
    required this.icon,
    this.availableQuantity = 10,
    this.cartQuantity = 0,
  });
}

class _ProductListScreenState extends State<ProductListScreen> {
  List<Product> products = [
    Product(name: 'Пицца', price: 800.0, icon: Icons.local_pizza),
    Product(name: 'Кофе', price: 300.0, icon: Icons.local_cafe),
    Product(name: 'Мороженое', price: 500.0, icon: Icons.icecream),
    Product(name: 'Фастфуд', price: 700.0, icon: Icons.fastfood),
    Product(name: 'Напиток', price: 250.0, icon: Icons.local_drink),
  ];

  // Метод увеличения количества товара в корзине
  void incrementCartQuantity(Product product) {
    setState(() {
      if (product.availableQuantity > 0) {
        product.cartQuantity += 1;
        product.availableQuantity -= 1;
      }
    });
  }

  // Метод уменьшения количества товара в корзине
  void decrementCartQuantity(Product product) {
    setState(() {
      if (product.cartQuantity > 0) {
        product.cartQuantity -= 1;
        product.availableQuantity += 1;
      }
    });
  }

  // Подсчёт общего количества товаров в корзине
  int getTotalCartItems() {
    int totalItems = 0;
    for (var product in products) {
      totalItems += product.cartQuantity;
    }
    return totalItems;
  }

  // Подсчёт общей стоимости товаров в корзине
  double getTotalCartPrice() {
    double totalPrice = 0;
    for (var product in products) {
      totalPrice += product.price * product.cartQuantity;
    }
    return totalPrice;
  }

  // Отдельный метод для создания элемента списка товара
  Widget buildProductItem(Product product) {
    return ListTile(
      leading:
          Icon(product.icon, size: 40, color: Colors.blue), // Иконка товара
      title: Text(product.name),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              'Цена: ${product.price.toStringAsFixed(2)} ₽'), // Цена товара в рублях
          Text(
              'В наличии: ${product.availableQuantity}'), // Доступное количество товара в магазине
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Кнопка уменьшения количества товара в корзине
          IconButton(
            icon: const Icon(Icons.remove_circle),
            onPressed: () => decrementCartQuantity(product),
          ),
          // Отображение количества товара в корзине
          Text(product.cartQuantity.toString()),
          // Кнопка увеличения количества товара в корзине
          IconButton(
            icon: const Icon(Icons.add_circle),
            onPressed: () => incrementCartQuantity(product),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Товары'),
        actions: [
          // Отображение количества товаров и общей суммы в корзине
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Сумма: ${getTotalCartPrice().toStringAsFixed(2)} ₽'),
                  Text('Товары: ${getTotalCartItems()}'),
                ],
              ),
            ),
          ),
          const Icon(Icons.shopping_cart),
        ],
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return buildProductItem(
              product); // Вызов метода для создания элемента списка
        },
      ),
    );
  }
}
