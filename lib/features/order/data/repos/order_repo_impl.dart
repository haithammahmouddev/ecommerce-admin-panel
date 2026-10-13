import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:ecommerce_admin_pannal/common/errors/failure.dart';
import 'package:ecommerce_admin_pannal/common/network/firebase/database_services.dart';
import 'package:ecommerce_admin_pannal/features/order/data/models/order_model.dart';
import 'package:ecommerce_admin_pannal/features/order/domain/entities/order_entity.dart';
import '../../domain/repos/order_repo.dart';

class OrderRepoImpl implements OrderRepo {
  final DatabaseServices _databaseServices;

  OrderRepoImpl({required DatabaseServices databaseServices})
      : _databaseServices = databaseServices;

  @override
  Future<Either<Failure, void>> createOrder({required OrderModel order}) async {
    try {
      await _databaseServices.addData(data: order.toJson(), path: 'Orders');
      return const Right(null);
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<OrderEntity>>> getAllOrders() async {
    try {
      final querySnapshot =
      await FirebaseFirestore.instance.collectionGroup('Orders').get();

      final List<OrderEntity> orderList = querySnapshot.docs
          .map((doc) =>
          OrderModel.fromFirebaseData(doc.data(), doc.id).toEntity())
          .toList();

      return right(orderList);
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Stream<Either<Failure, List<OrderEntity>>> getAllOrdersStream() async* {
    try {
      final stream =
      FirebaseFirestore.instance.collectionGroup('Orders').snapshots();

      await for (final querySnapshot in stream) {
        final List<OrderEntity> orderList = querySnapshot.docs
            .map((doc) =>
            OrderModel.fromFirebaseData(doc.data(), doc.id).toEntity())
            .toList();

        yield Right(orderList);
      }
    } catch (e) {
      yield Left(ServerFailure(e.toString()));
    }
  }


  Future<DocumentReference<Map<String, dynamic>>?> _findOrderRef(
      String orderId, {
        String? userId,
      }) async {
    final firestore = FirebaseFirestore.instance;

    if (userId != null && userId.isNotEmpty) {
      return firestore
          .collection('users')
          .doc(userId)
          .collection('Orders')
          .doc(orderId);
    }

    final snapshot = await firestore.collectionGroup('Orders').get();
    for (final doc in snapshot.docs) {
      if (doc.id == orderId) return doc.reference;
    }

    for (final doc in snapshot.docs) {
      if (doc.data()['id'] == orderId) return doc.reference;
    }

    return null;
  }

  @override
  Future<Either<Failure, void>> updateOrderSpecificValue(
      String orderId,
      Map<String, dynamic> data, {
        String? userId,
      }) async {
    try {
      final ref = await _findOrderRef(orderId, userId: userId);
      if (ref == null) {
        return left(ServerFailure('Order not found: $orderId'));
      }

      await ref.update(data);
      return const Right(null);
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteOrder(
      String orderId, {
        String? userId,
      }) async {
    try {
      final ref = await _findOrderRef(orderId, userId: userId);
      if (ref == null) {
        return left(ServerFailure('Order not found: $orderId'));
      }

      await ref.delete();
      return const Right(null);
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }
}