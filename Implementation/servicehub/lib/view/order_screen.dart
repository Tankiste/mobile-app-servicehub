import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:servicehub/controller/client_orders_listview.dart';
import 'package:servicehub/controller/widgets.dart';
import 'package:provider/provider.dart';
import 'package:servicehub/model/app_state.dart';
import 'package:servicehub/view/login.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  bool noOrder = false;

  @override
  void initState() {
    updateData();
    super.initState();
  }

  updateData() async {
    ApplicationState appState = Provider.of(context, listen: false);
    await appState.refreshUser();
  }

  @override
  Widget build(BuildContext context) {
    final appBar = CustomAppbar(
        text: 'Orders',
        showFilter: !noOrder,
        returnButton: false,
        showText: false,
        actionText: '');

    return Consumer<ApplicationState>(
      builder: (context, appState, _) {
        if (appState.getUser != null) {
          return buildOrderScreen(appBar: appBar, noOrder: noOrder);
        } else {
          return LoginPage();
        }
      },
    );
  }
}

class buildOrderScreen extends StatelessWidget {
  const buildOrderScreen({
    super.key,
    required this.appBar,
    required this.noOrder,
  });

  final CustomAppbar appBar;
  final bool noOrder;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: ClientOrdersListView(),
      ),
    );
  }
}
