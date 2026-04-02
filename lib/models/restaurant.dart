class Restaurant {
  final String id;
  final String name;
  final String? description;
  final String cuisine;
  final String address;
  final List<String> images;
  final double rating;
  final int reviewsCount;
  final double? lat;
  final double? lng;
  final List<MenuItem> menu;
  final double? averagePrice;
  final bool isOpen;

  Restaurant({
    required this.id,
    required this.name,
    this.description,
    required this.cuisine,
    required this.address,
    required this.images,
    required this.rating,
    required this.reviewsCount,
    this.lat,
    this.lng,
    required this.menu,
    this.averagePrice,
    required this.isOpen,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['_id'],
      name: json['name'],
      description: json['description'],
      cuisine: json['cuisine'],
      address: json['location']['address'],
      images: List<String>.from(json['images'] ?? []),
      rating: (json['rating'] ?? 0).toDouble(),
      reviewsCount: json['reviewsCount'] ?? 0,
      lat: (json['location']?['coordinates']?['lat'] as num?)?.toDouble(),
      lng: (json['location']?['coordinates']?['lng'] as num?)?.toDouble(),
      menu: (json['menu'] as List? ?? [])
          .map((item) => MenuItem.fromJson(item))
          .toList(),
      averagePrice: (json['averagePrice'] as num?)?.toDouble(),
      isOpen: json['isOpen'] ?? true,
    );
  }
}

class MenuItem {
  final String name;
  final double price;
  final String? description;
  final String? image;

  MenuItem({
    required this.name,
    required this.price,
    this.description,
    this.image,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      name: json['name'],
      price: (json['price'] ?? 0).toDouble(),
      description: json['description'],
      image: json['image'],
    );
  }
}
