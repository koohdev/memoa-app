import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:always/services/weather_service.dart';
import 'package:always/models/weather_model.dart';
import 'package:always/screens/remind.dart';
import 'package:always/screens/write_screen.dart';
import 'package:always/screens/diary.dart';
import 'package:always/screens/weather.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:always/theme_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    if (index == 2) {
      context.push('/write');
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  BottomNavigationBarItem _buildNavItem(
    String iconPath,
    String label,
    int index,
    bool isSelected,
    Color selectedColor,
    Color unselectedColor,
  ) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    if (label == 'Write') {
      return BottomNavigationBarItem(
        icon: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: themeProvider.isDarkMode ? Theme.of(context).colorScheme.primary : Colors.black,
            shape: BoxShape.circle,
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                Theme.of(context).colorScheme.onPrimary,
                BlendMode.srcIn,
              ),
              child: Image.asset(iconPath, height: 24),
            ),
          ),
        ),
        label: '',
      );
    }

    return BottomNavigationBarItem(
      icon: ColorFiltered(
        colorFilter: ColorFilter.mode(
          isSelected ? selectedColor : unselectedColor,
          BlendMode.srcIn,
        ),
        child: Image.asset(
          iconPath,
          height: 24,
          errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
        ),
      ),
      label: label,
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final username =
        user?.displayName ?? user?.email?.split('@').first ?? 'User';

    final List<Widget> widgetOptions = <Widget>[
      _MainHomeContent(username: username),
      const RemindScreen(),
      const WriteScreen(),
      const DiaryScreen(),
      const WeatherScreen(),
    ];

    return Scaffold(
      appBar: null, // AppBar removed
      body: IndexedStack(index: _selectedIndex, children: widgetOptions),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          _buildNavItem('images/home.png', 'Home', 0, _selectedIndex == 0, Theme.of(context).bottomNavigationBarTheme.selectedItemColor!, Theme.of(context).bottomNavigationBarTheme.unselectedItemColor!),
          _buildNavItem('images/remind.png', 'Remind', 1, _selectedIndex == 1, Theme.of(context).bottomNavigationBarTheme.selectedItemColor!, Theme.of(context).bottomNavigationBarTheme.unselectedItemColor!),
          _buildNavItem('images/write.png', 'Write', 2, _selectedIndex == 2, Theme.of(context).bottomNavigationBarTheme.selectedItemColor!, Theme.of(context).bottomNavigationBarTheme.unselectedItemColor!),
          _buildNavItem('images/diary.png', 'Diary', 3, _selectedIndex == 3, Theme.of(context).bottomNavigationBarTheme.selectedItemColor!, Theme.of(context).bottomNavigationBarTheme.unselectedItemColor!),
          _buildNavItem('images/weather.png', 'Weather', 4, _selectedIndex == 4, Theme.of(context).bottomNavigationBarTheme.selectedItemColor!, Theme.of(context).bottomNavigationBarTheme.unselectedItemColor!),
        ],
      ),
    );
  }
}

class _MainHomeContent extends StatelessWidget {
  final String username;
  const _MainHomeContent({required this.username});

  void _navigateToLogout(BuildContext context) {
    context.push('/logout');
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40), // Top padding for status bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Good morning, \n@$username!',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              ),
              IconButton(
                icon: Image.asset('images/logout-icon.png', height: 38),
                onPressed: () => _navigateToLogout(context),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const _WeatherWidget(),
          const SizedBox(height: 20),
          const _ReminderWidget(),
          const SizedBox(height: 20),
          _DiaryWidget(),
          const SizedBox(height: 20),
          const _ChatCard(),
          const SizedBox(height: 20),
          const _ThemeToggleCard(),
        ],
      ),
    );
  }
}

class _ThemeToggleCard extends StatelessWidget {
  const _ThemeToggleCard();

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Card(
      child: SwitchListTile(
        title: Text(
          'Dark Mode',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        value: themeProvider.isDarkMode,
        onChanged: (value) {
          themeProvider.toggleTheme();
        },
        secondary: Icon(
          themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}

class _ChatCard extends StatelessWidget {
  const _ChatCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () => context.go('/users'),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(Icons.chat_bubble_outline_rounded, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 16),
              Text(
                'Chat with Friends',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class _WeatherWidget extends StatefulWidget {
  const _WeatherWidget();

  @override
  __WeatherWidgetState createState() => __WeatherWidgetState();
}

class __WeatherWidgetState extends State<_WeatherWidget> {
  final WeatherService _weatherService = WeatherService();
  Weather? _weather;

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  Future<void> _fetchWeather() async {
    try {
      final weather = await _weatherService.fetchWeather(
        'Capas, Tarlac, Philippines',
      );
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _weather == null
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Today',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      Text(DateFormat('E, d MMM yyyy').format(DateTime.now()), style: Theme.of(context).textTheme.bodyMedium,),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${_weather!.temperature.round()}°',
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  const SizedBox(height: 10),
                   Text(
                    'Feels like ${_weather!.feelsLike.round()}°',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Theme.of(context).textTheme.bodySmall?.color),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Capas, Tarlac, Philippines',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
      ),
    );
  }
}

class _ReminderWidget extends StatelessWidget {
  const _ReminderWidget();

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const SizedBox.shrink(); // Don't show the widget if the user is not logged in
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Reminders',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 10),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('reminders')
                  .where('userId', isEqualTo: user.uid)
                  .where('date', isGreaterThanOrEqualTo: Timestamp.now())
                  .orderBy('date', descending: false)
                  .limit(3)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Text(
                    'Error loading reminders. A database index is required.',
                    style: TextStyle(color: Theme.of(context).colorScheme.error),
                  );
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return ListTile(
                    leading: Icon(
                      Icons.check_circle_outline,
                      color: Colors.green,
                    ),
                    title: Text('All caught up!', style: Theme.of(context).textTheme.titleMedium),
                    subtitle: Text('You have no upcoming reminders.', style: Theme.of(context).textTheme.bodyMedium),
                  );
                }

                final reminders = snapshot.data!.docs;

                return Column(
                  children: reminders.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    final title = data['title'] ?? 'No Title';
                    final description = data['description'] ?? 'No Description';
                    final date = (data['date'] as Timestamp).toDate();

                    return Card(
                      color: Theme.of(context).colorScheme.secondary,
                      margin: const EdgeInsets.symmetric(vertical: 4.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListTile(
                        title: Text(
                          title,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        subtitle: Text(description, style: Theme.of(context).textTheme.bodySmall),
                        trailing: Text(
                          DateFormat('E, MMM d').format(date),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        onTap: () {
                          context.push('/reminder/${doc.id}');
                        },
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _DiaryWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text('Log in to see your diary entries.', style: Theme.of(context).textTheme.bodyMedium),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Diary',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 10),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('notes')
                  .where('userId', isEqualTo: user.uid)
                  .orderBy('timestamp', descending: true)
                  .limit(3)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Text('Error loading diary: ${snapshot.error}', style: TextStyle(color: Theme.of(context).colorScheme.error));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Card(
                    color: Theme.of(context).colorScheme.secondary,
                    shape: RoundedRectangleBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                    ),
                    child: ListTile(
                      title: Text('No entries yet', style: Theme.of(context).textTheme.titleMedium),
                      subtitle: Text(
                        'Tap the "Write" button to start your first diary entry!',
                         style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  );
                }

                final notes = snapshot.data!.docs;

                return Column(
                  children: notes.map((doc) {
                    final noteData = doc.data() as Map<String, dynamic>;
                    final title = noteData['title'] ?? 'No Title';
                    final timestamp = noteData['timestamp'] as Timestamp?;

                    return Card(
                      color: Theme.of(context).colorScheme.secondary,
                      margin: const EdgeInsets.symmetric(vertical: 4.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListTile(
                        title: Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        subtitle: Text(
                          timestamp != null
                              ? timeago.format(timestamp.toDate())
                              : 'No date',
                           style: Theme.of(context).textTheme.bodySmall,
                        ),
                        onTap: () {
                          context.push('/diary/${doc.id}');
                        },
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
