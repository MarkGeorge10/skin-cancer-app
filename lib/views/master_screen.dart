import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skin_cancer_app/view_model/auth_view_model.dart';
import 'package:skin_cancer_app/view_model/bottom_nav_provider.dart';
import 'package:skin_cancer_app/views/chat/chat_screen.dart';
import 'package:skin_cancer_app/views/home/home_screen.dart';
import 'package:skin_cancer_app/views/notification/notification_screen.dart';
import 'package:skin_cancer_app/views/profile/profile_screen.dart';
import '../utils/app_styles.dart' as AppColors;

class MasterScreen extends StatefulWidget {
  const MasterScreen({super.key});

  @override
  State<MasterScreen> createState() => _MasterScreenState();
}

class _MasterScreenState extends State<MasterScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthViewModel, BottomNavProvider>(
      builder: (context, authVM, bottomProvider, child) {
        final user = authVM.currentUser;

        return Scaffold(
          key: scaffoldKey,
          backgroundColor: AppColors.backgroundColor,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(100),
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              automaticallyImplyLeading: false,
              flexibleSpace: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: AppColors.primaryColor,
                        backgroundImage: user?.avatarUrl != null
                            ? NetworkImage(user!.avatarUrl!)
                            : null,
                        child: user == null || user.avatarUrl == null
                            ? Text(
                          _initials(user?.name),
                          style: const TextStyle(color: Colors.white),
                        )
                            : null,
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              user != null ? 'Hello, ${user.name}!' : 'Hello!',
                              style: AppColors.headingStyle,
                            ),
                            const SizedBox(height: 4),
                            // const Text(
                            //   'Welcome to Skin Cancer App',
                            //   style: AppColors.subheadingStyle,
                            // ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          endDrawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: const BoxDecoration(color: AppColors.primaryColor),
                  child: Text(
                    user != null ? user.name : 'Menu',
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('Settings'),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Logout'),
                  onTap: () async {
                    await authVM.logout();
                    // navigate to login if needed
                  },
                ),
              ],
            ),
          ),
          body: IndexedStack(
            index: bottomProvider.selectedItem,
            children: const [
              HomeScreen(),
              ChatScreen(),
              ProfileScreen(),
              NotificationsScreen(),
            ],
          ),
          bottomNavigationBar: Container(
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 25),
            height: 65,
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(35),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 25,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNavItem(Icons.home_outlined, 0, bottomProvider),
                _buildNavItem(Icons.chat_bubble_outline, 1, bottomProvider),
                _buildNavItem(Icons.person_outline, 2, bottomProvider),
                _buildNavItem(Icons.notifications_outlined,3 , bottomProvider),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildNavItem(
      IconData icon, int index, BottomNavProvider bottomProvider) {
    final bool isSelected = bottomProvider.selectedItem == index;
    return GestureDetector(
      onTap: () {
        if (index == 4) {
          scaffoldKey.currentState?.openEndDrawer();
        } else {
          bottomProvider.changeScreenState(index);
        }
      },
      child: SizedBox(
        width: 50,
        height: 50,
        child: Center(
          child: Icon(
            icon,
            color: isSelected ? Colors.white : Colors.white.withOpacity(0.6),
            size: 26,
          ),
        ),
      ),
    );
  }

  String _initials(String? name) {
    if (name == null || name.isEmpty) return '';
    final parts = name.split(' ');
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return (parts[0][0] + parts.last[0]).toUpperCase();
  }
}
