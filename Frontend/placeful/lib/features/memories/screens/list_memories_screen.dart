import 'package:flutter/material.dart';
import 'package:placeful/features/memories/screens/memory_details_screen.dart';
import 'package:placeful/features/memories/screens/add_memory_screen.dart';
import 'package:provider/provider.dart';
import 'package:placeful/features/memories/viewmodels/list_memories_viewmodel.dart';
import 'package:google_fonts/google_fonts.dart';

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
  final Color _bgColor = const Color(0xFFF7F5FF);

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
          extendBodyBehindAppBar: true,
          backgroundColor: _bgColor,
          appBar: AppBar(
            title: Text(
              "All Memories",
              style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.black87,
                ),
              ),
            ),
            backgroundColor: _bgColor,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.black87),
          ),
          body: Stack(
            children: [
              Positioned(
                top: 20,
                left: -20,
                child: Transform.rotate(
                  angle: -0.3,
                  child: Icon(
                    Icons.eco_rounded,
                    size: 180,
                    color: Colors.purple.withValues(alpha: 0.15),
                  ),
                ),
              ),
              Positioned(
                bottom: 40,
                right: -20,
                child: Transform.rotate(
                  angle: 0.4,
                  child: Icon(
                    Icons.eco_rounded,
                    size: 200,
                    color: Colors.purple.withValues(alpha: 0.18),
                  ),
                ),
              ),
              SafeArea(
                child:
                    vm.isLoading && vm.memories.isEmpty
                        ? const Center(
                          child: CircularProgressIndicator(
                            color: Colors.deepPurple,
                          ),
                        )
                        : vm.memories.isEmpty
                        ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "No memories yet",
                                style: GoogleFonts.nunito(
                                  textStyle: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.black54,
                                  ),
                                ),
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
                              Text(
                                "Add your first memory",
                                style: GoogleFonts.nunito(
                                  textStyle: const TextStyle(
                                    color: Colors.black54,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                        : RefreshIndicator(
                          color: Colors.deepPurple,
                          onRefresh:
                              () async => vm.fetchMemoriesAndFavoriteList(),
                          child: GridView.builder(
                            controller: _scrollController,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 24,
                            ),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 16,
                                  mainAxisSpacing: 16,
                                  childAspectRatio: 0.7,
                                ),
                            itemCount:
                                vm.memories.length + (vm.isLoading ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index >= vm.memories.length) {
                                return const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.deepPurple,
                                  ),
                                );
                              }

                              final memory = vm.memories[index];

                              final isFavorite =
                                  vm.favoriteMemoriesList.memories?.any(
                                    (m) => m.id == memory.id,
                                  ) ??
                                  false;

                              return GestureDetector(
                                onTap: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (_) => MemoryDetailsScreen(
                                            memoryId: memory.id,
                                          ),
                                    ),
                                  );
                                  vm.fetchMemoriesAndFavoriteList();
                                },
                                child: Stack(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.purple.shade400,
                                            Colors.purple.shade100,
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          if (memory.imageUrl != null &&
                                              memory.imageUrl!.isNotEmpty)
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
                                                          Icons
                                                              .image_not_supported,
                                                        ),
                                                      ),
                                                    ),
                                              ),
                                            ),
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.all(
                                                8.0,
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    _truncate(memory.title),
                                                    style: GoogleFonts.poppins(
                                                      textStyle:
                                                          const TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.white,
                                                            fontSize: 16,
                                                          ),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    _truncate(
                                                      memory.description,
                                                    ),
                                                    style: GoogleFonts.nunito(
                                                      textStyle:
                                                          const TextStyle(
                                                            color:
                                                                Colors.white70,
                                                            fontSize: 12,
                                                          ),
                                                    ),
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
                                                            memory
                                                                .location
                                                                ?.name,
                                                          ),
                                                          style: GoogleFonts.nunito(
                                                            textStyle:
                                                                const TextStyle(
                                                                  color:
                                                                      Colors
                                                                          .white70,
                                                                  fontSize: 12,
                                                                ),
                                                          ),
                                                          maxLines: 1,
                                                          overflow:
                                                              TextOverflow
                                                                  .ellipsis,
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
                                    if (memory.imageUrl != null &&
                                        memory.imageUrl!.isNotEmpty)
                                      Positioned(
                                        top: 8,
                                        right: 8,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white.withValues(
                                              alpha: 0.8,
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
                                          child: IconButton(
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
                                            iconSize: 20,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
              ),
            ],
          ),
        );
      },
    );
  }
}
