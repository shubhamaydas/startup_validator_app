import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import '../models/startup_idea.dart';

class CreateIdeaScreen extends StatefulWidget {
  final StartupIdea? existingIdea;
  
  const CreateIdeaScreen({super.key, this.existingIdea});

  @override
  State<CreateIdeaScreen> createState() => _CreateIdeaScreenState();
}

class _CreateIdeaScreenState extends State<CreateIdeaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _problemController = TextEditingController();
  final _solutionController = TextEditingController();
  final _targetAudienceController = TextEditingController();
  
  final List<String> _validationSteps = [
    'Identified the problem',
    'Talked to potential users',
    'Researched competitors',
    'Validated market need',
    'Defined target audience',
  ];
  
  final List<bool> _completedSteps = List.filled(5, false);
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.existingIdea != null) {
      _titleController.text = widget.existingIdea!.title;
      _problemController.text = widget.existingIdea!.problem;
      _solutionController.text = widget.existingIdea!.solution;
      _targetAudienceController.text = widget.existingIdea!.targetAudience;
      
      for (int i = 0; i < _validationSteps.length; i++) {
        if (widget.existingIdea!.validationSteps.contains(_validationSteps[i])) {
          _completedSteps[i] = true;
        }
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _problemController.dispose();
    _solutionController.dispose();
    _targetAudienceController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final authService = Provider.of<AuthService>(context, listen: false);
    final firestoreService = Provider.of<FirestoreService>(context, listen: false);

    final user = authService.currentUser;
    if (user == null) return;

    try {
      final completedStepsList = <String>[];
      for (int i = 0; i < _completedSteps.length; i++) {
        if (_completedSteps[i]) {
          completedStepsList.add(_validationSteps[i]);
        }
      }

      final idea = StartupIdea(
        id: widget.existingIdea?.id ?? const Uuid().v4(),
        userId: user.uid,
        userName: user.uid,
        title: _titleController.text.trim(),
        problem: _problemController.text.trim(),
        solution: _solutionController.text.trim(),
        targetAudience: _targetAudienceController.text.trim(),
        validationSteps: completedStepsList,
        likes: widget.existingIdea?.likes ?? 0,
        likedBy: widget.existingIdea?.likedBy ?? [],
        createdAt: widget.existingIdea?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );

      if (widget.existingIdea == null) {
        await firestoreService.createIdea(idea);
      } else {
        await firestoreService.updateIdea(idea);
      }

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.existingIdea == null
                  ? 'Idea created successfully!'
                  : 'Idea updated successfully!',
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existingIdea == null ? 'Create Idea' : 'Edit Idea'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Title field
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Idea Title *',
                border: OutlineInputBorder(),
                hintText: 'e.g., AI-Powered Meal Planning App',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Problem field
            TextFormField(
              controller: _problemController,
              decoration: const InputDecoration(
                labelText: 'Problem *',
                border: OutlineInputBorder(),
                hintText: 'What problem does this solve?',
              ),
              maxLines: 3,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please describe the problem';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Solution field
            TextFormField(
              controller: _solutionController,
              decoration: const InputDecoration(
                labelText: 'Solution *',
                border: OutlineInputBorder(),
                hintText: 'How does your idea solve it?',
              ),
              maxLines: 3,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please describe your solution';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Target Audience field
            TextFormField(
              controller: _targetAudienceController,
              decoration: const InputDecoration(
                labelText: 'Target Audience *',
                border: OutlineInputBorder(),
                hintText: 'Who will use this?',
              ),
              maxLines: 2,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please describe your target audience';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),

            // Validation Checklist
            Text(
              'Validation Checklist',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Check the validation steps you\'ve completed:',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 12),

            ..._validationSteps.asMap().entries.map((entry) {
              final index = entry.key;
              final step = entry.value;
              return CheckboxListTile(
                title: Text(step),
                value: _completedSteps[index],
                onChanged: (value) {
                  setState(() {
                    _completedSteps[index] = value ?? false;
                  });
                },
                activeColor: Theme.of(context).primaryColor,
              );
            }).toList(),

            const SizedBox(height: 24),

            // Submit button
            ElevatedButton(
              onPressed: _isLoading ? null : _submit,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      widget.existingIdea == null ? 'Create Idea' : 'Update Idea',
                      style: const TextStyle(fontSize: 16),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
