import 'dart:io';

import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:bookology/services/api.service.dart';
import 'package:bookology/services/isbn.service.dart';
import 'package:bookology/ui/screens/confirmation.screen.dart';
import 'package:bookology/ui/screens/image_viewer.screen.dart';
import 'package:bookology/ui/widgets/image_container.widget.dart';
import 'package:bookology/ui/widgets/outlined_button.widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class CreateScreen extends StatefulWidget {
  const CreateScreen({Key? key}) : super(key: key);

  @override
  _CreateScreenState createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  int _index = 0;
  List<bool> activeTab = [
    false,
    false,
    false,
  ];
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

  int _currentStep = 0;
  StepperType stepperType = StepperType.horizontal;

  @override
  Widget build(BuildContext context) {
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
              : Form(
                  key: _formKey,
                  child: Stepper(
                    type: StepperType.vertical,
                    physics: BouncingScrollPhysics(),
                    currentStep: _currentStep,
                    onStepTapped: (step) => tapped(step),
                    controlsBuilder: (
                      BuildContext context, {
                      VoidCallback? onStepContinue,
                      VoidCallback? onStepCancel,
                    }) {
                      return Column(
                        children: [
                          SizedBox(
                            height: 40,
                          ),
                          Row(
                            children: [
                              TextButton(
                                child: Text('Previous'),
                                onPressed: cancel,
                              ),
                              SizedBox(
                                width: 30,
                              ),
                              OutLinedButton(
                                child: SizedBox(
                                  width: 100,
                                  child: Center(
                                    child: Text(
                                      'Next',
                                    ),
                                  ),
                                ),
                                outlineColor: Theme.of(context).accentColor,
                                onPressed: () {
                                  continued();
                                  if (_currentStep == 4) {
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
                                    if (bookSellingPriceController
                                            .text.isNotEmpty &&
                                        bookSellingPriceController
                                            .text.isNotEmpty) {
                                      if (int.parse(bookOriginalPriceController
                                              .text) <
                                          int.parse(bookSellingPriceController
                                              .text)) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                'Selling price cannot be '
                                                'more than Original Price.'),
                                          ),
                                        );
                                        return false;
                                      }
                                    }
                                    if (_formKey.currentState!.validate() &&
                                        _isBookConditionSelected &&
                                        _isImagesSelected) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              ConfirmationScreen(
                                            isbn: this
                                                .isbnController
                                                .text
                                                .toString(),
                                            bookName: this
                                                .bookNameController
                                                .text
                                                .toString(),
                                            bookAuthor: this
                                                .bookAuthorController
                                                .text
                                                .toString(),
                                            bookPublisher: this
                                                .bookPublisherController
                                                .text
                                                .toString(),
                                            bookCondition: _bookCondition,
                                            bookOriginalPrice: this
                                                .bookOriginalPriceController
                                                .text
                                                .toString(),
                                            bookSellingPrice: this
                                                .bookSellingPriceController
                                                .text
                                                .toString(),
                                            bookDescription: this
                                                .bookDescriptionController
                                                .text
                                                .toString(),
                                            bookImage1: _imageUrl1,
                                            bookImage2: _imageUrl2,
                                            bookImage3: _imageUrl3,
                                            bookImage4: _imageUrl4,
                                          ),
                                        ),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text('All fields are '
                                              'compulsory.'),
                                        ),
                                      );
                                    }
                                  }
                                },
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                    steps: [
                      Step(
                        title: Row(
                          children: [
                            Icon(Icons.info_outlined),
                            SizedBox(
                              width: 10,
                            ),
                            Text('Book Info'),
                          ],
                        ),
                        subtitle: Text('           Fill the basic book info'),
                        content: bookInfo(),
                        isActive: _currentStep >= 0,
                        state: _currentStep >= 0
                            ? StepState.complete
                            : StepState.disabled,
                      ),
                      Step(
                        title: Row(
                          children: [
                            Icon(Icons.description_outlined),
                            SizedBox(
                              width: 10,
                            ),
                            Text('Description'),
                          ],
                        ),
                        subtitle: Text('           Write the description of '
                            'book'),
                        content: bookDescription(),
                        isActive: _currentStep >= 0,
                        state: _currentStep >= 1
                            ? StepState.complete
                            : StepState.disabled,
                      ),
                      Step(
                        title: Row(
                          children: [
                            Icon(Icons.sell_outlined),
                            SizedBox(
                              width: 10,
                            ),
                            Text('Pricing'),
                          ],
                        ),
                        subtitle: Text('           Write the price you want '
                            'to sell the book at'),
                        content: bookPricing(),
                        isActive: _currentStep >= 0,
                        state: _currentStep >= 2
                            ? StepState.complete
                            : StepState.disabled,
                      ),
                      Step(
                        title: Row(
                          children: [
                            Icon(Icons.rule_outlined),
                            SizedBox(
                              width: 10,
                            ),
                            Text('Book Condition'),
                          ],
                        ),
                        subtitle: Text('           Select the condition of '
                            'the book'),
                        content: bookCondition(),
                        isActive: _currentStep >= 0,
                        state: _currentStep >= 3
                            ? StepState.complete
                            : StepState.disabled,
                      ),
                      Step(
                        title: Row(
                          children: [
                            Icon(Icons.image_outlined),
                            SizedBox(
                              width: 10,
                            ),
                            Text('Upload Images'),
                          ],
                        ),
                        subtitle: Text('           Upload the images of the '
                            'book'),
                        content: bookImagesContainer(context: context),
                        isActive: _currentStep >= 0,
                        state: _currentStep >= 4
                            ? StepState.complete
                            : StepState.disabled,
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  switchStepsType() {
    setState(() => stepperType == StepperType.horizontal
        ? stepperType = StepperType.vertical
        : stepperType = StepperType.horizontal);
  }

  tapped(int step) {
    setState(() => _currentStep = step);
  }

  continued() {
    if (_currentStep < 4) {
      setState(() => _currentStep += 1);
    } else {
      return null;
    }
  }

  cancel() {
    if (_currentStep > 0) {
      setState(() => _currentStep -= 1);
    } else {
      return null;
    }
  }

  Widget bookInfo() {
    return Container(
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
                      switchText = 'Book dosen\'t have ISBN number';
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
                  builder: (BuildContext context) => AlertDialog(
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
                        outlineColor: Theme.of(context).accentColor,
                        onPressed: () {
                          Navigator.of(context, rootNavigator: true)
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
                style: TextStyle(color: Theme.of(context).accentColor),
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
                      mainAxisAlignment: MainAxisAlignment.center,
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
                              borderRadius: new BorderRadius.circular(15),
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
                            if (val!.length < 10 || val.length > 13) {
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
                        outlineColor: Theme.of(context).accentColor,
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
        ],
      ),
    );
  }

  Widget bookDescription() {
    return Container(
      child: TextFormField(
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
    );
  }

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

  Widget bookPricing() {
    return Container(
      height: 200,
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(
        top: 10,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
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
            height: 20,
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
        ],
      ),
    );
  }

  Widget bookCondition() {
    return Container(
      padding: EdgeInsets.only(
        top: 20,
      ),
      child: Column(
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
                color: _isBookConditionSelected ? Colors.grey : Colors.red,
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
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).accentColor),
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
    );
  }

  Widget bookImagesContainer({required BuildContext context}) {
    return Container(
      child: Column(
        children: [
          SizedBox(
            height: 10,
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
                            _imagePickerBottomSheet(onCameraPressed: () async {
                              final pickedImage = await _picImage(
                                  source: ImageSource.camera,
                                  imageURI: _imageUrl1);
                              setState(() {
                                _imageUrl1 = pickedImage;
                                _isImage1Selected = true;
                                _showBookImage1 = true;
                              });
                              Navigator.pop(context);
                            }, onGalleryPressed: () async {
                              final pickedImage = await _picImage(
                                  source: ImageSource.gallery,
                                  imageURI: _imageUrl1);
                              setState(() {
                                _imageUrl1 = pickedImage;
                                _isImage1Selected = true;
                                _showBookImage1 = true;
                              });
                              Navigator.pop(context);
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
                            _imagePickerBottomSheet(onCameraPressed: () async {
                              final pickedImage = await _picImage(
                                  source: ImageSource.camera,
                                  imageURI: _imageUrl2);
                              setState(() {
                                _imageUrl2 = pickedImage;
                                _isImage2Selected = true;
                                _showBookImage2 = true;
                              });
                              Navigator.pop(context);
                            }, onGalleryPressed: () async {
                              final pickedImage = await _picImage(
                                  source: ImageSource.gallery,
                                  imageURI: _imageUrl2);
                              setState(() {
                                _imageUrl2 = pickedImage;
                                _isImage2Selected = true;
                                _showBookImage2 = true;
                              });
                              Navigator.pop(context);
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
                            _imagePickerBottomSheet(onCameraPressed: () async {
                              final pickedImage = await _picImage(
                                  source: ImageSource.camera,
                                  imageURI: _imageUrl3);
                              setState(() {
                                _imageUrl3 = pickedImage;
                                _isImage3Selected = true;
                                _showBookImage3 = true;
                              });
                              Navigator.pop(context);
                            }, onGalleryPressed: () async {
                              final pickedImage = await _picImage(
                                  source: ImageSource.gallery,
                                  imageURI: _imageUrl3);
                              setState(() {
                                _imageUrl3 = pickedImage;
                                _isImage3Selected = true;
                                _showBookImage3 = true;
                              });
                              Navigator.pop(context);
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
                            _imagePickerBottomSheet(onCameraPressed: () async {
                              final pickedImage = await _picImage(
                                  source: ImageSource.camera,
                                  imageURI: _imageUrl4);
                              setState(() {
                                _imageUrl4 = pickedImage;
                                _isImage4Selected = true;
                                _showBookImage4 = true;
                              });
                              Navigator.pop(context);
                            }, onGalleryPressed: () async {
                              final pickedImage = await _picImage(
                                  source: ImageSource.gallery,
                                  imageURI: _imageUrl4);
                              setState(() {
                                _imageUrl4 = pickedImage;
                                _isImage4Selected = true;
                                _showBookImage4 = true;
                              });
                              Navigator.pop(context);
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

  void _imagePickerBottomSheet(
      {required VoidCallback onCameraPressed,
      required VoidCallback onGalleryPressed}) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 10,
              bottom: 10,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            height: 250,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(
                    top: 5,
                  ),
                  width: 50,
                  height: 3,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: Text(
                    'Pic Image From',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                OutLinedButton(
                  onPressed: onCameraPressed,
                  outlineColor: Theme.of(context).accentColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.photo_camera_outlined),
                      SizedBox(
                        width: 10,
                      ),
                      Text('Camera'),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                OutLinedButton(
                  onPressed: onGalleryPressed,
                  outlineColor: Theme.of(context).accentColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.collections_outlined),
                      SizedBox(
                        width: 10,
                      ),
                      Text('Gallery'),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  Future<dynamic> _picImage(
      {required ImageSource source, required String imageURI}) async {
    final ImagePicker _picker = ImagePicker();
    final PickedFile? photo = await _picker.getImage(source: source);

    final croppedImage =
        await _cropImage(pickedImage: photo, imageURI: imageURI);

    return croppedImage;
  }

  Future<dynamic> _cropImage(
      {required PickedFile? pickedImage, required String imageURI}) async {
    File? cropped = await ImageCropper.cropImage(
      sourcePath: pickedImage!.path,
      aspectRatio: CropAspectRatio(ratioX: 16, ratioY: 9),
      androidUiSettings: AndroidUiSettings(
        toolbarColor: Colors.white,
        toolbarTitle: 'Crop Image',
      ),
      compressQuality: 50,
    ) as File;
    return imageURI = 'file://${cropped.path}';
  }
}
