import 'package:flutter_test/flutter_test.dart';
import 'package:tinder_de_rpg/features/matchmaking/models/campaign_model.dart';
import 'package:tinder_de_rpg/features/matchmaking/providers/matchmaking_provider.dart';

void main() {
  group('MatchmakingProvider Swipes', () {
    test('recordSwipe removes swiped campaign and updates list on like/pass',
        () async {
      final MatchmakingProvider provider = MatchmakingProvider();
      await provider.fetchAvailableCards();

      final int initialCount = provider.cards.length;
      expect(initialCount, greaterThan(0));

      final CampaignModel firstCard = provider.cards.first;

      // Swipe Right (Like: is_liked = true)
      await provider.recordSwipe(campaign: firstCard, isLiked: true);

      expect(provider.cards.length, equals(initialCount - 1));
      expect(provider.cards.contains(firstCard), isFalse);

      final CampaignModel secondCard = provider.cards.first;

      // Swipe Left (Pass: is_liked = false)
      await provider.recordSwipe(campaign: secondCard, isLiked: false);

      expect(provider.cards.length, equals(initialCount - 2));
      expect(provider.cards.contains(secondCard), isFalse);
    });
  });
}
