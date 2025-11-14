import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class RemindScreen extends StatelessWidget {
  const RemindScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Stay on track with reminders',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                        child: Text(
                          'Reminder',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ),
                      if (user != null)
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('reminders')
                              .where('userId', isEqualTo: user.uid)
                              .orderBy('date', descending: false)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: CircularProgressIndicator(),
                              ));
                            }
                            if (snapshot.hasError) {
                              return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: Theme.of(context).colorScheme.error)));
                            }
                            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                              return Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text('No reminders set yet.', style: Theme.of(context).textTheme.bodyMedium),
                              );
                            }

                            final reminders = snapshot.data!.docs;

                            return Column(
                              children: reminders.map((reminder) {
                                final data = reminder.data() as Map<String, dynamic>;
                                final title = data['title'] ?? 'No Title';
                                final description = data['description'] ?? 'No Description';
                                final date = (data['date'] as Timestamp).toDate();

                                return Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.secondary,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: ListTile(
                                    title: Text(title, style: Theme.of(context).textTheme.titleSmall),
                                    subtitle: Text(description, style: Theme.of(context).textTheme.bodySmall),
                                    trailing: Text(DateFormat('E, d MMM yyyy').format(date), style: Theme.of(context).textTheme.bodySmall),
                                    onTap: () {
                                      context.push('/reminder/${reminder.id}');
                                    },
                                  ),
                                );
                              }).toList(),
                            );
                          },
                        )
                      else
                         Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text('Please log in to see your reminders.', style: Theme.of(context).textTheme.bodyMedium),
                        ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () => context.go('/add_reminder'),
                        child: Container(
                          margin: const EdgeInsets.all(16),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.secondary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.add, color: Theme.of(context).colorScheme.onSecondary),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Add a reminder',
                                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                      color: Theme.of(context).colorScheme.onSecondary,
                                    ),
                                  ),
                                  Text(
                                    'What should we remind you about?',
                                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                      color: Theme.of(context).colorScheme.onSecondary.withOpacity(0.7),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
