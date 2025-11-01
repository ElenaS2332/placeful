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
      create: (BuildContext context) {
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.deepPurple),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const MemoryMapScreen()),
            );
          },
        ),
        title: Text(
          "Shared Memories",
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
                ? Center(
                  child: Text(
                    "No shared memories yet.",
                    style: GoogleFonts.poppins(color: Colors.grey),
                  ),
                )
                : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: vm.sharedMemories.length,
                  itemBuilder: (context, index) {
                    final sharedMemory = vm.sharedMemories[index];
                    final friend = sharedMemory.friendFullName;

                    // generate color per friend
                    // final color = vm.getColorForFriend(
                    //   friend?.firebaseUid ?? '',
                    // );

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
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.amber.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.black, width: 1),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 5,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              sharedMemory.memoryTitle ?? "Untitled",
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.amber,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              sharedMemory.memoryDescription ??
                                  "No description",
                              style: GoogleFonts.poppins(color: Colors.black87),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Shared by ${sharedMemory.friendFullName ?? "a friend"}",
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      ),
    );
  }
}
