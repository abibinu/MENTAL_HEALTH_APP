import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class RelaxationGamePage extends StatefulWidget {
  @override
  _RelaxationGamePageState createState() => _RelaxationGamePageState();
}

class _RelaxationGamePageState extends State<RelaxationGamePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isGameActive = true;
  String _feedback = "";

  // Define the target scale for "ideal" size.
  final double _targetScale = 1.0;

  @override
  void initState() {
    super.initState();
    // Initialize the animation controller (3 seconds cycle)
    _controller = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    );

    // Define an animation that goes from 0.5 to 1.5 (scale factors)
    _animation = Tween<double>(begin: 0.5, end: 1.5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Start the animation loop (expanding then contracting)
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Called when the circle is tapped
  void _onTap() {
    if (!_isGameActive) return;

    // Stop the animation to capture the current scale value
    _controller.stop();
    setState(() {
      _isGameActive = false;
    });

    double currentScale = _animation.value;
    double deviation = (currentScale - _targetScale).abs();

    // Provide feedback based on how close the current scale is to the target scale
    setState(() {
      if (deviation < 0.1) {
        _feedback = "Perfect timing!";
      } else if (deviation < 0.3) {
        _feedback = "Good job, try a bit better next time.";
      } else {
        _feedback = "Keep practicing!";
      }
    });
  }

  Future<void> _openMoreGames(BuildContext context) async {
    // Replace the URL below with the actual URL where your relaxation games are hosted.
    final Uri url = Uri.parse(
        'https://www.silvergames.com/en/t/relaxing?utm_source=chatgpt.com');

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      // If the URL cannot be opened, show a message.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Could not open the games page.")),
      );
    }
  }

  // Reset the game to play again
  void _resetGame() {
    setState(() {
      _feedback = "";
      _isGameActive = true;
    });
    _controller.repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Relaxation Game: Calm Tap'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Tap the circle when it is closest to its ideal size!",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 30),
            // Animated circle using AnimatedBuilder and GestureDetector
            GestureDetector(
              onTap: _onTap,
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _animation.value,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.greenAccent,
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 30),
            Text(
              _feedback,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _resetGame,
              child: Text("Restart Game"),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => _openMoreGames(context),
              child: Text("More Games"),
            ),
          ],
        ),
      ),
    );
  }
}
