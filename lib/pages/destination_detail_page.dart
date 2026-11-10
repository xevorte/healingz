import 'package:flutter/material.dart';

import '../models/destination.dart';

class DestinationDetailPage extends StatefulWidget {
  const DestinationDetailPage({
    super.key,
    required this.destination,
    required this.onBook,
    this.isFavorite = false,
    this.onFavoriteChanged,
  });
  final Destination destination;
  final VoidCallback onBook;
  final bool isFavorite;
  final ValueChanged<bool>? onFavoriteChanged;
  @override
  State<DestinationDetailPage> createState() => _DestinationDetailState();
}

class _DestinationDetailState extends State<DestinationDetailPage> {
  int tab = 0;
  late bool _isFavorite;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.isFavorite;
  }

  void _toggleFavorite() {
    setState(() => _isFavorite = !_isFavorite);
    widget.onFavoriteChanged?.call(_isFavorite);
  }

  @override
  Widget build(BuildContext context) {
    final place = widget.destination;
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 420;
        final heroHeight = (constraints.maxHeight * 0.47).clamp(250.0, 470.0);
        return Scaffold(
          backgroundColor: Colors.white,
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: heroHeight,
                pinned: true,
                backgroundColor: const Color(0xff27aaa5),
                leading: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 18),
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: IconButton(
                        tooltip: _isFavorite
                            ? 'Remove from favorites'
                            : 'Add to favorites',
                        onPressed: _toggleFavorite,
                        icon: Icon(
                          _isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: const Color(0xffff6b61),
                        ),
                      ),
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Image.network(
                    place.image,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => const ColoredBox(
                      color: Color(0xffc5e6ef),
                      child: Icon(Icons.landscape, size: 60),
                    ),
                    webHtmlElementStrategy: WebHtmlElementStrategy.fallback,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 760),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        compact ? 18 : 28,
                        26,
                        compact ? 18 : 28,
                        40,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          compact
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _placeName(place.name),
                                    const SizedBox(height: 4),
                                    _price(),
                                  ],
                                )
                              : Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(child: _placeName(place.name)),
                                    const SizedBox(width: 20),
                                    _price(),
                                  ],
                                ),
                          const SizedBox(height: 8),
                          Wrap(
                            alignment: WrapAlignment.spaceBetween,
                            runSpacing: 6,
                            spacing: 16,
                            children: [
                              const Row(
                                children: [
                                  Icon(
                                    Icons.star,
                                    color: Color(0xffff9633),
                                    size: 30,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    '4.9 (2.7K)',
                                    style: TextStyle(
                                      color: Color(0xffaaa7b5),
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                '* Estimated Cost',
                                style: const TextStyle(
                                  color: Color(0xffaaa7b5),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 34),
                          Row(
                            children: [
                              _tabButton('Overview', 0, compact),
                              _tabButton('Details', 1, compact),
                              _tabButton('Reviews', 2, compact),
                            ],
                          ),
                          const SizedBox(height: 28),
                          Text(
                            place.description.isEmpty
                                ? 'Nusa Penida is one of the world’s new holiday destinations in Bali. Located on the southeast of the island of Bali.'
                                : place.description,
                            style: const TextStyle(
                              color: Color(0xffaaa7b5),
                              fontSize: 18,
                              height: 1.45,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 34),
                          const Row(
                            children: [
                              Expanded(
                                child: _InfoItem(
                                  icon: Icons.access_time_filled,
                                  color: Color(0xffff6b61),
                                  value: '6 Days',
                                  label: 'Duration',
                                ),
                              ),
                              Expanded(
                                child: _InfoItem(
                                  icon: Icons.location_on,
                                  color: Color(0xff27aaa5),
                                  value: '100 KM',
                                  label: 'Distance',
                                ),
                              ),
                              Expanded(
                                child: _InfoItem(
                                  icon: Icons.wb_sunny,
                                  color: Color(0xffff9633),
                                  value: '24°C',
                                  label: 'Sunny',
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 40),
                          SizedBox(
                            width: double.infinity,
                            child: FilledButton(
                              style: FilledButton.styleFrom(
                                backgroundColor: const Color(0xff27aaa5),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 19,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(28),
                                ),
                              ),
                              onPressed: widget.onBook,
                              child: const Text(
                                'Book Now   →',
                                style: TextStyle(
                                  fontSize: 21,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _placeName(String name) => Text(
    name.isEmpty ? 'Destination' : name,
    style: const TextStyle(
      color: Color(0xff171044),
      fontSize: 31,
      fontWeight: FontWeight.w800,
    ),
  );

  Widget _price() => const Text(
    '\$100',
    style: TextStyle(
      color: Color(0xff27aaa5),
      fontSize: 39,
      fontWeight: FontWeight.w800,
    ),
  );

  Widget _tabButton(String label, int index, bool compact) => Expanded(
    child: GestureDetector(
      onTap: () => setState(() => tab = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 17),
        decoration: BoxDecoration(
          color: tab == index ? const Color(0xff27aaa5) : Colors.transparent,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: tab == index ? Colors.white : const Color(0xffaaa7b5),
            fontSize: compact ? 15 : 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    ),
  );
}

class _InfoItem extends StatelessWidget {
  const _InfoItem({
    required this.icon,
    required this.color,
    required this.value,
    required this.label,
  });
  final IconData icon;
  final Color color;
  final String value;
  final String label;
  @override
  Widget build(BuildContext context) => Column(
    children: [
      Icon(icon, color: color, size: 28),
      const SizedBox(height: 6),
      Text(
        value,
        style: const TextStyle(
          color: Color(0xff171044),
          fontSize: 17,
          fontWeight: FontWeight.w800,
        ),
      ),
      const SizedBox(height: 3),
      Text(
        label,
        style: const TextStyle(color: Color(0xffaaa7b5), fontSize: 13),
      ),
    ],
  );
}
