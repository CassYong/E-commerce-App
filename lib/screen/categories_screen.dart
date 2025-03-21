import 'package:flutter/material.dart';
import 'package:app_project/models/product_model.dart';
import 'package:app_project/services/favorite_service.dart';
import 'product_screen.dart';

class CategoriesScreen extends StatefulWidget {
  final String initialCategory;

  const CategoriesScreen({super.key, required this.initialCategory});

  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  late String selectedCategory;

  @override
  void initState() {
    super.initState();
    selectedCategory = widget.initialCategory;
  }

  final Map<String, List<Map<String, dynamic>>> categoryItems = {
    'Planners': [
      {
        'id': 'p1',
        'imagePath': 'assets/images/2025 Planner A5 Notebook.png',
        'name': '2025 Planner A5 Notebook',
        'price': 10.00,
        'details':
            'From January to December, this planner covers an entire year, allowing you to plan every day in advance. Each da page provides you with enough space to arrange your schedule, plans and goals, ensuring that your every day is organized. Multifunctional design: integrates calendar, schedule, planner, diary and school diary to meet your multiple needs.',
      },
      {
        'id': 'p2',
        'imagePath': 'assets/images/2025 A4 Agenda Planner.png',
        'name': '2025 A4 Agenda Planner',
        'price': 10.00,
        'salePrice': 5.00,
        'details':
            'The flower color printing process is bright and clear, and the cover color printing and film covering pattern is clear and clear.',
      },
      {
        'id': 'p3',
        'imagePath': 'assets/images/2025 Soft PU Leather planner.png',
        'name': '2025 Soft PU Leather Planner',
        'price': 20.00,
        'salePrice': 25.00,
        'details':
            'From January to December, this planner covers an entire year, allowing you to plan every day in advance. Each days page provides you with enough space to arrange your schedule, plans and goals, ensuring that your every day is organized. Multifunctional design: integrates calendar, schedule, planner, diary and school diary to meet your multiple needs.',
      },
      {
        'id': 'p4',
        'imagePath': 'assets/images/LUMINISCENCIA Diary Weekly Planner.png',
        'name': 'LUMINISCENCIA Diary Weekly Planner ',
        'price': 29.99,
        'details':
            'The Planner Notepad is ideal for students, travelers, office workers and teachers. Its simple and fashionable appearance makes it favorite among people.',
      },
      {
        'id': 'p5',
        'imagePath': 'assets/images/2025 Planner Spiral Notebook.png',
        'name': '2025 Planner Spiral Notebook',
        'price': 7.00,
        'details':
            'High quality hard cover planner note book.Eco-friendly paper, good for eyes.Smooth writing, 180 degree spread out.',
      },
      {
        'id': 'p6',
        'imagePath': 'assets/images/Starry Sky 12 Months Planner.png',
        'name': 'Starry Sky 12 Months Planner',
        'price': 12.00,
        'details':
            'Calendar, monthly planner, daily diary&check list, square grid pages, blank pages.',
      },
      {
        'id': 'p7',
        'imagePath': 'assets/images/2025 Little Bear Agenda Planner.png',
        'name': '2025 Little Bear Agenda Planner',
        'price': 25.00,
        'details':
            'You can use it to write, draw, make account, make notes, and as a gift to yourself and friends are good choices.',
      },
      {
        'id': 'p8',
        'imagePath': 'assets/images/Planwith 2025 Schedule Book.png',
        'name': 'Planwith 2025 Schedule Book ',
        'price': 40.00,
        'salePrice': 35.00,
        'details':
            'Our paper is soft and thick, and uses high-quality raw wood pulp, which can bring you a better create experience.',
      },
    ],
    'Books': [
      {
        'id': 'b1',
        'imagePath': 'assets/images/Mini Notebook.png',
        'name': 'Mini Notebook',
        'price': 2.50,
        'salePrice': 1.99,
        'details':
            'Creative, Cute Cartoon, Rich Patterns, Delicate Paper, Thick Inner Pages With cartoon and rich patterns, this notebook has adorable and funny look. -This product is suitable for student, school, office supplies and so on.',
      },
      {
        'id': 'b2',
        'imagePath': 'assets/images/Cute Cartoon Mini Coil Notebook.png',
        'name': 'Cute Cartoon Mini Coil Notebook',
        'price': 1.50,
        'details':
            '⦿ Material: Paper ⦿ Number Of Page: 80 Pages ⦿ Product Dimension: Approx 10.5cm x 8cm x 1cm ⦿ Weight: Approx 44g Office Tools',
      },
      {
        'id': 'b4',
        'imagePath': 'assets/images/B5 Binder Loose-Leaf Notebook.png',
        'name': 'B5 Binder Loose-Leaf Notebook',
        'price': 9.00,
        'details':
            'Product Material:  Paper + Cloth hardcover. Product Size: 20*13cm Color: Black Weight: 305g Feature: Elastic rubber bind. Package Condition:We use a bubble bag to wrap the product tightly to avoid damage during transportation.',
      },
      {
        'id': 'b5',
        'imagePath': 'assets/images/Dotted Notebook.png',
        'name': 'Dotted Notebook',
        'price': 8.90,
        'details':
            '[ 100% original ] We promise all our products are 100% original from the manufacturer & we have authorized distributors for the most famous brand.',
      },
      {
        'id': 'b6',
        'imagePath': 'assets/images/Soft Pastel Color Binder Notebook.png',
        'name': 'Soft Pastel Color Binder Notebook',
        'price': 3.60,
        'details':
            '[ 100% original ] We promise all our products are 100% original from the manufacturer & we have authorized distributors for the most famous brand.',
      },
      {
        'id': 'b7',
        'imagePath': 'assets/images/A5 Blank Paper Notebook.png',
        'name': 'A5 Blank Paper Notebook',
        'price': 1.80,
        'details':
            'A5 Kraft Notebook is another high-quality product which suit the local need of sketching. The notebook makes of 70gsm paper.',
      },
      {
        'id': 'b8',
        'imagePath': 'assets/images/Macaron Minimalist Notebook.png',
        'name': 'Macaron Minimalist Notebook',
        'price': 7.30,
        'salePrice': 6.50,
        'details':
            '⦿ 256pgs A5 Thick Macaron Minimalist Notebook ⦿ 256 pages or 128sheets with 70gm paper ⦿ 4 colors available ⦿ 2 different type of inner to choose, line or blank',
      },
      {
        'id': 'b9',
        'imagePath': 'assets/images/Blank Grid Hardcover notebook.png',
        'name': 'Blank Grid Hardcover Notebook',
        'price': 12.00,
        'details':
            '🔷Material: PP+Paper 🔷Inner Pages: Horizontal Lines 🔷Size: 142*209mm(A5)/175*251mm(B5) 🔷Weight: Approximately 150-210g',
      },
      {
        'id': 'b10',
        'imagePath': 'assets/images/Gradient Color Slant Flip Notebook.png',
        'name': 'Gradient Color Slant Flip Notebook',
        'price': 8.90,
        'details':
            '🔶The design is full of INS style, simple but stylish, with harmonious color matching. It is an excellent choice whether for personal use or as a gift.🔶The tilted notebook design, this innovative structure not only makes opening and closing more convenient, but also increases the fun and fashion sense of use.',
      },
      {
        'id': 'b11',
        'imagePath': 'assets/images/TACOTACO B5 Notebook.png',
        'name': 'TACOTACO B5 Notebook',
        'price': 8.00,
        'salePrice': 7.50,
        'details':
            'The above products are semi-handmade, and there will be slight differences between the products and the publicity pictures. Examples: color, pattern, shape, size, small black spots, inconspicuous depressions, etc.',
      },
    ],
    'Writing Tools': [
      {
        'id': 'w1',
        'imagePath': 'assets/images/1PCS Gel Pen 0.5mm.png',
        'name': '1PCS Gel Pen 0.5mm',
        'price': 2.00,
        'salePrice': 1.99,
        'details':
            '1.Name: Bullet Refill & Gel Pen 2.Product Material: Plastic + Ink 3.Ink Color: Black / Blue / Red 4.Refill replaceable: Yes',
      },
      {
        'id': 'w2',
        'imagePath': 'assets/images/Deli Delight Gel Pen.png',
        'name': 'Deli Delight Gel Pen',
        'price': 1.10,
        'details':
            '📌Brand: Deli 📌Smooth writing 📌Bright colors 📌Popular for artistic applications, note-taking, and creative writing 📌Reducing the likelihood of smudging or transferring to other surfaces',
      },
      {
        'id': 'w3',
        'imagePath': 'assets/images/Sanrio Kuromi 10 Color Pen.png',
        'name': 'Sanrio Kuromi 10 Color Pen',
        'price': 3.00,
        'salePrice': 2.79,
        'details':
            'Get ready to unleash your creativity with this super-cute 10-color pen! Its adorable topper will make writing a joy, while the vibrant ink colors will inspire you to dream up new and exciting ideas.',
      },
      {
        'id': 'w4',
        'imagePath': 'assets/images/Fountain Pen Retro.png',
        'name': 'Fountain Pen Retro',
        'price': 2.00,
        'details':
            'Write with elegance and ease. This ergonomic fountain pen features a comfortable grip and a smooth-flowing nib, making it perfect for everyday use.',
      },
      {
        'id': 'w5',
        'imagePath': 'assets/images/Kapibara Blue Erasable Pen.png',
        'name': 'Kapibara Blue Erasable Pen',
        'price': 2.10,
        'salePrice': 1.99,
        'details':
            'Bring a smile to your day with these adorable Kapibara pens! Their unique design and blue erasable ink make them the perfect writing tool for students and artists.',
      },
      {
        'id': 'w6',
        'imagePath': 'assets/images/INS Style Black Ink Gel Pen.png',
        'name': 'INS Style Black Ink Gel Pen',
        'price': 1.80,
        'details':
            '1. Name: Pen 2. Material: other 3. Style: Japanese and Korean 4. Size: as shown 5. Shape: as shown',
      },
      {
        'id': 'w7',
        'imagePath': 'assets/images/6 Piecesset Signature Pen.png',
        'name': '6 Pieces/set Signature Pen',
        'price': 10.80,
        'salePrice': 9.99,
        'details':
            'gift box packing, or opp bag for each unit then packed by bubble seal and cartons.KeywordGel Ink Pen :0.5 Single package size:16.2X8X1 cm Single gross weight:0.060 kg',
      },
      {
        'id': 'w8',
        'imagePath': 'assets/images/NIXXOS 6PcsSet 0.5mm.png',
        'name': 'NIXXOS 6Pcs/Set 0.5mm',
        'price': 10.00,
        'details':
            '👍Minimalist design 👍Comfortable pen grip 👍Smooth writing ⭐Ink : 0.5mm Black Ink ⭐Material : Plastic ⭐Size: 15cm±',
      },
      {
        'id': 'w9',
        'imagePath': 'assets/images/DOMI 0.5mm ST Nib Pen.png',
        'name': 'DOMI 0.5mm ST Nib Pen',
        'price': 2.45,
        'details':
            '🔹Ink Color :Black/Red/Blue 🔹Tip :ST 🔹Line Width : 0.5mm 🔹Quantity :1pcs',
      },
    ],
    'Art Supplies': [
      {
        'id': 'a1',
        'imagePath': 'assets/images/water colour 48 Colors.png',
        'name': 'Water colour 48 Colors',
        'price': 35.00,
        'details':
            '48 Colors Powder Solid Watercolor Paint Set including: 1 X 48 solid watercolours 1 X fountain pen 1 X paint brush 1 X 2B Pencil 1 X pencil sharpener 2 X sponge 1 X watercolour paper 1 X palette',
      },
      {
        'id': 'a2',
        'imagePath': 'assets/images/Tearable watercolor painting book.png',
        'name': 'Tearable watercolor painting book',
        'price': 25.00,
        'details': 'This product is 100% brand new and of superior quality',
      },
      {
        'id': 'a3',
        'imagePath': 'assets/images/Sandpaper Board.png',
        'name': 'Sandpaper Board',
        'price': 5.00,
        'details':
            'Sketching Pencil Sandpaper Board Sketching Charcoal Pencil Sharpening Sandpaper Set For Artist Art Drawing Supplies',
      },
      {
        'id': 'a4',
        'imagePath': 'assets/images/Dual Tip Watercolor Brush Pen.png',
        'name': 'Dual Tip Watercolor Brush Pen',
        'price': 24.50,
        'details':
            '👍 Dual tip pen: Soft brush & Fine tip 👍 Water-based ink, long-lasting and vibrant colors 👍 Odorless, Non-toxic 👍 Pen cap and ink are same color, easy to identify each color 👍 Ideal for drawing, sketching, calligraphy, journaling',
      },
      {
        'id': 'a5',
        'imagePath': 'assets/images/Arto A4 Sketch Pad.png',
        'name': 'Arto A4 Sketch Pad',
        'price': 6.32,
        'details':
            'Suitable for Pencil, Charcoal, Ink, Marker, Pastel, Crayon & Watercolor. Multipurpose paper for experimenting & perfecting techniques.',
      },
      {
        'id': 'a6',
        'imagePath': 'assets/images/Water-resistant Fountain Pen Ink.png',
        'name': 'Water-resistant Fountain Pen Ink',
        'price': 11.50,
        'details':
            'Water-resistant is not water-proof. Depending on the paper surface, it is possible that the ink could smear if rub hard with water before it dries up',
      },
      {
        'id': 'a7',
        'imagePath': 'assets/images/Portable Plastic Painting Box.png',
        'name': 'Portable Plastic Painting Box',
        'price': 17.40,
        'details':
            'Small and portable, easy to carry out for drawing. Enclosed with a high desity silicone gasket, it can effectively prevent the paint from drying.',
      },
      {
        'id': 'a8',
        'imagePath': 'assets/images/3 in 1 Brush Washing Bucket.png',
        'name': '3 in 1 Brush Washing Bucket',
        'price': 25.00,
        'salePrice': 24.99,
        'details':
            'Multi functional three piece pen washing bucket with color mixing plate, gouache, watercolor, acrylic oil painting pen washing bucket',
      },
      {
        'id': 'a9',
        'imagePath': 'assets/images/MIYA Water Colour Paint Set.png',
        'name': 'MIYA Water Colour Paint Set',
        'price': 43.30,
        'details':
            'Unique Jelly Cup Design & Portable Case — Upgraded jelly cups with easy removable lid keep the paint wet and creamy, only take seconds to replace when then paint runs out.',
      },
      {
        'id': 'a10',
        'imagePath':
            'assets/images/MIYA Himi 56 Colors Jelly Gouache Water Colour.png',
        'name': 'MIYA Himi 56 Colors Jelly Gouache Water Colour ',
        'price': 150.00,
        'salePrice': 149.00,
        'details':
            'High Quality Pigment — All paints are thick, creamy and vibrant. It does not become muddy and can be reactivated with water when the paint dries. Unique Jelly Cup Design ',
      },
      {
        'id': 'a11',
        'imagePath':
            'assets/images/MIYA Rhombus 36 Colors Solid Watercolor.png',
        'name': 'MIYA Rhombus 36 Colors Solid Watercolor',
        'price': 57.00,
        'details':
            'Highest quality, with an elevated concentration of finely ground top permanence rating and durability pigments, make our solid watercolor paints are durable and will not crack.',
      },
      {
        'id': 'a12',
        'imagePath': 'assets/images/Ginflash 48colors Glitter Water Color.png',
        'name': 'Ginflash 48colors Glitter Water Color',
        'price': 64.39,
        'details':
            '48colors Color Glitter Water Color Acuarelas Metallic Gold aquarela Pigment Paint Artist Painting Watercolors set paint brush.',
      },
      {
        'id': 'a13',
        'imagePath': 'assets/images/FKILA Watercolor Pigment.png',
        'name': 'FKILA Watercolor Pigment',
        'price': 25.00,
        'details':
            '1.Solid concentration makes concentrated paintings more durable. 2.Box design, depending on the specifications of the complimentary accessories. 3.Halo dyeing with overlapping colors, natural color mixing, and not easy to lose powder after drying.',
      },
    ],
    'Crafting': [
      {
        'id': 'c1',
        'imagePath': 'assets/images/Blue Series Soft Plush Ball.png',
        'name': 'Blue Series Soft Plush Ball',
        'price': 2.00,
        'salePrice': 1.99,
        'details': 'Color: Blue , white  Uses: DIY Making Handmade Accessories',
      },
      {
        'id': 'c2',
        'imagePath': 'assets/images/Ivory Series Plush Ball.png',
        'name': 'Ivory Series Plush Ball',
        'price': 1.70,
        'details': 'Uses: DIY Making Handmade Accessories',
      },
      {
        'id': 'c3',
        'imagePath': 'assets/images/30cm Chenille Stems Pipe.png',
        'name': '30cm Chenille Stems Pipe',
        'price': 5.39,
        'details':
            'Item Type: DIY Accessories Condition: 100% Brand New Material: Other Color: As Shown Size:30cm Quantity :100pcs/Bag Package Included: 100 Pipe Cleaner Toys',
      },
      {
        'id': 'c4',
        'imagePath': 'assets/images/1Roll Pearls Rhinestone Chain.png',
        'name': '1Roll Pearls Rhinestone Chain',
        'price': 2.93,
        'details':
            'Item Type: DIY Accessories Condition: 100% Brand New Material:Other Color: As Shown Size: As Shown Length :1Yard/Roll',
      },
      {
        'id': 'c5',
        'imagePath': 'assets/images/Artificial Flowers Stem Tape.png',
        'name': 'Artificial Flowers Stem Tape',
        'price': 2.34,
        'details':
            'Condition: 100% brand new Project Type: Craft Accessories, Tape Size: width 12mm Color: many colors Usage: 30 yards/roll 1.2cm wide tape is a good helper for home decoration, flower packaging, flower shop supplies, simple and stylish design makes life better.',
      },
      {
        'id': 'c6',
        'imagePath': 'assets/images/Artificial Flower Stamen Pearl.png',
        'name': 'Artificial Flower Stamen Pearl',
        'price': 1.60,
        'details':
            'Use place: wedding, home decoration, school DIY class, etc., can be used for wedding flowers, garlands, corsages, flower ornaments, etc.',
      },
      {
        'id': 'c7',
        'imagePath': 'assets/images/Crochet Knitting Yarn.png',
        'name': 'Crochet Knitting Yarn',
        'price': 2.00,
        'details':
            'Usage: Face mask extender, Water bottle holder, Kopiah,bag, tissue box cover, baby shoes, baby beanie, amigurumi and etc',
      },
      {
        'id': 'c8',
        'imagePath': 'assets/images/9PcsTulip Red Crochet Needle.png',
        'name': '9PcsTulip Red Crochet Needle',
        'price': 21.00,
        'details': '9PcsTulip Red Crochet Needle',
      },
      {
        'id': 'c9',
        'imagePath': 'assets/images/DMC Cotton Embroidery Floss.png',
        'name': 'DMC Cotton Embroidery Floss',
        'price': 2.50,
        'details':
            'DMC Cotton Embroidery Floss, made from long staple cotton and double mercerized for a brilliant sheen, is the most recommended floss in the world.',
      },
      {
        'id': 'c10',
        'imagePath': 'assets/images/Mitsushi Hot Melt Glue Gun.png',
        'name': 'Mitsushi Hot Melt Glue Gun',
        'price': 15.00,
        'details':
            '1.The product uses 40W power, which is not easy to block and the glue is smooth 2.Avoid casting technology, use high-quality materials, not easy to leak glue, not easy to pour glue.',
      },
      {
        'id': 'c11',
        'imagePath': 'assets/images/Hot Melt Glue Sticks.png',
        'name': 'Hot Melt Glue Sticks ',
        'price': 9.21,
        'details':
            '1.No impurities, non-toxic, high toughness, smooth and not rough surface, high transparency of glue stick 2.Good purity and good viscosity while still maintaining toughness and high transparency, can be bent at any angle.',
      },
    ],
    'Creative Kits': [
      {
        'id': 'ck1',
        'imagePath': 'assets/images/DIY Mosaic Coaster Making Kit.png',
        'name': 'DIY Mosaic Coaster Making Kit',
        'price': 12.00,
        'salePrice': 11.40,
        'details':
            'All DIY By yourself: The design and making process is simple and easy to have crafting time with kids, family, friends, and love one.',
      },
      {
        'id': 'ck2',
        'imagePath': 'assets/images/1008PCS Full Set Cuka Material Package.png',
        'name': '1008PCS Full Set Cuka Material Package',
        'price': 36.20,
        'details':
            'Applicable age group: 8 years old (excluding) - 14 years old (including) Pattern: animal patterns, plants and flowers, cartoon animation Object of use: Goo Chuck / Goo Card',
      },
      {
        'id': 'ck3',
        'imagePath': 'assets/images/DIY Punch Needle Coaster Kit.png',
        'name': 'DIY Punch Needle Coaster Kit',
        'price': 15.00,
        'details':
            'Package Content -> 1 Set Punch Needle Kits(without punch needle/poking pen), include the following: 1 x Embroidery Hoop (16cm/20cm) 1 x Embroidery Cloth(outline with selected design) 1 x Non-woven cloth for finishing (back) A pack of yarn thread',
      },
      {
        'id': 'ck4',
        'imagePath': 'assets/images/53CM DIY Fluid Bear.png',
        'name': '53CM DIY Fluid Bear',
        'price': 55.00,
        'details':
            '1. Put a plastic tablecloth on the table, wear gloves and an apron 2. Pour your favorite color into the cup 3. Fall on the bear 4. Check for unpainted areas 5. Air dry - done',
      },
      {
        'id': 'ck5',
        'imagePath': 'assets/images/Colorful Rainbow Scratch Art.png',
        'name': 'Colorful Rainbow Scratch Art',
        'price': 4.20,
        'details':
            'Simply scratch off the black coating with the included wooden drawing stick to reveal the colors underneath.',
      },
      {
        'id': 'ck6',
        'imagePath': 'assets/images/Water Spirit Toy Set DIY.png',
        'name': 'Water Spirit Toy Set DIY',
        'price': 60.00,
        'details':
            '1. A packet of elf companion with 1000ml of water fully stirred and dissolved. 2. Dip the mold into the solution and soak it with a brush. 3. After demolding the water sprite should be soaked in the solution for a few minutes to make it solidify.',
      },
      {
        'id': 'ck7',
        'imagePath': 'assets/images/DIY Rock Painting Kit.png',
        'name': 'DIY Rock Painting Kit',
        'price': 14.24,
        'details':
            'Complete art kit - Get creative with our rock kit. You get 3-4 rocks, 8 Acrylic paints, 4 3D Paints, 2 brushes, 2 rock painting stands. - Rocks - Paint adorable animals, silly monsters, cute cartoons, and colorful patterns!',
      },
      {
        'id': 'ck9',
        'imagePath': 'assets/images/3D Wooden Puzzles.png',
        'name': '3D Wooden Puzzles',
        'price': 33.00,
        'details':
            '✅【Cute and Colorful】Features vibrant colors and adorable characters.  ✅【Kid-Friendly】Designed to be fun and appealing to children.  ✅【Durable Material】Built to withstand everyday use while keeping your essentials organized.',
      },
      {
        'id': 'ck10',
        'imagePath': 'assets/images/Cartoon Puzzle Diamond Sticker Kit.png',
        'name': 'Cartoon Puzzle Diamond Sticker Kit',
        'price': 19.80,
        'details':
            'Size: 16*16cm inner card (15*15cm)  Diamond Material: PS polystyrene  Packing: Color box packing',
      },
      {
        'id': 'ck11',
        'imagePath': 'assets/images/Craft-Tastic String Art Kit.png',
        'name': 'Craft-Tastic String Art Kit',
        'price': 45.90,
        'details':
            'The Craft-tastic String Art Kit is an exceptional way to stimulate creativity in children. 3 STURDY FOAM CANVASES & 3 FUN NEW PATTERNS: Our best-selling arts & crafts kit features a bird, a starburst and the word "fun.',
      },
    ],
  };

  @override
  Widget build(BuildContext context) {
    final items = categoryItems[selectedCategory] ?? [];

    return Scaffold(
      backgroundColor: Colors.white, // Set background color to white
      appBar: AppBar(
        backgroundColor: Colors.white, // AppBar background color
        foregroundColor: Colors.black, // AppBar text color
        automaticallyImplyLeading: true, // Show the back button
        title: null, // Remove the default title positioning
        leading: null, // Remove default leading (back) button
        flexibleSpace: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: Text(
                  selectedCategory,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 12.0, bottom: 15),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: categoryItems.keys.map((category) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedCategory = category;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: selectedCategory == category
                              ? const Color(0xFFA3D5D4)
                              : Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          category,
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(8.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 3 / 4,
              ),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return ItemCard(
                  id: item['id'],
                  imagePath: item['imagePath'],
                  name: item['name'],
                  price: item['price'],
                  salePrice: item['salePrice'],
                  details: item['details'],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ItemCard extends StatefulWidget {
  final String id;
  final String imagePath;
  final String name;
  final double price;
  final double? salePrice;
  final String details;

  const ItemCard({
    super.key,
    required this.id,
    required this.imagePath,
    required this.name,
    required this.price,
    this.salePrice,
    required this.details,
  });

  @override
  _ItemCardState createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
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
      isLiked = favorites.any((product) => product.id == widget.id);
    });
    return service;
  }

  Future<void> _toggleFavorite(FavoriteService service) async {
    final product = Product(
      id: widget.id,
      imagePath: widget.imagePath,
      name: widget.name,
      price: widget.price,
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
                  id: widget.id,
                  imagePath: widget.imagePath,
                  name: widget.name,
                  originalPrice: widget.price,
                  salePrice: widget.salePrice,
                  details: widget.details,
                ),
              ),
            );
          },
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            color: Colors.white, // Set card background color to white
            elevation: 5, // Optional: Add shadow to the card
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 160,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                        image: DecorationImage(
                          image: AssetImage(widget.imagePath),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.name,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          const SizedBox(height: 4),
                          widget.salePrice != null
                              ? Row(
                                  children: [
                                    Text(
                                      'RM${widget.salePrice!.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.red,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      'RM${widget.price.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                    ),
                                  ],
                                )
                              : Text(
                                  'RM${widget.price.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                        ],
                      ),
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
          ),
        );
      },
    );
  }
}
