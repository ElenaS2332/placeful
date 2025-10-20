import 'package:flutter/material.dart';
import 'package:placeful/features/memories/screens/memory_details_screen.dart';
import 'package:placeful/features/memories/screens/add_memory_screen.dart';
import 'package:provider/provider.dart';
import 'package:placeful/features/memories/viewmodels/list_memories_viewmodel.dart';

class ListMemoriesScreen extends StatelessWidget {
  const ListMemoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ListMemoriesViewModel()..fetchMemoriesAndFavoriteList(),
      child: const _ListMemoriesScreenBody(),
    );
  }
}

class _ListMemoriesScreenBody extends StatefulWidget {
  const _ListMemoriesScreenBody();

  @override
  State<_ListMemoriesScreenBody> createState() =>
      _ListMemoriesScreenBodyState();
}

class _ListMemoriesScreenBodyState extends State<_ListMemoriesScreenBody> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  void _onScroll() {
    final vm = Provider.of<ListMemoriesViewModel>(context, listen: false);
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 100 &&
        !vm.isLoading) {
      vm.fetchMemoriesAndFavoriteList(loadMore: true);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  String _truncate(String? text, [int maxLength = 20]) {
    if (text == null) return '';
    return text.length <= maxLength
        ? text
        : '${text.substring(0, maxLength)}...';
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ListMemoriesViewModel>(
      builder: (context, vm, _) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (vm.errorMessage != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(vm.errorMessage!)));
            vm.errorMessage = null;
          }
        });

        return Scaffold(
          appBar: AppBar(
            title: const Text("All Memories"),
            backgroundColor: Colors.deepPurple,
          ),
          body: Padding(
            padding: const EdgeInsets.all(12.0),
            child:
                vm.isLoading && vm.memories.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : vm.memories.isEmpty
                    ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "No memories yet",
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                          const SizedBox(height: 16),
                          IconButton(
                            iconSize: 48,
                            color: Colors.deepPurple,
                            icon: const Icon(Icons.add_circle_outline),
                            onPressed: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const AddMemoryScreen(),
                                ),
                              );
                              vm.fetchMemoriesAndFavoriteList();
                            },
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "Add your first memory",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                    : RefreshIndicator(
                      onRefresh: () async => vm.fetchMemoriesAndFavoriteList(),
                      child: GridView.builder(
                        controller: _scrollController,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 0.7,
                            ),
                        itemCount: vm.memories.length + (vm.isLoading ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index >= vm.memories.length) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          final memory = vm.memories[index];

                          return GestureDetector(
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) =>
                                          MemoryDetailsScreen(memory: memory),
                                ),
                              );
                              vm.fetchMemoriesAndFavoriteList();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.purple.shade300.withValues(
                                  alpha: 0.8,
                                ),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 6,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  if (memory.imageUrl != null &&
                                      memory.imageUrl!.isNotEmpty)
                                    Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              const BorderRadius.vertical(
                                                top: Radius.circular(16),
                                              ),
                                          child: Image.network(
                                            memory.imageUrl!,
                                            height: 160,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (_, __, ___) => Container(
                                                  height: 160,
                                                  color: Colors.grey[300],
                                                  child: const Center(
                                                    child: Icon(
                                                      Icons.image_not_supported,
                                                    ),
                                                  ),
                                                ),
                                          ),
                                        ),
                                        Positioned(
                                          top: 4,
                                          right: 4,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white.withAlpha(
                                                230,
                                              ),
                                              shape: BoxShape.circle,
                                              boxShadow: const [
                                                BoxShadow(
                                                  color: Colors.black26,
                                                  blurRadius: 4,
                                                  offset: Offset(1, 2),
                                                ),
                                              ],
                                            ),
                                            child: Consumer<
                                              ListMemoriesViewModel
                                            >(
                                              builder: (context, vm, _) {
                                                final isFavorite = vm
                                                    .favoriteMemoriesList
                                                    .memories!
                                                    .any(
                                                      (m) => m.id == memory.id,
                                                    );
                                                return IconButton(
                                                  onPressed:
                                                      () => vm.toggleFavorite(
                                                        memory.id,
                                                      ),
                                                  icon: Icon(
                                                    isFavorite
                                                        ? Icons.favorite
                                                        : Icons.favorite_border,
                                                    color: Colors.redAccent,
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            _truncate(memory.title),
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              fontSize: 16,
                                            ),
                                            textAlign: TextAlign.left,
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            _truncate(memory.description),
                                            style: const TextStyle(
                                              color: Colors.white70,
                                              fontSize: 12,
                                            ),
                                            textAlign: TextAlign.left,
                                          ),
                                          const SizedBox(height: 4),
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.location_on,
                                                color: Colors.white70,
                                                size: 16,
                                              ),
                                              const SizedBox(width: 4),
                                              Expanded(
                                                child: Text(
                                                  _truncate(
                                                    memory.location?.name,
                                                  ),
                                                  style: const TextStyle(
                                                    color: Colors.white70,
                                                    fontSize: 12,
                                                  ),
                                                  textAlign: TextAlign.left,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
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
                          );
                        },
                      ),
                    ),
          ),
        );
      },
    );
  }
}
