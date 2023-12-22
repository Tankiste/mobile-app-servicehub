import 'package:flutter/material.dart';

class RecentCollabSearchView extends StatefulWidget {
  const RecentCollabSearchView({super.key});

  @override
  State<RecentCollabSearchView> createState() => _RecentCollabSearchViewState();
}

class _RecentCollabSearchViewState extends State<RecentCollabSearchView> {
  int selectedIndex = -1;

  Widget serviceWidget(int index) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            setState(() {
              selectedIndex = index;
            });
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(shape: BoxShape.circle),
                  child: ClipOval(
                      child: Image.asset(
                    'assets/supplier.png',
                    fit: BoxFit.cover,
                  )),
                ),
                const SizedBox(width: 15),
                Text(
                  'Binho',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                )
              ],
            ),
          ),
        ),
        Divider(
          endIndent: 20,
          indent: 20,
          color: Colors.grey.shade200,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recently collaborated',
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500),
              ),
              TextButton(
                  onPressed: () {},
                  child: Text(
                    'Edit',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.red),
                  ))
            ],
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
          child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              physics: NeverScrollableScrollPhysics(),
              itemCount: 2,
              itemBuilder: (BuildContext context, int index) {
                return serviceWidget(index);
              }),
        ),
      ],
    );
  }
}
