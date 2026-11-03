import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/services/supabase_service.dart';
import '../models/campaign_model.dart';

/// Provider responsible for managing matchmaking campaigns, fetching available cards
/// from Supabase and filtering out already-evaluated cards from the 'swipes' table.
class MatchmakingProvider extends ChangeNotifier {
  MatchmakingProvider() {
    fetchAvailableCards();
  }

  List<CampaignModel> _cards = <CampaignModel>[];
  bool _isLoading = false;
  String? _errorMessage;
  final Set<String> _swipedIds = <String>{};

  /// List of available cards ready for swiping.
  List<CampaignModel> get cards => _cards;

  /// Whether a network fetch operation is currently in progress.
  bool get isLoading => _isLoading;

  /// Error message, if an error occurred during fetch or swipe.
  String? get errorMessage => _errorMessage;

  /// Whether there are remaining cards to display.
  bool get hasCards => _cards.isNotEmpty;

  /// Default fallback campaigns used when the Supabase database table is empty or offline.
  static const List<CampaignModel> _fallbackCampaigns = [
    CampaignModel(
      id: 'camp-1',
      title: 'A Maldição da Cidadela Negra',
      system: 'D&D 5e',
      masterName: 'Mestre Eldon',
      description:
          'Um antigo mal desperta nas profundezas da Cidadela Negra. Buscamos aventureiros corajosos de nível 3 para explorar catacumbas esquecidas e recuperar a Lâmina Solar.',
      imageUrl:
          'https://images.unsplash.com/photo-1518709268805-4e9042af9f23?w=800&auto=format&fit=crop&q=80',
      schedule: 'Sábados às 19h • Semanal',
      tags: ['Dungeon Crawl', 'Roleplay Intenso', 'Nível 3'],
      maxPlayers: 5,
      currentPlayers: 3,
    ),
    CampaignModel(
      id: 'camp-2',
      title: 'A Queda do Império de Tauron',
      system: 'Tormenta 20',
      masterName: 'Kallian Forja-Cinzas',
      description:
          'Nas terras de Arton, conflitos entre minotauros e rebeldes ameaçam a paz da guarnição. Campanha focada em intriga política, táticas de combate e exploração nos ermos.',
      imageUrl:
          'https://images.unsplash.com/photo-1579783900882-c0d3dad7b119?w=800&auto=format&fit=crop&q=80',
      schedule: 'Domingos às 15h • Quinzenal',
      tags: ['Alta Fantasia', 'Combate Tático', 'Iniciantes Bem-vindos'],
      maxPlayers: 6,
      currentPlayers: 4,
    ),
    CampaignModel(
      id: 'camp-3',
      title: 'O Sussurro nas Brumas de Arkham',
      system: 'Call of Cthulhu 7e',
      masterName: 'Guardião Arthur',
      description:
          'Investigadores são convocados para desvendar o desaparecimento de um professor na floresta costeira. Enigmas, loucura cósmica e decisões sob constante tensão psicológica.',
      imageUrl:
          'https://images.unsplash.com/photo-1509198397868-475647b2a1e5?w=800&auto=format&fit=crop&q=80',
      schedule: 'Sextas às 20h30 • Semanal',
      tags: ['Terror Cósmico', 'Investigação', 'Sem Combate Pesado'],
      maxPlayers: 4,
      currentPlayers: 2,
    ),
    CampaignModel(
      id: 'camp-4',
      title: 'Relíquias da Floresta dos Pavorosos',
      system: 'Old Dragon 2',
      masterName: 'Velho Bárbaro',
      description:
          'Estilo clássico old-school. Pouco ouro, perigo real em cada esquina e monstros imprevisíveis. Traga tochas extras, cordas e uma ficha reserva caso o pior aconteça.',
      imageUrl:
          'https://images.unsplash.com/photo-1514539079130-25950c84af65?w=800&auto=format&fit=crop&q=80',
      schedule: 'Quartas às 20h • Semanal',
      tags: ['OSR', 'Alta Letalidade', 'Exploração'],
      maxPlayers: 5,
      currentPlayers: 2,
    ),
  ];

  /// Fetches available campaign cards from Supabase, excluding cards already evaluated in 'swipes'.
  Future<void> fetchAvailableCards({String? userId}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (!SupabaseService.isInitialized) {
        // Use filtered fallback campaigns in offline / mock mode
        _cards = _fallbackCampaigns
            .where((CampaignModel c) => !_swipedIds.contains(c.id))
            .toList();
        _isLoading = false;
        notifyListeners();
        return;
      }

      final SupabaseClient client = SupabaseService.client;
      final String? currentUserId = userId ?? client.auth.currentUser?.id;

      // 1. Query previously evaluated cards from 'swipes' table
      final Set<String> evaluatedIds = <String>{..._swipedIds};
      if (currentUserId != null && currentUserId.isNotEmpty) {
        try {
          final List<dynamic> swipeRows = await client
              .from('swipes')
              .select('campaign_id, target_id')
              .eq('user_id', currentUserId);

          for (final dynamic row in swipeRows) {
            if (row is Map<String, dynamic>) {
              final String? targetId = row['campaign_id']?.toString() ??
                  row['target_id']?.toString();
              if (targetId != null && targetId.isNotEmpty) {
                evaluatedIds.add(targetId);
              }
            }
          }
        } catch (e) {
          debugPrint('MatchmakingProvider: Notice reading swipes table: $e');
        }
      }

      // 2. Query available cards from 'campaigns' table
      List<CampaignModel> fetchedCampaigns = <CampaignModel>[];
      try {
        final List<dynamic> campaignRows =
            await client.from('campaigns').select();

        fetchedCampaigns = campaignRows
            .map((dynamic row) =>
                CampaignModel.fromJson(row as Map<String, dynamic>))
            .toList();
      } catch (e) {
        debugPrint('MatchmakingProvider: Notice reading campaigns table: $e');
      }

      // If the database has records, filter out evaluated ones
      if (fetchedCampaigns.isNotEmpty) {
        _cards = fetchedCampaigns
            .where((CampaignModel c) => !evaluatedIds.contains(c.id))
            .toList();
      } else {
        // Fallback to initial campaign presets if database table is empty
        _cards = _fallbackCampaigns
            .where((CampaignModel c) => !evaluatedIds.contains(c.id))
            .toList();
      }

      _swipedIds.addAll(evaluatedIds);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Falha ao buscar campanhas: $e';
      _cards = _fallbackCampaigns
          .where((CampaignModel c) => !_swipedIds.contains(c.id))
          .toList();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Inserts a swipe record into the Supabase 'swipes' table with `is_liked: true|false`.
  ///
  /// Mutual match creation will be handled by the Database Trigger in Supabase.
  Future<void> recordSwipe({
    required CampaignModel campaign,
    required bool isLiked,
    String? userId,
  }) async {
    _swipedIds.add(campaign.id);
    _cards.removeWhere((CampaignModel c) => c.id == campaign.id);
    notifyListeners();

    if (!SupabaseService.isInitialized) {
      debugPrint(
        'MatchmakingProvider: Offline swipe recorded on "${campaign.title}" -> is_liked: $isLiked',
      );
      return;
    }

    try {
      final SupabaseClient client = SupabaseService.client;
      final String? currentUserId = userId ?? client.auth.currentUser?.id;

      if (currentUserId != null && currentUserId.isNotEmpty) {
        await client.from('swipes').insert(<String, dynamic>{
          'user_id': currentUserId,
          'campaign_id': campaign.id,
          'target_id': campaign.id,
          'is_liked': isLiked,
          'direction': isLiked ? 'right' : 'left',
          'created_at': DateTime.now().toIso8601String(),
        });
        debugPrint(
          'MatchmakingProvider: Inserted swipe in Supabase "swipes" (user: $currentUserId, campaign: ${campaign.id}, is_liked: $isLiked)',
        );
      }
    } catch (e) {
      debugPrint('MatchmakingProvider: Error saving swipe to Supabase: $e');
    }
  }

  /// Reloads or resets the cards list.
  Future<void> refreshCards() async {
    await fetchAvailableCards();
  }
}
