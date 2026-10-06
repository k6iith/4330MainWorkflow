import 'package:flutter/material.dart';

void main() {
  runApp(const SwipeHireApp());
}

const brandBlue = Color(0xFF3B5BDB);
const brandViolet = Color(0xFF7048E8);

class SwipeHireApp extends StatelessWidget {
  const SwipeHireApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SwipeHire',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: brandBlue),
        useMaterial3: true,
      ),
      home: const HomeShell(),
    );
  }
}

// ---------------------------------------------------------------------------
// Data
// ---------------------------------------------------------------------------

class Candidate {
  const Candidate({
    required this.name,
    required this.initials,
    required this.headline,
    required this.education,
    required this.recent,
    required this.skills,
    required this.fit,
    required this.color,
  });

  final String name;
  final String initials;
  final String headline;
  final String education;
  final String recent;
  final List<String> skills;
  final int fit;
  final Color color;
}

// Fake candidates for the mockup.
const sampleCandidates = <Candidate>[
  Candidate(
    name: 'Jordan Lee',
    initials: 'JL',
    headline: 'CS Senior · Full-stack developer',
    education: 'UNT · B.S. Computer Science · May 2027',
    recent: 'Web Dev Intern, Mavrix (Summer 2026)',
    skills: ['React', 'Python', 'SQL', 'AWS'],
    fit: 92,
    color: Color(0xFF4C6EF5),
  ),
  Candidate(
    name: 'Priya Shah',
    initials: 'PS',
    headline: 'Data Science Junior',
    education: 'UTD · B.S. Data Science · 2028',
    recent: 'Research Asst., ML Lab',
    skills: ['Python', 'Pandas', 'TensorFlow'],
    fit: 85,
    color: Color(0xFF7048E8),
  ),
  Candidate(
    name: 'Marcus Reed',
    initials: 'MR',
    headline: 'Software Engineering Senior',
    education: 'UNT · B.S. Software Eng. · Dec 2026',
    recent: 'IT Support, Campus Tech Desk',
    skills: ['Java', 'Spring', 'Docker'],
    fit: 78,
    color: Color(0xFFE8590C),
  ),
  Candidate(
    name: 'Elena Torres',
    initials: 'ET',
    headline: 'CS Senior · Mobile developer',
    education: 'SMU · B.S. Computer Science · 2027',
    recent: 'iOS Intern, Lumen Apps',
    skills: ['Swift', 'Kotlin', 'Firebase'],
    fit: 81,
    color: Color(0xFF0CA678),
  ),
];

// ---------------------------------------------------------------------------
// Shell with bottom navigation
// ---------------------------------------------------------------------------

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _tab = 0;
  final List<Candidate> _matches = [];

  void _onMatch(Candidate candidate) {
    setState(() => _matches.insert(0, candidate));
    showDialog<void>(
      context: context,
      builder: (_) => MatchDialog(candidate: candidate),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text.rich(
          TextSpan(
            text: 'Swipe',
            style: TextStyle(fontWeight: FontWeight.w800),
            children: [
              TextSpan(text: 'Hire', style: TextStyle(color: brandBlue)),
            ],
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Chip(
              label: Text(_tab == 0 ? 'Job Seeker' : 'Employer'),
              visualDensity: VisualDensity.compact,
            ),
          ),
        ],
      ),
      body: IndexedStack(
        index: _tab,
        children: [
          const ProfileScreen(),
          DiscoverScreen(onMatch: _onMatch),
          MatchesScreen(matches: _matches),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: (i) => setState(() => _tab = i),
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
          const NavigationDestination(
            icon: Icon(Icons.style_outlined),
            selectedIcon: Icon(Icons.style),
            label: 'Discover',
          ),
          NavigationDestination(
            icon: Badge(
              isLabelVisible: _matches.isNotEmpty,
              label: Text('${_matches.length}'),
              child: const Icon(Icons.favorite_border),
            ),
            selectedIcon: const Icon(Icons.favorite),
            label: 'Matches',
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 1. Job seeker: upload resume & build profile
// ---------------------------------------------------------------------------

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _uploaded = false;
  final List<String> _skills = ['React', 'Python', 'SQL', 'AWS'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 16),
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer.withValues(alpha: 0.35),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.4), width: 2),
          ),
          child: Column(
            children: [
              Icon(Icons.upload_file, size: 48, color: theme.colorScheme.primary),
              const SizedBox(height: 8),
              Text('Upload your resume', style: theme.textTheme.titleMedium),
              const SizedBox(height: 4),
              Text(
                "PDF or DOCX · we'll build your profile for you",
                style: theme.textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              FilledButton.tonal(
                onPressed: () => setState(() => _uploaded = true),
                child: Text(_uploaded ? 'Replace file' : 'Choose file'),
              ),
            ],
          ),
        ),
        if (_uploaded) ...[
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
              title: const Text('Jordan_Lee_Resume.pdf'),
              subtitle: const Text('Uploaded · profile filled in below'),
              trailing: Icon(Icons.check_circle, color: Colors.green.shade600),
            ),
          ),
          const SizedBox(height: 16),
          Text('PULLED FROM YOUR RESUME', style: theme.textTheme.labelSmall),
          const SizedBox(height: 8),
          TextFormField(
            initialValue: 'CS Senior · Full-stack developer',
            decoration: const InputDecoration(labelText: 'Headline', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 12),
          TextFormField(
            initialValue: 'Software Engineer Intern · Dallas / Remote',
            decoration: const InputDecoration(labelText: 'Looking for', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (final skill in _skills)
                InputChip(
                  label: Text(skill),
                  onDeleted: () => setState(() => _skills.remove(skill)),
                ),
              ActionChip(
                avatar: const Icon(Icons.add, size: 18),
                label: const Text('Add skill'),
                onPressed: () => setState(() => _skills.add('Skill ${_skills.length + 1}')),
              ),
            ],
          ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Profile published to employers')),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Text('Publish profile to employers'),
            ),
          ),
        ],
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// 2. Employer: swipe on candidates
// ---------------------------------------------------------------------------

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key, required this.onMatch});

  final ValueChanged<Candidate> onMatch;

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  static const _threshold = 100.0;
  int _index = 0;
  Offset _drag = Offset.zero;

  Candidate? get _current => _index < sampleCandidates.length ? sampleCandidates[_index] : null;

  void _decide(String decision) {
    final candidate = _current;
    if (candidate == null) return;
    setState(() {
      _index++;
      _drag = Offset.zero;
    });
    switch (decision) {
      case 'yes':
        widget.onMatch(candidate);
      case 'star':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Shortlisted ${candidate.name}')),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final current = _current;
    final next = _index + 1 < sampleCandidates.length ? sampleCandidates[_index + 1] : null;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Wrap(
            spacing: 6,
            children: [
              Chip(label: Text('SWE Intern')),
              Chip(label: Text('Dallas')),
              Chip(label: Text('React')),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: current == null
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('No more candidates for this role.'),
                        TextButton(
                          onPressed: () => setState(() => _index = 0),
                          child: const Text('Start over'),
                        ),
                      ],
                    ),
                  )
                : Stack(
                    children: [
                      if (next != null)
                        Positioned.fill(
                          child: Transform.scale(scale: 0.95, child: CandidateCard(candidate: next)),
                        ),
                      Positioned.fill(
                        child: GestureDetector(
                          onPanUpdate: (d) => setState(() => _drag += d.delta),
                          onPanEnd: (_) {
                            if (_drag.dx > _threshold) {
                              _decide('yes');
                            } else if (_drag.dx < -_threshold) {
                              _decide('no');
                            } else if (_drag.dy < -_threshold) {
                              _decide('star');
                            } else {
                              setState(() => _drag = Offset.zero);
                            }
                          },
                          child: Transform.translate(
                            offset: _drag,
                            child: Transform.rotate(
                              angle: _drag.dx / 1000,
                              child: CandidateCard(
                                candidate: current,
                                stamp: _drag.dx > 40
                                    ? 'YES'
                                    : _drag.dx < -40
                                        ? 'PASS'
                                        : null,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton.outlined(
                tooltip: 'Pass',
                iconSize: 30,
                color: Colors.red,
                onPressed: current == null ? null : () => _decide('no'),
                icon: const Icon(Icons.close),
              ),
              const SizedBox(width: 16),
              IconButton.outlined(
                tooltip: 'Shortlist',
                color: Colors.amber.shade700,
                onPressed: current == null ? null : () => _decide('star'),
                icon: const Icon(Icons.star),
              ),
              const SizedBox(width: 16),
              IconButton.outlined(
                tooltip: 'Interested',
                iconSize: 30,
                color: Colors.green,
                onPressed: current == null ? null : () => _decide('yes'),
                icon: const Icon(Icons.check),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text('Drag the card or use the buttons', style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}

class CandidateCard extends StatelessWidget {
  const CandidateCard({super.key, required this.candidate, this.stamp});

  final Candidate candidate;
  final String? stamp;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 3,
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [candidate.color, candidate.color.withValues(alpha: 0.75)],
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 28,
                            backgroundColor: Colors.white.withValues(alpha: 0.25),
                            foregroundColor: Colors.white,
                            child: Text(candidate.initials, style: const TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            candidate.name,
                            style: theme.textTheme.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                          Text(candidate.headline, style: const TextStyle(color: Colors.white70)),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                      child: Column(
                        children: [
                          Text('${candidate.fit}%', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                          const Text('FIT', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _InfoRow(label: 'Education', value: candidate.education),
                    _InfoRow(label: 'Recent', value: candidate.recent),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [for (final s in candidate.skills) Chip(label: Text(s))],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'View full resume →',
                      style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (stamp != null)
            Positioned(
              top: 24,
              left: stamp == 'YES' ? 20 : null,
              right: stamp == 'PASS' ? 20 : null,
              child: Transform.rotate(
                angle: stamp == 'YES' ? -0.25 : 0.25,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.85),
                    border: Border.all(color: stamp == 'YES' ? Colors.green : Colors.red, width: 3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    stamp!,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: stamp == 'YES' ? Colors.green : Colors.red,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(label.toUpperCase(), style: Theme.of(context).textTheme.labelSmall),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 3. Match & connect
// ---------------------------------------------------------------------------

class MatchDialog extends StatelessWidget {
  const MatchDialog({super.key, required this.candidate});

  final Candidate candidate;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      clipBehavior: Clip.antiAlias,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [brandBlue, brandViolet],
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("It's a Match!",
                style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w800)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _Bubble(text: candidate.initials, color: candidate.color),
                const SizedBox(width: 8),
                const _Bubble(text: 'AC', color: Color(0xFF12B886)),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              '${candidate.name} and Acme Corp are both interested in the Software Engineer Intern role.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 16),
            const Wrap(
              spacing: 6,
              children: [
                Chip(label: Text('Thu 10am')),
                Chip(label: Text('Thu 2pm')),
                Chip(label: Text('Fri 11am')),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                style: FilledButton.styleFrom(backgroundColor: Colors.white, foregroundColor: brandBlue),
                onPressed: () {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Chat with ${candidate.name} opened')),
                  );
                },
                child: const Text('Send message'),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Keep swiping', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 36,
      backgroundColor: Colors.white,
      child: CircleAvatar(
        radius: 33,
        backgroundColor: color,
        foregroundColor: Colors.white,
        child: Text(text, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      ),
    );
  }
}

class MatchesScreen extends StatelessWidget {
  const MatchesScreen({super.key, required this.matches});

  final List<Candidate> matches;

  @override
  Widget build(BuildContext context) {
    if (matches.isEmpty) {
      return const Center(child: Text('No matches yet. Go swipe!'));
    }
    return ListView.separated(
      itemCount: matches.length,
      separatorBuilder: (_, _) => const Divider(height: 1),
      itemBuilder: (context, i) {
        final c = matches[i];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: c.color,
            foregroundColor: Colors.white,
            child: Text(c.initials),
          ),
          title: Text(c.name),
          subtitle: const Text('Software Engineer Intern · Acme Corp'),
          trailing: const Icon(Icons.chat_bubble_outline),
        );
      },
    );
  }
}
