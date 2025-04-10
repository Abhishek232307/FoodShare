import 'package:flutter/material.dart';
import '../donor_dashboard.dart';
import '../ngo_dashboard.dart';
import '../needy_dashboard.dart'; // Import NeedyDashboard

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Your Role', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
        automaticallyImplyLeading: false,
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'What would you like to do?',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            _buildRoleCard(
              context,
              'Donor',
              'Share food with those in need',
              Icons.volunteer_activism,
              Colors.orange,
                  () => _navigateToRoleScreen(context, 'donor'),
            ),
            const SizedBox(height: 20),
            _buildRoleCard(
              context,
              'NGO',
              'Collect and distribute food',
              Icons.business,
              Colors.blue,
                  () => _navigateToRoleScreen(context, 'ngo'),
            ),
            const SizedBox(height: 20),
            _buildRoleCard(
              context,
              'Needy',
              'Find available food donations',
              Icons.person,
              Colors.purple,
                  () => _handleNeedySelection(context), // Updated navigation
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleCard(
      BuildContext context,
      String title,
      String subtitle,
      IconData icon,
      Color color,
      VoidCallback onTap,
      ) {
    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: color, width: 2),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  size: 40,
                  color: color,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: color,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToRoleScreen(BuildContext context, String role) {
    if (role == 'donor') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const DonorDashboard()),
      );
    } else if (role == 'ngo') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const NGODashboard()),
      );
    }
  }

  void _handleNeedySelection(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const NeedyDashboard(user: null), // Pass user info if available
      ),
    );
  }
}
