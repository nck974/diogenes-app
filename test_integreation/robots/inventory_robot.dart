import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:diogenes/src/widgets/item_list_tile.dart';

class InventoryRobot {
  final WidgetTester driver;

  const InventoryRobot(this.driver);

  Future openAddItem() async {
    final Finder fab = find.byKey(const Key('addItemButton'));
    await driver.tap(fab);
    await driver.pumpAndSettle();
  }

  Future checkFirstItem(String name) async {
    final inventory = find.byKey(const Key('inventoryList'));
    final itemListTile = find
        .descendant(of: inventory, matching: find.byType(ItemListTile))
        .first;
    final textWidget =
        find.descendant(of: itemListTile, matching: find.byType(Text)).first;
    expect((textWidget.evaluate().single.widget as Text).data, name);
    await driver.pumpAndSettle();
  }

  // Future enterPassword(String password) async {
  //   await driver.tap(find.byValueKey('passwordTextField'));
  //   await driver.enterText(password);
  // }

  // Future tapLoginButton() async {
  //   await driver.tap(find.text('Login'));
  //   await driver.tap(find.text('Login'));
  // }

  // Future checkInvalidCredentialsMessageIsShown() async {
  //   final errorMessageFinder = find.byValueKey('snackbar');
  //   await driver.waitFor(errorMessageFinder);
  // }

  // Future checkWelcomeMessageIsShown(String email) async {
  //   final welcomeMessageFinder = find.text('Welcome $email');
  //   await driver.waitFor(welcomeMessageFinder);
  //   test.expect(await driver.getText(welcomeMessageFinder), 'Welcome $email');
  // }
}
