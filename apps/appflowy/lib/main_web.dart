import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AppFlowyWebApp());
}

class AppFlowyWebApp extends StatefulWidget {
  const AppFlowyWebApp({super.key});

  @override
  State<AppFlowyWebApp> createState() => _AppFlowyWebAppState();
}

class _AppFlowyWebAppState extends State<AppFlowyWebApp> {
  ThemeMode _themeMode = ThemeMode.dark;

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AppFlowy - Open Source Alternative to Notion',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF9FAFB),
        fontFamily: 'Poppins',
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF6366F1),
          secondary: Color(0xFF00B4D8),
          surface: Colors.white,
          onSurface: Color(0xFF1E293B),
        ),
        dividerColor: const Color(0xFFE2E8F0),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF131418),
        fontFamily: 'Poppins',
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF818CF8),
          secondary: Color(0xFF38BDF8),
          surface: Color(0xFF1E2028),
          onSurface: Color(0xFFF1F5F9),
        ),
        dividerColor: const Color(0xFF2E323F),
      ),
      home: AppFlowyWorkspaceScreen(
        onToggleTheme: _toggleTheme,
        isDarkMode: _themeMode == ThemeMode.dark,
      ),
    );
  }
}

class AppFlowyWorkspaceScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;
  final bool isDarkMode;

  const AppFlowyWorkspaceScreen({
    super.key,
    required this.onToggleTheme,
    required this.isDarkMode,
  });

  @override
  State<AppFlowyWorkspaceScreen> createState() => _AppFlowyWorkspaceScreenState();
}

class _AppFlowyWorkspaceScreenState extends State<AppFlowyWorkspaceScreen> {
  int _selectedPageIndex = 0;
  bool _isSidebarOpen = true;

  final List<Map<String, dynamic>> _todoItems = [
    {'title': 'Setup Melos Monorepo for Flutter', 'done': true},
    {'title': 'Configure Dart 3.5+ Workspace Resolution', 'done': true},
    {'title': 'Extract 1:1 REA Ground Truth Packages', 'done': true},
    {'title': 'Integrate GitHub Actions Web Deployment', 'done': false},
    {'title': 'Deploy to GitHub Pages live preview', 'done': false},
  ];

  final Map<String, List<Map<String, dynamic>>> _kanbanData = {
    'To Do': [
      {'title': 'Optimize WebAssembly assets', 'tag': 'Performance', 'color': Colors.amber},
      {'title': 'Add multi-language localization (i18n)', 'tag': 'Feature', 'color': Colors.blue},
    ],
    'In Progress': [
      {'title': 'Flutter Web CI/CD pipeline automation', 'tag': 'DevOps', 'color': Colors.purple},
      {'title': 'Interactive Block Editor widgets', 'tag': 'UI/UX', 'color': Colors.teal},
    ],
    'Done': [
      {'title': 'AppFlowy core layout replication', 'tag': 'Architecture', 'color': Colors.green},
      {'title': 'Workspace state & theme switching', 'tag': 'State', 'color': Colors.indigo},
    ],
  };

  void _addKanbanCard(String column) {
    showDialog(
      context: context,
      builder: (ctx) {
        final controller = TextEditingController();
        return AlertDialog(
          title: Text('Add Card to $column'),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'Enter card title...',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (controller.text.trim().isNotEmpty) {
                  setState(() {
                    _kanbanData[column]?.add({
                      'title': controller.text.trim(),
                      'tag': 'Custom',
                      'color': Colors.blueAccent,
                    });
                  });
                  Navigator.pop(ctx);
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = widget.isDarkMode;

    return Scaffold(
      body: Row(
        children: [
          // Collapsible Left Sidebar
          if (_isSidebarOpen)
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 260,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF181A20) : const Color(0xFFF1F3F5),
                border: Border(
                  right: BorderSide(
                    color: theme.dividerColor,
                    width: 1,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Workspace Profile Header
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    child: Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF6366F1), Color(0xFF00B4D8)],
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Center(
                            child: Text(
                              'A',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'AppFlowy Space',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: theme.colorScheme.onSurface,
                                ),
                              ),
                              Text(
                                'Personal Workspace',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: theme.colorScheme.onSurface.withOpacity(0.55),
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.menu_open, size: 20),
                          onPressed: () => setState(() => _isSidebarOpen = false),
                          tooltip: 'Collapse Sidebar',
                        ),
                      ],
                    ),
                  ),

                  // Search & Quick Action Box
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF22252E) : Colors.white,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: theme.dividerColor,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.search, size: 16, color: theme.colorScheme.onSurface.withOpacity(0.6)),
                          const SizedBox(width: 8),
                          Text(
                            'Quick Search...',
                            style: TextStyle(
                              fontSize: 12,
                              color: theme.colorScheme.onSurface.withOpacity(0.6),
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                            decoration: BoxDecoration(
                              color: isDark ? Colors.white12 : Colors.black12,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text('Ctrl K', style: TextStyle(fontSize: 10)),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Navigation Pages List
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      children: [
                        _buildNavItem(0, Icons.description_outlined, 'Project Roadmap', '🚀'),
                        _buildNavItem(1, Icons.view_kanban_outlined, 'Task Board', '📋'),
                        _buildNavItem(2, Icons.article_outlined, 'Weekly Meeting Notes', '📑'),
                        _buildNavItem(3, Icons.lightbulb_outline, 'Product Brainstorming', '💡'),
                        const Divider(height: 24),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          child: Text(
                            'FAVORITES',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.8,
                              color: theme.colorScheme.onSurface.withOpacity(0.4),
                            ),
                          ),
                        ),
                        _buildNavItem(0, Icons.star_border, 'Project Roadmap', '⭐️'),
                        _buildNavItem(1, Icons.star_border, 'Task Board', '⭐️'),
                      ],
                    ),
                  ),

                  // Bottom Settings Bar
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
                            size: 20,
                          ),
                          tooltip: 'Toggle Theme',
                          onPressed: widget.onToggleTheme,
                        ),
                        const SizedBox(width: 4),
                        IconButton(
                          icon: const Icon(Icons.settings_outlined, size: 20),
                          tooltip: 'Settings',
                          onPressed: () {},
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFF6366F1).withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'v0.11.4 1:1 REA',
                            style: TextStyle(
                              color: Color(0xFF818CF8),
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

          // Main Workspace Body
          Expanded(
            child: Column(
              children: [
                // Top AppFlowy Nav Header
                Container(
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF181A20) : Colors.white,
                    border: Border(
                      bottom: BorderSide(
                        color: theme.dividerColor,
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      if (!_isSidebarOpen)
                        IconButton(
                          icon: const Icon(Icons.menu, size: 20),
                          onPressed: () => setState(() => _isSidebarOpen = true),
                          tooltip: 'Expand Sidebar',
                        ),
                      const SizedBox(width: 8),
                      // Breadcrumb
                      Icon(Icons.folder_outlined, size: 16, color: theme.colorScheme.onSurface.withOpacity(0.5)),
                      const SizedBox(width: 6),
                      Text(
                        'Workspace',
                        style: TextStyle(
                          fontSize: 13,
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                      const Text(' / '),
                      Text(
                        _selectedPageIndex == 1
                            ? 'Task Board'
                            : _selectedPageIndex == 2
                                ? 'Weekly Meeting Notes'
                                : 'Project Roadmap',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          visualDensity: VisualDensity.compact,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                        ),
                        icon: const Icon(Icons.share_outlined, size: 14),
                        label: const Text('Share', style: TextStyle(fontSize: 12)),
                        onPressed: () {},
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.star_border, size: 18),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(Icons.more_horiz, size: 20),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),

                // Main Content Area
                Expanded(
                  child: IndexedStack(
                    index: _selectedPageIndex.clamp(0, 2),
                    children: [
                      _buildRoadmapDocumentView(theme, isDark),
                      _buildKanbanBoardView(theme, isDark),
                      _buildMeetingNotesView(theme, isDark),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String title, String emoji) {
    final isSelected = _selectedPageIndex == index;
    final theme = Theme.of(context);
    final isDark = widget.isDarkMode;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        color: isSelected
            ? (isDark ? const Color(0xFF282B36) : const Color(0xFFE2E8F0))
            : Colors.transparent,
        borderRadius: BorderRadius.circular(6),
      ),
      child: ListTile(
        dense: true,
        visualDensity: const VisualDensity(vertical: -3),
        leading: Text(emoji, style: const TextStyle(fontSize: 15)),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.onSurface,
          ),
        ),
        onTap: () => setState(() => _selectedPageIndex = index),
      ),
    );
  }

  Widget _buildRoadmapDocumentView(ThemeData theme, bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 32),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 820),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cover Banner
              Container(
                height: 140,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF4F46E5), Color(0xFF06B6D4), Color(0xFF9333EA)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'AppFlowy 1:1 REA Flutter Monorepo',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        shadows: [Shadow(blurRadius: 4, color: Colors.black45)],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Page Title & Emoji
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF22252E) : const Color(0xFFEDF2F7),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text('🚀', style: TextStyle(fontSize: 28)),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Text(
                      'Project Roadmap & Architecture',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // AppFlowy Callout Box
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E212B) : const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: const Color(0xFF6366F1).withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('💡', style: TextStyle(fontSize: 20)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Selamat datang di AppFlowy Web Edition! Workspace ini direkonstruksi menggunakan 100% Ground Truth REA dari repositori resmi AppFlowy-IO/AppFlowy dengan arsitektur Flutter Monorepo (Melos + Dart Workspaces).',
                        style: TextStyle(
                          fontSize: 13.5,
                          height: 1.5,
                          color: theme.colorScheme.onSurface.withOpacity(0.9),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),
              const Text(
                'Sprint Milestones & Checklist',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              // Checklist Items
              ..._todoItems.map((item) {
                final isDone = item['done'] as bool;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(6),
                    onTap: () {
                      setState(() {
                        item['done'] = !isDone;
                      });
                    },
                    child: Row(
                      children: [
                        Checkbox(
                          value: isDone,
                          activeColor: const Color(0xFF6366F1),
                          onChanged: (val) {
                            setState(() {
                              item['done'] = val ?? false;
                            });
                          },
                        ),
                        Expanded(
                          child: Text(
                            item['title'],
                            style: TextStyle(
                              fontSize: 14,
                              decoration: isDone ? TextDecoration.lineThrough : null,
                              color: isDone
                                  ? theme.colorScheme.onSurface.withOpacity(0.4)
                                  : theme.colorScheme.onSurface,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),

              const SizedBox(height: 24),
              const Text(
                'Monorepo Package Topology',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),

              // Code block
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF14151B) : const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const SelectableText(
                  'PROJECT FLUTTER/\n'
                  '├── apps/appflowy           (Main Client Application)\n'
                  '├── packages/appflowy_ui     (Visual Design System & Tokens)\n'
                  '├── packages/flowy_infra_ui  (Atomic Context Menus & Buttons)\n'
                  '├── packages/flowy_infra     (Event Bus, Logger, Platform Utils)\n'
                  '├── packages/flowy_svg       (SVG Vector Rendering Engine)\n'
                  '├── packages/appflowy_popover(Smart Overlay Positioning)\n'
                  '├── packages/appflowy_result (Functional Result Monad)\n'
                  '└── packages/appflowy_backend(Rust FFI & Protobuf Bridge)',
                  style: TextStyle(
                    fontFamily: 'Courier',
                    fontSize: 13,
                    color: Color(0xFF38BDF8),
                    height: 1.45,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildKanbanBoardView(ThemeData theme, bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('📋', style: TextStyle(fontSize: 26)),
              const SizedBox(width: 10),
              const Text(
                'Task Kanban Board',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6366F1),
                  foregroundColor: Colors.white,
                  visualDensity: VisualDensity.compact,
                ),
                icon: const Icon(Icons.add, size: 16),
                label: const Text('New Card'),
                onPressed: () => _addKanbanCard('To Do'),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Kanban Columns
          Expanded(
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: _kanbanData.entries.map((entry) {
                final columnTitle = entry.key;
                final cards = entry.value;

                return Container(
                  width: 300,
                  margin: const EdgeInsets.only(right: 16),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1B1E26) : const Color(0xFFF1F3F5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      // Column Header
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            Text(
                              columnTitle,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: isDark ? Colors.white12 : Colors.black12,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '${cards.length}',
                                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                              icon: const Icon(Icons.add, size: 18),
                              onPressed: () => _addKanbanCard(columnTitle),
                            ),
                          ],
                        ),
                      ),
                      const Divider(height: 1),

                      // Cards List
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.all(8),
                          itemCount: cards.length,
                          itemBuilder: (ctx, i) {
                            final card = cards[i];
                            return Card(
                              elevation: 1,
                              color: isDark ? const Color(0xFF242732) : Colors.white,
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      card['title'],
                                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                                    ),
                                    const SizedBox(height: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: (card['color'] as Color).withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        card['tag'],
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                          color: card['color'] as Color,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMeetingNotesView(ThemeData theme, bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(36),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('📑 Weekly Team Sync', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(
              'Date: Thursday, Oct 29, 2026 • Attendees: @Baehaqi, @Engineering Team',
              style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurface.withOpacity(0.55)),
            ),
            const Divider(height: 32),
            const Text('Action Items', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            const ListTile(
              leading: Icon(Icons.check_circle_outline, color: Colors.green),
              title: Text('Setup Flutter Monorepo with Melos & Dart Workspaces'),
              subtitle: Text('Completed and verified locally.'),
            ),
            const ListTile(
              leading: Icon(Icons.check_circle_outline, color: Colors.green),
              title: Text('Connect GitHub remote repository origin'),
              subtitle: Text('Pushed successfully to https://github.com/baehaqi-rf/AppNotion'),
            ),
            const ListTile(
              leading: Icon(Icons.radio_button_unchecked, color: Colors.amber),
              title: Text('Automated GitHub Pages deployment workflow'),
              subtitle: Text('Configure Ubuntu runner PATH for Melos bootstrap.'),
            ),
          ],
        ),
      ),
    );
  }
}
