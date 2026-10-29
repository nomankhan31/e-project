import 'watch_model.dart';

class CartModel {
  final WatchModel watch;
  int quantity;
  CartModel({required this.watch, this.quantity = 1});
}
