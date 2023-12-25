import 'package:flash_pdf_card/riverpod/cards_state.dart';
import 'package:flash_pdf_card/type/types.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TestPlayView extends ConsumerStatefulWidget {
  final String deckName;
  final dynamic cards;
  const TestPlayView({super.key, required this.deckName, required this.cards});
  @override
  TestPlayViewState createState() => TestPlayViewState();
}

class TestPlayViewState extends ConsumerState<TestPlayView> {
  final _cardWidth = 400.0;
  final _cardHeight = 200.0;
  final _cardFontSize = 16.0;
  final _buttonWidth = 100.0;
  final _buttonHeight = 40.0;
  final _questionColor = Colors.blueGrey;
  final _answerColor = Colors.blueAccent;
  bool _isFlipped = true;
  bool _onNote = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.deckName),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _flashCard(),
            const SizedBox(height: 8),
            _noteButton(),
            const SizedBox(height: 48),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _correctButton(),
                _pendingButton(),
                _incorrectButton(),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _noteButton() {
    var buttonStyle = _onNote
        ? ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.grey[700]),
            foregroundColor: MaterialStateProperty.all(Colors.grey),
          )
        : null;

    return Container(
      padding: const EdgeInsets.only(left: 4, right: 4),
      width: _cardWidth,
      height: _buttonHeight,
      child: ElevatedButton(
        onPressed: () => setState(() => _onNote = !_onNote),
        style: buttonStyle,
        child: const Text('ノート'),
      ),
    );
  }

  Widget _correctButton() {
    final cardsDatabase = ref.watch(cardsDatabaseProvider);
    return Container(
      margin: const EdgeInsets.only(left: 4, right: 4),
      width: _buttonWidth,
      height: _buttonHeight,
      child: ElevatedButton(
        onPressed: () => {
          cardsDatabase.updateCardStatus(
            widget.cards[0].id,
            CardStatus.correct,
          ),
          print(widget.cards[0])
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.white),
          foregroundColor: MaterialStateProperty.all(Colors.green),
        ),
        child: const Icon(Icons.check),
      ),
    );
  }

  Widget _pendingButton() {
    final cardsDatabase = ref.watch(cardsDatabaseProvider);
    return Container(
      margin: const EdgeInsets.only(left: 4, right: 4),
      width: _buttonWidth,
      height: _buttonHeight,
      child: ElevatedButton(
        onPressed: () => {
          cardsDatabase.updateCardStatus(
            widget.cards[0].id,
            CardStatus.pending,
          ),
          print(widget.cards[0])
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.white),
          foregroundColor: MaterialStateProperty.all(Colors.amber),
        ),
        child: const Icon(Icons.change_history),
      ),
    );
  }

  Widget _incorrectButton() {
    final cardsDatabase = ref.watch(cardsDatabaseProvider);
    return Container(
      margin: const EdgeInsets.only(left: 4, right: 4),
      width: _buttonWidth,
      height: _buttonHeight,
      child: ElevatedButton(
        onPressed: () => {
          cardsDatabase.updateCardStatus(
            widget.cards[0].id,
            CardStatus.incorrect,
          ),
          print(widget.cards[0])
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.white),
          foregroundColor: MaterialStateProperty.all(Colors.red),
        ),
        child: const Icon(Icons.close),
      ),
    );
  }

  Widget _flashCard() {
    return SizedBox(
      width: _cardWidth,
      child: Card(
        child: InkWell(
          onTap: () {
            setState(() => _isFlipped = !_isFlipped);
          },
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: _cardHeight,
                maxHeight: _cardHeight,
              ),
              child: _flashCardText(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _flashCardText() {
    if (_isFlipped) {
      return Text(
        widget.cards[0].question,
        style: TextStyle(color: _questionColor, fontSize: _cardFontSize),
      );
    } else {
      return Text(
        widget.cards[0].answer,
        style: TextStyle(color: _answerColor, fontSize: _cardFontSize),
      );
    }
  }
}
