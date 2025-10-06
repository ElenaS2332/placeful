import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:placeful/features/memories/viewmodels/list_memories_viewmodel.dart';

class ListMemoriesScreen extends StatelessWidget {
  const ListMemoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ListMemoriesViewModel()..fetchMemories(),
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
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final vm = Provider.of<ListMemoriesViewModel>(context, listen: false);
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 100 &&
        !vm.isLoading) {
      vm.fetchMemories(loadMore: true);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Color _getTileColor(int index) {
    final colors = [
      Colors.purple.shade300,
      Colors.blue.shade300,
      Colors.green.shade300,
      Colors.orange.shade300,
      Colors.red.shade300,
      Colors.teal.shade300,
    ];
    return colors[index % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ListMemoriesViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("All Memories"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child:
            vm.memories.isEmpty && vm.isLoading
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                  onRefresh: () async => vm.fetchMemories(),
                  child: GridView.builder(
                    controller: _scrollController,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 1,
                        ),
                    itemCount: vm.memories.length + (vm.isLoading ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index >= vm.memories.length) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final memory = vm.memories[index];
                      return Container(
                        decoration: BoxDecoration(
                          color: _getTileColor(index),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 6,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                memory.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                memory.description,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                memory.location?.latitude.toStringAsFixed(4) ??
                                    "No Lat",
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
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
  }
}
