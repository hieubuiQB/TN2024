class Food{
  late String description;
  late String discount;
  late String image;
  late String menuId;
  late String name;
  late String price;
  late String keys;

  Food({
    required this.description,
    required this.discount,
    required this.image,
    required this.menuId,
    required this.name,
    required this.price,
    required this.keys
  });

  Map<String, dynamic> toMap(Food food) {
    return {
      'description': description,
      'discount': discount,
      'image': image,
      'menuId': menuId,
      'name': name,
      'price': price,
      'keys': keys,
    };
  }

  Food.fromMap(Map<String, dynamic> mapData) {
    description = mapData['description'];
    discount = mapData['discount'];
    image = mapData['image'];
    menuId = mapData['menuId'];
    name = mapData['name'];
    price = mapData['price'];
    keys = mapData['keys'];
  }
}
