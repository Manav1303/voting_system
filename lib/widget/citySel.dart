import 'package:flutter/material.dart';
import 'package:voting_system/widget/candidatecard.dart';

class CitySelectionScreen extends StatefulWidget {
  final Map<String, List<Map<String, dynamic>>> cityWiseData;
  final void Function(String city, int index, Map<String, dynamic> updated)
      onEditCandidate;
  final void Function(String city, int index) onDeleteCandidate;

  const CitySelectionScreen({
    super.key,
    required this.cityWiseData,
    required this.onEditCandidate,
    required this.onDeleteCandidate,
  });

  @override
  State<CitySelectionScreen> createState() => _CitySelectionScreenState();
}

class _CitySelectionScreenState extends State<CitySelectionScreen> {
  String? selectedCity;

  List<Map<String, dynamic>> candidates = [];

  @override
  void didUpdateWidget(covariant CitySelectionScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.cityWiseData != widget.cityWiseData) {
      setState(() {
        if (selectedCity != null) {
          if (widget.cityWiseData.containsKey(selectedCity)) {
            candidates = List<Map<String, dynamic>>.from(
              widget.cityWiseData[selectedCity!]!,
            );
          } else {
            selectedCity = null;
            candidates = [];
          }
        }
      });
    }
  }

  void _onCityChanged(String? city) {
    setState(() {
      selectedCity = city;
      candidates = city != null
          ? List<Map<String, dynamic>>.from(widget.cityWiseData[city]!)
          : [];
    });
  }

  String _emojiForParty(String partyName) {
    switch (partyName.trim().toUpperCase()) {
      case 'BJP':
        return '🪷';
      case 'CONGRESS':
        return '✋';
      case 'AAP':
        return '🧹';
      case 'NCP':
        return '🕰️';
      default:
        return '🗳️';
    }
  }

  void _showEditDialog(int index, Map<String, dynamic> candidate) {
    final partyCtrl = TextEditingController(text: candidate["Partyname"]);
    final nameCtrl = TextEditingController(text: candidate["Candidatename"]);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Edit Candidate"),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: partyCtrl,
              decoration: const InputDecoration(labelText: "Party Name"),
            ),
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: "Candidate Name"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              final partyName = partyCtrl.text.trim();
              final candidateName = nameCtrl.text.trim();

              if (partyName.isEmpty || candidateName.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Please fill all fields")),
                );
                return;
              }

              widget.onEditCandidate(selectedCity!, index, {
                "Partyname": partyName,
                "Candidatename": candidateName,
                "Votes": candidate["Votes"],
                "Icon": _emojiForParty(partyName),
              });

              Navigator.pop(ctx);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cities = widget.cityWiseData.keys.toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                value: selectedCity,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.blue,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Colors.blueAccent,
                      width: 2,
                    ),
                  ),
                ),
                hint: const Text(
                  "Select City",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                dropdownColor: Colors.blue,
                style: const TextStyle(color: Colors.white),
                items: cities
                    .map(
                      (city) => DropdownMenuItem(
                        value: city,
                        child: Text(city),
                      ),
                    )
                    .toList(),
                onChanged: _onCityChanged,
              ),

              const SizedBox(height: 20),

              if (selectedCity == null)
                const Text(
                  "Please select a city to see candidates.",
                  style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                )
              else
                Text(
                  "Selected City: $selectedCity",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

              const SizedBox(height: 12),
            ],
          ),
        ),

        if (selectedCity != null)
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: candidates.length,
              itemBuilder: (context, index) {
                final e = candidates[index];

                return CandidateCard(
                  partyName: e["Partyname"],
                  candidateName: e["Candidatename"],
                  votes: e["Votes"],
                  icon: e["Icon"],
                  onEdit: () => _showEditDialog(index, e),
                  onDelete: () =>
                      widget.onDeleteCandidate(selectedCity!, index),
                );
              },
            ),
          ),
      ],
    );
  }
}