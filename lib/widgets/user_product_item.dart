import 'package:flutter/material.dart';

class UserProductItem extends StatelessWidget {
  final String productId;
  final String productTitle;
  final String productImage;

  const UserProductItem({
    Key? key,
    required this.productId,
    required this.productTitle,
    required this.productImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      title: Text(productTitle),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(productImage),
      ),
      trailing: Container(
        width: 100.0,
        child: Row(
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.edit),
              color: theme.colorScheme.primary,
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.delete),
              color: theme.colorScheme.error,
            ),
          ],
        ),
      ),
    );
  }
}
