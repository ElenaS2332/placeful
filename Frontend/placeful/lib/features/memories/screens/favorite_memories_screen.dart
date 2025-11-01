import 'package:flutter/material.dart';
import 'package:placeful/common/domain/models/memory.dart';
import 'package:placeful/features/memories/screens/memory_details_screen.dart';
import 'package:provider/provider.dart';
import 'package:placeful/features/memories/viewmodels/favorite_memories_viewmodel.dart';
import 'package:google_fonts/google_fonts.dart';

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
          backgroundColor: const Color(0xFFF8F6FF),
          appBar: AppBar(
            backgroundColor: const Color(0xFFF8F6FF),
            elevation: 0,
            title: Text(
              "Favorite Memories",
              style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            centerTitle: true,
            actions: [
              if (vm.favoriteMemoriesList?.memories?.isNotEmpty ?? false)
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.black87),
                  tooltip: "Clear Favorites",
                  onPressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder:
                          (_) => AlertDialog(
                            title: const Text("Clear All Favorites"),
                            content: const Text(
                              "Are you sure you want to clear all favorite memories?",
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
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
                ),
            ],
          ),
          body:
              vm.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : (vm.favoriteMemoriesList?.memories?.isEmpty ?? true)
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
                              builder:
                                  (_) => MemoryDetailsScreen(memoryId: item.id),
                            ),
                          );
                        },
                        child: Container(
                          height: 180,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            image:
                                item.imageUrl != null
                                    ? DecorationImage(
                                      image: NetworkImage(item.imageUrl!),
                                      fit: BoxFit.cover,
                                    )
                                    : null,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.15),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              gradient: LinearGradient(
                                colors: [
                                  Colors.black.withOpacity(0.5),
                                  Colors.transparent,
                                ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                            ),
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.title,
                                  style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  item.description,
                                  style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.white70,
                                    ),
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
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
