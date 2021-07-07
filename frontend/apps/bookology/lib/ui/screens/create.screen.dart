import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:bookology/services/api.service.dart';
import 'package:bookology/services/isbn.service.dart';
import 'package:bookology/ui/screens/image_viewer.screen.dart';
import 'package:bookology/ui/widgets/image_container.widget.dart';
import 'package:bookology/ui/widgets/outlined_button.widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class CreateScreen extends StatefulWidget {
  const CreateScreen({Key? key}) : super(key: key);

  @override
  _CreateScreenState createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  bool _hasISBN = true;
  bool _isLoading = false;
  bool _showSearchButton = false;
  bool _showBookImage1 = false;
  bool _showBookImage2 = false;
  bool _showBookImage3 = false;
  bool _showBookImage4 = false;
  bool _isBookConditionSelected = false;
  bool _isImagesSelected = false;
  bool _isImage1Selected = false;
  bool _isImage2Selected = false;
  bool _isImage3Selected = false;
  bool _isImage4Selected = false;

  String switchText = 'Book has ISBN number';
  String _bookCondition = 'Select';
  String _imageUrl1 = '';
  String _imageUrl2 = '';
  String _imageUrl3 = '';
  String _imageUrl4 = '';

  ScanResult? scanResult;
  var _aspectTolerance = 0.00;
  var _selectedCamera = -1;
  var _useAutoFocus = true;
  var _autoEnableFlash = false;

  final _formKey = GlobalKey<FormState>();

  final isbnController = TextEditingController();
  final bookNameController = TextEditingController();
  final bookAuthorController = TextEditingController();
  final bookPublisherController = TextEditingController();
  final bookDescriptionController = TextEditingController();
  final bookOriginalPriceController = TextEditingController();
  final bookSellingPriceController = TextEditingController();

  final isbnService = new IsbnService();
  static final _possibleFormats = BarcodeFormat.values.toList()
    ..removeWhere((e) => e == BarcodeFormat.unknown);

  List<BarcodeFormat> selectedFormats = [..._possibleFormats];

  final apiService = new ApiService();

  @override
  Widget build(BuildContext context) {
    void fetchBookData(String isbn) async {
      try {
        setState(() {
          _isLoading = true;
        });
        await isbnService.getBookInfo(isbn: isbn).then((value) async {
          if (value.toString().contains("/authors/")) {
            await isbnService
                .getBookAuthor(path: value['authors'][0]['key'].toString())
                .then((value) {
              setState(() {
                _isLoading = false;
                bookAuthorController.text = value;
              });
            });
          } else {
            setState(() {
              _isLoading = false;
              bookAuthorController.text = '';
            });
          }
          setState(() {
            isbnController.text = value['isbn_13'][0].toString();
            bookNameController.text = value['title'].toString();
          });
        });
      } catch (error) {
        if (error.toString().contains('FormatException')) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('No book found with the ISBN. Please fill details'
                  ' manually.'),
            ),
          );
        }
      }
    }

    Future<void> _scan() async {
      try {
        setState(() {
          _isLoading = true;
        });
        final result = await BarcodeScanner.scan(
          options: ScanOptions(
            restrictFormat: selectedFormats,
            useCamera: _selectedCamera,
            autoEnableFlash: _autoEnableFlash,
            android: AndroidOptions(
              aspectTolerance: _aspectTolerance,
              useAutoFocus: _useAutoFocus,
            ),
          ),
        );
        fetchBookData(result.rawContent);
      } on PlatformException catch (e) {
        setState(() {
          if (e.code == BarcodeScanner.cameraAccessDenied) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Camera Permission not granted. Allow '
                    'Permission in settings.'),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Unknown Error Occurred.'),
              ),
            );
          }
        });
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        title: Text(
          'Create new Booklet',
          style: GoogleFonts.poppins(color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Container(
          child: _isLoading
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(
                        height: 30,
                      ),
                      Text('Loading Book..')
                    ],
                  ),
                )
              : ListView(
                  scrollDirection: Axis.vertical,
                  padding: EdgeInsets.only(
                    left: 20,
                    right: 20,
                    bottom: 20,
                  ),
                  children: [
                    Center(
                      child: Container(
                        width: 250,
                        height: 250,
                        child: SvgPicture.asset('assets/svg/books.svg'),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(switchText),
                              Checkbox(
                                value: _hasISBN,
                                onChanged: (value) {
                                  setState(() {
                                    if (_hasISBN == true) {
                                      _hasISBN = false;
                                      switchText =
                                          'Book dosen\'t have ISBN number';
                                    } else {
                                      _hasISBN = true;
                                      switchText = 'Book has ISBN number';
                                    }
                                  });
                                },
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: InkWell(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    title: Text(
                                      'ISBN',
                                    ),
                                    content: Text(
                                      'The International Standard Book Number (ISBN) is a numeric commercial book identifier which is intended to be unique.'
                                      '\nAn ISBN is assigned to each separate '
                                      'edition and variation (except '
                                      'reprintings) of a publication.',
                                    ),
                                    actions: [
                                      OutLinedButton(
                                        child: Text('      OK      '),
                                        outlineColor:
                                            Theme.of(context).accentColor,
                                        onPressed: () {
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop('dialog');
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                              child: Text(
                                'What is ISBN number?',
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                    color: Theme.of(context).accentColor),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Visibility(
                            visible: _hasISBN,
                            child: Column(
                              children: [
                                SizedBox(
                                  width: 150,
                                  child: OutLinedButton(
                                    onPressed: () {
                                      _scan();
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.qr_code_scanner),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text('Scan')
                                      ],
                                    ),
                                    outlineColor: Theme.of(context).accentColor,
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text('OR'),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        decoration: new InputDecoration(
                                            labelText: "ISBN",
                                            fillColor: Colors.white,
                                            border: new OutlineInputBorder(
                                              borderRadius:
                                                  new BorderRadius.circular(15),
                                              borderSide: new BorderSide(),
                                            ),
                                            prefixIcon: Icon(Icons.fingerprint)
                                            //fillColor: Colors.green
                                            ),
                                        controller: isbnController,
                                        validator: (val) {
                                          if (val?.length == 0) {
                                            return "ISBN cannot be empty.";
                                          } else {
                                            if (val!.length < 10 ||
                                                val.length > 13) {
                                              return "ISBN should be of 10 or"
                                                  " 13 digits";
                                            } else {
                                              return null;
                                            }
                                          }
                                        },
                                        onChanged: (value) async {
                                          if (value.length == 10) {
                                            setState(() {
                                              _showSearchButton = true;
                                            });
                                          } else {
                                            setState(() {
                                              _showSearchButton = false;
                                            });

                                            if (value.length == 13) {
                                              fetchBookData(value);
                                            }
                                          }
                                        },
                                        keyboardType: TextInputType.number,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 30,
                                    ),
                                    Visibility(
                                      visible: _showSearchButton,
                                      child: OutLinedButton(
                                        child: Icon(
                                          Icons.search,
                                        ),
                                        outlineColor:
                                            Theme.of(context).accentColor,
                                        onPressed: () {
                                          fetchBookData(isbnController.text);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          bookDataFields(
                            context: context,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Column(
                            children: [
                              Container(
                                height: 65,
                                padding: EdgeInsets.only(
                                  left: 10,
                                  top: 5,
                                  bottom: 5,
                                  right: 10,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                    color: _isBookConditionSelected
                                        ? Colors.grey
                                        : Colors.red,
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      'The Condition of book is',
                                      style: TextStyle(
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    DropdownButton<String>(
                                      //elevation: 5,
                                      style: TextStyle(color: Colors.black),

                                      items: <String>[
                                        'Select',
                                        'New',
                                        'Excellent',
                                        'Okay',
                                        'Bad',
                                      ].map<DropdownMenuItem<String>>(
                                          (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(
                                            value,
                                            style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.bold,
                                                color: Theme.of(context)
                                                    .accentColor),
                                          ),
                                        );
                                      }).toList(),
                                      hint: Text(
                                        "Select",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      onChanged: (value) {
                                        setState(() {
                                          _bookCondition = value.toString();
                                        });
                                        if (value.toString() == "Select") {
                                          setState(() {
                                            _bookCondition = value.toString();
                                            _isBookConditionSelected = false;
                                          });
                                        } else {
                                          setState(() {
                                            _bookCondition = value.toString();
                                            _isBookConditionSelected = true;
                                          });
                                        }
                                      },
                                      value: _bookCondition,
                                    ),
                                  ],
                                ),
                              ),
                              Visibility(
                                visible: !_isBookConditionSelected,
                                child: SizedBox(
                                  height: 10,
                                ),
                              ),
                              Visibility(
                                visible: !_isBookConditionSelected,
                                child: Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      left: 10,
                                    ),
                                    child: Text(
                                      'Please Select book Condition',
                                      style: TextStyle(
                                        color: Colors.redAccent,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          bookImagesContainer(
                            context: context,
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          SizedBox(
                            width: 100,
                            child: OutLinedButton(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Next'),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Icon(Icons.arrow_forward),
                                ],
                              ),
                              outlineColor: Colors.black,
                              onPressed: () {
                                if (_isImage1Selected &&
                                    _isImage2Selected &&
                                    _isImage3Selected &&
                                    _isImage4Selected) {
                                  setState(() {
                                    _isImagesSelected = true;
                                  });
                                } else {
                                  setState(() {
                                    _isImagesSelected = false;
                                  });
                                }
                                if (int.parse(
                                        bookOriginalPriceController.text) <
                                    int.parse(
                                        bookSellingPriceController.text)) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Selling price cannot be '
                                          'more than Original Price.'),
                                    ),
                                  );
                                  return false;
                                }
                                if (_formKey.currentState!.validate() &&
                                    _isBookConditionSelected &&
                                    _isImagesSelected) {
                                  _showConfirmationSheet();
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget bookDataFields({required BuildContext context}) {
    return Container(
      child: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          TextFormField(
            decoration: new InputDecoration(
                labelText: "Book Name",
                fillColor: Colors.white,
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(15),
                  borderSide: new BorderSide(),
                ),
                prefixIcon: Icon(Icons.menu_book)
                //fillColor: Colors.green
                ),
            controller: bookNameController,
            validator: (val) {
              if (val?.length == 0) {
                return "Book name cannot be empty.";
              } else {
                if (val!.length < 5) {
                  return "Book name is not valid.";
                } else {
                  return null;
                }
              }
            },
            keyboardType: TextInputType.text,
          ),
          SizedBox(
            height: 20,
          ),
          TextFormField(
            decoration: new InputDecoration(
                labelText: "Author",
                fillColor: Colors.white,
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(15),
                  borderSide: new BorderSide(),
                ),
                prefixIcon: Icon(Icons.account_circle)
                //fillColor: Colors.green
                ),
            controller: bookAuthorController,
            validator: (val) {
              if (val?.length == 0) {
                return "Author cannot be empty.";
              } else {
                if (val!.length < 5) {
                  return "Author is not valid.";
                } else {
                  return null;
                }
              }
            },
            keyboardType: TextInputType.text,
          ),
          SizedBox(
            height: 20,
          ),
          TextFormField(
            decoration: new InputDecoration(
                labelText: "Publisher",
                fillColor: Colors.white,
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(15),
                  borderSide: new BorderSide(),
                ),
                prefixIcon: Icon(Icons.public)
                //fillColor: Colors.green
                ),
            controller: bookPublisherController,
            validator: (val) {
              if (val?.length == 0) {
                return "Publisher cannot be empty.";
              } else {
                if (val!.length < 5) {
                  return "Publisher is not valid.";
                } else {
                  return null;
                }
              }
            },
            keyboardType: TextInputType.text,
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            decoration: new InputDecoration(
              labelText: "Description",
              fillColor: Colors.white,
              border: new OutlineInputBorder(
                borderRadius: new BorderRadius.circular(15),
                borderSide: new BorderSide(),
              ),
            ),
            maxLines: null,
            controller: bookDescriptionController,
            validator: (val) {
              if (val?.length == 0) {
                return "Description cannot be empty.";
              } else {
                if (val!.length < 5) {
                  return "Description is not valid.";
                } else {
                  return null;
                }
              }
            },
            keyboardType: TextInputType.multiline,
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  decoration: new InputDecoration(
                      labelText: "Original Price",
                      fillColor: Colors.white,
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(15),
                        borderSide: new BorderSide(),
                      ),
                      prefixIcon: Icon(Icons.sell)
                      //fillColor: Colors.green
                      ),
                  controller: bookOriginalPriceController,
                  validator: (val) {
                    if (val?.length == 0) {
                      return "Original Price cannot be empty.";
                    } else {
                      if (val!.length < 1) {
                        return "Original Price is not valid.";
                      } else {
                        return null;
                      }
                    }
                  },
                  keyboardType: TextInputType.number,
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Expanded(
                child: TextFormField(
                  decoration: new InputDecoration(
                      labelText: "Selling Price",
                      fillColor: Colors.white,
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(15),
                        borderSide: new BorderSide(),
                      ),
                      prefixIcon: Icon(Icons.sell)
                      //fillColor: Colors.green
                      ),
                  controller: bookSellingPriceController,
                  validator: (val) {
                    if (val?.length == 0) {
                      return "Selling Price cannot be empty.";
                    } else {
                      if (val!.length < 1) {
                        return "Selling Price is not valid.";
                      } else {
                        return null;
                      }
                    }
                  },
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget bookImagesContainer({required BuildContext context}) {
    return Container(
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Text(
              'Upload Book Images',
              style: TextStyle(
                color: Theme.of(context).accentColor,
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          SizedBox(
            height: 150,
            width: MediaQuery.of(context).size.width,
            child: ListView(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              children: [
                Container(
                  child: Column(
                    children: [
                      Visibility(
                        visible: !_showBookImage1,
                        child: ImagePlaceholder(
                          onPressed: () async {
                            final PickedFile? pickedFile =
                                await ImagePicker.platform.pickImage(
                                    source: ImageSource.gallery,
                                    imageQuality: 50);

                            setState(() {
                              _showBookImage1 = true;
                              _imageUrl1 = 'file://${pickedFile!.path}';
                              _isImage1Selected = true;
                            });
                          },
                        ),
                      ),
                      Visibility(
                        visible: _showBookImage1,
                        child: ImageHolder(
                          imageURL: _imageUrl1,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    ImageViewer(imageURl: _imageUrl1),
                              ),
                            );
                          },
                          onCancelled: () {
                            setState(() {
                              _showBookImage1 = false;
                              _imageUrl1 = '';
                              _isImage1Selected = false;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Container(
                  child: Column(
                    children: [
                      Visibility(
                        visible: !_showBookImage2,
                        child: ImagePlaceholder(
                          onPressed: () async {
                            final PickedFile? pickedFile =
                                await ImagePicker.platform.pickImage(
                                    source: ImageSource.gallery,
                                    imageQuality: 50);

                            setState(() {
                              _showBookImage2 = true;
                              _imageUrl2 = 'file://${pickedFile!.path}';
                              _isImage2Selected = true;
                            });
                          },
                        ),
                      ),
                      Visibility(
                        visible: _showBookImage2,
                        child: ImageHolder(
                          imageURL: _imageUrl2,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    ImageViewer(imageURl: _imageUrl2),
                              ),
                            );
                          },
                          onCancelled: () {
                            setState(() {
                              _showBookImage2 = false;
                              _imageUrl2 = '';
                              _isImage2Selected = false;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Container(
                  child: Column(
                    children: [
                      Visibility(
                        visible: !_showBookImage3,
                        child: ImagePlaceholder(
                          onPressed: () async {
                            final PickedFile? pickedFile =
                                await ImagePicker.platform.pickImage(
                                    source: ImageSource.gallery,
                                    imageQuality: 50);

                            setState(() {
                              _showBookImage3 = true;
                              _imageUrl3 = 'file://${pickedFile!.path}';
                              _isImage3Selected = true;
                            });
                          },
                        ),
                      ),
                      Visibility(
                        visible: _showBookImage3,
                        child: ImageHolder(
                          imageURL: _imageUrl3,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    ImageViewer(imageURl: _imageUrl3),
                              ),
                            );
                          },
                          onCancelled: () {
                            setState(() {
                              _showBookImage3 = false;
                              _imageUrl3 = '';
                              _isImage3Selected = false;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Container(
                  child: Column(
                    children: [
                      Visibility(
                        visible: !_showBookImage4,
                        child: ImagePlaceholder(
                          onPressed: () async {
                            final PickedFile? pickedFile =
                                await ImagePicker.platform.pickImage(
                                    source: ImageSource.gallery,
                                    imageQuality: 50);

                            setState(() {
                              _showBookImage4 = true;
                              _imageUrl4 = 'file://${pickedFile!.path}';
                              _isImage4Selected = true;
                            });
                          },
                        ),
                      ),
                      Visibility(
                        visible: _showBookImage4,
                        child: ImageHolder(
                          imageURL: _imageUrl4,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    ImageViewer(imageURl: _imageUrl4),
                              ),
                            );
                          },
                          onCancelled: () {
                            setState(() {
                              _showBookImage4 = false;
                              _imageUrl4 = '';
                              _isImage4Selected = false;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Visibility(
            visible: !_isImagesSelected,
            child: SizedBox(
              height: 10,
            ),
          ),
          Visibility(
            visible: !_isImagesSelected,
            child: Padding(
              padding: EdgeInsets.only(
                left: 10,
              ),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  'Please Upload all Images',
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showConfirmationSheet() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 1000,
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(15),
                  topLeft: Radius.circular(15),
                )),
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: Color(0xFFE0E0E0),
                      width: 2,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          text: 'ISBN:  ',
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                          children: [
                            TextSpan(
                              text: this.isbnController.text.toString(),
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      RichText(
                        text: TextSpan(
                          text: 'Book Name:  ',
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                          children: [
                            TextSpan(
                              text: this.bookNameController.text.toString(),
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      RichText(
                        text: TextSpan(
                          text: 'Author:  ',
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                          children: [
                            TextSpan(
                              text: this.bookAuthorController.text.toString(),
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      RichText(
                        text: TextSpan(
                          text: 'Publisher:  ',
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                          children: [
                            TextSpan(
                              text:
                                  this.bookPublisherController.text.toString(),
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      RichText(
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                        text: TextSpan(
                          text: 'Description:  ',
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                          children: [
                            TextSpan(
                              text: this
                                      .bookDescriptionController
                                      .text
                                      .toString()
                                      .trim() +
                                  '...',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          RichText(
                            text: TextSpan(
                              text: 'Original Price:  ',
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: 14,
                              ),
                              children: [
                                TextSpan(
                                  text: this
                                      .bookOriginalPriceController
                                      .text
                                      .toString(),
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          RichText(
                            text: TextSpan(
                              text: 'Selling Price:  ',
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: 14,
                              ),
                              children: [
                                TextSpan(
                                  text: this
                                      .bookSellingPriceController
                                      .text
                                      .toString(),
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 150,
                        width: MediaQuery.of(context).size.width,
                        child: ListView(
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          children: [
                            ImageHolder(
                              onPressed: () {},
                              onCancelled: () {},
                              imageURL: _imageUrl1,
                              showCloseButton: false,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            ImageHolder(
                              onPressed: () {},
                              onCancelled: () {},
                              imageURL: _imageUrl2,
                              showCloseButton: false,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            ImageHolder(
                              onPressed: () {},
                              onCancelled: () {},
                              imageURL: _imageUrl3,
                              showCloseButton: false,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            ImageHolder(
                              onPressed: () {},
                              onCancelled: () {},
                              imageURL: _imageUrl4,
                              showCloseButton: false,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          OutLinedButton(
                            child: Text('     Post      '),
                            outlineColor: Colors.green,
                            onPressed: () async {
                              await apiService.postBookData(
                                isbn: '1234567899',
                                bookName: bookNameController.text,
                                bookAuthor: bookAuthorController.text,
                                bookPublisher: bookPublisherController.text,
                                bookDescription: bookDescriptionController.text,
                                bookCondition: _bookCondition,
                                originalPrice: '124',
                                sellingPrice: '123',
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }
}

Future _deleteImageFromCache(String imageURL) async {
  String url = imageURL;
  await CachedNetworkImage.evictFromCache(url);
}
