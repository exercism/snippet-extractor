class Anagram {
  List<String> findAnagrams(String subject, List<String> candidates) {
    final sortedSubject = _sort(subject.toLowerCase());
    return candidates.where((candidate) {
      final lower = candidate.toLowerCase();
      return lower != subject.toLowerCase() && _sort(lower) == sortedSubject;
    }).toList();
  }

  String _sort(String word) => (word.split('')..sort()).join();
