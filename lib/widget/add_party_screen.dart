import 'package:flutter/material.dart';

class AddPartyScreen extends StatefulWidget {
  final List<String> cities;
  final void Function(String city, String partyName, String candidateName)
      onAddParty;
  final Future<void> Function(String, Map<String, dynamic>) addCandidate;

  const AddPartyScreen({
    super.key,
    required this.cities,
    required this.addCandidate,
    required this.onAddParty,
  });

  @override
  State<AddPartyScreen> createState() => _AddPartyScreenState();
}

class _AddPartyScreenState extends State<AddPartyScreen> {
  String? selectedCity;
  bool isAdding = false;

  final partyController = TextEditingController();
  final candidateController = TextEditingController();
  final dateController = TextEditingController();

  @override
  void dispose() {
    partyController.dispose();
    candidateController.dispose();
    super.dispose();
  }

  String partyEmoji(String partyName) {
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

  Future<void> addPartyButtonClick() async {
    if (isAdding) return;

    if (selectedCity == null ||
        partyController.text.trim().isEmpty ||
        candidateController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    setState(() {
      isAdding = true;
    });

    try {
      await widget.addCandidate(selectedCity!, {
        "Partyname": partyController.text.trim(),
        "Candidatename": candidateController.text.trim(),
        "Votes": 0,
        "Icon": partyEmoji(partyController.text.trim()),
      });

      if (!mounted) return;

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );

      setState(() {
        isAdding = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: const Text(
          "Add Party",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                items: widget.cities.map((city) {
                  return DropdownMenuItem(
                    value: city,
                    child: Text(city),
                  );
                }).toList(),
                onChanged: isAdding
                    ? null
                    : (value) {
                        setState(() {
                          selectedCity = value;
                        });
                      },
              ),

              const SizedBox(height: 20),

              TextField(
                controller: partyController,
                enabled: !isAdding,
                decoration: InputDecoration(
                  labelText: "Party Name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              TextField(
                controller: candidateController,
                enabled: !isAdding,
                decoration: InputDecoration(
                  labelText: "Candidate Name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  onPressed: isAdding ? null : addPartyButtonClick,
                  child: isAdding
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          "Add Party",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 20),

              TextField(
                controller: dateController,
                decoration: InputDecoration(
                  labelText: "Voting Date",
                  hintText: "25 May 2026",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}