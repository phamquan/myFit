import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({Key? key}) : super(key: key);

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("About")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text("My Fit", style: Theme.of(context).textTheme.headline5),
                    const SizedBox(height: 8),
                    Text("PHAM QUAN"),
                    const SizedBox(height: 4),
                    Text("quanp@devx.vn / mr.pquan@gmail.com"),
                    const SizedBox(height: 2),
                    Text("Version 0.1")
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
