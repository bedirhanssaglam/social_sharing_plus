import 'dart:io' show File, Platform;

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_sharing_plus/social_sharing_plus.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Social Sharing Plus',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFE86F39),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF7F2EC),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
      ),
      home: const SharePage(),
    );
  }
}

class SharePage extends StatefulWidget {
  const SharePage({super.key});

  @override
  State<SharePage> createState() => _SharePageState();
}

class _SharePageState extends State<SharePage> {
  final TextEditingController _controller = TextEditingController();
  static const List<SocialPlatform> _platforms = SocialPlatform.values;

  final ImagePicker _picker = ImagePicker();
  List<String> _selectedMediaPaths = [];
  bool _isOpenBrowser = true;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _openMediaPickerSheet({required bool append}) async {
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.image_outlined),
                  title: const Text('Choose Photo'),
                  subtitle: Text(
                    append
                        ? 'Add a single photo to the current selection.'
                        : 'Replace the current selection with one photo.',
                  ),
                  onTap: () async {
                    Navigator.of(sheetContext).pop();
                    final XFile? pickedFile = await _picker.pickImage(
                      source: ImageSource.gallery,
                    );
                    if (pickedFile == null) return;
                    _updateSelectedMedia([pickedFile.path], append: append);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.collections_outlined),
                  title: const Text('Choose Photos'),
                  subtitle: Text(
                    append
                        ? 'Add multiple photos to the current selection.'
                        : 'Replace the current selection with multiple photos.',
                  ),
                  onTap: () async {
                    Navigator.of(sheetContext).pop();
                    final List<XFile> pickedFiles =
                        await _picker.pickMultiImage();
                    if (pickedFiles.isEmpty) return;
                    _updateSelectedMedia(
                      pickedFiles.map((file) => file.path).toList(),
                      append: append,
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.video_library_outlined),
                  title: const Text('Choose Video'),
                  subtitle: Text(
                    append
                        ? 'Add a single video to the current selection.'
                        : 'Replace the current selection with one video.',
                  ),
                  onTap: () async {
                    Navigator.of(sheetContext).pop();
                    final XFile? pickedFile = await _picker.pickVideo(
                      source: ImageSource.gallery,
                    );
                    if (pickedFile == null) return;
                    _updateSelectedMedia([pickedFile.path], append: append);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _updateSelectedMedia(List<String> newPaths, {required bool append}) {
    final normalizedPaths = newPaths.where((path) => path.isNotEmpty).toList();
    if (normalizedPaths.isEmpty) return;

    setState(() {
      if (append) {
        _selectedMediaPaths = [
          ..._selectedMediaPaths,
          ...normalizedPaths.where(
            (path) => !_selectedMediaPaths.contains(path),
          ),
        ];
      } else {
        _selectedMediaPaths = normalizedPaths;
      }
    });
  }

  void _clearSelectedMedia() {
    setState(() {
      _selectedMediaPaths = [];
    });
  }

  Future<void> _share(SocialPlatform platform) async {
    final String content = _controller.text;
    final selectedMediaPaths =
        _selectedMediaPaths.where((path) => path.isNotEmpty).toList();

    try {
      if (selectedMediaPaths.length > 1) {
        await SocialSharingPlus.shareToSocialMediaWithMultipleMedia(
          platform,
          media: selectedMediaPaths,
          content: content,
          isOpenBrowser: _isOpenBrowser,
          onAppNotInstalled: () {
            _showSnackBar('${platform.name.capitalize} is not installed.');
          },
        );
      } else {
        await SocialSharingPlus.shareToSocialMedia(
          platform,
          content,
          media: selectedMediaPaths.isEmpty ? null : selectedMediaPaths.first,
          isOpenBrowser: _isOpenBrowser,
          onAppNotInstalled: () {
            _showSnackBar('${platform.name.capitalize} is not installed.');
          },
        );
      }
    } catch (error) {
      _showSnackBar(error.toString());
    }
  }

  Future<void> _sharePlatformAuto(SocialPlatform platform) async {
    await _share(platform);
  }

  String get _selectionSummary {
    if (_selectedMediaPaths.isEmpty) {
      return 'No image or video selected yet.';
    }

    final videoCount = _selectedMediaPaths.where(_isVideoPath).length;
    final imageCount = _selectedMediaPaths.length - videoCount;
    final parts = <String>[];

    if (imageCount > 0) {
      parts.add('$imageCount image${imageCount == 1 ? '' : 's'}');
    }

    if (videoCount > 0) {
      parts.add('$videoCount video${videoCount == 1 ? '' : 's'}');
    }

    return '${_selectedMediaPaths.length} file(s) selected'
        '${parts.isEmpty ? '.' : ' • ${parts.join(' • ')}'}';
  }

  IconData get _selectionIcon {
    if (_selectedMediaPaths.isEmpty) {
      return Icons.image_not_supported_outlined;
    }

    if (_selectedMediaPaths.length == 1) {
      return _isVideoPath(_selectedMediaPaths.first)
          ? Icons.videocam_outlined
          : Icons.image_outlined;
    }

    return Icons.perm_media_outlined;
  }

  Widget? get _selectionPreview {
    if (_selectedMediaPaths.isEmpty) {
      return null;
    }

    if (_selectedMediaPaths.length == 1) {
      final path = _selectedMediaPaths.first;
      return _MediaPreviewCard(
        path: path,
        isVideo: _isVideoPath(path),
        label: _basename(path),
        compact: false,
      );
    }

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children:
          _selectedMediaPaths
              .map(
                (path) => _MediaPreviewCard(
                  path: path,
                  isVideo: _isVideoPath(path),
                  label: _basename(path),
                  compact: true,
                ),
              )
              .toList(),
    );
  }

  bool _isVideoPath(String path) {
    final extension = path.split('.').last.toLowerCase();
    return ['mp4', 'mov', 'avi', 'm4v', 'mkv'].contains(extension);
  }

  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFFF5EA), Color(0xFFF5EFEA), Color(0xFFEFE7E1)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 980),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _HeroCard(
                      title: 'Social Sharing Plus',
                      subtitle:
                          'Flutter plugin that allows you to share content, images and videos to various social media platforms',
                      badges: [
                        _InfoBadge(
                          icon: Icons.text_fields_rounded,
                          label: 'Text',
                        ),
                        _InfoBadge(
                          icon: Icons.perm_media_outlined,
                          label: 'Media',
                        ),
                        _InfoBadge(
                          icon: Icons.layers_outlined,
                          label: 'Multi Share',
                        ),
                        _InfoBadge(
                          icon: Icons.open_in_browser_rounded,
                          label: 'Fallback',
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final isCompact = constraints.maxWidth < 760;
                        final composeSection = _SectionCard(
                          title: 'Compose',
                          description:
                              'Set the message and browser fallback behavior before sharing.',
                          child: Column(
                            children: [
                              TextField(
                                controller: _controller,
                                minLines: 3,
                                maxLines: 5,
                                decoration: const InputDecoration(
                                  labelText: 'Message',
                                  hintText:
                                      'Write something to share with the selected platform.',
                                ),
                              ),
                              const SizedBox(height: 10),
                              SwitchListTile.adaptive(
                                value: _isOpenBrowser,
                                contentPadding: EdgeInsets.zero,
                                title: const Text(
                                  'Open browser when app is missing',
                                ),
                                subtitle: const Text(
                                  'Useful for fallback testing across platforms.',
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    _isOpenBrowser = value;
                                  });
                                },
                              ),
                            ],
                          ),
                        );
                        final selectedMediaSection = _SectionCard(
                          title: 'Selected Media',
                          description:
                              'Your current selection is handled automatically as single or multiple share.',
                          child: Column(
                            children: [
                              _SelectionTile(
                                title: 'Current selection',
                                subtitle: _selectionSummary,
                                icon: _selectionIcon,
                                accent: const Color(0xFFCD6D2D),
                                actionLabel: 'Reset',
                                onAction:
                                    _selectedMediaPaths.isEmpty
                                        ? null
                                        : _clearSelectedMedia,
                                preview: _selectionPreview,
                              ),
                              const SizedBox(height: 14),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: OutlinedButton.icon(
                                  onPressed:
                                      _selectedMediaPaths.isEmpty
                                          ? null
                                          : _clearSelectedMedia,
                                  icon: const Icon(Icons.refresh_rounded),
                                  label: const Text('Reset All Picks'),
                                ),
                              ),
                            ],
                          ),
                        );

                        return Column(
                          children: [
                            if (isCompact) ...[
                              composeSection,
                              const SizedBox(height: 16),
                              selectedMediaSection,
                            ] else
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(flex: 3, child: composeSection),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    flex: 2,
                                    child: selectedMediaSection,
                                  ),
                                ],
                              ),
                            const SizedBox(height: 16),
                            _SectionCard(
                              title: 'Media Lab',
                              description:
                                  'Pick media once, then add more if you want to turn it into a multi-share set.',
                              child: Wrap(
                                spacing: 12,
                                runSpacing: 12,
                                children: [
                                  FilledButton.tonalIcon(
                                    onPressed:
                                        () => _openMediaPickerSheet(
                                          append: false,
                                        ),
                                    icon: const Icon(Icons.add_photo_alternate),
                                    label: const Text('Pick Media'),
                                  ),
                                  OutlinedButton.icon(
                                    onPressed:
                                        _selectedMediaPaths.isEmpty
                                            ? null
                                            : () => _openMediaPickerSheet(
                                              append: true,
                                            ),
                                    icon: const Icon(
                                      Icons.playlist_add_rounded,
                                    ),
                                    label: const Text('Add More'),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            _SectionCard(
                              title: 'Generic Share',
                              description:
                                  'These buttons use the main package API. If a multi-selection exists, the demo automatically uses the multiple-media method. Instagram can continue inside its own chooser flow after handoff.',
                              child: Wrap(
                                spacing: 12,
                                runSpacing: 12,
                                children:
                                    _platforms
                                        .map(
                                          (platform) => FilledButton.icon(
                                            onPressed:
                                                () => _sharePlatformAuto(
                                                  platform,
                                                ),
                                            icon: Icon(platform.icon),
                                            label: Text(
                                              'Share ${platform.name.capitalize}',
                                            ),
                                          ),
                                        )
                                        .toList(),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _basename(String path) => path.split(Platform.pathSeparator).last;
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({
    required this.title,
    required this.subtitle,
    required this.badges,
  });

  final String title;
  final String subtitle;
  final List<Widget> badges;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1F3B73), Color(0xFFB84C2A), Color(0xFFE99C52)],
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x261E3557),
            blurRadius: 28,
            offset: Offset(0, 16),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.headlineMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.8,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            subtitle,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: const Color(0xFFF8F0E8),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 18),
          Wrap(spacing: 10, runSpacing: 10, children: badges),
        ],
      ),
    );
  }
}

class _InfoBadge extends StatelessWidget {
  const _InfoBadge({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0x26FFFFFF),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0x40FFFFFF)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: Colors.white),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.description,
    required this.child,
  });

  final String title;
  final String description;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFDFBF8),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE5D8CA)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 14,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            description,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF665B54),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 18),
          child,
        ],
      ),
    );
  }
}

class _SelectionTile extends StatelessWidget {
  const _SelectionTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accent,
    this.preview,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color accent;
  final Widget? preview;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.09),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: accent.withValues(alpha: 0.22)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: accent),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              if (actionLabel != null)
                TextButton(onPressed: onAction, child: Text(actionLabel!)),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            subtitle,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodyMedium?.copyWith(height: 1.35),
          ),
          if (preview != null) ...[const SizedBox(height: 12), preview!],
        ],
      ),
    );
  }
}

class _MediaPreviewCard extends StatelessWidget {
  const _MediaPreviewCard({
    required this.path,
    required this.isVideo,
    required this.label,
    required this.compact,
  });

  final String path;
  final bool isVideo;
  final String label;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: compact ? 96 : double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0x1A000000)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: compact ? 84 : 168,
            width: double.infinity,
            child:
                isVideo
                    ? _VideoPreviewPlaceholder(compact: compact)
                    : _ImagePreview(path: path),
          ),
          Container(
            width: double.infinity,
            color: const Color(0xFFFDFBF8),
            padding: EdgeInsets.symmetric(
              horizontal: compact ? 8 : 12,
              vertical: compact ? 8 : 10,
            ),
            child: Text(
              label,
              maxLines: compact ? 2 : 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: const Color(0xFF5C524C),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ImagePreview extends StatelessWidget {
  const _ImagePreview({required this.path});

  final String path;

  @override
  Widget build(BuildContext context) {
    return Image.file(
      File(path),
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return const ColoredBox(
          color: Color(0xFFF1E7DE),
          child: Center(
            child: Icon(
              Icons.broken_image_outlined,
              color: Color(0xFF8C7E73),
              size: 28,
            ),
          ),
        );
      },
    );
  }
}

class _VideoPreviewPlaceholder extends StatelessWidget {
  const _VideoPreviewPlaceholder({required this.compact});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF312F4A), Color(0xFF5B4B7B), Color(0xFF8C5E5B)],
        ),
      ),
      child: Center(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: compact ? 10 : 14,
            vertical: compact ? 8 : 10,
          ),
          decoration: BoxDecoration(
            color: const Color(0x2BFFFFFF),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: const Color(0x33FFFFFF)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.play_circle_fill_rounded,
                color: Colors.white,
                size: compact ? 18 : 22,
              ),
              SizedBox(width: compact ? 6 : 8),
              Text(
                'Video',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: compact ? 12 : 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

extension StringExtension on String {
  String get capitalize => "${this[0].toUpperCase()}${substring(1)}";
}

extension on SocialPlatform {
  IconData get icon {
    switch (this) {
      case SocialPlatform.facebook:
        return Icons.facebook_rounded;
      case SocialPlatform.linkedin:
        return Icons.work_outline_rounded;
      case SocialPlatform.reddit:
        return Icons.forum_outlined;
      case SocialPlatform.twitter:
        return Icons.alternate_email_rounded;
      case SocialPlatform.whatsapp:
        return Icons.chat_outlined;
      case SocialPlatform.telegram:
        return Icons.send_outlined;
      case SocialPlatform.instagram:
        return Icons.camera_alt_outlined;
    }
  }
}
