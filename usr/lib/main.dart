import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() {
  runApp(const CosmicDestinyApp());
}

class CosmicDestinyApp extends StatelessWidget {
  const CosmicDestinyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cosmic Destiny Sanctuary',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const CosmicDashboard(),
      },
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF09041A),
        primaryColor: const Color(0xFFD4AF37),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFD4AF37),
          secondary: Color(0xFF6B4CA4),
          surface: Color(0xFF140A2E),
          background: Color(0xFF09041A),
        ),
        fontFamily: 'Georgia', // A serif font for an esoteric feel
        textTheme: const TextTheme(
          displayLarge: TextStyle(color: Color(0xFFD4AF37), fontWeight: FontWeight.bold),
          titleLarge: TextStyle(color: Color(0xFFD4AF37)),
          bodyLarge: TextStyle(color: Colors.white70),
          bodyMedium: TextStyle(color: Colors.white60),
        ),
      ),
    );
  }
}

class CosmicDashboard extends StatefulWidget {
  const CosmicDashboard({Key? key}) : super(key: key);

  @override
  State<CosmicDashboard> createState() => _CosmicDashboardState();
}

class _CosmicDashboardState extends State<CosmicDashboard> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _starController;

  final List<String> _tabs = [
    'Overview',
    'Career & Karma',
    'Love & Union',
    'Health',
    'Wealth',
    'Remedies',
  ];

  @override
  void initState() {
    super.initState();
    _starController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 40),
    )..repeat();
  }

  @override
  void dispose() {
    _starController.dispose();
    super.dispose();
  }

  Widget _buildContent() {
    switch (_selectedIndex) {
      case 0:
        return const OverviewTab();
      case 1:
        return const CareerTab();
      case 2:
        return const LoveTab();
      case 3:
        return const HealthTab();
      case 4:
        return const WealthTab();
      case 5:
        return const RemediesTab();
      default:
        return const OverviewTab();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 800;

    Widget contentArea = Stack(
      children: [
        // Starry Background
        Positioned.fill(
          child: AnimatedBuilder(
            animation: _starController,
            builder: (context, child) {
              return Transform.rotate(
                angle: _starController.value * 2 * math.pi,
                child: CustomPaint(
                  painter: StarryBackgroundPainter(),
                ),
              );
            },
          ),
        ),
        // Main Content
        Positioned.fill(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface.withOpacity(0.85),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32),
                    ),
                    border: Border.all(
                      color: Theme.of(context).primaryColor.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32),
                    ),
                    child: _buildContent(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );

    return Scaffold(
      body: SafeArea(
        child: isDesktop
            ? Row(
                children: [
                  _buildNavRail(),
                  Expanded(child: contentArea),
                ],
              )
            : Column(
                children: [
                  _buildMobileNav(),
                  Expanded(child: contentArea),
                ],
              ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          Text(
            'K U N D A L I   S A N C T U A R Y',
            style: TextStyle(
              fontSize: 14,
              letterSpacing: 8,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'The Destiny of Oct 2, 1993',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w300,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Nellore, Andhra Pradesh • 2:21 PM',
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavRail() {
    return NavigationRail(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      selectedIndex: _selectedIndex,
      onDestinationSelected: (int index) {
        setState(() {
          _selectedIndex = index;
        });
      },
      selectedLabelTextStyle: TextStyle(color: Theme.of(context).primaryColor),
      unselectedLabelTextStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
      labelType: NavigationRailLabelType.all,
      destinations: _tabs.map((String tab) {
        return NavigationRailDestination(
          icon: Icon(Icons.circle_outlined, color: Colors.white.withOpacity(0.5)),
          selectedIcon: Icon(Icons.adjust, color: Theme.of(context).primaryColor),
          label: Text(tab),
        );
      }).toList(),
    );
  }

  Widget _buildMobileNav() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: List.generate(_tabs.length, (index) {
          final isSelected = _selectedIndex == index;
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ChoiceChip(
              label: Text(_tabs[index]),
              selected: isSelected,
              onSelected: (bool selected) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
              labelStyle: TextStyle(
                color: isSelected ? Theme.of(context).primaryColor : Colors.white60,
              ),
              side: BorderSide(
                color: isSelected ? Theme.of(context).primaryColor : Colors.transparent,
              ),
            ),
          );
        }),
      ),
    );
  }
}

// --- TABS ---

class OverviewTab extends StatelessWidget {
  const OverviewTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24.0),
      children: [
        Center(
          child: Container(
            width: 300,
            height: 300,
            margin: const EdgeInsets.only(bottom: 32),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  blurRadius: 50,
                  spreadRadius: 10,
                ),
              ],
            ),
            child: CustomPaint(
              painter: LagnaChartPainter(
                primaryColor: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ),
        _buildSectionTitle(context, 'The Foundation (Lagna & Nakshatra)'),
        _buildParagraph(
            'Ascendant (Lagna): Capricorn (Makara)\n'
            'Your soul chose a crucible of discipline, structure, and ambition. '
            'Ruled by Saturn, your path is not one of overnight success, but of enduring '
            'legacy. You build empires brick by brick.'),
        _buildParagraph(
            'Moon Sign (Rashi): Aries (Mesha) - Ashwini Nakshatra\n'
            'The Esoteric Soul Purpose: Ashwini is symbolized by the horse\'s head, indicating '
            'swiftness, healing, and pioneering energy. Your inner mind operates at light-speed. '
            'Your soul\'s purpose is to initiate, to heal the collective through innovative actions, '
            'and to fearlessly charge into the unknown.'),
      ],
    );
  }
}

class CareerTab extends StatelessWidget {
  const CareerTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24.0),
      children: [
        _buildSectionTitle(context, 'Career & Ambitious Growth'),
        _buildParagraph(
            '10th House Analysis (Libra):\n'
            'Venus ruling your 10th house points toward careers involving design, diplomacy, '
            'or balancing complex systems. However, Saturn\'s dominant placement in its own '
            'sign of Aquarius (2nd House) heavily aspects your work sector.'),
        _buildParagraph(
            'The Tech & Leadership Influence:\n'
            'Aquarius governs advanced technology, networks, and large organizations. '
            'You possess an innate architectural mind. High-growth technology sectors, '
            'data visualization, systems engineering, and strategic tech leadership are '
            'your undisputed domains.'),
        _buildParagraph(
            'The Great Switch (D10 Dashamsha):\n'
            'The upcoming planetary transitions suggest a monumental pivot within the next 18 '
            'months. You will move from being an "implementer" to a "visionary director." '
            'Prepare to scale your impact—stepping into executive roles or independent tech entrepreneurship.'),
      ],
    );
  }
}

class LoveTab extends StatelessWidget {
  const LoveTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24.0),
      children: [
        _buildSectionTitle(context, 'Love & Union (7th House)'),
        _buildParagraph(
            'The 7th House (Cancer):\n'
            'Ruled by the Moon, your partnership sector desires profound emotional '
            'security and nurturing. However, with your Capricorn Ascendant, there is a '
            'natural push-and-pull between your cold, pragmatic outer shell and your desire '
            'for a warm, empathetic partner.'),
        _buildParagraph(
            'Hard Truths:\n'
            'You often prioritize ambition over emotional availability. Your fast-moving Aries '
            'Moon can make you impatient with a partner\'s emotional processing. '
            'You must consciously practice holding space for vulnerability.'),
        _buildParagraph(
            'Great Strengths:\n'
            'Once committed, you are an immovable fortress. You protect and provide with '
            'unmatched loyalty. Venus in your chart promises a relationship built on mutual '
            'respect, shared intellectual pursuits, and refined aesthetics.'),
      ],
    );
  }
}

class HealthTab extends StatelessWidget {
  const HealthTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24.0),
      children: [
        _buildSectionTitle(context, 'Health & Vitality'),
        _buildParagraph(
            'The 6th House (Gemini) & Ascendant:\n'
            'Ruled by Mercury, your health is deeply tied to your nervous system. '
            'Anxiety, overthinking, and mental burnout are your primary adversaries.'),
        _buildParagraph(
            'Vitality Focus:\n'
            'Your fiery Ashwini Moon gives you bursts of immense energy, but you lack '
            'pacing. To preserve your vitality, you must ground your energy. Pratyahara '
            '(sense withdrawal) and deep, restorative sleep are non-negotiable for your longevity.'),
      ],
    );
  }
}

class WealthTab extends StatelessWidget {
  const WealthTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24.0),
      children: [
        _buildSectionTitle(context, 'Abundance & Relationship Alchemy'),
        _buildParagraph(
            'The 2nd House (Aquarius) & 11th House (Scorpio):\n'
            'Saturn residing in your 2nd house of accumulated wealth signifies that '
            'money comes through persistent, highly structured, and organized effort. '
            'This is the signature of self-made wealth. No windfalls, only earned empires.'),
        _buildParagraph(
            'The 11th House of Gains:\n'
            'Mars ruling your 11th indicates aggressive, strategic network building. '
            'Your greatest financial expansions will come not from solo endeavors, but '
            'from spearheading technical collectives or exclusive professional networks.'),
      ],
    );
  }
}

class RemediesTab extends StatelessWidget {
  const RemediesTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24.0),
      children: [
        _buildSectionTitle(context, 'Remedies (The Upayas)'),
        _buildParagraph(
            'To balance planetary debilities and unlock your maximum potential, '
            'integrate these practices into your life:'),
        _buildParagraph(
            '1. The Sapphire Resonance:\n'
            'Wearing a Blue Sapphire (Neelam) in silver or platinum can harmonize '
            'Saturn, accelerating your career growth and stabilizing your wealth accumulation. '
            '(Always test for 3 days before permanent wear).'),
        _buildParagraph(
            '2. Sonic Alchemy (Mantra):\n'
            'Chant the Ashwini Kumara Mantra or the Ketu Beej Mantra: \n'
            '"Om Sraam Sreem Sraum Sah Ketave Namah"\n'
            '108 times on Tuesdays to calm the mental hyperactivity of your Moon.'),
        _buildParagraph(
            '3. Behavioral Shift:\n'
            'Practice "Slowing Down." Your mind lives in the future. Spend 15 minutes '
            'daily in complete silence, focusing purely on grounding your feet to the earth '
            'to balance your airy and fiery elements.'),
      ],
    );
  }
}

Widget _buildSectionTitle(BuildContext context, String text) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 16.0),
    child: Text(
      text,
      style: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).primaryColor,
        letterSpacing: 1.2,
      ),
    ),
  );
}

Widget _buildParagraph(String text) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 16.0),
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        height: 1.6,
        color: Colors.white70,
      ),
    ),
  );
}

// --- PAINTERS ---

class StarryBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withOpacity(0.1);
    final random = math.Random(42); // Deterministic stars

    for (int i = 0; i < 200; i++) {
      final x = random.nextDouble() * size.width * 2 - size.width / 2;
      final y = random.nextDouble() * size.height * 2 - size.height / 2;
      final radius = random.nextDouble() * 1.5;
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class LagnaChartPainter extends CustomPainter {
  final Color primaryColor;

  LagnaChartPainter({required this.primaryColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final w = size.width;
    final h = size.height;

    // Outer Square
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h), paint);

    // Diagonals
    canvas.drawLine(const Offset(0, 0), Offset(w, h), paint);
    canvas.drawLine(Offset(w, 0), Offset(0, h), paint);

    // Midpoint Diamond
    final path = Path();
    path.moveTo(w / 2, 0);
    path.lineTo(w, h / 2);
    path.lineTo(w / 2, h);
    path.lineTo(0, h / 2);
    path.close();
    canvas.drawPath(path, paint);

    // Labels for Houses (Ascendant = 1)
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    void drawText(String text, Offset position, {double size = 16, bool bold = false}) {
      textPainter.text = TextSpan(
        text: text,
        style: TextStyle(
          color: primaryColor,
          fontSize: size,
          fontWeight: bold ? FontWeight.bold : FontWeight.normal,
        ),
      );
      textPainter.layout();
      textPainter.paint(
          canvas, Offset(position.dx - textPainter.width / 2, position.dy - textPainter.height / 2));
    }

    // Placing some esoteric markers (Ascendant in House 1)
    drawText('ASC\n10', Offset(w / 2, h / 4), bold: true); // 1st House (Capricorn - 10)
    drawText('11', Offset(w / 4, h / 8)); // 2nd House
    drawText('12', Offset(w / 8, h / 4)); // 3rd House
    drawText('Moon\n1', Offset(w / 4, h / 2), size: 14); // 4th House (Aries - Moon)
    drawText('2', Offset(w / 8, h * 0.75));
    drawText('3', Offset(w / 4, h * 0.875));
    drawText('4', Offset(w / 2, h * 0.75));
    drawText('5', Offset(w * 0.75, h * 0.875));
    drawText('6', Offset(w * 0.875, h * 0.75));
    drawText('7', Offset(w * 0.75, h / 2));
    drawText('8', Offset(w * 0.875, h / 4));
    drawText('9', Offset(w * 0.75, h / 8));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
