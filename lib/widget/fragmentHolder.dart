import 'package:flutter/material.dart';
import 'package:voting_system/widget/listing_screen.dart';
import 'package:voting_system/widget/user_voting_screen.dart';

class FragmentPlaceholder extends StatefulWidget {
  final bool isAdmin;

  const FragmentPlaceholder({super.key, required this.isAdmin});
  @override
  State<FragmentPlaceholder> createState() => _FragmentPlaceholderState();
}

class _FragmentPlaceholderState extends State<FragmentPlaceholder> {
  List<String> messages = [
    "Want to live better?",
    "Choose your leaders wisely.",
    "Vote for a brighter future!",
  ];
  String votingDate = "25 May 2026";

  Map<String, List<Map<String, dynamic>>> cityWiseData = {
    "Vadodara": [
      {
        "Partyname": "BJP",
        "Candidatename": "Ranjan Bhatt",
        "Votes": 60,
        "Icon": Icons.how_to_vote_outlined,
      },
      {
        "Partyname": "Congress",
        "Candidatename": "Prashant Patel",
        "Votes": 20,
        "Icon": Icons.how_to_vote_outlined,
      },
      {
        "Partyname": "AAP",
        "Candidatename": "Aum Solanki",
        "Votes": 2,
        "Icon": Icons.how_to_vote_outlined,
      },
      {
        "Partyname": "NCP",
        "Candidatename": "Ravi Patel",
        "Votes": 0,
        "Icon": Icons.how_to_vote_outlined,
      },
    ],
    "Ahmedabad": [
      {
        "Partyname": "BJP",
        "Candidatename": "Bhupendra Patel",
        "Votes": 0,
        "Icon": Icons.how_to_vote_outlined,
      },
      {
        "Partyname": "Congress",
        "Candidatename": "Ajay Patel",
        "Votes": 0,
        "Icon": Icons.how_to_vote_outlined,
      },
      {
        "Partyname": "AAP",
        "Candidatename": "Gopal Parmar",
        "Votes": 0,
        "Icon": Icons.how_to_vote_outlined,
      },
    ],
    "Surat": [
      {
        "Partyname": "BJP",
        "Candidatename": "Mukesh Dalal",
        "Votes": 0,
        "Icon": Icons.how_to_vote_outlined,
      },
      {
        "Partyname": "Congress",
        "Candidatename": "Nilesh Kumbhani",
        "Votes": 0,
        "Icon": Icons.how_to_vote_outlined,
      },
      {
        "Partyname": "AAP",
        "Candidatename": "Hetal Katariya",
        "Votes": 0,
        "Icon": Icons.how_to_vote_outlined,
      },
    ],
    "Rajkot": [
      {
        "Partyname": "BJP",
        "Candidatename": "Parshottam Rupala",
        "Votes": 0,
        "Icon": Icons.how_to_vote_outlined,
      },
      {
        "Partyname": "Congress",
        "Candidatename": "Paresh Dhanani",
        "Votes": 0,
        "Icon": Icons.how_to_vote_outlined,
      },
      {
        "Partyname": "NCP",
        "Candidatename": "Jayesh Radadiya",
        "Votes": 0,
        "Icon": Icons.how_to_vote_outlined,
      },
    ],
    "Anand": [
      {
        "Partyname": "BJP",
        "Candidatename": "Mitesh Patel",
        "Votes": 0,
        "Icon": Icons.how_to_vote_outlined,
      },
      {
        "Partyname": "Congress",
        "Candidatename": "Amul Bhatiya",
        "Votes": 0,
        "Icon": Icons.how_to_vote_outlined,
      },
      {
        "Partyname": "AAP",
        "Candidatename": "Suresh Desai",
        "Votes": 0,
        "Icon": Icons.how_to_vote_outlined,
      },
    ],
  };

  void addCandidate(String city, Map<String, dynamic> candidate) {
    setState(() {
      cityWiseData = {
        ...cityWiseData,
        city: [...(cityWiseData[city] ?? []), candidate],
      };
    });
  }

  void editCandidate(String city, int index, Map<String, dynamic> updated) {
    setState(() {
      final list = List<Map<String, dynamic>>.from(cityWiseData[city]!);
      list[index] = updated;
      cityWiseData = {...cityWiseData, city: list};
    });
  }

  void deleteCandidate(String city, int index) {
    setState(() {
      final list = List<Map<String, dynamic>>.from(cityWiseData[city]!);
      list.removeAt(index);
      cityWiseData = {...cityWiseData, city: list};
    });
  }

  void voteCandidate(String city, int index) {
    setState(() {
      cityWiseData[city]![index]["Votes"]++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blue.shade800,
        title: Row(
          children: [
            const Icon(Icons.how_to_vote, color: Colors.white),
            const SizedBox(width: 8),
          ],
        ),
      ),
      body: widget.isAdmin
          ? ListingScreen(
              messages: messages,
              cityWiseData: cityWiseData,
              addCandidate: addCandidate,
              onEditCandidate: editCandidate,
              onDeleteCandidate: deleteCandidate,
            )
          : UserVotingScreen(
              cityWiseData: cityWiseData,
              votingDate: votingDate,
              onVote: voteCandidate,
            ),
    );
  }
}
