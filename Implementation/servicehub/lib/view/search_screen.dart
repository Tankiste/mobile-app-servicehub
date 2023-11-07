import 'package:flutter/material.dart';
import 'package:servicehub/controller/recent_collab_search.dart';
import 'package:servicehub/controller/recent_order_search.dart';
import 'package:servicehub/view/explore_screen.dart';
// import 'package:servicehub/view/home_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;
  String selectedOption = 'Services';

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _animation = Tween<Offset>(
      begin: const Offset(0.0, 0.0),
      end: const Offset(0.0, 0.0),
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _updateSelectedOption(String option) {
    setState(() {
      selectedOption = option;
      if (option == 'Services') {
        _animation = Tween<Offset>(
          begin: const Offset(1.0, 0.0),
          end: const Offset(0.0, 0.0),
        ).animate(_controller);
      } else {
        _animation = Tween<Offset>(
          begin: const Offset(0.0, 0.0),
          end: const Offset(1.0, 0.0),
        ).animate(_controller);
      }
      _controller.forward(from: 0.0);
    });
  }

  Widget buildDivider() {
    return SlideTransition(
      position: _animation,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.5,
        child: Divider(
          height: 0,
          thickness: 2.0,
          color: const Color(0xFFC84457),
        ),
      ),
    );
  }

  Widget buildContent() {
    if (selectedOption == 'Services') {
      return RecentOrderSearchView(
        showText: true,
      );
    } else {
      return RecentCollabSearchView();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Padding(
          padding: const EdgeInsets.only(right: 15, top: 60),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ExploreScreen()));
                      },
                      icon: Icon(Icons.arrow_back_ios_new_rounded)),
                  const SizedBox(
                    width: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 30),
                    child: SizedBox(
                      height: 30,
                      width: 250,
                      child: TextFormField(
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                            hintText: 'Search a service...',
                            hintStyle: TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade400,
                            )),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () => _updateSelectedOption('Services'),
                    child: Text(
                      'Services',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: selectedOption == 'Services'
                            ? Color(0xFFC84457)
                            : Colors.grey.shade500,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => _updateSelectedOption('Suppliers'),
                    child: Text(
                      'Suppliers',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: selectedOption == 'Suppliers'
                            ? Color(0xFFC84457)
                            : Colors.grey.shade500,
                      ),
                    ),
                  ),
                ],
              ),
              buildDivider(),
              buildContent(),
            ],
          ),
        ),
      ),
    );
  }
}
