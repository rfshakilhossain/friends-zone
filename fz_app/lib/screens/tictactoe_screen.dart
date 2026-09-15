import 'package:flutter/material.dart';
import '../coin_referral_manager.dart';

class TicTacToeScreen extends StatefulWidget {
  const TicTacToeScreen({super.key});

  @override
  State<TicTacToeScreen> createState() => _TicTacToeScreenState();
}

class _TicTacToeScreenState extends State<TicTacToeScreen> {
  late List<String> _board;
  String _currentPlayer = 'X';
  bool _isGameOver = false;
  String _gameMessage = 'Player X Turn';
  int _currentCoins = 0;

  @override
  void initState() {
    super.initState();
    _resetGame();
    _loadUserCoins();
  }

  Future<void> _loadUserCoins() async {
    int coins = await CoinReferralManager.getCoins();
    setState(() {
      _currentCoins = coins;
    });
  }

  void _resetGame() {
    setState(() {
      _board = List.filled(9, '');
      _currentPlayer = 'X';
      _isGameOver = false;
      _gameMessage = 'Player X Turn';
    });
  }

  void _handleTap(int index) async {
    if (_board[index] != '' || _isGameOver) return;

    setState(() {
      _board[index] = _currentPlayer;
      if (_checkWinner(_currentPlayer)) {
        _isGameOver = true;
        _gameMessage = '🎉 Player $_currentPlayer Wins 50 FZ Tokens!';
        _rewardWinner();
      } else if (!_board.contains('')) {
        _isGameOver = true;
        _gameMessage = '🤝 It\'s a Draw!';
      } else {
        _currentPlayer = _currentPlayer == 'X' ? 'O' : 'X';
        _gameMessage = 'Player $_currentPlayer Turn';
      }
    });
  }

  Future<void> _rewardWinner() async {
    int newCoins = await CoinReferralManager.addCoins(50);
    setState(() {
      _currentCoins = newCoins;
    });
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('+50 FZ Tokens added to your wallet!'),
        backgroundColor: Color(0xFFFF2E93),
        duration: Duration(seconds: 2),
      ),
    );
  }

  bool _checkWinner(String player) {
    const winPatterns = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8], // Rows
      [0, 3, 6], [1, 4, 7], [2, 5, 8], // Columns
      [0, 4, 8], [2, 4, 6]              // Diagonals
    ];

    for (var pattern in winPatterns) {
      if (_board[pattern[0]] == player &&
          _board[pattern[1]] == player &&
          _board[pattern[2]] == player) {
        return true;
      }
    }
    return false;
  }

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
          'Tic-Tac-Toe Arena',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: goldColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: goldColor),
            ),
            child: Row(
              children: [
                const Icon(Icons.monetization_on, color: goldColor, size: 16),
                const SizedBox(width: 4),
                Text(
                  '$_currentCoins',
                  style: const TextStyle(color: goldColor, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _gameMessage,
              style: const TextStyle(
                color: neonPink,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: neonPink.withOpacity(0.5), width: 1.5),
              ),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: 9,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => _handleTap(index),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF2E0854),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white24),
                      ),
                      child: Center(
                        child: Text(
                          _board[index],
                          style: TextStyle(
                            color: _board[index] == 'X' ? neonPink : goldColor,
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: neonPink,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: _resetGame,
              icon: const Icon(Icons.refresh),
              label: const Text('Restart Game', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
