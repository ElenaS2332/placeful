import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:placeful/features/memories/screens/memory_details_screen.dart';
import 'package:placeful/features/memories/screens/memory_map_screen.dart';
import 'package:placeful/features/memories/viewmodels/shared_memory_screen_viewmodel.dart';
import 'package:provider/provider.dart';

class SharedMemoryScreen extends StatelessWidget {
  const SharedMemoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SharedMemoryViewModel>(
      create: (context) {
        final vm = SharedMemoryViewModel();
        vm.loadSharedMemories();
        return vm;
      },
      child: const _SharedMemoryScreenBody(),
    );
  }
}

class _SharedMemoryScreenBody extends StatelessWidget {
  const _SharedMemoryScreenBody();

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<SharedMemoryViewModel>(context);
    final bgColor = const Color(0xFFF7F5FF);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        title: Text(
          "Memories from your Friends",
          style: GoogleFonts.poppins(
            textStyle: const TextStyle(
              color: Colors.deepPurple,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child:
            vm.isLoading
                ? const Center(
                  child: CircularProgressIndicator(color: Colors.deepPurple),
                )
                : vm.error != null
                ? Center(child: Text(vm.error!))
                : vm.sharedMemories.isEmpty
                ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: Center(
                    child: Text(
                      "Your friends haven't shared any memories yet. \nStart exploring together!",
                      style: GoogleFonts.poppins(color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
                : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: vm.sharedMemories.length,
                  itemBuilder: (context, index) {
                    final sharedMemory = vm.sharedMemories[index];
                    final friend = sharedMemory.friendFullName ?? "Friend";

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => MemoryDetailsScreen(
                                  memoryId: sharedMemory.memoryId,
                                ),
                          ),
                        );
                      },
                      child: Container(
                        height: 180,
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          image:
                              sharedMemory.memoryImageUrl != null
                                  ? DecorationImage(
                                    image: NetworkImage(
                                      sharedMemory.memoryImageUrl!,
                                    ),
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
                                sharedMemory.memoryTitle ?? "Untitled Memory",
                                style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              if (sharedMemory.memoryDescription != null &&
                                  sharedMemory.memoryDescription!.isNotEmpty)
                                Text(
                                  sharedMemory.memoryDescription!,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.poppins(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.person,
                                        color: Colors.white70,
                                        size: 18,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        friend,
                                        style: GoogleFonts.poppins(
                                          color: Colors.white70,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (sharedMemory.memoryDate != null)
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.calendar_today,
                                          color: Colors.white70,
                                          size: 16,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          "${sharedMemory.memoryDate!.day}/${sharedMemory.memoryDate!.month}/${sharedMemory.memoryDate!.year}",
                                          style: GoogleFonts.poppins(
                                            color: Colors.white70,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
      ),
    );
  }
}
