import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cpsc5250hw/leaderboard.dart';
import 'package:go_router/go_router.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({super.key});

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Theme.of(context).primaryColor,
          title: Center(
              child: Text(AppLocalizations.of(context)!.leaderboard ,style: TextStyle(color: Theme.of(context).colorScheme.onPrimary, fontSize: 20),
              )
          )
      ),
      body: ListView(
        children: const[
          SizedBox(height: 1200, child: Leaderboard())
        ],
      ),
      bottomNavigationBar: BottomAppBar(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: OverflowBar(
              overflowAlignment: OverflowBarAlignment.center,
              alignment: MainAxisAlignment.center,
              overflowSpacing: 5.0,
              children: [
                TextButton(onPressed: ()=> GoRouter.of(context).push("/workout"), child: Text(AppLocalizations.of(context)!.workRecordPage)),
                TextButton(onPressed: ()=> GoRouter.of(context).push("/emotion"), child: Text(AppLocalizations.of(context)!.emotionRecordPage)),
                TextButton(onPressed: ()=> GoRouter.of(context).push("/diet"), child: Text(AppLocalizations.of(context)!.dietRecordPage))
              ],
            ),
          )
      ),
    );
  }
}
