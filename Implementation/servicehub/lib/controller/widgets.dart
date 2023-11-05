import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:servicehub/view/explore_screen.dart';
import 'package:servicehub/view/home_screen.dart';
import 'package:servicehub/view/search_screen.dart';

class SearchBarItem extends StatelessWidget {
  const SearchBarItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 30),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.grey.shade300),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade300,
                blurRadius: 2,
              )
            ]),
        child: Padding(
          padding: EdgeInsets.only(top: 5),
          child: InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: ((context) => SearchScreen())));
            },
            child: TextField(
              style: TextStyle(fontSize: 13),
              decoration: InputDecoration(
                  hintText: 'Search Categories',
                  hintStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey.shade400,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey.shade400,
                  ),
                  border: InputBorder.none),
            ),
          ),
        ),
      ),
    );
  }
}

class BottomBar extends StatefulWidget {
  final int initialIndex;

  const BottomBar({super.key, required this.initialIndex});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  late int currentPageIndex = 0;
  // List<IconData> listOfIcons = [
  //   Icons.home_rounded,
  //   FontAwesomeIcons.envelope,
  //   Icons.manage_search,
  //   Icons.cases_rounded,
  //   Icons.person_rounded
  // ];

  @override
  void initState() {
    currentPageIndex = widget.initialIndex;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
        // backgroundColor: Colors.white,
        indicatorColor: Colors.transparent,
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
            switch (currentPageIndex) {
              case 0:
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const HomeScreen()));
                break;
              case 1:
                print('Inbox');
                break;
              case 2:
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ExploreScreen()));
                break;
              case 3:
                print('Orders');
                break;
              case 4:
                print('Account');
                break;
              default:
                print('Home Screen');
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => const HomeScreen()));
                break;
            }
          });
        },
        selectedIndex: currentPageIndex,
        destinations: <Widget>[
          AnimatedContainer(
            duration: Duration(seconds: 1),
            curve: Curves.fastLinearToSlowEaseIn,
            height: 50,
            width: 60,
            decoration: BoxDecoration(
              color: currentPageIndex == 0
                  ? Color(0xFFC84457).withOpacity(.2)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: NavigationDestination(
                selectedIcon: Icon(
                  Icons.home_rounded,
                  color: Color(0xFFC84457),
                  size: 33,
                ),
                icon: Icon(Icons.home_rounded, size: 33),
                label: 'Home'),
          ),
          AnimatedContainer(
            duration: Duration(seconds: 1),
            curve: Curves.fastLinearToSlowEaseIn,
            height: 50,
            width: 60,
            decoration: BoxDecoration(
              color: currentPageIndex == 1
                  ? Color(0xFFC84457).withOpacity(.2)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: NavigationDestination(
                selectedIcon: Icon(
                  FontAwesomeIcons.envelope,
                  color: Color(0xFFC84457),
                ),
                icon: Icon(FontAwesomeIcons.envelope),
                label: 'InBox'),
          ),
          AnimatedContainer(
            duration: Duration(seconds: 1),
            curve: Curves.fastLinearToSlowEaseIn,
            height: 50,
            width: 60,
            decoration: BoxDecoration(
              color: currentPageIndex == 2
                  ? Color(0xFFC84457).withOpacity(.2)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: NavigationDestination(
                selectedIcon: Icon(
                  Icons.manage_search,
                  color: Color(0xFFC84457),
                  size: 35,
                ),
                icon: Icon(
                  Icons.manage_search,
                  size: 35,
                ),
                label: 'Explore'),
          ),
          AnimatedContainer(
            duration: Duration(seconds: 1),
            curve: Curves.fastLinearToSlowEaseIn,
            height: 50,
            width: 60,
            decoration: BoxDecoration(
              color: currentPageIndex == 3
                  ? Color(0xFFC84457).withOpacity(.2)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: NavigationDestination(
                selectedIcon: Icon(
                  Icons.cases_rounded,
                  color: Color(0xFFC84457),
                ),
                icon: Icon(Icons.cases_rounded),
                label: 'Orders'),
          ),
          AnimatedContainer(
            duration: Duration(seconds: 1),
            curve: Curves.fastLinearToSlowEaseIn,
            height: 50,
            width: 60,
            decoration: BoxDecoration(
              color: currentPageIndex == 4
                  ? Color(0xFFC84457).withOpacity(.2)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: NavigationDestination(
                selectedIcon: Icon(Icons.person_rounded,
                    color: Color(0xFFC84457), size: 33),
                icon: Icon(Icons.person_rounded, size: 33),
                label: 'Account'),
          ),
        ]);
  }
}
