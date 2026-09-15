import 'package:flutter/material.dart';

class GroupRoomScreen extends StatefulWidget {
  const GroupRoomScreen({super.key});

  @override
  State<GroupRoomScreen> createState() => _GroupRoomScreenState();
}

class _GroupRoomScreenState extends State<GroupRoomScreen> {
  bool _isMicMuted = true;
  bool _isInOnlineCall = false;

  @override
  Widget build(BuildContext context) {
    const Color bgColor = Color(0xFF0F051D);
    const Color cardColor = Color(0xFF1A0B2E);
    const Color neonPink = Color(0xFFFF2E93);
    const Color goldColor = Color(0xFFFFD700);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        title: const Text(
          'Online Voice Lounge',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // অনলাইন স্ট্যাটাস ব্যানার
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: neonPink.withOpacity(0.4), width: 1.5),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _isInOnlineCall ? Colors.green.withOpacity(0.2) : neonPink.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _isInOnlineCall ? Icons.headset_mic : Icons.wifi_off,
                      color: _isInOnlineCall ? Colors.green : neonPink,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _isInOnlineCall ? 'Connected to Online Voice Room' : 'Offline / Disconnected',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _isInOnlineCall 
                              ? 'Voice chat is active with online players.' 
                              : 'Join an online match to start voice chat.',
                          style: const TextStyle(color: Colors.white60, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // স্পিকার বা প্লেয়ারদের গ্রিড (অনলাইন ভয়েস রুম মেম্বার)
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildParticipantCard('You (Host)', _isInOnlineCall && !_isMicMuted, neonPink),
                  _buildParticipantCard('Online Opponent', _isInOnlineCall, goldColor),
                ],
              ),
            ),

            // ভয়েস কন্ট্রোল বাটনসমূহ (শুধু অনলাইন মোডের জন্য)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // মাইক মিউট/আনমিউট বাটন
                  FloatingActionButton(
                    heroTag: 'micBtn',
                    backgroundColor: _isMicMuted ? Colors.redAccent : Colors.green,
                    onPressed: _isInOnlineCall ? () {
                      setState(() {
                        _isMicMuted = !_isMicMuted;
                      });
                    } : null,
                    child: Icon(
                      _isMicMuted ? Icons.mic_off : Icons.mic,
                      color: Colors.white,
                    ),
                  ),

                  // কল জয়েন বা লিভ করার বাটন
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isInOnlineCall ? Colors.red : neonPink,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    onPressed: () {
                      setState(() {
                        _isInOnlineCall = !_isInOnlineCall;
                        if (_isInOnlineCall) {
                          _isMicMuted = false; // অটো আনমিউট হবে
                        } else {
                          _isMicMuted = true;
                        }
                      });
                    },
                    icon: Icon(_isInOnlineCall ? Icons.call_end : Icons.phone),
                    label: Text(
                      _isInOnlineCall ? 'Leave Voice Room' : 'Join Online Voice',
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildParticipantCard(String name, bool isSpeaking, Color borderColor) {
    const Color cardColor = Color(0xFF1A0B2E);
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSpeaking ? Colors.green : borderColor.withOpacity(0.5), 
          width: isSpeaking ? 2 : 1.5,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              if (isSpeaking)
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.green.withOpacity(0.3),
                  ),
                ),
              const CircleAvatar(
                radius: 30,
                backgroundColor: Color(0xFF2E0854),
                child: Icon(Icons.person, color: Colors.white, size: 35),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            isSpeaking ? 'Speaking...' : 'Muted / Silent',
            style: TextStyle(
              color: isSpeaking ? Colors.greenAccent : Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
