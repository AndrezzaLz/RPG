/// Model representing an RPG campaign or quest posted on the board.
class CampaignModel {
  const CampaignModel({
    required this.id,
    required this.title,
    required this.system,
    required this.description,
    this.masterId = '',
    this.masterName = 'Mestre Anônimo',
    this.imageUrl = '',
    this.tags = const <String>[],
    this.schedule = 'A definir',
    this.maxPlayers = 5,
    this.currentPlayers = 1,
    this.createdAt,
  });

  final String id;
  final String masterId;
  final String masterName;
  final String title;
  final String system;
  final String description;
  final String imageUrl;
  final List<String> tags;
  final String schedule;
  final int maxPlayers;
  final int currentPlayers;
  final DateTime? createdAt;

  factory CampaignModel.fromJson(Map<String, dynamic> json) {
    List<String> parsedTags = <String>[];
    if (json['tags'] is List) {
      parsedTags = (json['tags'] as List)
          .map((dynamic item) => item.toString())
          .toList();
    } else if (json['tags'] is String && (json['tags'] as String).isNotEmpty) {
      parsedTags = (json['tags'] as String)
          .split(',')
          .map((String s) => s.trim())
          .toList();
    }

    return CampaignModel(
      id: json['id']?.toString() ?? '',
      masterId: json['master_id']?.toString() ??
          json['masterId']?.toString() ??
          '',
      masterName: json['master_name']?.toString() ??
          json['masterName']?.toString() ??
          'Mestre da Guilda',
      title: json['title']?.toString() ??
          json['name']?.toString() ??
          'Campanha Sem Título',
      system: json['system']?.toString() ?? 'D&D 5e',
      description: json['description']?.toString() ??
          'Uma jornada repleta de perigos e glória nos ermos desconhecidos.',
      imageUrl: json['image_url']?.toString() ??
          json['imageUrl']?.toString() ??
          json['cover_url']?.toString() ??
          '',
      tags: parsedTags,
      schedule: json['schedule']?.toString() ??
          json['horario']?.toString() ??
          'Fins de semana',
      maxPlayers: (json['max_players'] is num)
          ? (json['max_players'] as num).toInt()
          : 5,
      currentPlayers: (json['current_players'] is num)
          ? (json['current_players'] as num).toInt()
          : 1,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'master_id': masterId,
      'master_name': masterName,
      'title': title,
      'system': system,
      'description': description,
      'image_url': imageUrl,
      'tags': tags,
      'schedule': schedule,
      'max_players': maxPlayers,
      'current_players': currentPlayers,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
    };
  }
}
