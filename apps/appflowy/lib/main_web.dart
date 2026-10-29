import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:appflowy_board/appflowy_board.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AppFlowy1to1App());
}

class AppFlowy1to1App extends StatefulWidget {
  const AppFlowy1to1App({super.key});

  @override
  State<AppFlowy1to1App> createState() => _AppFlowy1to1AppState();
}

class _AppFlowy1to1AppState extends State<AppFlowy1to1App> {
  ThemeMode _themeMode = ThemeMode.dark;

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AppFlowy - 1:1 REA Web Edition',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        AppFlowyEditorLocalizations.delegate,
      ],
      supportedLocales: AppFlowyEditorLocalizations.delegate.supportedLocales,
      theme: ThemeData(
        brightness: Brightness.light,
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: const Color(0xFFFAFAFA),
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF6366F1),
          secondary: Color(0xFF00B4D8),
          surface: Colors.white,
          onSurface: Color(0xFF1E293B),
        ),
        dividerColor: const Color(0xFFE2E8F0),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: const Color(0xFF131418),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF818CF8),
          secondary: Color(0xFF38BDF8),
          surface: Color(0xFF1E2028),
          onSurface: Color(0xFFF1F5F9),
        ),
        dividerColor: const Color(0xFF282B36),
        useMaterial3: true,
      ),
      home: AppFlowyWorkspaceScaffold(
        onToggleTheme: _toggleTheme,
        isDarkMode: _themeMode == ThemeMode.dark,
      ),
    );
  }
}

class AppFlowyWorkspaceScaffold extends StatefulWidget {
  final VoidCallback onToggleTheme;
  final bool isDarkMode;

  const AppFlowyWorkspaceScaffold({
    super.key,
    required this.onToggleTheme,
    required this.isDarkMode,
  });

  @override
  State<AppFlowyWorkspaceScaffold> createState() => _AppFlowyWorkspaceScaffoldState();
}

class _AppFlowyWorkspaceScaffoldState extends State<AppFlowyWorkspaceScaffold> {
  int _activeViewIndex = 0; // 0: Document Editor, 1: Kanban Board
  bool _isSidebarVisible = true;

  // Real AppFlowy Editor State
  late EditorState _editorState;
  late final EditorScrollController _editorScrollController;

  // Real AppFlowy Board State
  late final AppFlowyBoardController _boardController;
  late final AppFlowyBoardScrollController _boardScrollController;

  @override
  void initState() {
    super.initState();
    _initEditor();
    _initBoard();
  }

  void _initEditor() {
    // Initial Notion-like document in authentic AppFlowy Markdown
    const initialMarkdown = '''
# 🚀 AppFlowy 1:1 REA Workspace

> **Welcome to AppFlowy!** This is the authentic **AppFlowy Editor Engine** running live on Flutter Web. You can format text, create headings, checklists, code blocks, and type `/` for slash commands.

## 🎯 Active Sprint Objectives
- [x] Extract 1:1 REA Monorepo packages from GitHub
- [x] Configure Melos Orchestrator and Dart 3.5+ Workspaces
- [x] Mount authentic AppFlowyEditor block system
- [x] Mount authentic AppFlowyBoard multi-column kanban system
- [ ] Try editing blocks or dragging kanban task cards

```dart
// Pure Flutter Web & AppFlowy Engine
void main() {
  runApp(const AppFlowy1to1App());
}
```

### 💡 Tips
Select any text to reveal the **AppFlowy Floating Toolbar**, or press Enter on an empty line and type `/` to insert callouts, dividers, or headers.
''';

    final document = markdownToDocument(initialMarkdown);
    _editorState = EditorState(document: document);
    _editorScrollController = EditorScrollController(
      editorState: _editorState,
      shrinkWrap: false,
    );
  }

  void _initBoard() {
    _boardScrollController = AppFlowyBoardScrollController();
    _boardController = AppFlowyBoardController(
      onMoveGroup: (fromGroupId, fromIndex, toGroupId, toIndex) {},
      onMoveGroupItem: (groupId, fromIndex, toIndex) {},
      onMoveGroupItemToGroup: (fromGroupId, fromIndex, toGroupId, toIndex) {},
    );

    final todoGroup = AppFlowyGroupData(
      id: 'todo',
      name: 'To Do',
      items: [
        _CustomBoardCard(
          id: '1',
          title: 'Implement Dark/Light Theme Transition',
          tag: 'UI/UX',
          tagColor: Colors.blueAccent,
          due: 'Tomorrow',
        ),
        _CustomBoardCard(
          id: '2',
          title: 'Optimize WebAssembly CanvasKit Rendering',
          tag: 'Performance',
          tagColor: Colors.amber,
          due: 'Oct 31',
        ),
      ],
    );

    final inProgressGroup = AppFlowyGroupData(
      id: 'in_progress',
      name: 'In Progress',
      items: [
        _CustomBoardCard(
          id: '3',
          title: '1:1 REA Production Editor & Board Integration',
          tag: 'Engine',
          tagColor: Colors.purpleAccent,
          due: 'Today',
        ),
        _CustomBoardCard(
          id: '4',
          title: 'GitHub Pages Automated Release Pipeline',
          tag: 'DevOps',
          tagColor: Colors.teal,
          due: 'Today',
        ),
      ],
    );

    final doneGroup = AppFlowyGroupData(
      id: 'done',
      name: 'Done',
      items: [
        _CustomBoardCard(
          id: '5',
          title: 'Clone & Extract AppFlowy-IO/AppFlowy Monorepo',
          tag: 'Architecture',
          tagColor: Colors.green,
          due: 'Completed',
        ),
        _CustomBoardCard(
          id: '6',
          title: 'Harmonize Melos Dependency Overrides',
          tag: 'Core',
          tagColor: Colors.indigo,
          due: 'Completed',
        ),
      ],
    );

    _boardController.addGroup(todoGroup);
    _boardController.addGroup(inProgressGroup);
    _boardController.addGroup(doneGroup);
  }

  @override
  void dispose() {
    _editorScrollController.dispose();
    _editorState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = widget.isDarkMode;

    return Scaffold(
      body: Row(
        children: [
          // Authentic AppFlowy Left Sidebar
          if (_isSidebarVisible)
            Container(
              width: 250,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF181920) : const Color(0xFFF4F5F7),
                border: Border(right: BorderSide(color: theme.dividerColor, width: 1)),
              ),
              child: Column(
                children: [
                  // Workspace Switcher
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    child: Row(
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF6366F1), Color(0xFF00B4D8)],
                            ),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Center(
                            child: Text(
                              'A',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "AppFlowy's Space",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                  color: theme.colorScheme.onSurface,
                                ),
                              ),
                              Text(
                                'Personal Workspace',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: theme.colorScheme.onSurface.withOpacity(0.5),
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.keyboard_double_arrow_left, size: 18),
                          onPressed: () => setState(() => _isSidebarVisible = false),
                          tooltip: 'Hide Sidebar',
                        ),
                      ],
                    ),
                  ),

                  // Search Box
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF22242E) : Colors.white,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: theme.dividerColor, width: 1),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.search, size: 15, color: theme.colorScheme.onSurface.withOpacity(0.5)),
                          const SizedBox(width: 8),
                          Text(
                            'Quick Search',
                            style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurface.withOpacity(0.5)),
                          ),
                          const Spacer(),
                          Text(
                            'Ctrl K',
                            style: TextStyle(fontSize: 10, color: theme.colorScheme.onSurface.withOpacity(0.4)),
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
                        _buildSidebarItem(
                          title: 'Roadmap & Specs',
                          emoji: '📄',
                          index: 0,
                          badge: 'Doc Editor',
                        ),
                        _buildSidebarItem(
                          title: 'Task Kanban Board',
                          emoji: '📋',
                          index: 1,
                          badge: 'Board View',
                        ),
                        const Divider(height: 24),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          child: Text(
                            'WORKSPACE PAGES',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.8,
                              color: theme.colorScheme.onSurface.withOpacity(0.4),
                            ),
                          ),
                        ),
                        _buildSidebarItem(title: 'Getting Started', emoji: '✨', index: 0),
                        _buildSidebarItem(title: 'Sprint Backlog', emoji: '📌', index: 1),
                        _buildSidebarItem(title: 'Meeting Notes', emoji: '📑', index: 0),
                      ],
                    ),
                  ),

                  // Footer Theme Switcher
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
                            size: 19,
                          ),
                          tooltip: 'Switch Theme',
                          onPressed: widget.onToggleTheme,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          isDark ? 'Dark Mode' : 'Light Mode',
                          style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurface.withOpacity(0.7)),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFF6366F1).withOpacity(0.15),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            'REA 1:1',
                            style: TextStyle(fontSize: 10, color: Color(0xFF818CF8), fontWeight: FontWeight.bold),
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
                // Top AppFlowy Navigation Bar
                Container(
                  height: 44,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF16171D) : Colors.white,
                    border: Border(bottom: BorderSide(color: theme.dividerColor, width: 1)),
                  ),
                  child: Row(
                    children: [
                      if (!_isSidebarVisible)
                        IconButton(
                          icon: const Icon(Icons.menu, size: 18),
                          onPressed: () => setState(() => _isSidebarVisible = true),
                          tooltip: 'Show Sidebar',
                        ),
                      const SizedBox(width: 6),
                      Text(
                        _activeViewIndex == 0 ? '📄 Roadmap & Specs' : '📋 Task Kanban Board',
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                      const Spacer(),
                      // Tab toggles between Document and Board
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF22242E) : const Color(0xFFE9ECEF),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          children: [
                            _buildViewToggleButton(0, Icons.description_outlined, 'Document'),
                            _buildViewToggleButton(1, Icons.view_kanban_outlined, 'Board'),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          visualDensity: VisualDensity.compact,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                        ),
                        icon: const Icon(Icons.share_outlined, size: 14),
                        label: const Text('Share', style: TextStyle(fontSize: 12)),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),

                // Active View Body
                Expanded(
                  child: _activeViewIndex == 0
                      ? _buildRealAppFlowyEditorView(theme, isDark)
                      : _buildRealAppFlowyBoardView(theme, isDark),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarItem({
    required String title,
    required String emoji,
    required int index,
    String? badge,
  }) {
    final isSelected = _activeViewIndex == index;
    final theme = Theme.of(context);
    final isDark = widget.isDarkMode;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        color: isSelected
            ? (isDark ? const Color(0xFF262933) : const Color(0xFFE5E7EB))
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
            color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurface,
          ),
        ),
        trailing: badge != null
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                decoration: BoxDecoration(
                  color: isSelected
                      ? theme.colorScheme.primary.withOpacity(0.15)
                      : (isDark ? Colors.white10 : Colors.black12),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  badge,
                  style: TextStyle(
                    fontSize: 9,
                    color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurface.withOpacity(0.6),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            : null,
        onTap: () => setState(() => _activeViewIndex = index),
      ),
    );
  }

  Widget _buildViewToggleButton(int index, IconData icon, String label) {
    final isActive = _activeViewIndex == index;
    final theme = Theme.of(context);

    return InkWell(
      borderRadius: BorderRadius.circular(5),
      onTap: () => setState(() => _activeViewIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: isActive ? theme.colorScheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          children: [
            Icon(icon, size: 14, color: isActive ? Colors.white : theme.colorScheme.onSurface.withOpacity(0.7)),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                color: isActive ? Colors.white : theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Real AppFlowy Editor Implementation ---
  Widget _buildRealAppFlowyEditorView(ThemeData theme, bool isDark) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 860),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
          child: FloatingToolbar(
            textDirection: TextDirection.ltr,
            items: [
              paragraphItem,
              ...headingItems,
              ...markdownFormatItems,
              quoteItem,
              bulletedListItem,
              numberedListItem,
              linkItem,
              buildTextColorItem(),
              buildHighlightColorItem(),
            ],
            editorState: _editorState,
            editorScrollController: _editorScrollController,
            child: AppFlowyEditor(
              editorState: _editorState,
              editorScrollController: _editorScrollController,
              editorStyle: EditorStyle.desktop(
                cursorColor: theme.colorScheme.primary,
                selectionColor: theme.colorScheme.primary.withOpacity(0.25),
                textStyleConfiguration: TextStyleConfiguration(
                  text: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 15,
                    color: theme.colorScheme.onSurface,
                    height: 1.6,
                  ),
                  bold: const TextStyle(fontWeight: FontWeight.bold),
                  italic: const TextStyle(fontStyle: FontStyle.italic),
                  code: TextStyle(
                    fontFamily: 'RobotoMono',
                    backgroundColor: isDark ? const Color(0xFF262933) : const Color(0xFFEDF2F7),
                    color: isDark ? const Color(0xFF38BDF8) : const Color(0xFF0284C7),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --- Real AppFlowy Board Implementation ---
  Widget _buildRealAppFlowyBoardView(ThemeData theme, bool isDark) {
    final boardConfig = AppFlowyBoardConfig(
      groupBackgroundColor: isDark ? const Color(0xFF1B1E26) : const Color(0xFFF1F3F5),
      stretchGroupHeight: false,
    );

    return Padding(
      padding: const EdgeInsets.all(20),
      child: AppFlowyBoard(
        controller: _boardController,
        boardScrollController: _boardScrollController,
        config: boardConfig,
        headerBuilder: (context, groupData) {
          return AppFlowyGroupHeader(
            icon: const Icon(Icons.circle, size: 10, color: Color(0xFF6366F1)),
            title: Text(
              groupData.headerData.groupName,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            addIcon: const Icon(Icons.add, size: 18),
            onAddButtonClick: () {
              _boardController.addGroupItem(
                groupData.id,
                _CustomBoardCard(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  title: 'New Task Card',
                  tag: 'Task',
                  tagColor: Colors.blueAccent,
                  due: 'Today',
                ),
              );
            },
            height: 48,
          );
        },
        footerBuilder: (context, groupData) {
          return AppFlowyGroupFooter(
            icon: const Icon(Icons.add, size: 16),
            title: const Text('Add Card', style: TextStyle(fontSize: 12)),
            height: 42,
            onAddButtonClick: () {
              _boardController.addGroupItem(
                groupData.id,
                _CustomBoardCard(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  title: 'New Card item',
                  tag: 'Backlog',
                  tagColor: Colors.teal,
                  due: 'Next sprint',
                ),
              );
            },
          );
        },
        cardBuilder: (context, group, groupItem) {
          final card = groupItem as _CustomBoardCard;
          return AppFlowyGroupCard(
            key: ValueKey(card.id),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF242732) : Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    card.title,
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: card.tagColor.withOpacity(0.18),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          card.tag,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: card.tagColor,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Icon(Icons.calendar_today_outlined, size: 12, color: theme.colorScheme.onSurface.withOpacity(0.4)),
                      const SizedBox(width: 4),
                      Text(
                        card.due,
                        style: TextStyle(
                          fontSize: 11,
                          color: theme.colorScheme.onSurface.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _CustomBoardCard extends AppFlowyGroupItem {
  final String _id;
  final String title;
  final String tag;
  final Color tagColor;
  final String due;

  _CustomBoardCard({
    required String id,
    required this.title,
    required this.tag,
    required this.tagColor,
    required this.due,
  }) : _id = id;

  @override
  String get id => _id;
}
