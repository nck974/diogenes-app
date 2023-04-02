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
}
