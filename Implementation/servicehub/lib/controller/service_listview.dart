import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:servicehub/model/services/services.dart';
import 'package:servicehub/view/result_search_view.dart';

class DevListView extends StatefulWidget {
  const DevListView({super.key});

  @override
  State<DevListView> createState() => _DevListViewState();
}

class _DevListViewState extends State<DevListView> {
  // int selectedIndex = -1;

  Widget serviceWidget(int index, String name, String imageName) {
    return Padding(
      padding: const EdgeInsets.only(right: 10, bottom: 10, left: 10),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: ((context) => ResultSearchView(
                        serviceType: name,
                      ))));
        },
        child: Container(
          height: 145,
          width: 135,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    blurRadius: 5,
                    offset: Offset(0, 5))
              ]),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 105,
                width: 135,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15))),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15)),
                  child: Image.asset(
                    imageName,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 3),
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: SizedBox(
                  //   height: 40,
                  //   width: 85,
                  child: Text(
                    name,
                    maxLines: 2,
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.clip,
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Services services = Services();

    return Container(
      height: 160,
      decoration: BoxDecoration(color: Colors.transparent),
      child: FutureBuilder<List<DocumentSnapshot>>(
          future: services.getServiceTypesDocs('Software Development'),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<DocumentSnapshot> serviceTypes = snapshot.data!;

              return ListView.builder(
                  // shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: serviceTypes.length,
                  itemBuilder: (BuildContext context, int index) {
                    DocumentSnapshot serviceType = serviceTypes[index];
                    String name = serviceType['name'];
                    String imageName = serviceType['image'];
                    return serviceWidget(index, name, imageName);
                  });
            } else if (snapshot.hasError) {
              return Text('Erreur: ${snapshot.error}');
            } else {
              return Container(
                  height: 20, width: 20, child: CircularProgressIndicator());
            }
          }),
    );
  }
}

class InfographyListView extends StatefulWidget {
  const InfographyListView({super.key});

  @override
  State<InfographyListView> createState() => _InfographyListViewState();
}

class _InfographyListViewState extends State<InfographyListView> {
  int selectedIndex = -1;

  Widget serviceWidget(int index, String name, String imageName) {
    return Padding(
      padding: const EdgeInsets.only(right: 10, bottom: 10, left: 10),
      child: Container(
        height: 145,
        width: 135,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  blurRadius: 5,
                  offset: Offset(0, 5))
            ]),
        child: InkWell(
          onTap: () {
            setState(() {
              selectedIndex = index;
            });
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 105,
                width: 135,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15))),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15)),
                  child: Image.asset(
                    imageName,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: SizedBox(
                  //   height: 40,
                  //   width: 85,
                  child: Text(
                    name,
                    maxLines: 2,
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.clip,
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Services services = Services();

    return Container(
      height: 160,
      decoration: BoxDecoration(color: Colors.transparent),
      child: FutureBuilder<List<DocumentSnapshot>>(
          future: services.getServiceTypesDocs('UI & UX Design'),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<DocumentSnapshot> serviceTypes = snapshot.data!;
              return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: serviceTypes.length,
                  itemBuilder: (BuildContext context, int index) {
                    DocumentSnapshot serviceType = serviceTypes[index];
                    String name = serviceType['name'];
                    String imageName = serviceType['image'];
                    return serviceWidget(index, name, imageName);
                  });
            } else if (snapshot.hasError) {
              return Text('Erreur: ${snapshot.error}');
            } else {
              return Container(
                  height: 20, width: 20, child: CircularProgressIndicator());
            }
          }),
    );
  }
}

class DatabaseListView extends StatefulWidget {
  const DatabaseListView({super.key});

  @override
  State<DatabaseListView> createState() => _DatabaseListViewState();
}

class _DatabaseListViewState extends State<DatabaseListView> {
  int selectedIndex = -1;

  Widget serviceWidget(int index, String name, String imageName) {
    return Padding(
      padding: const EdgeInsets.only(right: 10, bottom: 10, left: 10),
      child: Container(
        height: 145,
        width: 135,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  blurRadius: 5,
                  offset: Offset(0, 5))
            ]),
        child: InkWell(
          onTap: () {
            setState(() {
              selectedIndex = index;
            });
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 105,
                width: 135,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15))),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15)),
                  child: Image.asset(
                    imageName,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: SizedBox(
                  //   height: 40,
                  //   width: 85,
                  child: Text(
                    name,
                    maxLines: 2,
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.clip,
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Services services = Services();

    return Container(
      height: 160,
      decoration: BoxDecoration(color: Colors.transparent),
      child: FutureBuilder<List<DocumentSnapshot>>(
          future: services.getServiceTypesDocs('Database Management'),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<DocumentSnapshot> serviceTypes = snapshot.data!;
              return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: serviceTypes.length,
                  itemBuilder: (BuildContext context, int index) {
                    DocumentSnapshot serviceType = serviceTypes[index];
                    String name = serviceType['name'];
                    String imageName = serviceType['image'];
                    return serviceWidget(index, name, imageName);
                  });
            } else if (snapshot.hasError) {
              return Text('Erreur: ${snapshot.error}');
            } else {
              return Container(
                  height: 20, width: 20, child: CircularProgressIndicator());
            }
          }),
    );
  }
}
