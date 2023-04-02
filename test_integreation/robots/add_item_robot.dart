import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

class AddItemRobot {
  final WidgetTester driver;

  const AddItemRobot(this.driver);

  Future enterItemName(String name) async {
    final Finder fab = find.byKey(const Key('addItemNameTextField'));
    await driver.enterText(fab, name);
    await driver.pumpAndSettle();
  }

  Future enterItemDescription(String description) async {
    final Finder fab = find.byKey(const Key('addItemDescriptionTextField'));
    await driver.enterText(fab, description);
    await driver.pumpAndSettle();
  }

  Future enterItemNumber(String number) async {
    final Finder fab = find.byKey(const Key('addItemNumberTextField'));
    await driver.enterText(fab, number);
    await driver.pumpAndSettle();
  }

  Future saveItem() async {
    final Finder fab = find.byKey(const Key('addItemSaveButton'));
    await driver.tap(fab);
    await driver.pumpAndSettle();
  }
}
