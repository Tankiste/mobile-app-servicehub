import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:servicehub/controller/widgets.dart';
import 'package:provider/provider.dart';
import 'package:servicehub/model/app_state.dart';
import 'package:servicehub/model/orders/orders.dart';
import 'package:servicehub/view/home_supplier.dart';

class ManageOrderView extends StatefulWidget {
  final orderId;
  final image;
  final serviceName;
  final clientName;
  final price;
  final delivaryDate;
  final completion;
  const ManageOrderView(
      {super.key,
      this.orderId,
      this.image,
      this.serviceName,
      this.clientName,
      this.price,
      this.delivaryDate,
      this.completion});

  @override
  State<ManageOrderView> createState() => _ManageOrderViewState();
}

class _ManageOrderViewState extends State<ManageOrderView> {
  TextEditingController _completionController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    updateData();
    _completionController.text = widget.completion.toString();
    super.initState();
  }

  updateData() async {
    ApplicationState appState = Provider.of(context, listen: false);
    await appState.refreshUser();
  }

  @override
  Widget build(BuildContext context) {
    List<String> splitByComma = widget.delivaryDate.split(', ');
    String dayAndMonth = splitByComma[1];
    String year = splitByComma[2];
    String date = dayAndMonth + ', ' + year;

    void updateCompletion() async {
      setState(() {
        isLoading = true;
      });
      String resp = await ManageOrders().updateCompletion(
          widget.orderId, int.parse(_completionController.text));

      if (resp == 'success') {
        await Fluttertoast.showToast(
          msg: "Percentage completion updated successfully !",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Color(0xFFC84457),
          fontSize: 16.0,
        );
        Navigator.push(
            context, MaterialPageRoute(builder: ((context) => HomeSupplier())));
      }
      setState(() {
        isLoading = false;
      });
    }

    return Scaffold(
      appBar: CustomAppbar(
        text: 'Manage Orders',
        showFilter: false,
        returnButton: true,
        showText: false,
        actionText: '',
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.only(left: 25, top: 25, right: 25),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                                color: Colors.grey,
                                blurRadius: 15,
                                offset: Offset(0, 5))
                          ]),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                height: 130,
                                width: 140,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: widget.image != null
                                      ? Image.network(widget.image,
                                          fit: BoxFit.cover, loadingBuilder:
                                              (BuildContext context,
                                                  Widget child,
                                                  ImageChunkEvent?
                                                      loadingProgress) {
                                          if (loadingProgress == null)
                                            return child;
                                          return Center(
                                              child: CircularProgressIndicator(
                                            value: loadingProgress
                                                        .expectedTotalBytes !=
                                                    null
                                                ? loadingProgress
                                                        .cumulativeBytesLoaded /
                                                    loadingProgress
                                                        .expectedTotalBytes!
                                                : null,
                                          ));
                                        }, errorBuilder: (BuildContext context,
                                              Object exception,
                                              StackTrace? stackTrace) {
                                          return Icon(Icons.error);
                                        })
                                      : Image.asset(
                                          'assets/realite-virtuelle.png',
                                          fit: BoxFit.cover,
                                        ),
                                ),
                              ),
                              const SizedBox(width: 15),
                              SizedBox(
                                height: 60,
                                width: 133,
                                child: Text(
                                  widget.serviceName,
                                  maxLines: 2,
                                  textAlign: TextAlign.left,
                                  overflow: TextOverflow.clip,
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ), //
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Client',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  )),
                              Text(widget.clientName,
                                  style: GoogleFonts.roboto(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ))
                            ],
                          ),
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Price',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  )),
                              Text('XAF ${widget.price}',
                                  style: GoogleFonts.roboto(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey.shade400,
                                  ))
                            ],
                          ),
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Delivery Date',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  )),
                              Text(date,
                                  style: GoogleFonts.roboto(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey.shade400,
                                  ))
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('% Completion',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  )),
                              Container(
                                padding: EdgeInsets.zero,
                                alignment: Alignment.topCenter,
                                width: 50,
                                height: 20,
                                child: TextField(
                                  controller: _completionController,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                      suffixText: '%',
                                      suffixStyle: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey.shade400)),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 130,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          isLoading ? null : updateCompletion();
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFC84457),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            )),
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: 85, right: 85, top: 15, bottom: 15),
                          child: isLoading
                              ? CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white))
                              : Text(
                                  'Update Order',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Gilroy'),
                                ),
                        )),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 10,
              left: 15,
              right: 15,
              child: FloatingBar(),
            )
            // Positioned(
            //   bottom: 10,
            //   left: 15,
            //   right: 15,
            //   child: Container(
            //     padding: EdgeInsets.zero,
            //     margin: EdgeInsets.zero,
            //     height: 70,
            //     decoration: BoxDecoration(
            //       color: Colors.white,
            //       borderRadius: BorderRadius.circular(15),
            //       boxShadow: [
            //         BoxShadow(
            //             color: Colors.grey.shade400,
            //             blurRadius: 5,
            //             offset: Offset(0, 4))
            //       ],
            //     ),
            //     child: ClipRRect(
            //         borderRadius: BorderRadius.circular(15),
            //         child: BottomBar(initialIndex: 2)),
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
