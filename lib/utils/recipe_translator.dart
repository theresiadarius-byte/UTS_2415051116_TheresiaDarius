/// RecipeTranslator – utilitas untuk menerjemahkan bahan, takaran,
/// kategori, dan istilah resep dari bahasa Inggris ke bahasa Indonesia.
class RecipeTranslator {
  RecipeTranslator._();

  // ── KAMUS NAMA BAHAN (INGREDIENTS) ─────────────────────────────────────────
  static final Map<String, String> _ingredientMap = {
    // Tepung & Pengembang
    'flour': 'Tepung Terigu',
    'plain flour': 'Tepung Terigu Serbaguna',
    'all-purpose flour': 'Tepung Terigu Serbaguna',
    'self-raising flour': 'Tepung Terigu Self-Raising',
    'whole wheat flour': 'Tepung Gandum Utuh',
    'cake flour': 'Tepung Kue Halus',
    'bread flour': 'Tepung Roti Protein Tinggi',
    'cornstarch': 'Tepung Maizena',
    'corn flour': 'Tepung Maizena',
    'rice flour': 'Tepung Beras',
    'tapioca starch': 'Tepung Tapioka',
    'almond flour': 'Tepung Almond',
    'baking powder': 'Baking Powder',
    'baking soda': 'Soda Kue (Baking Soda)',
    'bicarbonate of soda': 'Soda Kue',
    'yeast': 'Ragi Instan',
    'active dry yeast': 'Ragi Kering Aktif',

    // Gula & Pemanis
    'sugar': 'Gula Pasir',
    'granulated sugar': 'Gula Pasir Halus',
    'caster sugar': 'Gula Kastor (Gula Halus)',
    'icing sugar': 'Gula Bubuk (Gula Halus / Icing)',
    'powdered sugar': 'Gula Bubuk',
    'confectioners sugar': 'Gula Bubuk',
    'brown sugar': 'Gula Palem / Brown Sugar',
    'dark brown sugar': 'Gula Palem Gelap',
    'light brown sugar': 'Gula Palem Terang',
    'honey': 'Madu Murni',
    'maple syrup': 'Sirup Maple',
    'golden syrup': 'Sirup Kencana (Golden Syrup)',
    'molasses': 'Molase (Tetes Tebu)',
    'corn syrup': 'Sirup Jagung',
    'sweetened condensed milk': 'Susu Kental Manis',
    'condensed milk': 'Susu Kental Manis',

    // Produk Susu & Lemak
    'butter': 'Mentega (Butter)',
    'unsalted butter': 'Mentega Tawar (Unsalted Butter)',
    'salted butter': 'Mentega Asin (Salted Butter)',
    'margarine': 'Margarin',
    'milk': 'Susu Cair',
    'whole milk': 'Susu Cair Full Cream',
    'skimmed milk': 'Susu Skim Rendah Lemak',
    'buttermilk': 'Buttermilk (Susu Asam)',
    'heavy cream': 'Krim Kental (Heavy Cream)',
    'double cream': 'Krim Kental Ganda (Double Cream)',
    'whipping cream': 'Krim Kocok (Whipping Cream)',
    'sour cream': 'Krim Asam (Sour Cream)',
    'cream cheese': 'Keju Krim (Cream Cheese)',
    'mascarpone': 'Keju Mascarpone',
    'ricotta': 'Keju Ricotta',
    'cheddar cheese': 'Keju Cheddar',
    'parmesan': 'Keju Parmesan',
    'evaporated milk': 'Susu Evaporasi',
    'yogurt': 'Yogurt',
    'greek yogurt': 'Greek Yogurt',
    'oil': 'Minyak Goreng',
    'vegetable oil': 'Minyak Nabati',
    'canola oil': 'Minyak Kanola',
    'coconut oil': 'Minyak Kelapa',
    'olive oil': 'Minyak Zaitun',

    // Telur
    'egg': 'Telur',
    'eggs': 'Butir Telur',
    'egg white': 'Putih Telur',
    'egg whites': 'Putih Telur',
    'egg yolk': 'Kuning Telur',
    'egg yolks': 'Kuning Telur',

    // Cokelat & Perasa
    'cocoa powder': 'Cokelat Bubuk',
    'chocolate': 'Cokelat',
    'dark chocolate': 'Cokelat Hitam (Dark Chocolate)',
    'milk chocolate': 'Cokelat Susu',
    'white chocolate': 'Cokelat Putih',
    'chocolate chips': 'Choco Chips',
    'semi-sweet chocolate': 'Cokelat Semi-Manis',
    'vanilla': 'Vanila',
    'vanilla extract': 'Ekstrak Vanila',
    'vanilla essence': 'Pasta / Perisa Vanila',
    'vanilla bean': 'Biji Vanila Alami',
    'almond extract': 'Ekstrak Almond',
    'coffee': 'Kopi',
    'instant coffee': 'Kopi Instan Bubuk',
    'espresso': 'Kopi Espresso',

    // Buah-buahan & Selai
    'lemon': 'Lemon',
    'lemon juice': 'Air Perasan Lemon',
    'lemon zest': 'Parutan Kulit Lemon',
    'orange': 'Jeruk Manis',
    'orange juice': 'Air Jeruk',
    'orange zest': 'Parutan Kulit Jeruk',
    'lime': 'Jeruk Nipis',
    'lime juice': 'Air Jeruk Nipis',
    'apple': 'Apel',
    'apples': 'Buah Apel',
    'banana': 'Pisang',
    'bananas': 'Buah Pisang',
    'strawberry': 'Stroberi',
    'strawberries': 'Buah Stroberi',
    'blueberry': 'Blueberry',
    'blueberries': 'Buah Blueberry',
    'raspberry': 'Raspberry',
    'raspberries': 'Buah Raspberry',
    'blackberry': 'Blackberry',
    'blackberries': 'Buah Blackberry',
    'cherry': 'Ceri',
    'cherries': 'Buah Ceri',
    'raisins': 'Kismis',
    'sultanas': 'Kismis Kuning',
    'cranberries': 'Buah Cranberry Kering',
    'coconut': 'Kelapa',
    'desiccated coconut': 'Kelapa Parut Kering',
    'coconut milk': 'Santan Kelapa',
    'jam': 'Selai',
    'strawberry jam': 'Selai Stroberi',
    'apricot jam': 'Selai Aprikot',
    'raspberry jam': 'Selai Raspberry',

    // Kacang-kacangan
    'nuts': 'Kacang-kacangan',
    'almonds': 'Kacang Almond',
    'flaked almonds': 'Irisan Kacang Almond',
    'walnuts': 'Kacang Kenari (Walnut)',
    'pecans': 'Kacang Pecan',
    'hazelnuts': 'Kacang Hazelnut',
    'peanuts': 'Kacang Tanah',
    'peanut butter': 'Selai Kacang',
    'pistachios': 'Kacang Pistachio',

    // Rempah & Tambahan
    'salt': 'Garam',
    'sea salt': 'Garam Laut',
    'cinnamon': 'Kayu Manis Bubuk',
    'ground cinnamon': 'Kayu Manis Bubuk',
    'nutmeg': 'Pala Bubuk',
    'ground nutmeg': 'Pala Bubuk',
    'ginger': 'Jahe Bubuk',
    'ground ginger': 'Jahe Bubuk',
    'cloves': 'Cengkeh Bubuk',
    'allspice': 'Rempah Allspice',
    'cardamom': 'Kapulaga',
    'gelatine': 'Gelatin',
    'gelatin': 'Gelatin',
    'water': 'Air Bersih',
    'boiling water': 'Air Mendidih',
    'warm water': 'Air Hangat',
    'cold water': 'Air Dingin',
    'ice': 'Es Batu',
    'mint': 'Daun Mint',
    'food coloring': 'Pewarna Makanan',
    'red food coloring': 'Pewarna Makanan Merah',
  };

  // ── KAMUS TAKARAN (MEASURES) ───────────────────────────────────────────────
  static String translateMeasure(String raw) {
    if (raw.trim().isEmpty) return '-';
    var text = raw.trim();

    final replacements = <String, String>{
      'tablespoons': 'sdm',
      'tablespoon':  'sdm',
      'tbsp':        'sdm',
      'tbsps':       'sdm',
      'tbs':         'sdm',
      'teaspoons':   'sdt',
      'teaspoon':    'sdt',
      'tsp':         'sdt',
      'tsps':        'sdt',
      'cups':        'cangkir',
      'cup':         'cangkir',
      'pinch':       'sejumput',
      'pinches':     'sejumput',
      'dash':        'sedikit tetes',
      'handful':     'segenggam',
      'slices':      'irisan',
      'slice':       'iris',
      'pieces':      'potong',
      'piece':       'potong',
      'drops':       'tetes',
      'drop':        'tetes',
      'to taste':    'secukupnya',
      'for dusting': 'untuk taburan',
      'for greasing':'untuk olesan',
      'melted':      'dilelehkan',
      'chopped':     'cincang',
      'diced':       'potong dadu',
      'grated':      'parut',
      'crushed':     'dihancurkan',
      'divided':     'dibagi',
      'beaten':      'dikocok lepas',
      'warm':        'hangat',
      'cold':        'dingin',
      'chilled':     'dingin kulkas',
      'room temperature': 'suhu ruang',
      'about':       'sekitar',
      'heaped':      'penuh munjung',
      'level':       'peres (rata)',
    };

    // Replace case-insensitively
    replacements.forEach((key, val) {
      final reg = RegExp('\\b$key\\b', caseSensitive: false);
      text = text.replaceAll(reg, val);
    });

    return text;
  }

  // ── TERJEMAHKAN BAHAN ──────────────────────────────────────────────────────
  static String translateIngredient(String raw) {
    final clean = raw.trim().toLowerCase();
    if (_ingredientMap.containsKey(clean)) {
      return _ingredientMap[clean]!;
    }

    // Cek kecocokan substring
    for (final entry in _ingredientMap.entries) {
      if (clean == entry.key || clean.contains(entry.key)) {
        return entry.value;
      }
    }

    // Default kembalikan aslinya jika tidak ada dalam kamus
    return raw.trim();
  }

  // ── TERJEMAHKAN KATEGORI ───────────────────────────────────────────────────
  static String translateCategory(String? category) {
    if (category == null || category.isEmpty) return 'Kue & Hidangan Penutup';
    final lower = category.toLowerCase();
    if (lower.contains('dessert')) return 'Hidangan Penutup (Dessert)';
    if (lower.contains('miscellaneous')) return 'Aneka Resep';
    if (lower.contains('cake')) return 'Kue (Cake)';
    return category;
  }

  // ── TERJEMAHKAN ASAL NEGARA / AREA ─────────────────────────────────────────
  static String translateArea(String? area) {
    if (area == null || area.isEmpty) return 'Internasional';
    const areaMap = {
      'american': 'Amerika',
      'british': 'Inggris',
      'canadian': 'Kanada',
      'chinese': 'Tiongkok',
      'croatian': 'Kroasia',
      'dutch': 'Belanda',
      'egyptian': 'Mesir',
      'filipino': 'Filipina',
      'french': 'Prancis',
      'greek': 'Yunani',
      'indian': 'India',
      'irish': 'Irlandia',
      'italian': 'Italia',
      'jamaican': 'Jamaika',
      'japanese': 'Jepang',
      'kenyan': 'Kenya',
      'malaysian': 'Malaysia',
      'mexican': 'Meksiko',
      'moroccan': 'Maroko',
      'polish': 'Polandia',
      'portuguese': 'Portugal',
      'russian': 'Rusia',
      'spanish': 'Spanyol',
      'thai': 'Thailand',
      'tunisian': 'Tunisia',
      'turkish': 'Turki',
      'vietnamese': 'Vietnam',
    };
    final key = area.toLowerCase();
    return areaMap[key] ?? area;
  }
}
