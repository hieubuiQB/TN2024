
class Request{
  late String address;
  late Map foodList;
  late String name;
  late String uid;
  late String status;
  late String total;

  Request({
    required this.address,
    required this.foodList,
    required this.name,
    required this.uid,
    required this.status,
    required this.total,
  });

  Map toMap(Request request) {
    var data = Map<String, dynamic>();
    data['address'] = request.address;
    data['foodList'] = request.foodList;
    data['name'] = request.name;
    data['uid'] = request.uid;
    data['status'] = request.status;
    data['total'] = request.total;
    return data;
  }

  Request.fromMap(Map<dynamic, dynamic> mapData) {
    this.address = mapData['address'];
    this.foodList = mapData['foodList'];
    this.name=mapData['name'];
    this.uid=mapData["uid"];
    this.status=mapData["status"];
    this.total=mapData["total"];
  }
}