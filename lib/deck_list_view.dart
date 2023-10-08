import 'package:flutter/material.dart';
import 'card_view_control.dart';
import 'deck_insert_dialog.dart';
import 'deck_update_dialog.dart';
import 'deck_delete_dialog.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'riverpod/decks_state.dart';

class DeckListView extends ConsumerStatefulWidget {
  const DeckListView({super.key});
  @override
  DeckListViewState createState() => DeckListViewState();
}

class DeckListViewState extends ConsumerState<DeckListView> {
  @override
  Widget build(BuildContext context) {
    final decksStream = ref.watch(decksStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI暗記カード (Demo版)'),
      ),
      body: Center(
        child: _asyncDeckList(decksStream),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showInsertDeckDialog(context),
        icon: const Icon(Icons.style),
        label: const Text('デッキ作成'),
      ),
    );
  }

  Widget _asyncDeckList(AsyncValue decksStream) {
    return decksStream.when(
      data: (decks) => _deckList(decks),
      loading: () => const CircularProgressIndicator(),
      error: (error, stackTrace) => Text('error: $error'),
    );
  }

  Widget _deckList(List decks) {
    return ListView.builder(
      itemCount: decks.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: const Icon(Icons.style),
          title: Text(decks[index].title),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CardViewControl(
                  deckName: decks[index].title,
                ),
              ),
            );
          },
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _updateDeckButton(decks[index].id, decks[index].title),
              _deleteDeckButton(decks[index].id, decks[index].title),
            ],
          ),
        );
      },
    );
  }

  Widget _updateDeckButton(int id, String title) {
    final decksDatabase = ref.watch(decksDatabaseProvider);
    return IconButton(
      icon: const Icon(Icons.edit),
      onPressed: () async {
        final result = await _showUpdateDeckDialog(title);
        if (result == null) return;
        await decksDatabase.updateDeck(id, result);
      },
    );
  }

  Widget _deleteDeckButton(int id, String title) {
    final decksDatabase = ref.watch(decksDatabaseProvider);
    return IconButton(
      icon: const Icon(Icons.delete),
      onPressed: () async {
        final result = await _showDeleteDeckDialog(title);
        if (!result) return;
        await decksDatabase.deleteDeck(id);
      },
    );
  }

  void _showInsertDeckDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const DeckInsertDialog();
      },
    );
  }

  Future<String?> _showUpdateDeckDialog(String title) async {
    String? result = await showDialog(
      context: context,
      builder: (BuildContext context) => DeckUpdateDialog(title: title),
    );
    return result;
  }

  Future<bool> _showDeleteDeckDialog(String title) async {
    bool result = await showDialog(
      context: context,
      builder: (BuildContext context) => DeckDeleteDialog(title: title),
    );
    return result;
  }
}
