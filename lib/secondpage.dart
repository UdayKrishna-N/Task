
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whiteboard/whiteboard.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:ui' as ui;

class SecondPage extends StatefulWidget {
  const SecondPage({Key? key, required this.color}) : super(key: key);

  final Color color;

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  WhiteBoardController controller = WhiteBoardController();

  int? selectedWidgetIndex;
  File? image;

  Future pickImage() async{
    try{
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if(image == null) return null;
      final imageTemporary = File(image.path);
      setState(() {
        this.image = imageTemporary;
      });
    } on PlatformException catch(e){
      var snackBar = SnackBar(
        content: Text(e as String),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {


    List<Widget> widgets = [
      WhiteBoard(
        controller: controller,
        strokeColor: widget.color,
        onConvertImage: (Uint8List data) async{
          ui.Image image = await decodeImageFromList(data);
          ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
          Uint8List pngBytes = byteData!.buffer.asUint8List();
          Directory directory = await getApplicationDocumentsDirectory();
          String filePath = '${directory.path}/whiteboard.png';
          File file = File(filePath);
          await file.writeAsBytes(pngBytes);
        },
      ),
      image == null ? Center(child: Text('No Image Choosen'),) : Image.file(image!,fit: BoxFit.fill,),
    ];

    return Scaffold(
      body: Center(
        child: Card(
          elevation: 10,
          shadowColor: widget.color,
          margin: EdgeInsets.symmetric(horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.7,
            decoration: BoxDecoration(
              color: widget.color,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                left: 15,
                right: 15,
                top: 20,
              ),
              child: Column(
                children: [
                  Expanded(
                    child: selectedWidgetIndex!= null ? widgets[selectedWidgetIndex!] : SizedBox(),
                  ),
                  SizedBox(
                    height: 100,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          PopupMenuButton(
                              icon: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Icon(
                                  Icons.add,
                                  size: 30,
                                  color: widget.color,
                                ),
                              ),
                              onSelected: (value){
                                if(value == 1) pickImage();
                                setState(() {
                                  selectedWidgetIndex = value;
                                });
                              },
                              itemBuilder: (context) {
                                return [
                                  PopupMenuItem(
                                    value: 0,
                                    child: Row(
                                      children: [
                                        Icon(Icons.edit),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text('White Board'),
                                      ],
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: 1,
                                    child: Row(
                                      children: [
                                        Icon(Icons.filter),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text('Choose Image'),
                                      ],
                                    ),
                                  ),
                                ];
                              }),
                          selectedWidgetIndex == 1
                              ? IconButton(
                            onPressed: () {
                              image = null;
                              setState(() {
                                selectedWidgetIndex = null;
                              });
                            },
                            icon: Icon(
                              Icons.close,
                              size: 30,
                              color: Colors.white,
                            ),
                          )
                              : SizedBox(),
                          selectedWidgetIndex == 0
                              ? IconButton(
                                  onPressed: () {
                                    controller.convertToImage();
                                    setState(() {
                                      selectedWidgetIndex = null;
                                    });
                                  },
                                  icon: Icon(
                                    Icons.save_rounded,
                                    size: 30,
                                    color: Colors.white,
                                  ),
                                )
                              : SizedBox(),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
