/// HCPC (Health and Care Professions Council) Registered Professions
/// UK'de kayıtlı sağlık ve bakım meslekleri listesi
class HCPCProfessions {
  static const List<String> professions = [
    'Arts Therapist',
    'Biomedical Scientist',
    'Chiropodist / Podiatrist',
    'Clinical Scientist',
    'Dietitian',
    'Hearing Aid Dispenser',
    'Occupational Therapist',
    'Operating Department Practitioner',
    'Orthoptist',
    'Paramedic',
    'Physiotherapist',
    'Practitioner Psychologist',
    'Prosthetist / Orthotist',
    'Radiographer (Diagnostic)',
    'Radiographer (Therapeutic)',
    'Social Worker in England',
    'Speech and Language Therapist',
    'Orthotist',
    'Prosthetist',
    'Clinical Psychologist',
    'Counselling Psychologist',
    'Educational Psychologist',
    'Forensic Psychologist',
    'Health Psychologist',
    'Occupational Psychologist',
    'Sport and Exercise Psychologist',
  ];

  /// Search professions by query (case-insensitive)
  /// Returns professions that start with the query, then those that contain it
  static List<String> searchProfessions(String query) {
    if (query.isEmpty) return professions;

    final lowerQuery = query.toLowerCase();
    final startsWith = professions
        .where((profession) => profession.toLowerCase().startsWith(lowerQuery))
        .toList();
    final contains = professions
        .where((profession) =>
            !profession.toLowerCase().startsWith(lowerQuery) &&
            profession.toLowerCase().contains(lowerQuery))
        .toList();

    return [...startsWith, ...contains];
  }

  /// Get profession by exact match
  static String? getProfession(String profession) {
    try {
      return professions.firstWhere(
        (p) => p.toLowerCase() == profession.toLowerCase(),
      );
    } catch (e) {
      return null;
    }
  }
}
