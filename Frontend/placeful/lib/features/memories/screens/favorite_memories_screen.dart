import 'package:flutter/material.dart';
import 'package:placeful/common/domain/models/memory.dart';
import 'package:placeful/features/memories/screens/memory_details_screen.dart';
import 'package:provider/provider.dart';
import 'package:placeful/features/memories/viewmodels/favorite_memories_viewmodel.dart';

class FavoriteMemoriesScreen extends StatelessWidget {
  const FavoriteMemoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FavoriteMemoriesViewModel()..fetchFavorites(),
      child: const _FavoriteMemoriesBody(),
    );
  }
}

class _FavoriteMemoriesBody extends StatelessWidget {
  const _FavoriteMemoriesBody();

  @override
  Widget build(BuildContext context) {
    return Consumer<FavoriteMemoriesViewModel>(
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
            title: const Text("Favorite Memories"),
            actions: [
              vm.favoriteMemoriesList != null &&
                      vm.favoriteMemoriesList!.memories != null &&
                      vm.favoriteMemoriesList!.memories!.isNotEmpty
                  ? IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder:
                            (context) => AlertDialog(
                              title: const Text("Clear All Favorites"),
                              content: const Text(
                                "Are you sure you want to clear all favorite memories?",
                              ),
                              actions: [
                                TextButton(
                                  onPressed:
                                      () => Navigator.pop(context, false),
                                  child: const Text("Cancel"),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text("Clear"),
                                ),
                              ],
                            ),
                      );

                      if (confirm == true) {
                        vm.favoriteMemoriesList!.memories!.clear();
                        vm.notifyListenersFromVM();

                        try {
                          await vm.clearFavorites();
                        } catch (_) {
                          vm.errorMessage = "Something went wrong";
                          vm.notifyListenersFromVM();
                        }
                      }
                    },
                  )
                  : const SizedBox.shrink(),
            ],
            backgroundColor: Colors.amber.shade700,
          ),
          body:
              vm.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : vm.favoriteMemoriesList == null ||
                      vm.favoriteMemoriesList!.memories == null ||
                      vm.favoriteMemoriesList!.memories!.isEmpty
                  ? const Center(
                    child: Text(
                      "No favorite memories yet",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                  : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: vm.favoriteMemoriesList!.memories!.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final Memory item =
                          vm.favoriteMemoriesList!.memories![index];

                      return InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => MemoryDetailsScreen(memory: item),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.amber.shade300,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.title,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      item.description,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.white70,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(
                                Icons.chevron_right,
                                color: Colors.white,
                                size: 28,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
        );
      },
    );
  }
}
