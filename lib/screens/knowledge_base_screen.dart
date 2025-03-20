import 'package:flutter/material.dart';
import 'package:sigma_path/api/mock_api.dart';
import 'package:sigma_path/theme/app_theme.dart';
import 'package:sigma_path/utils/constants.dart';

class KnowledgeBaseScreen extends StatefulWidget {
  const KnowledgeBaseScreen({super.key});

  @override
  State<KnowledgeBaseScreen> createState() => _KnowledgeBaseScreenState();
}

class _KnowledgeBaseScreenState extends State<KnowledgeBaseScreen> {
  List<Map<String, dynamic>> _categories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      final categories = await MockApi().getKnowledgeCategories();
      setState(() {
        _categories = categories;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sigma Knowledge'),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Featured article card
                  _buildFeaturedCard(context),
                  const SizedBox(height: 24),

                  // Categories
                  const Text(
                    'KNOWLEDGE CATEGORIES',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Category grid
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.2,
                    ),
                    itemCount: _categories.length,
                    itemBuilder: (context, index) {
                      final category = _categories[index];
                      return _buildCategoryCard(context, category);
                    },
                  ),
                  const SizedBox(height: 24),

                  // Latest articles
                  const Text(
                    'LATEST ARTICLES',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Latest articles list
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 5, // Show 5 latest articles
                    itemBuilder: (context, index) {
                      return _buildArticleListItem(
                        context,
                        title:
                            'The Power of Strategic Solitude in a Hyperconnected World',
                        readTime: index * 3 + 5,
                        date: DateTime.now().subtract(Duration(days: index)),
                        category: 'Mindset',
                      );
                    },
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildFeaturedCard(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ArticleScreen(
                title: 'The Silent Path to Exceptional Success',
                category: 'Mindset',
                readTime: 8,
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppTheme.primaryColor,
                AppTheme.primaryColor.withOpacity(0.8),
                AppTheme.secondaryColor,
              ],
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.star,
                      color: Colors.white,
                      size: 16,
                    ),
                    SizedBox(width: 4),
                    Text(
                      'FEATURED',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              const Text(
                'The Silent Path to Exceptional Success',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'MINDSET',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    '8 min read',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCard(
      BuildContext context, Map<String, dynamic> category) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CategoryArticlesScreen(
                category: category['title'],
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _getCategoryIcon(category['title']),
                size: 40,
                color: _getCategoryColor(category['title']),
              ),
              const SizedBox(height: 12),
              Text(
                category['title'],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                '${category['articles']} articles',
                style: TextStyle(
                  color: AppTheme.textSecondaryColor,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildArticleListItem(
    BuildContext context, {
    required String title,
    required int readTime,
    required DateTime date,
    required String category,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ArticleScreen(
                title: title,
                category: category,
                readTime: readTime,
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: _getCategoryColor(category).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getCategoryIcon(category),
                  color: _getCategoryColor(category),
                  size: 30,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _getCategoryColor(category).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            category.toUpperCase(),
                            style: TextStyle(
                              color: _getCategoryColor(category),
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '$readTime min read',
                          style: TextStyle(
                            color: AppTheme.textSecondaryColor,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _formatDate(date),
                          style: TextStyle(
                            color: AppTheme.textSecondaryColor,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Financial Independence':
        return Colors.green;
      case 'Mental Toughness':
        return Colors.purple;
      case 'Minimalism':
        return Colors.blue;
      case 'High Performance':
        return Colors.orange;
      case 'Strategic Solitude':
        return AppTheme.primaryColor;
      case 'Mindset':
        return AppTheme.secondaryColor;
      default:
        return AppTheme.primaryColor;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Financial Independence':
        return Icons.attach_money;
      case 'Mental Toughness':
        return Icons.psychology;
      case 'Minimalism':
        return Icons.minimize;
      case 'High Performance':
        return Icons.speed;
      case 'Strategic Solitude':
        return Icons.self_improvement;
      case 'Mindset':
        return Icons.lightbulb;
      default:
        return Icons.article;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

class CategoryArticlesScreen extends StatelessWidget {
  final String category;

  const CategoryArticlesScreen({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 10, // Mock 10 articles per category
        itemBuilder: (context, index) {
          return _buildArticleListItem(
            context,
            title: _generateArticleTitle(category, index),
            readTime: (index % 5) + 5,
            date: DateTime.now().subtract(Duration(days: index * 3)),
            category: category,
          );
        },
      ),
    );
  }

  Widget _buildArticleListItem(
    BuildContext context, {
    required String title,
    required int readTime,
    required DateTime date,
    required String category,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ArticleScreen(
                title: title,
                category: category,
                readTime: readTime,
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: _getCategoryColor(category).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getCategoryIcon(category),
                  color: _getCategoryColor(category),
                  size: 30,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          '$readTime min read',
                          style: TextStyle(
                            color: AppTheme.textSecondaryColor,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _formatDate(date),
                          style: TextStyle(
                            color: AppTheme.textSecondaryColor,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Financial Independence':
        return Colors.green;
      case 'Mental Toughness':
        return Colors.purple;
      case 'Minimalism':
        return Colors.blue;
      case 'High Performance':
        return Colors.orange;
      case 'Strategic Solitude':
        return AppTheme.primaryColor;
      case 'Mindset':
        return AppTheme.secondaryColor;
      default:
        return AppTheme.primaryColor;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Financial Independence':
        return Icons.attach_money;
      case 'Mental Toughness':
        return Icons.psychology;
      case 'Minimalism':
        return Icons.minimize;
      case 'High Performance':
        return Icons.speed;
      case 'Strategic Solitude':
        return Icons.self_improvement;
      case 'Mindset':
        return Icons.lightbulb;
      default:
        return Icons.article;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _generateArticleTitle(String category, int index) {
    final List<String> titles = [];

    switch (category) {
      case 'Financial Independence':
        titles.addAll([
          'Building Wealth Through Strategic Minimalism',
          'Investing Like a Sigma: The Lone Wolf\'s Guide to Financial Freedom',
          'Passive Income Streams for the Independent Man',
          'Escaping the 9-5: How to Break Free from Financial Dependency',
          'Sigma Finance: Building Wealth Outside the System',
          'The Minimalist Investment Strategy for Maximum Returns',
          'Financial Independence Without Sacrificing Quality of Life',
          'Crypto and Alternative Investments for the Independent Thinker',
          'Building a Business Empire as a Solo Entrepreneur',
          'Retirement Planning for the Man Who Answers to No One',
        ]);
        break;
      case 'Mental Toughness':
        titles.addAll([
          'Forging an Unbreakable Mind: Mental Resilience Training',
          'Stoicism for the Modern Sigma Male',
          'The Art of Remaining Unmoved in Chaos',
          'Building Mental Fortitude Through Intentional Discomfort',
          'Psychological Strength Training for Men Who Stand Alone',
          'Overcoming Adversity: Lessons from History\'s Greatest Lone Wolves',
          'The Silent Power of Emotional Control',
          'Mental Clarity Through Disciplined Thinking',
          'Developing Unwavering Focus in a Distracted World',
          'The Sigma\'s Guide to Psychological Self-Mastery',
        ]);
        break;
      case 'Minimalism':
        titles.addAll([
          'The Sigma Approach to Minimalist Living',
          'Owning Less, Achieving More: The Power of Essential Living',
          'Digital Minimalism for Enhanced Focus and Productivity',
          'Streamlining Your Life for Maximum Impact',
          'The Minimalist Wardrobe: Quality Over Quantity',
          'Sigma Spaces: Designing a Minimalist Environment for Peak Performance',
          'Eliminating Distractions: The Minimalist Approach to Technology',
          'Intentional Consumption: The Art of Buying Only What Matters',
          'Time Minimalism: Protecting Your Most Valuable Resource',
          'The Freedom of Less: How Reduction Leads to Greater Control',
        ]);
        break;
      case 'High Performance':
        titles.addAll([
          'Peak Performance Habits of Elite Sigma Males',
          'The Science of Mastery: How to Excel in Any Field',
          'Optimizing Your Body and Mind for Maximum Output',
          'Sleep Optimization for High Performers',
          'Nutritional Strategies for Enhanced Mental and Physical Performance',
          'Time Management Systems for Exceptional Productivity',
          'The Flow State: Accessing Your Highest Level of Performance',
          'Deliberate Practice: The Path to Excellence',
          'Recovery Techniques for Sustained High Performance',
          'Cognitive Enhancement: Natural Methods to Upgrade Your Mind',
        ]);
        break;
      case 'Strategic Solitude':
        titles.addAll([
          'The Power of Strategic Isolation in a Connected World',
          'Solitude as a Competitive Advantage',
          'Building Deep Work Habits Through Intentional Isolation',
          'The Creative Power of Being Alone',
          'Sigma Networking: Connecting Strategically While Maintaining Independence',
          'Cultivating Quality Relationships as a Natural Loner',
          'Setting Boundaries in an Invasive World',
          'Digital Detox: Reclaiming Your Mental Space',
          'The Art of Saying No Without Explanation',
          'Protecting Your Energy: Social Strategies for the Sigma Male',
        ]);
        break;
      default:
        titles.addAll([
          'The Sigma Male Mindset: A Complete Guide',
          'Developing Unshakeable Self-Confidence',
          'The Art of Strategic Thinking',
          'Cultivating Mental Clarity Through Discipline',
          'Building a Life on Your Own Terms',
          'The Power of Delayed Gratification',
          'Becoming Immune to Social Pressure',
          'Developing an Elite Mindset',
          'The Philosophy of Self-Reliance',
          'Mastering Emotional Control',
        ]);
    }

    return titles[index % titles.length];
  }
}

class ArticleScreen extends StatelessWidget {
  final String title;
  final String category;
  final int readTime;

  const ArticleScreen({
    super.key,
    required this.title,
    required this.category,
    required this.readTime,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getCategoryColor(category).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    category.toUpperCase(),
                    style: TextStyle(
                      color: _getCategoryColor(category),
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '$readTime min read',
                  style: TextStyle(
                    color: AppTheme.textSecondaryColor,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              _generateArticleContent(title, category),
              style: const TextStyle(
                fontSize: 16,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'KEY TAKEAWAYS',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 16),
            ...List.generate(
              3,
              (index) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text(
                          '•',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _generateTakeaway(title, index),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Financial Independence':
        return Colors.green;
      case 'Mental Toughness':
        return Colors.purple;
      case 'Minimalism':
        return Colors.blue;
      case 'High Performance':
        return Colors.orange;
      case 'Strategic Solitude':
        return AppTheme.primaryColor;
      case 'Mindset':
        return AppTheme.secondaryColor;
      default:
        return AppTheme.primaryColor;
    }
  }

  String _generateArticleContent(String title, String category) {
    // This would normally fetch content from an API
    // For now, generate some placeholder content
    return '''
In the realm of personal development and self-mastery, the concept of the Sigma Male has emerged as a powerful archetype for those who seek independence, excellence, and self-determination in a world that often rewards conformity.

${title.split(":").first} represents a cornerstone principle for those walking the Sigma path. Unlike conventional wisdom that emphasizes constant social validation and external metrics of success, the true Sigma understands that exceptional achievement often happens in the shadows, away from the spotlight.

## The Foundation of ${category} Mastery

The journey toward mastery in this domain begins with self-awareness and deliberate choice. Most people drift through life responding to external stimuli and social pressure, never fully taking control of their destiny. The Sigma Male, however, operates differently.

By cultivating a deep understanding of your own values, strengths, and purpose, you create a solid foundation upon which all other success is built. This internal clarity becomes a compass that guides decision-making, regardless of external opinions or temporary trends.

## Practical Implementation Strategies

1. **Deliberate Isolation**: Schedule regular periods of complete solitude for deep work and reflection. This is not about being antisocial, but rather about strategically protecting your mental space to foster clarity and creativity.

2. **Outcome Independence**: Develop the ability to pursue excellence for its own sake, rather than for validation or recognition. True Sigmas find satisfaction in the quality of their work and personal growth, not in applause.

3. **Strategic Minimalism**: Eliminate unnecessary distractions, possessions, and commitments that don't align with your core values and goals. This creates space for what truly matters.

The most successful practitioners of this approach understand that ${category} is not about ego or superiority, but rather about freedom and self-actualization. By mastering these principles, you develop the capacity to navigate life on your own terms, unburdened by needless social constraints or expectations.

## Advanced Concepts

As you progress in your journey, you'll discover that true power comes not from dominance over others, but from mastery over yourself. This inner sovereignty becomes a magnetic force that naturally commands respect without demanding it.

Remember that the path of the Sigma is not about isolation for its own sake, but rather strategic independence that allows for deeper connection on your own terms. By developing this capacity, you create the foundation for exceptional achievement and personal fulfillment that remains elusive to those who live at the mercy of external validation.

The ultimate goal is not to separate yourself from society entirely, but to engage with it intentionally, from a position of self-determined strength rather than neediness or dependency.
''';
  }

  String _generateTakeaway(String title, int index) {
    final List<String> takeaways = [
      'True Sigma achievement requires strategic periods of isolation and deep focus away from social distractions.',
      'Develop outcome independence by finding satisfaction in the quality of your work rather than external validation.',
      'Eliminate unnecessary possessions, commitments and distractions that don\'t align with your core values and goals.',
    ];

    return takeaways[index % takeaways.length];
  }
}
