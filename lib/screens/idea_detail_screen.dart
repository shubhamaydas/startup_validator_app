import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import '../models/startup_idea.dart';
import '../models/feedback.dart' as app_feedback;

class IdeaDetailScreen extends StatefulWidget {
  final StartupIdea idea;

  const IdeaDetailScreen({super.key, required this.idea});

  @override
  State<IdeaDetailScreen> createState() => _IdeaDetailScreenState();
}

class _IdeaDetailScreenState extends State<IdeaDetailScreen> {
  final _feedbackController = TextEditingController();

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  Future<void> _submitFeedback() async {
    if (_feedbackController.text.trim().isEmpty) return;

    final authService = Provider.of<AuthService>(context, listen: false);
    final firestoreService = Provider.of<FirestoreService>(context, listen: false);
    
    final user = authService.currentUser;
    if (user == null) return;

    try {
      await firestoreService.addFeedback(
        ideaId: widget.idea.id,
        userId: user.uid,
        userName: user.uid,
        comment: _feedbackController.text.trim(),
      );

      _feedbackController.clear();
      FocusScope.of(context).unfocus();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Feedback submitted!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    final firestoreService = Provider.of<FirestoreService>(context, listen: false);
    final userId = authService.currentUser?.uid ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Idea Details'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<List<StartupIdea>>(
        stream: firestoreService.getIdeasStream(),
        builder: (context, ideaSnapshot) {
          // Get the latest version of the idea
          final currentIdea = ideaSnapshot.data?.firstWhere(
                (idea) => idea.id == widget.idea.id,
                orElse: () => widget.idea,
              ) ??
              widget.idea;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Title
              Text(
                currentIdea.title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),

              // User and date
              Row(
                children: [
                  Icon(Icons.person_outline, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    currentIdea.userName,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(width: 16),
                  Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    DateFormat('MMM d, yyyy').format(currentIdea.createdAt),
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Like button
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      currentIdea.likedBy.contains(userId)
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: currentIdea.likedBy.contains(userId)
                          ? Colors.red
                          : Colors.grey,
                    ),
                    onPressed: () {
                      firestoreService.toggleLike(currentIdea.id, userId);
                    },
                  ),
                  Text(
                    '${currentIdea.likes} likes',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const Divider(),

              // Problem
              _buildSection('Problem', currentIdea.problem),
              const SizedBox(height: 16),

              // Solution
              _buildSection('Solution', currentIdea.solution),
              const SizedBox(height: 16),

              // Target Audience
              _buildSection('Target Audience', currentIdea.targetAudience),
              const SizedBox(height: 16),

              // Validation Steps
              Text(
                'Validation Progress',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              if (currentIdea.validationSteps.isEmpty)
                Text(
                  'No validation steps completed yet',
                  style: TextStyle(color: Colors.grey[600]),
                )
              else
                ...currentIdea.validationSteps.map((step) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: Theme.of(context).primaryColor,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(child: Text(step)),
                        ],
                      ),
                    )),
              const SizedBox(height: 24),

              // Feedback Section
              Text(
                'Community Feedback',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),

              // Feedback input
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _feedbackController,
                      decoration: const InputDecoration(
                        hintText: 'Share your feedback...',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 2,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: _submitFeedback,
                    color: Theme.of(context).primaryColor,
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Feedback list
              StreamBuilder<List<app_feedback.Feedback>>(
                stream: firestoreService.getFeedbackStream(currentIdea.id),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final feedbackList = snapshot.data ?? [];

                  if (feedbackList.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Text(
                          'No feedback yet. Be the first to share your thoughts!',
                          style: TextStyle(color: Colors.grey[600]),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }

                  return Column(
                    children: feedbackList.map((feedback) {
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.person,
                                    size: 16,
                                    color: Colors.grey[600],
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    feedback.userName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    DateFormat('MMM d').format(feedback.createdAt),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(feedback.comment),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: const TextStyle(height: 1.5),
        ),
      ],
    );
  }
}
