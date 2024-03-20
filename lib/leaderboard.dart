import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:cpsc5250hw/recording_points_dao.dart';
import 'package:cpsc5250hw/points_record.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class Leaderboard extends StatelessWidget {
  const Leaderboard({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<PointsRecord>>(
      stream: context.read<PointsDao>().listenForAllPoints(),
      builder: (context, streamSnapshot) {
        if (streamSnapshot.hasError) {
          // return Text('Error: ${streamSnapshot.error}');
          return Scaffold(
            body: Center(
              child: Column(
                children: [
                  Text(AppLocalizations.of(context)!.signInToView),
                  TextButton(
                    style: TextButton.styleFrom(
                      textStyle: TextStyle(fontSize: 16),
                    ),
                    onPressed: ()=> GoRouter.of(context).push('/signIn'),
                    child: const Text('Sign In'),
                  ),
                ],
              )
            )
          );
        }
        switch (streamSnapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return const CircularProgressIndicator();
          default:
            if (streamSnapshot.hasData) {
              final queryResults = streamSnapshot.data!;
              return Scaffold(
                body: queryResults.isEmpty
                    ? const Text('No points record in the Firebase')
                    : ListView(
                  shrinkWrap: true,
                  children: queryResults.map<Widget>(
                          (doc) => ListTile(
                          title: Text(doc.name),
                          subtitle: Text(doc.points.toString()),
                      )
                  ).toList(),
                ),
              );
            } else {
              return const Text('No Data Available');
            }
        }
      },
    );
  }
}

