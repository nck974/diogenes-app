import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:diogenes/main.dart' as app;

import 'robots/add_item_robot.dart';
import 'robots/inventory_robot.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    testWidgets('Add item', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      InventoryRobot inventoryRobot = InventoryRobot(tester);
      AddItemRobot addItemRobot = AddItemRobot(tester);

      await inventoryRobot.openAddItem();

      await addItemRobot.enterItemName("TestName");
      await addItemRobot.enterItemDescription("TestDescription");
      await addItemRobot.enterItemNumber("33");
      await addItemRobot.saveItem();

      await inventoryRobot.checkFirstItem("TestName");
    });
  });
}
