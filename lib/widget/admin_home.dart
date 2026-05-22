import 'package:flutter/material.dart';
import 'package:voting_system/widget/listing_screen.dart';

class AdminHome extends StatelessWidget {
  final List<String> messages;
  final Map<String, List<Map<String, dynamic>>> cityWiseData;
  final Future<void> Function(String city, Map<String, dynamic> candidate) addCandidate;
  final void Function(String city, int index, Map<String, dynamic> updated)
  onEditCandidate;
  final void Function(String city, int index) onDeleteCandidate;

  const AdminHome({
    super.key,
    required this.messages,
    required this.cityWiseData,
    required this.addCandidate,
    required this.onEditCandidate,
    required this.onDeleteCandidate,
  });

  @override
  Widget build(BuildContext context) {
    return ListingScreen(
      messages: messages,
      cityWiseData: cityWiseData,
      addCandidate: addCandidate,
      onEditCandidate: onEditCandidate,
      onDeleteCandidate: onDeleteCandidate,
    );
  }
}
