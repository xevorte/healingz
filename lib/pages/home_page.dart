import 'package:flutter/material.dart';

import '../models/destination.dart';
import '../services/api_service.dart';
import 'booking_page.dart';
import 'destination_detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, this.initialData});

  final Future<DashboardData>? initialData;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<DashboardData> _data;
  final Set<String> _saved = {};
  String _search = '';
  String _category = 'Popular';
  int _tab = 0;

  @override
  void initState() {
    super.initState();
    _data = widget.initialData ?? ApiService.loadDashboard();
  }

  void _retry() {
    setState(() => _data = ApiService.loadDashboard());
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.white,
    body: SafeArea(
      child: FutureBuilder<DashboardData>(
        future: _data,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xff27aaa5)),
            );
          }
          if (snapshot.hasError) return _ErrorView(onRetry: _retry);
          return _content(snapshot.data ?? DashboardData.empty());
        },
      ),
    ),
    bottomNavigationBar: _bottomNavigation(),
  );

  Widget _content(DashboardData data) {
    final destinations = data.destinations.where((item) {
      final query = _search.toLowerCase();
      final searchMatch =
          query.isEmpty ||
          item.name.toLowerCase().contains(query) ||
          item.location.toLowerCase().contains(query);
      final categoryMatch =
          _category == 'All' ||
          _category == 'Popular' ||
          _category == 'Recommended' ||
          item.category.toLowerCase() == _category.toLowerCase();
      return searchMatch && categoryMatch;
    }).toList();
    if (_category == 'Popular') {
      destinations.sort((a, b) => b.rating.compareTo(a.rating));
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth > 700;
        final contentWidth = constraints.maxWidth.clamp(0.0, 760.0);
        final sideMargin = (constraints.maxWidth - contentWidth) / 2;
        final edge =
            sideMargin +
            (contentWidth < 360
                ? 16.0
                : wide
                ? 28.0
                : 22.0);
        final cardWidth = (contentWidth * 0.55).clamp(180.0, 240.0);
        final specialWidth = (contentWidth * 0.75).clamp(250.0, 350.0);
        final cardHeight = (constraints.maxHeight * 0.31).clamp(235.0, 290.0);
        return CustomScrollView(
          slivers: [
            SliverPadding(
              padding: EdgeInsets.fromLTRB(edge, 16, edge, 12),
              sliver: SliverToBoxAdapter(child: _header(contentWidth < 360)),
            ),
            if (_tab == 0)
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: edge),
                sliver: SliverToBoxAdapter(child: _searchBox()),
              ),
            SliverPadding(
              padding: EdgeInsets.fromLTRB(edge, 30, edge, 14),
              sliver: SliverToBoxAdapter(child: _categoryTabs(data.categories)),
            ),
            SliverPadding(
              padding: const EdgeInsets.only(top: 18),
              sliver: SliverToBoxAdapter(
                child: _popularList(destinations, edge, cardWidth, cardHeight),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.fromLTRB(edge, 28, edge, 12),
              sliver: SliverToBoxAdapter(
                child: _sectionTitle('Special For you', 'Explore'),
              ),
            ),
            SliverToBoxAdapter(
              child: _specialList(destinations, edge, specialWidth),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 40)),
          ],
        );
      },
    );
  }

  Widget _header(bool compact) => Row(
    children: [
      ClipOval(
        child: Image.network(
          'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=200',
          width: compact ? 46 : 54,
          height: compact ? 46 : 54,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => SizedBox(
            width: compact ? 46 : 54,
            height: compact ? 46 : 54,
            child: const ColoredBox(
              color: Color(0xffe8f1ed),
              child: Icon(Icons.person),
            ),
          ),
        ),
      ),
      SizedBox(width: compact ? 10 : 14),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Jihan Audy,',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Color(0xff171044),
                fontSize: compact ? 19 : 23,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 3),
            Text(
              'Where do you want to go?',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Color(0xffaaa7c0),
                fontSize: compact ? 13 : 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      Container(
        width: compact ? 46 : 56,
        height: compact ? 46 : 56,
        decoration: const BoxDecoration(
          color: Color(0xfffafafd),
          shape: BoxShape.circle,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            const Icon(
              Icons.notifications_none_rounded,
              color: Color(0xff171044),
              size: 28,
            ),
            Positioned(
              top: compact ? 10 : 13,
              right: compact ? 10 : 13,
              child: const CircleAvatar(
                radius: 4,
                backgroundColor: Color(0xffff6b61),
              ),
            ),
          ],
        ),
      ),
    ],
  );

  Widget _searchBox() => TextField(
    onChanged: (value) => setState(() => _search = value),
    style: const TextStyle(color: Color(0xff171044)),
    decoration: const InputDecoration(
      hintText: 'Search',
      hintStyle: TextStyle(
        color: Color(0xffaaa7c0),
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      prefixIcon: Icon(
        Icons.search_rounded,
        size: 32,
        color: Color(0xff171044),
      ),
      suffixIcon: Icon(Icons.tune_rounded, size: 30, color: Color(0xff171044)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(28)),
        borderSide: BorderSide(color: Color(0xff27aaa5), width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(28)),
        borderSide: BorderSide(color: Color(0xff27aaa5), width: 2),
      ),
      contentPadding: EdgeInsets.symmetric(vertical: 18),
    ),
  );

  Widget _categoryTabs(List<Category> categories) {
    final items = [
      const Category(id: 'all', name: 'All'),
      const Category(id: 'popular', name: 'Popular'),
      const Category(id: 'recommended', name: 'Recommended'),
      ...categories.where(
        (category) => ![
          'all',
          'popular',
          'recommended',
        ].contains(category.name.toLowerCase()),
      ),
    ];
    return SizedBox(
      height: 54,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, _) => const SizedBox(width: 14),
        itemBuilder: (context, index) {
          final item = items[index];
          final selected = item.name == _category;
          return GestureDetector(
            onTap: () => setState(() => _category = item.name),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 13),
              decoration: BoxDecoration(
                color: selected ? const Color(0xff27aaa5) : Colors.transparent,
                borderRadius: BorderRadius.circular(22),
              ),
              child: Text(
                item.name,
                style: TextStyle(
                  color: selected ? Colors.white : const Color(0xffaaa7c0),
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _sectionTitle(String title, String action) => Row(
    children: [
      Expanded(
        child: Text(
          title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Color(0xff171044),
            fontSize: 23,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      TextButton(
        onPressed: () {},
        child: Row(
          children: [
            Text(
              action,
              style: const TextStyle(
                color: Color(0xff27aaa5),
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: 6),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: Color(0xff171044),
            ),
          ],
        ),
      ),
    ],
  );

  Widget _popularList(
    List<Destination> items,
    double edge,
    double cardWidth,
    double cardHeight,
  ) {
    if (items.isEmpty) {
      return const SizedBox(
        height: 260,
        child: Center(
          child: Text(
            'No destinations found',
            style: TextStyle(color: Color(0xffaaa7c0)),
          ),
        ),
      );
    }
    return SizedBox(
      height: cardHeight,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: edge),
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, _) => const SizedBox(width: 18),
        itemBuilder: (context, index) => _popularCard(items[index], cardWidth),
      ),
    );
  }

  Widget _popularCard(Destination place, double cardWidth) {
    return SizedBox(
      width: cardWidth,
      child: Card(
        color: Colors.white,
        margin: EdgeInsets.zero,
        elevation: 5,
        shadowColor: const Color(0x15000000),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => _openDetails(place),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          place.image,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => const ColoredBox(
                            color: Color(0xffdcece5),
                            child: Icon(Icons.landscape),
                          ),
                          webHtmlElementStrategy:
                              WebHtmlElementStrategy.fallback,
                        ),
                      ),
                      Positioned(
                        top: 12,
                        right: 12,
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: IconButton(
                            tooltip: _saved.contains(place.id)
                                ? 'Remove from favorites'
                                : 'Add to favorites',
                            onPressed: () => _toggleSaved(place.id),
                            icon: Icon(
                              _saved.contains(place.id)
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: const Color(0xffff6b61),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  place.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xff171044),
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      size: 19,
                      color: Color(0xff27aaa5),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        place.location,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xffaaa7c0),
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _specialList(List<Destination> items, double edge, double cardWidth) {
    return SizedBox(
      height: 92,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: edge),
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, _) => const SizedBox(width: 14),
        itemBuilder: (context, index) {
          final place = items[index];
          return SizedBox(
            width: cardWidth,
            child: Card(
              margin: EdgeInsets.zero,
              color: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22),
                side: const BorderSide(color: Color(0xffaaa7c0), width: 1.5),
              ),
              child: InkWell(
                onTap: () => _openDetails(place),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          place.image,
                          width: 74,
                          height: 74,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => const SizedBox(
                            width: 74,
                            height: 74,
                            child: ColoredBox(
                              color: Color(0xffdcece5),
                              child: Icon(Icons.landscape),
                            ),
                          ),
                          webHtmlElementStrategy:
                              WebHtmlElementStrategy.fallback,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              place.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Color(0xff171044),
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              place.location,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Color(0xffaaa7c0),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _bottomNavigation() => SafeArea(
    child: Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
      child: Center(
        heightFactor: 1,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Container(
            height: 68,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x18000000),
                  blurRadius: 20,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _navIcon(Icons.home_rounded, 0),
                _navIcon(Icons.show_chart_rounded, 1),
                _navIcon(Icons.settings_outlined, 2),
              ],
            ),
          ),
        ),
      ),
    ),
  );
  Widget _navIcon(IconData icon, int index) => IconButton(
    onPressed: () => setState(() => _tab = index),
    icon: Icon(
      icon,
      color: _tab == index ? const Color(0xff27aaa5) : const Color(0xffaaa7c0),
      size: 30,
    ),
  );
  void _toggleSaved(String id) =>
      setState(() => _saved.contains(id) ? _saved.remove(id) : _saved.add(id));
  void _openDetails(Destination place) => Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => DestinationDetailPage(
        destination: place,
        isFavorite: _saved.contains(place.id),
        onFavoriteChanged: (isFavorite) => setState(() {
          if (isFavorite) {
            _saved.add(place.id);
          } else {
            _saved.remove(place.id);
          }
        }),
        onBook: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => BookingPage(destination: place)),
        ),
      ),
    ),
  );
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.onRetry});
  final VoidCallback onRetry;
  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.cloud_off_rounded, size: 48, color: Color(0xffaaa7c0)),
        const SizedBox(height: 12),
        const Text('Could not load destinations'),
        const SizedBox(height: 14),
        FilledButton(onPressed: onRetry, child: const Text('Try again')),
      ],
    ),
  );
}
