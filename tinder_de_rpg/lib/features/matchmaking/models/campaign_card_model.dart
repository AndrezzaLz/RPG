export '../../profile/models/profile_model.dart';
export 'campaign_model.dart';

/// Legacy model representing an RPG adventurer for matchmaking cards.
class RpgProfile {
  const RpgProfile({
    required this.id,
    required this.name,
    required this.characterClass,
    required this.avatarUrl,
    required this.bio,
    this.level = 1,
    this.system = 'D&D 5e',
    this.playStyle = 'Roleplay & Exploração',
  });

  final String id;
  final String name;
  final String characterClass;
  final String avatarUrl;
  final String bio;
  final int level;
  final String system;
  final String playStyle;
}
