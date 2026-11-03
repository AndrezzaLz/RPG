/// Model representing an adventurer user profile from Supabase.
class ProfileModel {
  const ProfileModel({
    required this.id,
    required this.name,
    required this.bio,
    this.avatarUrl = '',
    this.characterClass = 'Aventureiro',
    this.favoriteSystem = 'D&D 5e',
    this.playStyle = 'Roleplay & Exploração',
    this.reputation = 5.0,
    this.isMaster = false,
  });

  final String id;
  final String name;
  final String bio;
  final String avatarUrl;
  final String characterClass;
  final String favoriteSystem;
  final String playStyle;
  final double reputation;
  final bool isMaster;

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ??
          json['username']?.toString() ??
          'Aventureiro Sem Nome',
      bio: json['bio']?.toString() ??
          'Aventureiro em busca de glória e companheiros de jornada.',
      avatarUrl: json['avatar_url']?.toString() ??
          json['avatarUrl']?.toString() ??
          '',
      characterClass: json['character_class']?.toString() ??
          json['class']?.toString() ??
          'Aventureiro',
      favoriteSystem: json['favorite_system']?.toString() ??
          json['system']?.toString() ??
          'D&D 5e',
      playStyle: json['play_style']?.toString() ??
          json['playStyle']?.toString() ??
          'Roleplay & Exploração',
      reputation: (json['reputation'] is num)
          ? (json['reputation'] as num).toDouble()
          : 5.0,
      isMaster: json['is_master'] == true || json['isMaster'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'bio': bio,
      'avatar_url': avatarUrl,
      'character_class': characterClass,
      'favorite_system': favoriteSystem,
      'play_style': playStyle,
      'reputation': reputation,
      'is_master': isMaster,
    };
  }
}
