import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voting_system/widget/listing_screen.dart';
import 'package:voting_system/widget/user_voting_screen.dart';

class Candidate {
  final String partyName;
  final String candidateName;
  final int votes;
  final String icon;

  Candidate({
    required this.partyName,
    required this.candidateName,
    required this.votes,
    required this.icon,
  });

  factory Candidate.fromJson(Map<String, dynamic> json) {
    final rawIcon = json['Icon'];

    return Candidate(
      partyName: json['Partyname'] as String,
      candidateName: json['Candidatename'] as String,
      votes: (json['Votes'] as num).toInt(),
      icon: (rawIcon is String && rawIcon.isNotEmpty)
          ? rawIcon
          : _emojiForParty(json['Partyname'] as String? ?? ''),
    );
  }

  factory Candidate.fromPrefs(SharedPreferences prefs, String prefix) {
    final partyName = prefs.getString('${prefix}_partyname') ?? '';
    final rawIcon = prefs.getString('${prefix}_icon') ?? '';

    return Candidate(
      partyName: partyName,
      candidateName: prefs.getString('${prefix}_candidatename') ?? '',
      votes: prefs.getInt('${prefix}_votes') ?? 0,
      icon: rawIcon.isNotEmpty ? rawIcon : _emojiForParty(partyName),
    );
  }

  Future<void> saveToPrefs(SharedPreferences prefs, String prefix) async {
    await prefs.setString('${prefix}_partyname', partyName);
    await prefs.setString('${prefix}_candidatename', candidateName);
    await prefs.setInt('${prefix}_votes', votes);
    await prefs.setString('${prefix}_icon', icon);
  }

  Map<String, dynamic> toMap() {
    return {
      'Partyname': partyName,
      'Candidatename': candidateName,
      'Votes': votes,
      'Icon': icon,
    };
  }

  static String _emojiForParty(String partyName) {
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
}

class FragmentPlaceholder extends StatefulWidget {
  final bool isAdmin;

  const FragmentPlaceholder({super.key, required this.isAdmin});
  @override
  State<FragmentPlaceholder> createState() => _FragmentPlaceholderState();
}

class _FragmentPlaceholderState extends State<FragmentPlaceholder> {
  SharedPreferences? _prefs;
  bool isLoading = true;

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
        "Icon": "🪷",
      },
      {
        "Partyname": "Congress",
        "Candidatename": "Prashant Patel",
        "Votes": 20,
        "Icon": "✋",
      },
      {
        "Partyname": "AAP",
        "Candidatename": "Aum Solanki",
        "Votes": 2,
        "Icon": "🧹",
      },
      {
        "Partyname": "NCP",
        "Candidatename": "Ravi Patel",
        "Votes": 0,
        "Icon": "🕰️",
      },
    ],
    "Ahmedabad": [
      {
        "Partyname": "BJP",
        "Candidatename": "Bhupendra Patel",
        "Votes": 0,
        "Icon": "🪷",
      },
      {
        "Partyname": "Congress",
        "Candidatename": "Ajay Patel",
        "Votes": 0,
        "Icon": "✋",
      },
      {
        "Partyname": "AAP",
        "Candidatename": "Gopal Parmar",
        "Votes": 0,
        "Icon": "🧹",
      },
    ],
    "Surat": [
      {
        "Partyname": "BJP",
        "Candidatename": "Mukesh Dalal",
        "Votes": 0,
        "Icon": "🪷",
      },
      {
        "Partyname": "Congress",
        "Candidatename": "Nilesh Kumbhani",
        "Votes": 0,
        "Icon": "✋",
      },
      {
        "Partyname": "AAP",
        "Candidatename": "Hetal Katariya",
        "Votes": 0,
        "Icon": "🧹",
      },
    ],
    "Rajkot": [
      {
        "Partyname": "BJP",
        "Candidatename": "Parshottam Rupala",
        "Votes": 0,
        "Icon": "🪷",
      },
      {
        "Partyname": "Congress",
        "Candidatename": "Paresh Dhanani",
        "Votes": 0,
        "Icon": "✋",
      },
      {
        "Partyname": "NCP",
        "Candidatename": "Jayesh Radadiya",
        "Votes": 0,
        "Icon": "🕰️",
      },
    ],
    "Anand": [
      {
        "Partyname": "BJP",
        "Candidatename": "Mitesh Patel",
        "Votes": 0,
        "Icon": "🪷",
      },
      {
        "Partyname": "Congress",
        "Candidatename": "Amul Bhatiya",
        "Votes": 0,
        "Icon": "✋",
      },
      {
        "Partyname": "AAP",
        "Candidatename": "Suresh Desai",
        "Votes": 0,
        "Icon": "🧹",
      },
    ],
  };

  @override
  void initState() {
    super.initState();
    prepareList();
  }

  Future<SharedPreferences> _getPrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  Future<void> prepareList() async {
    final prefs = await _getPrefs();

    final String? citiesRaw = prefs.getString('cities');

    if (citiesRaw == null || citiesRaw.isEmpty) {
      await _persistAll(prefs);
    } else {
      await _loadFromPrefs(prefs);
    }

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _loadFromPrefs(SharedPreferences prefs) async {
    final String? citiesRaw = prefs.getString('cities');

    if (citiesRaw == null || citiesRaw.isEmpty) {
      return;
    }

    final List<String> cities = citiesRaw
        .split(',')
        .where((city) => city.trim().isNotEmpty)
        .toList();

    final Map<String, List<Map<String, dynamic>>> loaded = {};

    for (final city in cities) {
      final int count = prefs.getInt('count_$city') ?? 0;
      final List<Map<String, dynamic>> candidates = [];

      for (int i = 0; i < count; i++) {
        final candidate = Candidate.fromPrefs(prefs, 'c_${city}_$i');

        if (candidate.partyName.isNotEmpty &&
            candidate.candidateName.isNotEmpty) {
          candidates.add(candidate.toMap());
        }
      }

      loaded[city] = candidates;
    }

    if (mounted) {
      setState(() {
        cityWiseData = loaded;
      });
    }
  }

  Future<void> saveList() async {
    final prefs = await _getPrefs();
    await _persistAll(prefs);
  }

  Future<void> _persistAll(SharedPreferences prefs) async {
    final List<String> oldCities =
        prefs.getString('cities')?.split(',') ?? [];

    for (final oldCity in oldCities) {
      final oldCount = prefs.getInt('count_$oldCity') ?? 0;

      for (int i = 0; i < oldCount; i++) {
        await prefs.remove('c_${oldCity}_${i}_partyname');
        await prefs.remove('c_${oldCity}_${i}_candidatename');
        await prefs.remove('c_${oldCity}_${i}_votes');
        await prefs.remove('c_${oldCity}_${i}_icon');
      }

      await prefs.remove('count_$oldCity');
    }

    final List<String> cityNames = cityWiseData.keys.toList();

    await prefs.setString('cities', cityNames.join(','));

    for (final city in cityNames) {
      final List<Map<String, dynamic>> candidates = cityWiseData[city] ?? [];

      await prefs.setInt('count_$city', candidates.length);

      for (int i = 0; i < candidates.length; i++) {
        final candidate = Candidate.fromJson(candidates[i]);
        await candidate.saveToPrefs(prefs, 'c_${city}_$i');
      }
    }
  }

  Future<void> addCandidate(
    String city,
    Map<String, dynamic> candidate,
  ) async {
    setState(() {
      cityWiseData = {
        ...cityWiseData,
        city: [
          ...(cityWiseData[city] ?? []),
          candidate,
        ],
      };
    });

    await saveList();
  }
  

  Future<void> editCandidate(
    String city,
    int index,
    Map<String, dynamic> updated,
  ) async {
    setState(() {
      final list = List<Map<String, dynamic>>.from(cityWiseData[city] ?? []);
      list[index] = updated;
      cityWiseData = {
        ...cityWiseData,
        city: list,
      };
    });

    await saveList();
  }

  Future<void> deleteCandidate(String city, int index) async {
    setState(() {
      final list = List<Map<String, dynamic>>.from(cityWiseData[city] ?? []);
      list.removeAt(index);
      cityWiseData = {
        ...cityWiseData,
        city: list,
      };
    });

    await saveList();
  }

  void voteCandidate(String city, int index) {
    setState(() {
      cityWiseData[city]![index]["Votes"]++;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blue,
        title: const Row(
          children: [
            Icon(Icons.how_to_vote, color: Colors.white),
            SizedBox(width: 8),
            Text(
              "Voting System",
              style: TextStyle(color: Colors.white),
            ),
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