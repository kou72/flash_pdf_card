import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'riverpod/decks_state.dart';

class DeckInsertDialog extends ConsumerStatefulWidget {
  const DeckInsertDialog({super.key});
  @override
  DeckInsertDialogState createState() => DeckInsertDialogState();
}

class DeckInsertDialogState extends ConsumerState<DeckInsertDialog> {
  String _deckName = "";

  @override
  Widget build(BuildContext context) {
    final decksDatabase = ref.watch(decksDatabaseProvider);

    return AlertDialog(
      title: const Text('デッキを作成', style: TextStyle(fontSize: 16)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            autofocus: true,
            decoration: const InputDecoration(labelText: 'デッキ名'),
            onChanged: (String value) {
              setState(() => _deckName = value);
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          child: const Text('キャンセル', style: TextStyle(color: Colors.blue)),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('作成', style: TextStyle(color: Colors.blue)),
          onPressed: () async {
            await decksDatabase.insertDeck(_deckName);
            if (!context.mounted) return;
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
