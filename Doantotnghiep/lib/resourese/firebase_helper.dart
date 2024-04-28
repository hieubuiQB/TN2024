
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:doantotnghiep/models/Category.dart';
import 'package:doantotnghiep/models/Food.dart';
import 'package:doantotnghiep/models/Request.dart';
import 'package:doantotnghiep/resourese/auth_methods.dart';
import 'package:doantotnghiep/resourese/databaseSQL.dart';

import '../models/User.dart';

class FirebaseHelper{

  // Firebase Database, will use to get reference.
  static final FirebaseDatabase _database = FirebaseDatabase.instance;

  static final DatabaseReference _ordersReference = _database.reference().child("Orders");
  static final DatabaseReference _categoryReference = _database.reference().child("Category");
  static final DatabaseReference _foodReference = _database.reference().child("Foods");

  // fetch all foods list from food reference
  Future<List<Food>> fetchAllFood() async {
    List<Food> foodList = <Food>[];
    DatabaseReference foodReference = _database.reference().child("Foods");
    try {
      DataSnapshot snapshot = (await foodReference.once()) as DataSnapshot;
      if (snapshot.value != null && snapshot.value is Map<dynamic, dynamic>) {
        Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
        data.forEach((key, value) {
          Food food = new Food(
            description: value['description'] ?? '',
            discount: value['discount'] ?? 0,
            image: value['image'] ?? '',
            menuId: value['menuId'] ?? '',
            name: value['name'] ?? '',
            price: value['price'] ?? 0.0,
            keys: key.toString(),
          );
          foodList.add(food);
        });
      }
    } catch (error) {
      print("Error: $error");
    }
    return foodList;
  }



  // fetch food list with query string
  Future<List<Food>> fetchSpecifiedFoods(String queryStr) async {
    List<Food> foodList = [];

    // Sử dụng await để chờ Future trả về từ _foodReference.once()
    var event = await _foodReference.once();

    // Trích xuất dữ liệu từ snapshot và xử lý
    var snapshot = event.snapshot;
    final data = snapshot.value as Map<dynamic, dynamic>;
    if (data != null) { // Kiểm tra xem data có phải là null hay không
      var keys = data.keys;
      foodList.clear();
      for (var individualKey in keys) {
        var foodData = data[individualKey];
        if (foodData != null && foodData is Map<dynamic, dynamic>) { // Kiểm tra xem foodData có phải là null hay không
          Food food = new Food(
            description: foodData['description'],
            discount: foodData['discount'],
            image: foodData['image'],
            menuId: foodData['menuId'],
            name: foodData['name'],
            price: foodData['price'],
            keys: individualKey.toString(),
          );
          if (food.menuId == queryStr) {
            foodList.add(food);
          }
        }
      }
    }

    // Trả về danh sách thức ăn sau khi xử lý
    return foodList;
  }






  Future<bool> placeOrder(Request request)async{
    await _ordersReference.child(request.uid).push().set(request.toMap(request));
    return true;
  }

  Future<List<Category>> fetchCategory() async {
    List<Category> categoryList = [];

    // Sử dụng await để chờ Future trả về từ _categoryReference.once()
    DataSnapshot snapshot = (await _categoryReference.once()) as DataSnapshot; // Đảm bảo snapshot được khai báo là kiểu DataSnapshot

    // Trích xuất dữ liệu từ snapshot và xử lý
    var data = snapshot.value;
    if (data != null && data is Map<dynamic, dynamic>) { // Kiểm tra kiểu dữ liệu của data
      var keys = data.keys;
      categoryList.clear();
      for (var individualKey in keys) {
        Category posts = new Category(
          image: data[individualKey]['Image'],
          name: data[individualKey]['Name'],
          keys: individualKey.toString(),
        );
        categoryList.add(posts);
      }
    }

    // Trả về danh sách category sau khi xử lý
    return categoryList;
  }



  Future<List<Request>> fetchOrders(UserModel currentUser) async {
    List<Request> requestList = [];
    DatabaseReference foodReference = _ordersReference.child(currentUser.uid);

    // Sử dụng await để chờ Future trả về từ _ordersReference.once()
    DataSnapshot snapshot = (await foodReference.once()) as DataSnapshot;

    // Trích xuất dữ liệu từ snapshot và xử lý
    var data = snapshot.value;
    if (data != null && data is Map<dynamic, dynamic>) {
      var keys = data.keys;
      requestList.clear();
      for (var individualKey in keys) {
        Request request = Request(
          address: data[individualKey]['address'],
          name: data[individualKey]['name'],
          uid: data[individualKey]['uid'],
          status: data[individualKey]['status'],
          total: data[individualKey]['total'],
          foodList: data[individualKey]['foodList'],
        );
        requestList.add(request);
      }
    }

    // Trả về danh sách request sau khi xử lý
    return requestList;
  }


  Future<void> addOrder(String totalPrice, List<Food> orderedFoodList, String name, String address) async {
    // getter user details
    User user = (await AuthMethods().getCurrentUser()) as User;
    String uidtxt = user.uid;
    String statustxt = "0";
    String totaltxt = totalPrice.toString();

    // creating model of list of ordered foods
    Map aux = new Map<String,dynamic>();
    orderedFoodList.forEach((food){
      aux[food.keys] = food.toMap(food);
    });

    Request request = new Request(
        address:address,
        name:name,
        uid:uidtxt,
        status:statustxt,
        total:totaltxt,
        foodList:aux
    );

    // add order to database
    await _ordersReference.child(request.uid).push().set(request.toMap(request)).then((value) async {
      // delete cart data
      DatabaseSql databaseSql = DatabaseSql();
      await databaseSql.openDatabaseSql();
      await databaseSql.deleteAllData();
    });
  }
}