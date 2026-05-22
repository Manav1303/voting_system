import 'package:flutter/material.dart';

class AddPartyScreen extends StatefulWidget {
  final List<String> cities;
  final Function(String, Map<String, dynamic>) addCandidate;
  final void Function(String city, String partyName, String candidateName)
  onAddParty;

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
  final partyController = TextEditingController();
  final candidateController = TextEditingController();
  final dateController = TextEditingController();

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
                  return DropdownMenuItem(value: city, child: Text(city));
                }).toList(),
                onChanged: (value) => setState(() => selectedCity = value),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: partyController,
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
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  onPressed: () {
                    if (selectedCity == null ||
                        partyController.text.isEmpty ||
                        candidateController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Please fill all fields")),
                      );
                      return;
                    }
                    widget.addCandidate(selectedCity!, {
                      "Partyname": partyController.text,
                      "Candidatename": candidateController.text,
                      "Votes": 0,
                      "Icon": Icons.how_to_vote_outlined,
                    });
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Add Party",
                    style: TextStyle(color: Colors.white, fontSize: 18),
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
