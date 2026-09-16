import 'package:flutter/material.dart';

import '../services/location_service.dart';
import '../services/user_service.dart';
import 'chats_screen.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() =>
      _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  Future<List<Map<String, dynamic>>>? _nearbyFuture;

  bool _scanning = false;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  Future<void> _scan() async {
    if (_scanning) return;

    setState(() {
      _scanning = true;
    });

    try {
      final position =
          await LocationService.instance
              .publishCurrentLocation();

      if (position == null) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Location permission or location service is unavailable.',
            ),
          ),
        );

        return;
      }

      final future =
          UserService.instance.nearbyUsers(
        latitude: position.latitude,
        longitude: position.longitude,
        radiusKm: 10,
      );

      setState(() {
        _nearbyFuture = future;
      });

      await future;
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Radar scan failed. Please try again.',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _scanning = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFF07030F);
    const pink = Color(0xFFFF2E93);
    const purple = Color(0xFF7C3AED);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'ZONE RADAR',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Scan',
            onPressed: _scanning ? null : _scan,
            icon: const Icon(
              Icons.radar_rounded,
              color: pink,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          SizedBox(
            height: 270,
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  _RadarRing(size: 245, opacity: .12),
                  _RadarRing(size: 190, opacity: .18),
                  _RadarRing(size: 135, opacity: .25),
                  RotationTransition(
                    turns: _animationController,
                    child: Container(
                      width: 245,
                      height: 245,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: SweepGradient(
                          colors: [
                            Colors.transparent,
                            pink.withOpacity(.28),
                            purple.withOpacity(.12),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 62,
                    height: 62,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: pink.withOpacity(.12),
                      border: Border.all(
                        color: pink.withOpacity(.55),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: pink.withOpacity(.35),
                          blurRadius: 28,
                          spreadRadius: 3,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.radar_rounded,
                      color: pink,
                      size: 32,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: Row(
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Nearby Friends',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        'Results are filtered securely on the server.',
                        style: TextStyle(
                          color: Colors.white38,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                FilledButton.icon(
                  onPressed: _scanning ? null : _scan,
                  icon: _scanning
                      ? const SizedBox(
                          width: 15,
                          height: 15,
                          child:
                              CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(
                          Icons.bolt_rounded,
                        ),
                  label: Text(
                    _scanning ? 'Scanning' : 'Scan',
                  ),
                  style: FilledButton.styleFrom(
                    backgroundColor: pink,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: _nearbyFuture == null
                ? const _RadarEmpty()
                : FutureBuilder<
                    List<Map<String, dynamic>>>(
                    future: _nearbyFuture,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const _RadarError();
                      }

                      if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: pink,
                          ),
                        );
                      }

                      final users =
                          snapshot.data ?? const [];

                      if (users.isEmpty) {
                        return const _RadarEmpty(
                          scanned: true,
                        );
                      }

                      return ListView.builder(
                        padding: const EdgeInsets.fromLTRB(
                          16,
                          4,
                          16,
                          20,
                        ),
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          final user = users[index];

                          final name =
                              (user['display_name'] ??
                                      'Friends Zone User')
                                  .toString();

                          final bio =
                              (user['bio'] ?? '')
                                  .toString();

                          final avatar =
                              (user['avatar_url'] ?? '')
                                  .toString();

                          final distance =
                              (user['distance_km'] as num?)
                                  ?.toDouble();

                          final online =
                              user['is_online'] == true;

                          return Container(
                            margin: const EdgeInsets.only(
                              bottom: 10,
                            ),
                            padding:
                                const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white
                                  .withOpacity(.045),
                              borderRadius:
                                  BorderRadius.circular(18),
                              border: Border.all(
                                color: pink.withOpacity(.12),
                              ),
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 27,
                                  backgroundColor: pink,
                                  backgroundImage:
                                      avatar.isNotEmpty
                                          ? NetworkImage(
                                              avatar,
                                            )
                                          : null,
                                  child: avatar.isEmpty
                                      ? Text(
                                          name.isEmpty
                                              ? '?'
                                              : name[0]
                                                  .toUpperCase(),
                                          style:
                                              const TextStyle(
                                            color: Colors.white,
                                            fontWeight:
                                                FontWeight
                                                    .w800,
                                          ),
                                        )
                                      : null,
                                ),
                                const SizedBox(width: 13),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment
                                            .start,
                                    children: [
                                      Row(
                                        children: [
                                          Flexible(
                                            child: Text(
                                              name,
                                              maxLines: 1,
                                              overflow:
                                                  TextOverflow
                                                      .ellipsis,
                                              style:
                                                  const TextStyle(
                                                color:
                                                    Colors.white,
                                                fontWeight:
                                                    FontWeight
                                                        .w800,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 7,
                                          ),
                                          Container(
                                            width: 7,
                                            height: 7,
                                            decoration:
                                                BoxDecoration(
                                              color: online
                                                  ? Colors
                                                      .greenAccent
                                                  : Colors
                                                      .white24,
                                              shape: BoxShape
                                                  .circle,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        bio.isEmpty
                                            ? 'Friends Zone member'
                                            : bio,
                                        maxLines: 1,
                                        overflow:
                                            TextOverflow
                                                .ellipsis,
                                        style:
                                            const TextStyle(
                                          color:
                                              Colors.white38,
                                          fontSize: 11,
                                        ),
                                      ),
                                      if (distance != null)
                                        Padding(
                                          padding:
                                              const EdgeInsets
                                                  .only(
                                            top: 4,
                                          ),
                                          child: Text(
                                            '${distance.toStringAsFixed(2)} km away',
                                            style:
                                                const TextStyle(
                                              color: pink,
                                              fontSize: 11,
                                              fontWeight:
                                                  FontWeight
                                                      .w600,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  tooltip: 'Message',
                                  onPressed: () {
                                    Navigator.of(context)
                                        .push(
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            ChatScreen(
                                          userName: name,
                                          otherUid:
                                              user['id']
                                                  .toString(),
                                          avatarUrl: avatar,
                                        ),
                                      ),
                                    );
                                  },
                                  icon: const Icon(
                                    Icons
                                        .chat_bubble_outline_rounded,
                                    color: pink,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

class _RadarRing extends StatelessWidget {
  final double size;
  final double opacity;

  const _RadarRing({
    required this.size,
    required this.opacity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: const Color(0xFFFF2E93)
              .withOpacity(opacity),
        ),
      ),
    );
  }
}

class _RadarEmpty extends StatelessWidget {
  final bool scanned;

  const _RadarEmpty({
    this.scanned = false,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Text(
          scanned
              ? 'No visible Friends Zone users found nearby.'
              : 'Tap Scan to discover people around you.',
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white38,
            height: 1.5,
          ),
        ),
      ),
    );
  }
}

class _RadarError extends StatelessWidget {
  const _RadarError();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(30),
        child: Text(
          'Radar could not load nearby users.\nPlease scan again.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white38,
            height: 1.5,
          ),
        ),
      ),
    );
  }
}
