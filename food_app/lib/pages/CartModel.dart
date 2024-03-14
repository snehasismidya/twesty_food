class CartItem {
  final String cartid;
  final String foodid;
  final String id;
  final String date;
  int quantity;
  final String foodname;
  final String foodimage;
  final String foodprice;
  final String fooddesc;
  final String categoryid;
  final String featured;
  CartItem(
      {required this.cartid,
      required this.foodid,
      required this.id,
      required this.date,
      required this.quantity,
      required this.foodname,
      required this.foodimage,
      required this.foodprice,
      required this.fooddesc,
      required this.categoryid,
      required this.featured});
}