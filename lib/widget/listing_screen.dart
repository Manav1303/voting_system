import 'package:flutter/material.dart';
import 'package:voting_system/widget/citySel.dart';
import 'package:voting_system/widget/add_party_screen.dart';

class ListingScreen extends StatelessWidget {
  final List<String> messages;
  final Map<String, List<Map<String, dynamic>>> cityWiseData;
  final void Function(String city, Map<String, dynamic> candidate) addCandidate;
  final void Function(String city, int index, Map<String, dynamic> updated)
  onEditCandidate;
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Voting System',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color.fromARGB(255, 9, 14, 10),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add New Party',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddPartyScreen(
                    cities: cityWiseData.keys.toList(),
                    addCandidate: addCandidate,
                    onAddParty: (city, partyName, candidateName) {
                      addCandidate(city, {
                        "Partyname": partyName,
                        "Candidatename": candidateName,
                        "Votes": 0,
                        "Icon": Icons.how_to_vote_outlined,
                      });
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: CitySelectionScreen(
        cityWiseData: cityWiseData,
        onEditCandidate: onEditCandidate,
        onDeleteCandidate: onDeleteCandidate,
      ),
    );
  }
}
