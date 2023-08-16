import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:text1/constants/routes.dart';
import 'package:text1/models/consumer.dart';
import 'package:text1/screens/expanded_image_view.dart';
import 'package:text1/services/auth.dart';
import 'package:text1/services/database.dart';
import 'package:http/http.dart' as http;

//enum for fields used for updating text onto text fields
enum SelectedTextField {
  none,
  shopName,
  vendorName,
  address,
  vendorCode,
}

SelectedTextField selectedTextField = SelectedTextField.none;

class TextInputScreen extends StatefulWidget {
  const TextInputScreen({super.key});

  @override
  TextInputScreenState createState() => TextInputScreenState();
}

class TextInputScreenState extends State<TextInputScreen> {
  //variables for storing field values
  String inputText = '';
  String inputAddress = '';
  String inputMobile = '';
  String inputName = '';
  String submitText = '';
  String submitAddress = '';
  String submitMobile = '';
  String submitName = '';
  //default font sizes
  double _fontSize = 38.0;
  double _fontAdd = 12.0;
  double _fontName = 26.0;
  double _fontPhone = 26.0;
  //text edit controllers for updating text onto text fields
  late TextEditingController _shopEditingController;
  late TextEditingController _addEditingController;
  late TextEditingController _nameEditingController;
  late TextEditingController _mobileEditingController;

  // initializing values for text edit controllers
  @override
  void initState() {
    super.initState();
    _shopEditingController = TextEditingController(text: inputText);
    _addEditingController = TextEditingController(text: inputAddress);
    _nameEditingController = TextEditingController(text: inputName);
    _mobileEditingController = TextEditingController(text: inputMobile);

  }
  //disposing text edit controllers
  @override
  void dispose() {
    _shopEditingController.dispose();
    _addEditingController.dispose();
    _nameEditingController.dispose();
    _mobileEditingController.dispose();

    super.dispose();
  }
  String? vendorCodeFontFamily;
  String? addressFontFamily;
  String? vendorNameFontFamily;
  String? shopNameFontFamily;

  //fonts list used
  List<String> fontFamilies = [
    'Roboto',
    'Poppins',
    'Open Sans',
    'Times New Roman',
    'Courier New',
    'Oswald',
    'Caprasimo',
  ];
  String? selectedFontFamily;

  //colors list user
  List <Color> colorOptions=[
  Colors.black,
  Colors.white,
  Colors.grey,
  Colors.red,
  Colors.green,
  Colors.blue,
  Colors.yellow,
  Colors.orange,
  ];

  //default positions
  double shopl = 60.0;
  double shopt = 70.0;
  double addPositionl=10.0;
  double addPositiont=115.0;
  double  iconPositionl=170.0;
  double  iconPositiont=90.0;
  double namePositionl=200.0;
  double namePositiont=492.0;
  double phonePositionl=180.0;
  double phonePositiont=523.0;

  String? selectedOption;

  //default color
  Color?  selectedColorAdd= Colors.black;
  Color?  selectedColorShop= Colors.black;
  Color?  selectedColorName= Colors.black;
  Color?  selectedColorPhone= Colors.black;

  final GlobalKey stackKey = GlobalKey();
  String? _selectedImage;

  final ImagePicker _picker = ImagePicker();

  final List<File> _selectedImages = [];
  //function to add a small logo
  Future _addSmallLogo() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImages.add(File(pickedFile.path));
      });
    }
  }
  List<String> savedImageUrls = []; // List to store saved image URLs


  // Function to fetch image URLs from Firebase Storage "models" folder
  Future<List<String>> fetchModelImages() async {
  List<String> imageUrls = [];

  try {
  firebase_storage.ListResult result =
  await firebase_storage.FirebaseStorage.instance.ref('models/').listAll();

  for (firebase_storage.Reference ref in result.items) {
  String url = await ref.getDownloadURL();
  imageUrls.add(url);
  }
  } catch (e) {
  print('Error fetching model images: $e');
  }

  return imageUrls;
  }

//function to show the template options available
  Future<void> _showImageOptionsDialog() async {
    List<String> modelImages = await fetchModelImages();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Model Image'),
          content: SingleChildScrollView(
            child: ListBody(
              children: modelImages.asMap().entries.map((entry) {
                int index = entry.key;
                String imageUrl = entry.value;
                return Card(
                  elevation: 4,
                  margin: EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: Image.network(
                      imageUrl,
                      width: 80,
                      height: 80,
                    ),
                    title: Text('Model Image ${index + 1}'), // Dynamic title
                    onTap: () {
                      // Download the selected image and assign it to _selectedImage
                      // _downloadAndSetSelectedImage(imageUrl);
                      Navigator.of(context).pop(); // Close the dialog
                      setState((){
                        _selectedImage=imageUrl;
                      });

                    },
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }





  @override
  Widget build(BuildContext context) {
    Cansumer? user = Provider.of<Cansumer?>(context);
    final AuthService _auth = AuthService();
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        title: const Text('Poster Pal'),
        backgroundColor: Colors.blue[400],
        elevation: 0.0,
        actions: <Widget>[
          TextButton.icon(
            icon: const Icon(
              Icons.person,
              color: Colors.black,
            ),
            label: const Text(
              'LogOut',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              prefs.setBool('isUserLoggedIn', false);
              await _auth.signOut();
              Navigator.pushNamed(context, MyRoute.loginRoute);
            },
          ),

        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 30.0,),
              _selectedImage == null
                  ? const Column(children: [SizedBox(height: 20.0,),Text('No image selected.')],)
                  : RepaintBoundary(
                key: stackKey,
                child: Stack(
                  children: <Widget>[
                    Image.network(_selectedImage!,
                        width: double.infinity,
                        fit: BoxFit.fill),
                    Positioned(
                      left: shopl,
                      top: shopt,
                      child: GestureDetector(
                        onPanUpdate: (details) {
                          setState(() {
                            shopl += details.delta.dx;
                            shopt += details.delta.dy;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(0.0),
                          child: Text(
                            submitText,
                            style:TextStyle(
                                color: selectedColorShop,
                                fontWeight: FontWeight.bold,
                                fontSize: _fontSize,
                                fontFamily: shopNameFontFamily,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: addPositionl,
                      top: addPositiont,
                      child: GestureDetector(
                        onPanUpdate: (details) {
                          setState(() {
                            addPositionl += details.delta.dx;
                            addPositiont += details.delta.dy;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(0.0),
                          child: Text(
                            submitAddress,
                            style: TextStyle(
                                color: selectedColorAdd,
                                fontWeight: FontWeight.bold,
                                fontSize: _fontAdd,
                                fontFamily: addressFontFamily ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: namePositionl,
                      top: namePositiont,
                      child: GestureDetector(
                        onPanUpdate: (details) {
                          setState(() {
                            namePositionl += details.delta.dx;
                            namePositiont += details.delta.dy;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(0.0),
                          child: Text(
                            submitName,
                            style: TextStyle(
                                color: selectedColorName,
                                fontWeight: FontWeight.bold,
                                fontSize: _fontName,
                                fontFamily: vendorNameFontFamily),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: phonePositionl,
                      top: phonePositiont,
                      child: GestureDetector(
                        onPanUpdate: (details) {
                          setState(() {
                            phonePositionl += details.delta.dx;
                            phonePositiont += details.delta.dy;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(0.0),
                          child: Text(
                            submitMobile,
                            style: TextStyle(
                              color: selectedColorPhone,
                              fontWeight: FontWeight.bold,
                              fontSize: _fontPhone,
                              fontFamily: vendorCodeFontFamily,),
                          ),
                        ),
                      ),
                    ),
                    for (var i = 0; i < _selectedImages.length; i++)
                      Positioned(
                        left: iconPositionl,
                        top: iconPositiont,
                        child: GestureDetector(
                          onPanUpdate: (details) {
                            setState(() {
                              iconPositionl += details.delta.dx;
                              iconPositiont += details.delta.dy;
                            });
                          },
                          child: Image.file(
                            _selectedImages[i],
                            width: 50,// Adjust the size of the small logo
                            height: 50,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height:10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text("SHOP NAME :",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                  SizedBox(
                    width:200,
                    height: 35,
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          inputText = value;
                        });
                      },
                      onTap: () {
                        setState(() {
                          selectedTextField = SelectedTextField.shopName;
                        });
                      },
                      controller: _shopEditingController,
                      decoration: InputDecoration(
                        hintText: 'Enter Shop name',
                        contentPadding: EdgeInsets.zero,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(1.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              //shopName
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Slider(
                    value: _fontSize,
                    min: 10.0,
                    max: 40.0,
                    divisions: 30,
                    onChanged: (value) {
                      setState(() {
                        _fontSize = value;
                      });
                    },
                  ),
                  DropdownButton<Color>(
                    value: selectedColorShop,
                    onChanged: (Color? newValue) {
                      setState(() {
                        selectedColorShop = newValue;
                      });
                    },
                    items: colorOptions.map<DropdownMenuItem<Color>>((Color value) {
                      return DropdownMenuItem<Color>(
                        value: value,
                        child: Container(
                          width: 50,
                          height: 20,
                          color: value,
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),

              Row (
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text("  ADDRESS     :",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    width:200,
                    height: 35,
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          inputAddress = value;
                        });
                      },
                      onTap: () {
                        setState(() {
                          selectedTextField = SelectedTextField.address;
                        });
                      },
                      controller: _addEditingController,
                      decoration: InputDecoration(
                        hintText: 'Enter your address',
                        contentPadding: EdgeInsets.zero,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(1.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ), //Address
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Slider(
                    value: _fontAdd,
                    min: 10.0,
                    max: 40.0,
                    divisions: 30,
                    onChanged: (value) {
                      setState(() {
                        _fontAdd = value;
                      });
                    },
                  ),
                  DropdownButton<Color>(
                    value: selectedColorAdd,
                    onChanged: (Color? newValue) {
                      setState(() {
                        selectedColorAdd = newValue;
                      });
                    },
                    items: colorOptions.map<DropdownMenuItem<Color>>((Color value) {
                      return DropdownMenuItem<Color>(
                        value: value,
                        child: Container(
                          width: 50,
                          height: 20,
                          color: value,
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text("VENDOR NAME:",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                  SizedBox(
                    width: 200,
                    height: 35,
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          inputName = value;
                        });
                      },
                      onTap: () {
                        setState(() {
                          selectedTextField = SelectedTextField.vendorName;
                        });
                      },
                      controller:_nameEditingController,
                      maxLines: 1,
                      decoration: InputDecoration(
                        hintText: 'Enter Name',
                        contentPadding: EdgeInsets.zero,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(1.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ), //name
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Slider(
                    value: _fontName,
                    min: 10.0,
                    max: 40.0,
                    divisions: 30,
                    onChanged: (value) {
                      setState(() {
                        _fontName = value;
                      });
                    },
                  ),

                  DropdownButton<Color>(
                    value: selectedColorName,
                    onChanged: (Color? newValue) {
                      setState(() {
                        selectedColorName = newValue;
                      });
                    },
                    items: colorOptions.map<DropdownMenuItem<Color>>((Color value) {
                      return DropdownMenuItem<Color>(
                        value: value,
                        child: Container(
                          width: 50,
                          height: 20,
                          color: value,
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text("VENDOR CODE:",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                  SizedBox(
                    width: 200,
                    height: 35,
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          inputMobile = value;
                        });
                      },
                      onTap: () {
                        setState(() {
                          selectedTextField = SelectedTextField.vendorCode;
                        });
                      },
                      controller: _mobileEditingController,
                      decoration: InputDecoration(
                        hintText: 'Enter vendor code',
                        contentPadding: EdgeInsets.zero,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(1.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ), //name
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Slider(
                    value: _fontPhone,
                    min: 10.0,
                    max: 40.0,
                    divisions: 30,
                    onChanged: (value) {
                      setState(() {
                        _fontPhone = value;
                      });
                    },
                  ),

                  DropdownButton<Color>(
                    value: selectedColorPhone,
                    onChanged: (Color? newValue) {
                      setState(() {
                        selectedColorPhone = newValue;
                      });
                    },
                    items: colorOptions.map<DropdownMenuItem<Color>>((Color value) {
                      return DropdownMenuItem<Color>(
                        value: value,
                        child: Container(
                          width: 50,
                          height: 20,
                          color: value,
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),

              Container(
                decoration: BoxDecoration(
                  color: Colors.cyan, // Background color
                  borderRadius: BorderRadius.circular(2), // Border radius
                  border: Border.all(
                    color: Colors.black, // Border color
                    width: 2, // Border width
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text("Select Font Family:",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,fontFamily: selectedFontFamily),),
                        //font selection button
                        DropdownButton<String>(
                          value: selectedFontFamily,
                          hint: const Text('Select a Font'),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedFontFamily = newValue;
                              if (selectedTextField == SelectedTextField.shopName) {
                                shopNameFontFamily = selectedFontFamily;
                              } else if (selectedTextField == SelectedTextField.vendorName) {
                                vendorNameFontFamily = selectedFontFamily;
                              } else if (selectedTextField == SelectedTextField.address) {
                                addressFontFamily = selectedFontFamily;
                              } else if (selectedTextField == SelectedTextField.vendorCode) {
                                vendorCodeFontFamily = selectedFontFamily;
                              }
                            });
                          },
                          items: fontFamilies.map((String fontFamily) {
                            return DropdownMenuItem<String>(
                              value: fontFamily,
                              child: Text(fontFamily),

                            );
                          }).toList(),
                        ),
                      ],),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        //Button to select the template design
                        ElevatedButton(
                          onPressed:(){
                            _showImageOptionsDialog();
                            },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.black,
                            backgroundColor: Colors.yellow[200], // Text color
                            elevation: 4, // Elevation
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6), // Rounded edges
                              side: const BorderSide(
                                  color: Colors.black, width: 1.0), // Small black border
                               ),
                            ),
                  child: const Text('Upload Design'),
                        ),
                        //Button to fetch text from the details collection
                        ElevatedButton(
                          onPressed: () async {
                            try {
                              final FirebaseAuth auth = FirebaseAuth.instance;
                              final User? user = auth.currentUser;
                              if (user != null) {
                                String currentUserId = user.uid;

                                final CollectionReference detailsCollection =
                                FirebaseFirestore.instance.collection('details');

                                DocumentSnapshot detailsDoc =
                                await detailsCollection.doc(currentUserId).get();

                                if (detailsDoc.exists) {
                                  Map<String, dynamic> detailsData = detailsDoc.data() as Map<String, dynamic>;

                                  setState(() {
                                    inputText = detailsData['shopName'] ?? '';
                                    inputAddress = detailsData['address'] ?? '';
                                    inputMobile = detailsData['vendorCode'] ?? '';
                                    inputName = detailsData['vendorName'] ?? '';
                                    _shopEditingController.text = inputText;
                                    _addEditingController.text = inputAddress;
                                    _nameEditingController.text = inputName;
                                    _mobileEditingController.text = inputMobile;


                                  });
                                } else {
                                  // Document doesn't exist
                                  print('Details document not found.');
                                }
                              }
                            } catch (e) {
                              print('Error fetching details: $e');
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.black,
                            backgroundColor: Colors.yellow[200], // Text color
                            elevation: 4, // Elevation
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6), // Rounded edges
                              side: const BorderSide(
                                  color: Colors.black, width: 1.0), // Small black border
                            ),
                          ),
                          child: const Text('Get Text'),
                        ),
                        //Button to add a small logo onto the stack
                        ElevatedButton(
                          onPressed: _addSmallLogo,
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.black,
                            backgroundColor: Colors.yellow[200], // Text color
                            elevation: 4, // Elevation
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6), // Rounded edges
                              side: const BorderSide(
                                  color: Colors.black, width: 1.0), // Small black border
                            ),
                          ), // Call _addSmallLogo method
                          child: const Text('Add PIC'),
                        ),
                        //Button to save the stack as a image onto the gallery as well as onto the cloud storage
                        ElevatedButton(
                          onPressed: () {
                            Future<void> saveStack() async {
                              // Check for permission to access the storage
                              final PermissionStatus permissionStatus =
                              await Permission.storage.request();
                              if (permissionStatus.isGranted) {
                                try {
                                  // Capture the stack as an image
                                  RenderRepaintBoundary boundary = stackKey.currentContext!
                                      .findRenderObject() as RenderRepaintBoundary;
                                  ui.Image image = await boundary.toImage();
                                  ByteData? byteData =
                                  await image.toByteData(format: ui.ImageByteFormat.png);
                                  Uint8List bytes = byteData!.buffer.asUint8List();
                                   if(user!= null)
                                   {
                                     final String imageName = '${DateTime.now().millisecondsSinceEpoch}.png';
                                   firebase_storage.Reference storageReference = firebase_storage.FirebaseStorage.instance.ref().child('images/$imageName');
                                   firebase_storage.UploadTask uploadTask = storageReference.putData(bytes);

                                   await uploadTask.whenComplete(() async {
                                     String imageUrl = await storageReference.getDownloadURL();
                                     DatabaseService(uid: user.uid).updateConsumerDataWithImage(imageUrl);
                                   });
                                   }
                                  // Save the image to the gallery
                                  await ImageGallerySaver.saveImage(bytes);

                                  // Show a success message
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Image saved to gallery')),
                                  );
                                } catch (e) {
                                  // Show an error message
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Failed to save Image')),
                                  );
                                }
                              } else {
                                if (permissionStatus.isPermanentlyDenied) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Permission permanently denied')),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Permission denied')),
                                  );
                                }
                              }
                            }
                            saveStack();
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.black,
                            backgroundColor: Colors.yellow[200], // Text color
                            elevation: 4, // Elevation
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6), // Rounded edges
                              side: const BorderSide(
                                  color: Colors.black, width: 1.0), // Small black border
                            ),
                          ),
                          child: const Text('SAVE'),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //Button to submit the fetched or entered text onto the stack
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              submitText = inputText;
                              submitAddress = inputAddress;
                              submitName = inputName;
                              submitMobile = inputMobile;
                            });
                            // print('The user entered: $inputText');
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.cyan[400],  // Text color
                            elevation: 4, // Elevation
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6), // Rounded edges
                              side: const BorderSide(
                                  color: Colors.black, width: 1.0), // Small black border
                            ),
                          ),
                          child: const Text('SUBMIT TEXT'),
                        ),
                        const SizedBox(width: 15),
                        //Button to fetch and display the previously created posters by the user
                        ElevatedButton(
                            onPressed: (){
                                      Future<void> loadSavedImages() async {
                                      List<String> imageUrls = await DatabaseService(uid: user!.uid).getUserImageUrls();
                                      setState(() {savedImageUrls = imageUrls;});
                                      }
                                      loadSavedImages();
                                      },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.cyan[400], // Text color
                            elevation: 4, // Elevation
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6), // Rounded edges
                              side: const BorderSide(
                                  color: Colors.black, width: 1.0), // Small black border
                            ),
                          ),
                          child: const Text('VIEW SAVED')),
                      ],
                    )
                  ],
                ),
              ),
              //The space where the previously created posters by the user are displayed
              Column(
                children: savedImageUrls.map((imageUrl) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Card(
                      child: InkWell(
                        //a expanded view of the poster
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ExpandedImageView(imageUrl: imageUrl),
                            ),
                          );
                        },
                        child: Column(
                          children: [
                            Image.network(
                              imageUrl,
                              width: 200,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                            const SizedBox(height: 8.0),
                            //Button to download the poster from the cloud storage
                            ElevatedButton(
                              onPressed: () async {
                                try {
                                  // Download the image data from the URL
                                  http.Response response = await http.get(Uri.parse(imageUrl));
                                  Uint8List imageData = response.bodyBytes;

                                  // Save the image data to the gallery
                                  bool isSaved = await ImageGallerySaver.saveImage(imageData);

                                  if (isSaved) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Image saved to gallery')),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Failed to save image to gallery')),
                                    );
                                  }
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Image saved to gallery')),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.cyan[400], // Text color
                                elevation: 4, // Elevation
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6), // Rounded edges
                                  side: const BorderSide(
                                      color: Colors.black, width: 1.0), // Small black border
                                ),
                              ),
                              child: const Text('Download to Gallery'),
                            ),

                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}