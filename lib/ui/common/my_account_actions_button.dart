import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../app/app.dart';

class MyAccountActionsButton extends StatelessWidget {
  const MyAccountActionsButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      tooltip: 'My account',
      offset: const Offset(0.0, kToolbarHeight),
      onSelected: (value) async {
        switch (value) {
          case 'Sign out':
            await context.read<AuthenticationService>().signOut();
            break;
          default:
            break;
        }
      },
      itemBuilder: (_) {
        return <PopupMenuItem<String>>[
          const PopupMenuItem(value: 'Sign out', child: Text('Sign out')),
        ];
      },
      child: Builder(builder: (context) {
        final user = context.read<MyAccountService>().myAccount;

        if (user != null) {
          return Row(children: [
            if (user.imageUrl != null)
              CircleAvatar(
                backgroundImage:
                    CachedNetworkImageProvider(user.imageUrl.toString()),
              )
            else
              const CircleAvatar(child: Icon(Icons.person)),
            const SizedBox(width: 8),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2!
                      .apply(fontWeightDelta: 1),
                ),
                Text(
                  user.email,
                  style: Theme.of(context).textTheme.caption,
                ),
              ],
            ),
          ]);
        }
        return const SizedBox.shrink();
      }),
    );
  }
}
