import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cpsc5250hw/points_record.dart';

const _collectionName = 'Points';

class PointsDao {
  Stream<List<PointsRecord>> listenForAllPoints() {
    return FirebaseFirestore
        .instance
        .collection(_collectionName)
        .orderBy('points', descending: true)
        .snapshots()
        .map((snapshot) {
          return _snapshotsToString(snapshot.docs);
    });
  }

  List<PointsRecord> _snapshotsToString(List<QueryDocumentSnapshot<Map<String, dynamic>>> snapshots) {
    return snapshots.map(_snapshotToTodoItem).toList();
  }

  PointsRecord _snapshotToTodoItem(QueryDocumentSnapshot<Map<String, dynamic>> snapshot) {
    return PointsRecord(snapshot['name'], snapshot['points']);
  }

  // Stream<int> listenForUserPoints(String id) {
  //   return FirebaseFirestore.instance
  //       .collection(_collectionName)
  //       .doc(id)
  //       .snapshots()
  //       .map((snapshot) {
  //     int points = snapshot.get('points');
  //     print("Read User points: $points");
  //     return points; // Or any other logic you want to apply
  //   });
  // }

  Future<int> getUserPoints(String id) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
          .collection(_collectionName)
          .doc(id)
          .get();

      int points = snapshot.get('points') ?? 0;
      print("Read User points: $points");
      return points; // Or any other logic you want to apply
    } catch (e) {
      print("Error getting user points: $e");
      return 0; // Handle the error appropriately
    }
  }

}