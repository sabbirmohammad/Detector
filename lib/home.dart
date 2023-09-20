import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _loading = true;
  late File _image;
  late List _output;
  final picker = ImagePicker();
  List<String> expectedLabels = [
    'Corn Common Rust',
    'Corn Gray Leaf Spot',
    'Corn Healthy',
    'Corn Northern Leaf Blight'
  ];


  @override
  void initState() {
    super.initState();
    loadModel().then((value) {
      setState(() {

      });
    });
  }


  detectImage(File image) async {
    var output = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 4,
      threshold: 0.6,
      imageMean: 127.5,
      imageStd: 127.5,
    )as List<dynamic> ;
    setState(() {
      _output = output;
      _loading = false;
    });
  }

  checkOutput() {
    for (var i = 0; i < expectedLabels.length; i++) {
      if (_output[0]['label'].toString().toLowerCase() ==
          expectedLabels[i].toLowerCase()) {
        // Display the label and confidence score if it matches an expected label
        return;
      }
    }
    // Display an error message if none of the labels match the expected labels
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: const Text('Could not recognize the image'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  loadModel() async {
    await Tflite.loadModel(
      model: 'assets/corn.tflite',
      labels: 'assets/label.txt',
    );
  }

  @override
  void dispose() {

    super.dispose();
  }

  pickImage() async {
    var image = await picker.pickImage(source: ImageSource.camera);

    if (image == null) return null;

    setState(() {
      _image = File(image.path);
    });

    detectImage(_image);
  }

  pickGalleryImage() async {
    var image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) return null;


    setState(() {
      _image = File(image.path);
    });

    detectImage(_image);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 50),
            const Text('DETECTOR',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            const Text('Detect the world around you',
              style: TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 50),
            Center(
                child: _loading ? SizedBox(
                    width: 400,
                    child: Column(
                        children: <Widget>[
                          Image.asset('assets/logo.jpg'),
                          const SizedBox(height: 50),
                        ]
                    )
                ) : Container(
                    child: Column(
                        children: <Widget>[
                          Container(
                            height: 250,
                            child: Image.file(_image),
                          ),
                          const SizedBox(height: 20),
                          _output != null ? Text('${_output[0]['label']}',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ) : Container(
                              child: Column(
                                  children: <Widget>[
                                    Container(
                                      height: 250,
                                      child: Image.file(_image),
                                    )
                                  ]
                              )
                          ),
                          const SizedBox(height: 10),
                          _output != null ? Text(
                              '${_output[0]}',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20
                              )
                          ) : Container(),
                          const SizedBox(height: 10),
                        ]
                    )
                )
            ),
            Container(width: MediaQuery.of(context).size.width,
                child: Column(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          pickImage();
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width - 250,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 18),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text('Take Photo',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () {
                          pickGalleryImage();
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width - 250,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 18),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text('Select Photo',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ]
                )
            )
          ],
        ),
      ),
    );
  }
}