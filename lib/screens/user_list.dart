import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

class UserListScreen extends StatelessWidget {
  const UserListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;

    return Scaffold(
      appBar: null, // Remove the default app bar
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Custom header
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios, color: Theme.of(context).colorScheme.onBackground),
                    onPressed: () => context.pop(),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Chat with Friends',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // StreamBuilder to get the list of users
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Center(child: Text('Something went wrong'));
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    // Filter out the current user from the list
                    final users = snapshot.data!.docs
                        .where((doc) => doc.id != auth.currentUser!.uid)
                        .toList();

                    if (users.isEmpty) {
                      return Center(
                        child: Text(
                          'No other users found.',
                          style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6)),
                        ),
                      );
                    }

                    // Display users in a styled list
                    return ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        final user = users[index];
                        final userEmail = user['email'] ?? 'No Email';

                        return Card(
                          elevation: 0,
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
                              child: Text(
                                userEmail.substring(0, 1).toUpperCase(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                                ),
                              ),
                            ),
                            title: Text(
                              userEmail,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            onTap: () {
                              // Navigate to the chat screen with the selected user's ID
                              context.go(
                                '/chat',
                                extra: {
                                  'receiverId': user.id,
                                  'receiverEmail': userEmail,
                                },
                              );
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
