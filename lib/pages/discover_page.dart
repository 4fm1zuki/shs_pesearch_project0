import 'package:flutter/material.dart';
import 'signup_page.dart';

// Content Category Categories
enum ContentCategory { explore, tips, eligibility, drives, stories }

// Content Item Data Model
class ContentItem {
  final String title;
  final String subtitle;
  final String imageUrl;
  final String tag;
  final ContentCategory category;
  final IconData? icon;

  ContentItem({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.tag,
    required this.category,
    this.icon,
  });
}

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key});

  @override
  State<DiscoverPage> createState() => _BloodDonationDiscoverPageState();
}

class _BloodDonationDiscoverPageState extends State<DiscoverPage> {
  // Active Selected Category
  ContentCategory _selectedCategory = ContentCategory.explore;

  // Search & Notification States
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Static Data List
  final List<ContentItem> _allContent = [
    // EXPLORE / HERO
    ContentItem(
      title: 'National Blood Shortage: How One Donation Saves Up to 3 Lives',
      subtitle:
          'Hospitals are facing critical shortages. Find a drive near you today.',
      imageUrl:
          'https://images.unsplash.com/photo-1615461066841-6116e61058f4?q=80&w=1000',
      tag: 'URGENT NEED',
      category: ContentCategory.explore,
    ),

    // TIPS
    ContentItem(
      title: 'Hydration First Before Donating',
      subtitle:
          'Drink at least 16 oz of water before your appointment for a smooth donation.',
      imageUrl:
          'https://images.unsplash.com/photo-1527613426441-4da17471b66d?q=80&w=400',
      tag: 'PRE-DONATION',
      category: ContentCategory.tips,
      icon: Icons.local_drink,
    ),
    ContentItem(
      title: 'Eat Iron-Rich Foods',
      subtitle:
          'Eat spinach, beans, or lean meat leading up to your appointment.',
      imageUrl:
          'https://images.unsplash.com/photo-1498837167922-ddd27525d352?q=80&w=400',
      tag: 'NUTRITION',
      category: ContentCategory.tips,
      icon: Icons.restaurant,
    ),
    ContentItem(
      title: 'Post-Donation Rest & Recovery',
      subtitle:
          'Avoid heavy lifting and rest for 24 hours to let your body rebuild.',
      imageUrl:
          'https://images.unsplash.com/photo-1541781774459-bb2af2f05b55?q=80&w=400',
      tag: 'RECOVERY',
      category: ContentCategory.tips,
      icon: Icons.bed,
    ),

    // ELIGIBILITY
    ContentItem(
      title: 'Basic Requirements: Age, Weight & Health',
      subtitle:
          'Must be at least 17 years old, weigh 110+ lbs, and be in general good health.',
      imageUrl:
          'https://images.unsplash.com/photo-1576091160399-112ba8d25d1d?q=80&w=400',
      tag: 'CHECKLIST',
      category: ContentCategory.eligibility,
    ),
    ContentItem(
      title: 'Can I Donate If I Got a Tattoo?',
      subtitle:
          'You can donate if the tattoo was applied by a state-regulated shop with sterile needles.',
      imageUrl:
          'https://images.unsplash.com/photo-1565258664614-38686e00b3f8?q=80&w=400',
      tag: 'FAQ',
      category: ContentCategory.eligibility,
    ),
    ContentItem(
      title: 'How Often Can You Donate?',
      subtitle:
          'Wait 56 days between Whole Blood donations and 7 days for Platelets.',
      imageUrl:
          'https://images.unsplash.com/photo-1506784983877-45594efa4cbe?q=80&w=400',
      tag: 'INTERVALS',
      category: ContentCategory.eligibility,
    ),

    // BLOOD DRIVES
    ContentItem(
      title: 'Downtown Community Center Drive',
      subtitle: 'Oct 12 • 9:00 AM - 3:00 PM • 123 Main St, Downtown',
      imageUrl:
          'https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d?q=80&w=400',
      tag: 'UPCOMING EVENT',
      category: ContentCategory.drives,
    ),
    ContentItem(
      title: 'City University Mobile Blood Bus',
      subtitle: 'Oct 15 • 10:00 AM - 4:00 PM • Campus Quad',
      imageUrl:
          'https://images.unsplash.com/photo-1584515979956-d9f6e5d09982?q=80&w=400',
      tag: 'MOBILE BUS',
      category: ContentCategory.drives,
    ),

    // STORIES
    ContentItem(
      title: '"A stranger’s donation saved my daughter’s life."',
      subtitle:
          'Read how emergency blood transfusions saved 6-year-old Lily after a critical recovery.',
      imageUrl:
          'https://images.unsplash.com/photo-1582213782179-e0d53f98f2ca?q=80&w=400',
      tag: 'RECIPIENT STORY',
      category: ContentCategory.stories,
    ),
    ContentItem(
      title: 'Meet Mark: 50th Blood Donation Milestone',
      subtitle:
          'Mark shares why he has consistently donated blood every 8 weeks for over 10 years.',
      imageUrl:
          'https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=400',
      tag: 'DONOR SPOTLIGHT',
      category: ContentCategory.stories,
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Filter items based on active category and live search query
    List<ContentItem> filteredItems =
        _selectedCategory == ContentCategory.explore
            ? _allContent
            : _allContent
                .where((item) => item.category == _selectedCategory)
                .toList();

    if (_searchQuery.trim().isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      filteredItems = _allContent.where((item) {
        return item.title.toLowerCase().contains(query) ||
            item.subtitle.toLowerCase().contains(query) ||
            item.tag.toLowerCase().contains(query);
      }).toList();
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.sizeOf(context).width < 600 ? 16 : 32,
            vertical: 24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(theme),
              if (MediaQuery.sizeOf(context).width < 1300 && !_isSearching) ...[
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _navButton('EXPLORE', ContentCategory.explore, theme),
                      _navButton('TIPS', ContentCategory.tips, theme),
                      _navButton(
                          'ELIGIBILITY', ContentCategory.eligibility, theme),
                      _navButton('BLOOD DRIVES', ContentCategory.drives, theme),
                      _navButton('STORIES', ContentCategory.stories, theme),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 28),
              if (_searchQuery.trim().isNotEmpty) ...[
                _buildSectionTitle('Search Results for "$_searchQuery"', theme),
                const SizedBox(height: 16),
                filteredItems.isEmpty
                    ? Text('No results found.',
                        style: TextStyle(
                            color:
                                theme.colorScheme.onSurface.withOpacity(0.6)))
                    : _buildCardsGrid(filteredItems, theme),
              ] else if (_selectedCategory == ContentCategory.explore) ...[
                _buildHeroCard(_allContent.first, theme),
                const SizedBox(height: 36),
                _buildSectionTitle('Featured Updates', theme),
                const SizedBox(height: 16),
                _buildCardsGrid(
                  _allContent
                      .where((i) => i.category != ContentCategory.explore)
                      .toList(),
                  theme,
                ),
              ] else ...[
                _buildSectionTitle(_getCategoryTitle(_selectedCategory), theme),
                const SizedBox(height: 16),
                _buildCardsGrid(filteredItems, theme),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // Header Navigation Bar adapting to context Theme
  Widget _buildHeader(ThemeData theme) {
    final primaryColor = theme.colorScheme.primary;
    final isCompact = MediaQuery.sizeOf(context).width < 1300;

    return Row(
      children: [
        const SizedBox.shrink(),
        const Spacer(),

        // Category Navigation Tabs (Hidden if user is actively searching to keep header clean)
        if (!_isSearching && !isCompact) ...[
          Row(
            children: [
              _navButton('EXPLORE', ContentCategory.explore, theme),
              _navButton('DONATION TIPS', ContentCategory.tips, theme),
              _navButton('ELIGIBILITY', ContentCategory.eligibility, theme),
              _navButton('BLOOD DRIVES', ContentCategory.drives, theme),
              _navButton('STORIES', ContentCategory.stories, theme),
            ],
          ),
          const Spacer(),
        ],

        // Expandable Search Bar Widget
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: _isSearching ? 300 : 48,
          height: 48,
          decoration: BoxDecoration(
            color: _isSearching ? theme.cardColor : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: _isSearching
                ? Border.all(color: theme.dividerColor.withOpacity(0.2))
                : null,
          ),
          child: Row(
            children: [
              IconButton(
                icon: Icon(
                  _isSearching ? Icons.close : Icons.search,
                  size: 20,
                  color: theme.colorScheme.onSurface,
                ),
                onPressed: () {
                  setState(() {
                    _isSearching = !_isSearching;
                    if (!_isSearching) {
                      _searchQuery = '';
                      _searchController.clear();
                    }
                  });
                },
              ),
              if (_isSearching)
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    autofocus: true,
                    style: TextStyle(
                        fontSize: 13, color: theme.colorScheme.onSurface),
                    decoration: InputDecoration(
                      hintText: 'Search updates, tips, drives...',
                      hintStyle: TextStyle(
                          fontSize: 12,
                          color: theme.colorScheme.onSurface.withOpacity(0.5)),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(width: 8),

        // Notification Button with a Badge Counter
        Stack(
          children: [
            IconButton(
              icon: Icon(Icons.notifications_outlined,
                  size: 20, color: theme.colorScheme.onSurface),
              onPressed: () {
                showDialog<void>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Notifications'),
                    content: const Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(Icons.bloodtype_outlined),
                          title: Text('O- blood needed nearby'),
                          subtitle: Text('Digos Medical Center · 12 min ago'),
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(Icons.event_outlined),
                          title: Text('Community blood drive'),
                          subtitle: Text('Digos City Hall · Tomorrow'),
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Close'),
                      ),
                    ],
                  ),
                );
              },
            ),
            Positioned(
              right: 8,
              top: 8,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: primaryColor,
                  shape: BoxShape.circle,
                ),
                child: const Text(
                  '2',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 12),

        FilledButton.icon(
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute<void>(builder: (_) => const SignUpPage()),
          ),
          icon: const Icon(Icons.person_add_alt_1),
          label: Text(isCompact ? 'Register' : 'Register as donor'),
        ),
      ],
    );
  }

  Widget _navButton(String label, ContentCategory category, ThemeData theme) {
    final isSelected = _selectedCategory == category;
    final primaryColor = theme.colorScheme.primary;
    final unselectedColor = theme.colorScheme.onSurface.withOpacity(0.6);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: TextButton(
        onPressed: () {
          setState(() {
            _selectedCategory = category;
            _searchQuery = '';
            _searchController.clear();
            _isSearching = false;
          });
        },
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? primaryColor : unselectedColor,
          ),
        ),
      ),
    );
  }

  Widget _buildHeroCard(ContentItem item, ThemeData theme) {
    final primaryColor = theme.colorScheme.primary;

    return Container(
      height: 300,
      width: double.infinity,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              item.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => ColoredBox(
                color: theme.colorScheme.primaryContainer,
                child: Icon(
                  Icons.volunteer_activism_outlined,
                  size: 72,
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
            ),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black87, Colors.transparent],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      item.tag,
                      style: TextStyle(
                        color: theme.colorScheme.onPrimary,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    item.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardsGrid(List<ContentItem> items, ThemeData theme) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 1000
            ? 3
            : constraints.maxWidth >= 620
                ? 2
                : 1;
        final itemWidth =
            (constraints.maxWidth - (16 * (columns - 1))) / columns;
        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: items.map((item) {
            return SizedBox(
              width: itemWidth,
              child: _buildItemCard(item, theme),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildItemCard(ContentItem item, ThemeData theme) {
    final cardBgColor = theme.cardColor;
    final primaryColor = theme.colorScheme.primary;
    final textColor = theme.colorScheme.onSurface;
    final subtextColor = theme.colorScheme.onSurface.withOpacity(0.6);
    final borderColor = theme.dividerColor.withOpacity(0.15);

    return Container(
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: SystemMouseCursors.text == SystemMouseCursors.text
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.network(
              item.imageUrl,
              height: 130,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => ColoredBox(
                color: theme.colorScheme.secondaryContainer,
                child: SizedBox(
                  height: 130,
                  child: Center(
                    child: Icon(
                      item.icon ?? Icons.article_outlined,
                      size: 32,
                      color: theme.colorScheme.onSecondaryContainer,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (item.icon != null) ...[
                      Icon(item.icon, size: 14, color: primaryColor),
                      const SizedBox(width: 4),
                    ],
                    Text(
                      item.tag,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  item.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    color: subtextColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, ThemeData theme) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: theme.colorScheme.onSurface,
      ),
    );
  }

  String _getCategoryTitle(ContentCategory cat) {
    switch (cat) {
      case ContentCategory.tips:
        return 'Donation Tips & Guides';
      case ContentCategory.eligibility:
        return 'Eligibility Requirements & FAQs';
      case ContentCategory.drives:
        return 'Upcoming Local Blood Drives';
      case ContentCategory.stories:
        return 'Community & Recipient Stories';
      default:
        return 'Explore Updates';
    }
  }
}
