import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../widgets/user_card.dart';
import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();


    final provider = Provider.of<UserProvider>(context, listen: false);
    provider.loadCachedUsers();


    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider.fetchUsers();
    });

    _scrollController.addListener(() {
      final provider = Provider.of<UserProvider>(context, listen: false);
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent &&
          !provider.isLoading &&
          provider.hasMore) {
        provider.fetchUsers();
      }
    });
  }

  Future<void> _refresh() async {
    await Provider.of<UserProvider>(context, listen: false).fetchUsers(isRefresh: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User Directory')),
      body: Consumer<UserProvider>(
        builder: (context, provider, child) {
          if (provider.error != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(provider.error!),
                  action: SnackBarAction(
                    label: 'Retry',
                    onPressed: () {
                      provider.fetchUsers(isRefresh: true);
                    },
                  ),
                ),
              );
            });
          }

          if (provider.isLoading && provider.users.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.builder(
              controller: _scrollController,
              itemCount: provider.users.length + (provider.hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index < provider.users.length) {
                  final user = provider.users[index];
                  return GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetailScreen(user: user),
                      ),
                    ),
                    child: UserCard(user: user),
                  );
                } else {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }

}
