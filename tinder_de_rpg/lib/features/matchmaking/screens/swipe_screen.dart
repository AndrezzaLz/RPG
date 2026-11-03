import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/colors.dart';
import '../../auth/providers/auth_provider.dart';
import '../models/campaign_model.dart';
import '../providers/matchmaking_provider.dart';
import '../widgets/parchment_card.dart';

/// Main matchmaking screen featuring card swiping with real campaigns from Supabase.
class SwipeScreen extends StatefulWidget {
  const SwipeScreen({super.key});

  @override
  State<SwipeScreen> createState() => _SwipeScreenState();
}

class _SwipeScreenState extends State<SwipeScreen> {
  final CardSwiperController _controller = CardSwiperController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onSwipeRight(CampaignModel campaign) {
    // ignore: avoid_print
    print('Match!');
    context.read<MatchmakingProvider>().recordSwipe(
          campaign: campaign,
          isLiked: true,
        );
  }

  void _onSwipeLeft(CampaignModel campaign) {
    // ignore: avoid_print
    print('Passed');
    context.read<MatchmakingProvider>().recordSwipe(
          campaign: campaign,
          isLiked: false,
        );
  }

  bool _handleSwipe(
    int previousIndex,
    int? currentIndex,
    CardSwiperDirection direction,
    List<CampaignModel> cards,
  ) {
    if (previousIndex >= 0 && previousIndex < cards.length) {
      final CampaignModel campaign = cards[previousIndex];
      if (direction == CardSwiperDirection.right) {
        _onSwipeRight(campaign);
      } else if (direction == CardSwiperDirection.left) {
        _onSwipeLeft(campaign);
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final MatchmakingProvider matchmaking =
        context.watch<MatchmakingProvider>();

    return Scaffold(
      backgroundColor: AppColors.darkBrown,
      appBar: AppBar(
        backgroundColor: AppColors.darkBrown,
        foregroundColor: AppColors.parchment,
        elevation: 0,
        title: const Text(
          'Mural de Missões',
          style: TextStyle(
            color: AppColors.parchment,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Atualizar Mural',
            color: AppColors.parchment,
            onPressed: matchmaking.isLoading
                ? null
                : () => matchmaking.refreshCards(),
          ),
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline),
            tooltip: 'Mensagens',
            color: AppColors.parchment,
            onPressed: () => context.go('/chat'),
          ),
          IconButton(
            icon: const Icon(Icons.person_outline),
            tooltip: 'Ficha de Personagem',
            color: AppColors.parchment,
            onPressed: () => context.go('/profile'),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sair da Guilda',
            color: AppColors.parchment,
            onPressed: () => context.read<AuthProvider>().signOut(),
          ),
        ],
      ),
      body: SafeArea(
        child: matchmaking.isLoading
            ? _buildLoadingState()
            : !matchmaking.hasCards
                ? _buildEmptyState(matchmaking)
                : Column(
                    children: [
                      Expanded(
                        child: CardSwiper(
                          controller: _controller,
                          cardsCount: matchmaking.cards.length,
                          numberOfCardsDisplayed: matchmaking.cards.length >= 3
                              ? 3
                              : matchmaking.cards.length,
                          backCardOffset: const Offset(0, -22),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                          onSwipe: (
                            int previousIndex,
                            int? currentIndex,
                            CardSwiperDirection direction,
                          ) =>
                              _handleSwipe(
                            previousIndex,
                            currentIndex,
                            direction,
                            matchmaking.cards,
                          ),
                          cardBuilder: (
                            BuildContext context,
                            int index,
                            int percentX,
                            int percentY,
                          ) {
                            return _buildCampaignCard(matchmaking.cards[index]);
                          },
                        ),
                      ),
                      _buildActionButtons(),
                    ],
                  ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: AppColors.primaryOrange),
          SizedBox(height: 16),
          Text(
            'Consultando o Mural da Guilda...',
            style: TextStyle(
              color: AppColors.parchment,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Buscando missões e campanhas disponíveis',
            style: TextStyle(
              color: AppColors.parchmentDim,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(MatchmakingProvider matchmaking) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: ParchmentCard(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.task_alt,
                size: 64,
                color: AppColors.primaryOrange,
              ),
              const SizedBox(height: 16),
              const Text(
                'Mural Vazio por Enquanto!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Você já avaliou todas as campanhas disponíveis no momento.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryOrange,
                  foregroundColor: AppColors.parchment,
                ),
                icon: const Icon(Icons.refresh),
                label: const Text('Recarregar Mural'),
                onPressed: () => matchmaking.refreshCards(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCampaignCard(CampaignModel campaign) {
    return ParchmentCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Campaign Header Image using CachedNetworkImage
          Expanded(
            flex: 5,
            child: Stack(
              fit: StackFit.expand,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(14),
                    topRight: Radius.circular(14),
                  ),
                  child: campaign.imageUrl.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: campaign.imageUrl,
                          fit: BoxFit.cover,
                          placeholder: (BuildContext context, String url) =>
                              Container(
                            color: AppColors.parchmentDim,
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: AppColors.primaryOrange,
                              ),
                            ),
                          ),
                          errorWidget:
                              (BuildContext context, String url, Object err) =>
                                  _buildImageFallback(),
                        )
                      : _buildImageFallback(),
                ),

                // Dark subtle gradient at the bottom edge of image
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  height: 50,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          AppColors.darkBrown.withValues(alpha: 0.65),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),

                // System & Player Count Badges
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.darkBrown.withValues(alpha: 0.85),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.primaryOrange,
                        width: 1,
                      ),
                    ),
                    child: Text(
                      campaign.system,
                      style: const TextStyle(
                        color: AppColors.accentGold,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.darkBrown.withValues(alpha: 0.85),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.primaryOrange,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.group,
                          size: 13,
                          color: AppColors.parchment,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${campaign.currentPlayers}/${campaign.maxPlayers}',
                          style: const TextStyle(
                            color: AppColors.parchment,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Content section inside Parchment
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Master Name
                  Text(
                    campaign.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.shield,
                        size: 14,
                        color: AppColors.primaryOrange,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Mestre: ${campaign.masterName}',
                        style: const TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryOrange,
                        ),
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.schedule,
                        size: 13,
                        color: AppColors.textDark,
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          campaign.schedule,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textDark,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Tags
                  if (campaign.tags.isNotEmpty) ...[
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: campaign.tags.map(_buildChip).toList(),
                    ),
                    const SizedBox(height: 8),
                  ],

                  const Divider(color: AppColors.parchmentDim, height: 1),
                  const SizedBox(height: 8),

                  // Campaign Synopsis / Description
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Text(
                        campaign.description,
                        style: const TextStyle(
                          fontSize: 13,
                          height: 1.4,
                          color: AppColors.textDark,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageFallback() {
    return Container(
      color: AppColors.parchmentDim,
      child: const Center(
        child: Icon(
          Icons.castle_outlined,
          size: 64,
          color: AppColors.primaryOrange,
        ),
      ),
    );
  }

  Widget _buildChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.parchmentDim.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: AppColors.primaryOrange.withValues(alpha: 0.5),
          width: 0.8,
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 11.5,
          fontWeight: FontWeight.w600,
          color: AppColors.textDark,
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Pass (Swipe Left)
          _buildCircleButton(
            icon: Icons.close,
            color: AppColors.errorRed,
            tooltip: 'Passar Missão (Swipe Left)',
            size: 54,
            onPressed: () => _controller.swipe(CardSwiperDirection.left),
          ),
          // Undo
          _buildCircleButton(
            icon: Icons.rotate_left,
            color: AppColors.accentGold,
            tooltip: 'Desfazer Último Deslize',
            size: 44,
            onPressed: _controller.undo,
          ),
          // Match / Accept (Swipe Right)
          _buildCircleButton(
            icon: Icons.shield,
            color: AppColors.successGreen,
            tooltip: 'Entrar na Campanha (Swipe Right)',
            size: 54,
            onPressed: () => _controller.swipe(CardSwiperDirection.right),
          ),
        ],
      ),
    );
  }

  Widget _buildCircleButton({
    required IconData icon,
    required Color color,
    required String tooltip,
    required double size,
    required VoidCallback onPressed,
  }) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        child: Ink(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.darkBrownCard,
            border: Border.all(color: color, width: 2),
            boxShadow: const [
              BoxShadow(
                color: Color(0x66000000),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onPressed,
            child: Icon(icon, color: color, size: size * 0.5),
          ),
        ),
      ),
    );
  }
}
