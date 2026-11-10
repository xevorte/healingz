class Category {
  final String id;
  final String name;
  const Category({required this.id, required this.name});
}

class Destination {
  final String id;
  final String name;
  final String location;
  final String category;
  final String image;
  final String description;
  final double rating;

  const Destination({
    required this.id,
    required this.name,
    required this.location,
    required this.category,
    required this.image,
    this.description = '',
    this.rating = 0,
  });
}

class DashboardData {
  final List<Category> categories;
  final List<Destination> destinations;
  const DashboardData({required this.categories, required this.destinations});
  factory DashboardData.empty() => const DashboardData(
    categories: [
      Category(id: 'all', name: 'All'),
      Category(id: 'popular', name: 'Popular'),
      Category(id: 'recommended', name: 'Recommended'),
      Category(id: 'most', name: 'Most visited'),
    ],
    destinations: [],
  );
}
