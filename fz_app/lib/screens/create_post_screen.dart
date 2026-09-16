import 'package:flutter/material.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  // পোস্টের ক্যাপশন বা টেক্সট কন্ট্রোলার
  final TextEditingController _postController = TextEditingController();
  
  // ডামি মিডিয়া স্টেট (ছবি বা ভিডিও যুক্ত আছে কিনা তা ট্র্যাক করার জন্য)
  String? _attachedMediaType; // 'image' অথবা 'video'
  bool _hasMedia = false;

  @override
  void dispose() {
    _postController.dispose();
    super.dispose();
  }

  // ছবি বা ভিডিও যুক্ত করার সিমুলেশন ফাংশন
  void _attachMedia(String type) {
    setState(() {
      _attachedMediaType = type;
      _hasMedia = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$type attached successfully! You can edit or change it.')),
    );
  }

  // মিডিয়া রিমোভ বা এডিট করার ফাংশন
  void _removeMedia() {
    setState(() {
      _hasMedia = false;
      _attachedMediaType = null;
    });
  }

  // পোস্ট সাবমিট করার ফাংশন
  void _submitPost() {
    if (_postController.text.trim().isEmpty && !_hasMedia) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please write something or attach media to post!')),
      );
      return;
    }

    // সফলভাবে পোস্ট ক্রিয়েট হওয়ার পর ফিডে ফিরে যাওয়ার লজিক
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Post created successfully!')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Post'),
        backgroundColor: Colors.grey[900],
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: _submitPost,
              child: const Text('Post', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ইউজারের তথ্য
            Row(
              children: const [
                CircleAvatar(
                  backgroundColor: Colors.deepPurple,
                  child: Icon(Icons.person, color: Colors.white),
                ),
                SizedBox(width: 12),
                Text(
                  'Biplob Hossain Billal',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // টেক্সট লেখার ফিল্ড
            TextField(
              controller: _postController,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: 'What is on your mind, Biplob?',
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
              ),
            ),
            const SizedBox(height: 16),

            // যদি কোনো ছবি বা ভিডিও যুক্ত করা হয়, তার প্রিভিউ বক্স এবং এডিট/রিমোভ অপশন
            if (_hasMedia)
              Stack(
                children: [
                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _attachedMediaType == 'image' ? Icons.image : Icons.videocam,
                            size: 50,
                            color: Colors.deepPurpleAccent,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Attached ${_attachedMediaType == 'image' ? 'Photo' : 'Video'} Preview',
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: CircleAvatar(
                      backgroundColor: Colors.black54,
                      child: IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: _removeMedia,
                        tooltip: 'Remove/Change Media',
                      ),
                    ),
                  ),
                ],
              ),

            const SizedBox(height: 24),
            const Divider(color: Colors.grey),
            const SizedBox(height: 8),

            // মিডিয়া যুক্ত করার অপশন বার (Photo / Video Add Buttons)
            const Text(
              'Add to your post',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: const BorderSide(color: Colors.deepPurple),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () => _attachMedia('image'),
                    icon: const Icon(Icons.photo, color: Colors.deepPurpleAccent),
                    label: const Text('Photo', style: TextStyle(color: Colors.white)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: const BorderSide(color: Colors.deepPurple),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () => _attachMedia('video'),
                    icon: const Icon(Icons.video_call, color: Colors.deepPurpleAccent),
                    label: const Text('Video', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
