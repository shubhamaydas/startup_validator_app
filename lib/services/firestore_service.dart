import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../models/startup_idea.dart';
import '../models/feedback.dart' as app_feedback;

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Uuid _uuid = const Uuid();

  // Create a new startup idea
  Future<void> createIdea(StartupIdea idea) async {
    try {
      await _firestore.collection('ideas').doc(idea.id).set(idea.toMap());
    } catch (e) {
      print('Create idea error: $e');
      rethrow;
    }
  }

  // Get all startup ideas (stream) - NO INDEX NEEDED
  Stream<List<StartupIdea>> getIdeasStream() {
    return _firestore
        .collection('ideas')
        .snapshots()  // ← Removed orderBy
        .map((snapshot) {
      final ideas = snapshot.docs
          .map((doc) => StartupIdea.fromMap(doc.data()))
          .toList();
      // Sort in memory instead
      ideas.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return ideas;
    });
  }

  // Get user's ideas - NO INDEX NEEDED
  Stream<List<StartupIdea>> getUserIdeasStream(String userId) {
    return _firestore
        .collection('ideas')
        .where('userId', isEqualTo: userId)
        .snapshots()  // ← Removed orderBy
        .map((snapshot) {
      final ideas = snapshot.docs
          .map((doc) => StartupIdea.fromMap(doc.data()))
          .toList();
      // Sort in memory instead
      ideas.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return ideas;
    });
  }

  // Update startup idea
  Future<void> updateIdea(StartupIdea idea) async {
    try {
      await _firestore
          .collection('ideas')
          .doc(idea.id)
          .update(idea.toMap());
    } catch (e) {
      print('Update idea error: $e');
      rethrow;
    }
  }

  // Delete startup idea
  Future<void> deleteIdea(String ideaId) async {
    try {
      // Delete all feedback for this idea
      final feedbackDocs = await _firestore
          .collection('feedback')
          .where('ideaId', isEqualTo: ideaId)
          .get();

      for (var doc in feedbackDocs.docs) {
        await doc.reference.delete();
      }

      // Delete the idea
      await _firestore.collection('ideas').doc(ideaId).delete();
    } catch (e) {
      print('Delete idea error: $e');
      rethrow;
    }
  }

  // Toggle like on an idea
  Future<void> toggleLike(String ideaId, String userId) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('ideas').doc(ideaId).get();
      if (doc.exists) {
        StartupIdea idea = StartupIdea.fromMap(doc.data() as Map<String, dynamic>);

        List<String> likedBy = List.from(idea.likedBy);
        int likes = idea.likes;

        if (likedBy.contains(userId)) {
          likedBy.remove(userId);
          likes--;
        } else {
          likedBy.add(userId);
          likes++;
        }

        await _firestore.collection('ideas').doc(ideaId).update({
          'likes': likes,
          'likedBy': likedBy,
        });
      }
    } catch (e) {
      print('Toggle like error: $e');
      rethrow;
    }
  }

  // Add feedback to an idea
  Future<void> addFeedback({
    required String ideaId,
    required String userId,
    required String userName,
    required String comment,
  }) async {
    try {
      final feedback = app_feedback.Feedback(
        id: _uuid.v4(),
        ideaId: ideaId,
        userId: userId,
        userName: userName,
        comment: comment,
        createdAt: DateTime.now(),
      );

      await _firestore
          .collection('feedback')
          .doc(feedback.id)
          .set(feedback.toMap());
    } catch (e) {
      print('Add feedback error: $e');
      rethrow;
    }
  }

  Stream<List<app_feedback.Feedback>> getFeedbackStream(String ideaId) {
    return _firestore
        .collection('feedback')
        .where('ideaId', isEqualTo: ideaId)
        .snapshots()  // ← Removed orderBy
        .map((snapshot) {
      final feedbacks = snapshot.docs
          .map((doc) => app_feedback.Feedback.fromMap(doc.data()))
          .toList();
      // Sort in memory instead
      feedbacks.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      return feedbacks;
    });
  }
}