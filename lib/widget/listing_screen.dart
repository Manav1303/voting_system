import 'package:flutter/material.dart';
import 'package:voting_system/widget/citySel.dart';
import 'package:voting_system/widget/add_party_screen.dart';

class ListingScreen extends StatefulWidget {
  final List<String> messages;
  final Map<String, List<Map<String, dynamic>>> cityWiseData;
  final void Function(String city, int index, Map<String, dynamic> updated)
  onEditCandidate;
  final Future<void> Function(String city, Map<String, dynamic> candidate) addCandidate;
  final void Function(String city, int index) onDeleteCandidate;

  const ListingScreen({
    super.key,
    required this.messages,
    required this.cityWiseData,
    required this.addCandidate,
    required this.onEditCandidate,
    required this.onDeleteCandidate,
  });

  @override
  State<ListingScreen> createState() => _ListingScreenState();
}

class _ListingScreenState extends State<ListingScreen> {
  static String partyEmoji(String partyName) {
    switch (partyName.trim().toUpperCase()) {
      case 'BJP':      return '🪷';
      case 'CONGRESS': return '✋';
      case 'AAP':      return '🧹';
      case 'NCP':      return '🕰️';
      default:         return '🗳️';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            children: [
              const Expanded(
                child: Text(
                  'Voting System',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    color: Color.fromARGB(255, 9, 14, 10),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add),
                tooltip: 'Add New Party',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddPartyScreen(
                        cities: widget.cityWiseData.keys.toList(),
                        addCandidate: widget.addCandidate,
                        onAddParty: (city, partyName, candidateName) {},
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: CitySelectionScreen(
            cityWiseData: widget.cityWiseData,
            onEditCandidate: widget.onEditCandidate,
            onDeleteCandidate: widget.onDeleteCandidate,
          ),
        ),
      ],
    );
  }
}