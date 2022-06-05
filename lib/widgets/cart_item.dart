import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart/cart.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String title;

  final double price;
  final int quantity;

  final String productKey;

  const CartItem({
    Key? key,
    required this.id,
    required this.title,
    required this.price,
    required this.productKey,
    required this.quantity,
  }) : super(key: key);

  void handleDismissed(
    BuildContext context,
    DismissDirection direction,
    String id,
  ) {
    final cartContainer = Provider.of<Cart>(context, listen: false);
    cartContainer.removeItem(id);
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) =>
          handleDismissed(context, direction, productKey),
      background: Container(
        color: Theme.of(context).colorScheme.error,
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 30.0,
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20.0),
        margin: const EdgeInsets.symmetric(
          horizontal: 15.0,
          vertical: 4.0,
        ),
      ),
      child: buildCart(),
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) {
            return buildConfirmAlertDialog(ctx);
          },
        );
      },
    );
  }

  AlertDialog buildConfirmAlertDialog(BuildContext ctx) {
    return AlertDialog(
      title: const Text('Are you sure?'),
      content: const Text('Do you want to remove the item from the cart?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(ctx).pop(true);
          },
          child: const Text('Yes'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(ctx).pop(false);
          },
          child: const Text('No'),
        ),
      ],
    );
  }

  Card buildCart() {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 15.0,
        vertical: 4.0,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          leading: CircleAvatar(
            child: FittedBox(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Text('\$$price'),
              ),
            ),
          ),
          title: Text(title),
          subtitle: Text(' Total: \$${(price * quantity)}'),
          trailing: Text('$quantity x'),
        ),
      ),
    );
  }
}
