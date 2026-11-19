import 'mahsulot_modeli.dart';

class FinishedProductModel {
  final int? id;
  final int productId;
  final int quantity;
  final MahsulotModel? product;
  final DateTime? createdAt;

  // Mahsulotni qaysi account/token egasi qo'shgan
  final int? createdById;
  final String? createdByName;
  final String? createdByRole;

  FinishedProductModel({
    this.id,
    required this.productId,
    required this.quantity,
    this.product,
    this.createdAt,
    this.createdById,
    this.createdByName,
    this.createdByRole,
  });

  factory FinishedProductModel.fromJson(
      Map<String, dynamic> json,
      ) {
    final createdBy =
        json['createdBy'] ?? json['created_by'];

    return FinishedProductModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse('${json['id']}'),

      productId: json['product_id'] is int
          ? json['product_id']
          : int.tryParse('${json['product_id']}') ?? 0,

      quantity: json['quantity'] is int
          ? json['quantity']
          : int.tryParse('${json['quantity']}') ?? 0,

      product: json['product'] != null
          ? MahsulotModel.fromJson(json['product'])
          : null,

      createdAt: json['created_at'] != null
          ? DateTime.tryParse(
        json['created_at'].toString(),
      )
          : json['createdAt'] != null
          ? DateTime.tryParse(
        json['createdAt'].toString(),
      )
          : null,

      createdById: createdBy != null
          ? (createdBy['id'] is int
          ? createdBy['id']
          : int.tryParse(
        '${createdBy['id']}',
      ))
          : null,

      createdByName: createdBy != null
          ? (createdBy['fullName'] ??
             createdBy['full_name'] ??
             createdBy['name'] ??
             createdBy['username'] ??
             createdBy['login'] ??
             createdBy['displayName'])?.toString()
          : (json['createdByName'] ??
             json['created_by_name'] ??
             json['createdByName'] ??
             json['created_by_user'])?.toString(),

      createdByRole: createdBy != null
          ? (createdBy['role'] ?? createdBy['user_role'])?.toString()
          : (json['createdByRole'] ?? json['created_by_role'])?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'quantity': quantity,
    };
  }
}