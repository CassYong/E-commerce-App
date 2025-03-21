import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'favorite_screen.dart';
import 'cart_screen.dart';
import 'profile_screen.dart';
import 'categories_screen.dart';
import 'product_screen.dart';
import 'package:app_project/services/favorite_service.dart';
import 'package:app_project/models/product_model.dart';
import 'notification_icon.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.asset(
                  'assets/icons/logo.png',
                  height: 30, // Adjust the height to fit your design
                ),
                const SizedBox(
                    width: 8), // Add some spacing between the logo and title
                const Text(
                  'ArtBox',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            const NotificationsIcon(),
          ],
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(
              left: 0.0, right: 0.0, top: 5.0, bottom: 10.0),
          children: [
            const SizedBox(height: 10),
            const GreetingBanner(),
            const SizedBox(height: 16),
            const CategoriesWidget(),
            const SizedBox(height: 16),
            FlashSaleWidget(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite), label: 'Favorites'),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), label: 'Cart'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: 0, // Default selected index
        selectedItemColor:
            const Color.fromARGB(255, 96, 184, 183), // Selected icon color
        unselectedItemColor: Colors.grey, // Unselected icon color
        onTap: (index) {
          switch (index) {
            case 0:
              break;
            case 1:
              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      const FavoriteScreen(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    const begin = Offset(0.0, 1.0);
                    const end = Offset.zero;
                    const curve = Curves.easeInOut;

                    var tween = Tween(begin: begin, end: end)
                        .chain(CurveTween(curve: curve));
                    var offsetAnimation = animation.drive(tween);

                    return SlideTransition(
                        position: offsetAnimation, child: child);
                  },
                ),
              );
              break;
            case 2:
              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      const CartScreen(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    const begin = Offset(0.0, 1.0);
                    const end = Offset.zero;
                    const curve = Curves.easeInOut;

                    var tween = Tween(begin: begin, end: end)
                        .chain(CurveTween(curve: curve));
                    var offsetAnimation = animation.drive(tween);

                    return SlideTransition(
                        position: offsetAnimation, child: child);
                  },
                ),
              );
              break;
            case 3:
              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      const ProfileScreen(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    const begin = Offset(0.0, 1.0);
                    const end = Offset.zero;
                    const curve = Curves.easeInOut;

                    var tween = Tween(begin: begin, end: end)
                        .chain(CurveTween(curve: curve));
                    var offsetAnimation = animation.drive(tween);

                    return SlideTransition(
                        position: offsetAnimation, child: child);
                  },
                ),
              );
              break;
          }
        },
        showSelectedLabels: true, // Always show selected labels
        showUnselectedLabels: true, // Always show unselected labels
      ),
    );
  }
}

class GreetingBanner extends StatelessWidget {
  const GreetingBanner({super.key});

  @override
  Widget build(BuildContext context) {
    // Retrieve the current user
    final User? user = FirebaseAuth.instance.currentUser;
    final String email = user?.email ?? 'Guest';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0), // Set padding here
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          gradient: const LinearGradient(
            colors: [Color(0xFFC5DBD6), Color(0xFFB4D7D2), Color(0xFFA3D5D4)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.0, 0.49, 1.0],
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Hello, ',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              email,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const Text(
              '!',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoriesWidget extends StatelessWidget {
  const CategoriesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 8),
        Padding(
          padding: EdgeInsets.only(
              left: 20.0), // Padding only for the "Categories" text
          child: Text(
            'Categories',
            style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold), // Updated font size to 27px
          ),
        ),
        SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              SizedBox(width: 20),
              CategoryCircleButton(
                  imagePath: 'assets/images/2025 Soft PU Leather planner.png',
                  label: 'Planners'),
              SizedBox(width: 20),
              CategoryCircleButton(
                  imagePath: 'assets/images/Macaron Minimalist Notebook.png',
                  label: 'Books'),
              SizedBox(width: 15),
              CategoryCircleButton(
                  imagePath: 'assets/images/DOMI 0.5mm ST Nib Pen.png',
                  label: 'Writing Tools'),
              SizedBox(width: 15),
              CategoryCircleButton(
                  imagePath: 'assets/images/FKILA Watercolor Pigment.png',
                  label: 'Art Supplies'),
              SizedBox(width: 15),
              CategoryCircleButton(
                  imagePath: 'assets/images/Crochet Knitting Yarn.png',
                  label: 'Crafting'),
              SizedBox(width: 15),
              CategoryCircleButton(
                  imagePath:
                      'assets/images/Cartoon Puzzle Diamond Sticker Kit.png',
                  label: 'Creative Kits'),
              SizedBox(width: 20),
            ],
          ),
        ),
      ],
    );
  }
}

class CategoryCircleButton extends StatelessWidget {
  final String imagePath;
  final String label;

  const CategoryCircleButton({
    super.key,
    required this.imagePath,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to the CategoriesScreen when the button is tapped
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoriesScreen(initialCategory: label),
          ),
        );
      },
      child: Column(
        children: [
          CircleAvatar(
            radius: 34,
            backgroundColor:
                const Color.fromARGB(255, 206, 197, 219), // Light grey color
            child: ClipOval(
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                width: 60,
                height: 60,
                errorBuilder: (BuildContext context, Object exception,
                    StackTrace? stackTrace) {
                  return const Icon(Icons.error, color: Colors.red, size: 30);
                },
              ),
            ),
          ),
          const SizedBox(height: 5),
          Text(label, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}

class FlashSaleWidget extends StatelessWidget {
  FlashSaleWidget({super.key});

  final List<Map<String, dynamic>> flashSaleItems = [
    {
      'id': 'p2',
      'imagePath': 'assets/images/2025 A4 Agenda Planner.png',
      'name': '2025 A4 Agenda Planner',
      'originalPrice': 10.00,
      'salePrice': 5.00,
      'details':
          "The flower color printing process is bright and clear, and the cover color printing and film covering pattern is clear and clear.",
    },
    {
      'id': 'p3',
      'imagePath': 'assets/images/2025 Soft PU Leather planner.png',
      'name': '2025 Soft PU Leather Planner',
      'originalPrice': 20.00,
      'salePrice': 25.00,
      'details':
          'From January to December, this planner covers an entire year, allowing you to plan every day in advance. Each days page provides you with enough space to arrange your schedule, plans and goals, ensuring that your every day is organized. Multifunctional design: integrates calendar, schedule, planner, diary and school diary to meet your multiple needs.',
    },
    {
      'id': 'p8',
      'imagePath': 'assets/images/Planwith 2025 Schedule Book.png',
      'name': 'Planwith 2025 Schedule Book',
      'originalPrice': 40.00,
      'salePrice': 35.00,
      'details':
          'Our paper is soft and thick, and uses high-quality raw wood pulp, which can bring you a better create experience.',
    },

    {
      'id': 'b8',
      'imagePath': 'assets/images/Macaron Minimalist Notebook.png',
      'name': 'Macaron Minimalist Notebook',
      'originalPrice': 7.30,
      'salePrice': 6.50,
      'details':
          '⦿ 256pgs A5 Thick Macaron Minimalist Notebook ⦿ 256 pages or 128sheets with 70gm paper ⦿ 4 colors available ⦿ 2 different type of inner to choose, line or blank',
    },
    {
      'id': 'w1',
      'imagePath': 'assets/images/1PCS Gel Pen 0.5mm.png',
      'name': '1PCS Gel Pen 0.5mm',
      'originalPrice': 2.00,
      'salePrice': 1.99,
      'details':
          '1.Name: Bullet Refill & Gel Pen 2.Product Material: Plastic + Ink 3.Ink Color: Black / Blue / Red 4.Refill replaceable: Yes',
    },
    {
      'id': 'w3',
      'imagePath': 'assets/images/Sanrio Kuromi 10 Color Pen.png',
      'name': 'Sanrio Kuromi 10 Color Pen',
      'originalPrice': 3.00,
      'salePrice': 2.79,
      'details':
          'Get ready to unleash your creativity with this super-cute 10-color pen! Its adorable topper will make writing a joy, while the vibrant ink colors will inspire you to dream up new and exciting ideas.',
    },
    {
      'id': 'w5',
      'imagePath': 'assets/images/Kapibara Blue Erasable Pen.png',
      'name': 'Kapibara Blue Erasable Pen',
      'originalPrice': 2.10,
      'salePrice': 1.99,
      'details':
          'Bring a smile to your day with these adorable Kapibara pens! Their unique design and blue erasable ink make them the perfect writing tool for students and artists.',
    },
    {
      'id': 'w7',
      'imagePath': 'assets/images/6 Piecesset Signature Pen.png',
      'name': '6 Pieces/set Signature Pen',
      'originalPrice': 10.80,
      'salePrice': 9.99,
      'details':
          'gift box packing, or opp bag for each unit then packed by bubble seal and cartons.KeywordGel Ink Pen :0.5 Single package size:16.2X8X1 cm Single gross weight:0.060 kg',
    },
    {
      'id': 'a8',
      'imagePath': 'assets/images/3 in 1 Brush Washing Bucket.png',
      'name': '3 in 1 Brush Washing Bucket',
      'originalPrice': 25.00,
      'salePrice': 24.99,
      'details':
          'Multi functional three piece pen washing bucket with color mixing plate, gouache, watercolor, acrylic oil painting pen washing bucket',
    },
    {
      'id': 'a10',
      'imagePath':
          'assets/images/MIYA Himi 56 Colors Jelly Gouache Water Colour.png',
      'name': 'MIYA Himi 56 Colors Jelly Gouache Water Colour ',
      'originalPrice': 150.00,
      'salePrice': 149.00,
      'details':
          'High Quality Pigment — All paints are thick, creamy and vibrant. It does not become muddy and can be reactivated with water when the paint dries. Unique Jelly Cup Design ',
    },
    {
      'id': 'c1',
      'imagePath': 'assets/images/Blue Series Soft Plush Ball.png',
      'name': 'Blue Series Soft Plush Ball',
      'originalPrice': 2.00,
      'salePrice': 1.99,
      'details': 'Color: Blue , white  Uses: DIY Making Handmade Accessories',
    },
    {
      'id': 'ck1',
      'imagePath': 'assets/images/DIY Mosaic Coaster Making Kit.png',
      'name': 'DIY Mosaic Coaster Making Kit',
      'originalPrice': 12.00,
      'salePrice': 11.40,
      'details':
          'All DIY By yourself: The design and making process is simple and easy to have crafting time with kids, family, friends, and love one.',
    },
    // Add more items as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: 20.0), // Padding for the Flash Sale section
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          const Row(
            children: [
              Text(
                'Flash Sale',
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
              ),
              Spacer(),
            ],
          ),
          const SizedBox(height: 10),
          GridView.builder(
            shrinkWrap: true, // Allows GridView to fit within the ListView
            physics:
                const NeverScrollableScrollPhysics(), // Disable inner scrolling
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Two items per row
              crossAxisSpacing: 16, // Space between columns
              mainAxisSpacing: 16, // Space between rows
              childAspectRatio:
                  3 / 4, // Adjust this to fit your item's aspect ratio
            ),
            itemCount: flashSaleItems
                .length, // Dynamically set the item count based on the list
            itemBuilder: (context, index) {
              final item = flashSaleItems[index];
              return FlashSaleItem(
                id: item['id'],
                imagePath: item['imagePath'],
                name: item['name'],
                originalPrice: item['originalPrice'],
                salePrice: item['salePrice'],
                details: item['details'],
              );
            },
          ),
        ],
      ),
    );
  }
}

class FlashSaleItem extends StatefulWidget {
  final String id;
  final String imagePath;
  final String name;
  final double originalPrice;
  final double salePrice;
  final String details;

  const FlashSaleItem({
    super.key,
    required this.id,
    required this.imagePath,
    required this.name,
    required this.originalPrice,
    required this.salePrice,
    required this.details,
  });

  @override
  _FlashSaleItemState createState() => _FlashSaleItemState();
}

class _FlashSaleItemState extends State<FlashSaleItem> {
  bool isLiked = false;
  late Future<FavoriteService> _favoriteServiceFuture;

  @override
  void initState() {
    super.initState();
    _favoriteServiceFuture = _initializeFavoriteService();
  }

  Future<FavoriteService> _initializeFavoriteService() async {
    final service = FavoriteService();
    final favorites = await service.getFavorites();
    setState(() {
      isLiked = favorites.any((product) => product.name == widget.name);
    });
    return service;
  }

  Future<void> _toggleFavorite(FavoriteService service) async {
    final product = Product(
      id: widget.id, // Ensure you pass the unique id here
      imagePath: widget.imagePath,
      name: widget.name,
      price: widget.originalPrice,
      salePrice: widget.salePrice,
      details: widget.details,
    );

    if (isLiked) {
      await service.removeFavorite(product);
    } else {
      await service.saveFavorite(product);
    }

    setState(() {
      isLiked = !isLiked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FavoriteService>(
      future: _favoriteServiceFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        if (snapshot.hasError) {
          return const Center(child: Text('Error initializing favorites'));
        }

        final service = snapshot.data!;

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductScreen(
                  id: widget.id, // Ensure you pass the unique id here
                  imagePath: widget.imagePath,
                  name: widget.name,
                  originalPrice: widget.originalPrice,
                  salePrice: widget.salePrice,
                  details: widget.details,
                ),
              ),
            );
          },
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Image
                  Container(
                    height: 160,
                    width: 178,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: AssetImage(widget.imagePath),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8), // Space between image and text
                  // Product Name
                  Text(
                    widget.name,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w500),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  const SizedBox(height: 4), // Space between name and prices
                  // Prices
                  Row(
                    children: [
                      Text(
                        'RM${widget.salePrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'RM${widget.originalPrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              // Love Icon
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: Icon(
                      isLiked ? Icons.favorite : Icons.favorite_border,
                      color: isLiked ? Colors.red : Colors.grey,
                    ),
                    onPressed: () => _toggleFavorite(service),
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
