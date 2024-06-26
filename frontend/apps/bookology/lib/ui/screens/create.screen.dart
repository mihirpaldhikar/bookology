/*
 * Copyright 2021 Mihir Paldhikar
 *
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the "Software"),
 *  to deal in the Software without restriction, including without limitation the
 *  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 *  copies of the Software, and to permit persons to whom the Software is furnished
 *  to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies
 *  or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
 * OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
 * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR
 * OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
 * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 */

import 'package:bookology/constants/strings.constant.dart';
import 'package:bookology/constants/values.constants.dart';
import 'package:bookology/handlers/image.handler.dart';
import 'package:bookology/managers/bottom_sheet.manager.dart';
import 'package:bookology/managers/currency.manager.dart';
import 'package:bookology/managers/dialogs.managers.dart';
import 'package:bookology/managers/toast.manager.dart';
import 'package:bookology/services/api.service.dart';
import 'package:bookology/services/auth.service.dart';
import 'package:bookology/services/location.service.dart';
import 'package:bookology/ui/components/collapsable_app_bar.component.dart';
import 'package:bookology/ui/screens/image_viewer.screen.dart';
import 'package:bookology/ui/widgets/image_container.widget.dart';
import 'package:bookology/ui/widgets/rounded_button.widget.dart';
import 'package:bookology/utils/random_string_generator.util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class CreateScreen extends StatefulWidget {
  const CreateScreen({Key? key}) : super(key: key);

  @override
  _CreateScreenState createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  bool _hasISBN = true;
  final bool _isLoading = false;
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
  String _nextStep = 'Next';
  String _currentLocation = '';
  String _imageDownloadURL1 = '';
  String _imageDownloadURL2 = '';
  String _imageDownloadURL3 = '';
  String _imageDownloadURL4 = '';
  String _imagesCollectionsID = '';

  final _formKey = GlobalKey<FormState>();

  final _isbnController = TextEditingController();
  final _bookNameController = TextEditingController();
  final _bookAuthorController = TextEditingController();
  final _bookPublisherController = TextEditingController();
  final _bookDescriptionController = TextEditingController();
  final _bookOriginalPriceController = TextEditingController();
  final _bookSellingPriceController = TextEditingController();

  final _apiService = ApiService();

  int _currentStep = 0;
  StepperType _stepperType = StepperType.horizontal;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _asyncMethod();
    });
  }

  _asyncMethod() async {
    if (await Permission.locationWhenInUse.isDenied ||
        await Permission.locationWhenInUse.isPermanentlyDenied ||
        await Permission.locationWhenInUse.isRestricted) {
      DialogsManager(context).showLocationNotGrantedDialog(
          onOpenSettingsClicked: () {
        Navigator.pop(context);
        openAppSettings();
      });
    } else {
      await LocationService(context).getCurrentLocation().then((location) {
        setState(() {
          _currentLocation = location;
          _imagesCollectionsID = RandomString().generate(15);
        });
      });
    }
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthService>(context);
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: SafeArea(
          child: CollapsableAppBar(
            automaticallyImplyLeading: true,
            title: 'Upload New Book',
            body: Container(
              child: _isLoading
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          CircularProgressIndicator(),
                          SizedBox(
                            height: 30,
                          ),
                          Text('Loading Book..')
                        ],
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(
                        top: 10,
                      ),
                      child: Form(
                        key: _formKey,
                        child: Stepper(
                          type: StepperType.vertical,
                          currentStep: _currentStep,
                          onStepTapped: (step) => tapped(step),
                          controlsBuilder: (
                            BuildContext context,
                            ControlsDetails controlsDetails,
                          ) {
                            return Column(
                              children: [
                                const SizedBox(
                                  height: 40,
                                ),
                                Row(
                                  children: [
                                    TextButton(
                                      child: Visibility(
                                        visible: _currentStep != 0,
                                        child: Text(
                                          'Previous',
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                          ),
                                        ),
                                      ),
                                      onPressed: cancel,
                                    ),
                                    const SizedBox(
                                      width: 30,
                                    ),
                                    SizedBox(
                                      width: 100,
                                      child: RoundedButton(
                                        text: _nextStep,
                                        textColor: Theme.of(context)
                                            .colorScheme
                                            .onPrimary,
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        onPressed: () async {
                                          continued();
                                          if (_currentStep == 4) {
                                            setState(() {
                                              _nextStep = 'Continue';
                                            });
                                            if (await Permission
                                                .locationWhenInUse.isGranted) {
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
                                              if (_bookSellingPriceController
                                                      .text.isNotEmpty &&
                                                  _bookSellingPriceController
                                                      .text.isNotEmpty) {
                                                if (int.parse(
                                                        _bookOriginalPriceController
                                                            .text) <
                                                    int.parse(
                                                        _bookSellingPriceController
                                                            .text)) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                          'Selling price cannot be '
                                                          'more than Original Price.'),
                                                    ),
                                                  );
                                                }
                                              }
                                              if (_formKey.currentState!
                                                      .validate() &&
                                                  _isBookConditionSelected &&
                                                  _isImagesSelected) {
                                                BottomSheetManager(context)
                                                    .showUploadBookConfirmationBottomSheet(
                                                  isbn: _isbnController.text
                                                          .trim()
                                                          .isEmpty
                                                      ? 'No ISBN'
                                                      : _isbnController.text,
                                                  bookName:
                                                      _bookNameController.text,
                                                  bookAuthor:
                                                      _bookAuthorController
                                                          .text,
                                                  bookPublisher:
                                                      _bookPublisherController
                                                          .text,
                                                  bookDescription:
                                                      _bookDescriptionController
                                                          .text,
                                                  bookOriginalPrice:
                                                      _bookOriginalPriceController
                                                          .text,
                                                  bookSellingPrice:
                                                      _bookSellingPriceController
                                                          .text,
                                                  bookCondition: _bookCondition,
                                                  bookImage1: _imageUrl1,
                                                  bookImage2: _imageUrl2,
                                                  bookImage3: _imageUrl3,
                                                  bookImage4: _imageUrl4,
                                                  onUploadClicked: () async {
                                                    DialogsManager(context)
                                                        .showProgressDialog(
                                                      content: 'Uploading...',
                                                    );
                                                    final name =
                                                        '${DateTime.now().minute}${DateTime.now().microsecond}${DateTime.now().hashCode}';
                                                    await ImageHandler(context)
                                                        .uploadImage(
                                                      filePath: _imageUrl1,
                                                      imagePath:
                                                          'Users/${user.user?.uid}/BooksImages/$_imagesCollectionsID',
                                                      imageName: name,
                                                    )
                                                        .then((value) {
                                                      setState(
                                                        () {
                                                          _imageDownloadURL1 =
                                                              value;
                                                        },
                                                      );
                                                    }).then(
                                                      (value) async {
                                                        final name =
                                                            '${DateTime.now().minute}${DateTime.now().microsecond}${DateTime.now().hashCode}';
                                                        await ImageHandler(
                                                                context)
                                                            .uploadImage(
                                                          filePath: _imageUrl2,
                                                          imagePath:
                                                              'Users/${user.user?.uid}/BookImages/$_imagesCollectionsID',
                                                          imageName: name,
                                                        )
                                                            .then(
                                                          (value) {
                                                            setState(() {
                                                              _imageDownloadURL2 =
                                                                  value;
                                                            });
                                                          },
                                                        ).then(
                                                          (value) async {
                                                            final name =
                                                                '${DateTime.now().minute}${DateTime.now().microsecond}${DateTime.now().hashCode}';
                                                            await ImageHandler(
                                                                    context)
                                                                .uploadImage(
                                                              filePath:
                                                                  _imageUrl3,
                                                              imagePath:
                                                                  'Users/${user.user?.uid}/BookImages/$_imagesCollectionsID',
                                                              imageName: name,
                                                            )
                                                                .then((value) {
                                                              setState(() {
                                                                _imageDownloadURL3 =
                                                                    value;
                                                              });
                                                            }).then(
                                                              (value) async {
                                                                final name =
                                                                    '${DateTime.now().minute}${DateTime.now().microsecond}${DateTime.now().hashCode}';
                                                                await ImageHandler(
                                                                        context)
                                                                    .uploadImage(
                                                                  filePath:
                                                                      _imageUrl4,
                                                                  imagePath:
                                                                      'Users/${user.user?.uid}/BookImages/$_imagesCollectionsID',
                                                                  imageName:
                                                                      name,
                                                                )
                                                                    .then(
                                                                  (value) {
                                                                    setState(
                                                                        () {
                                                                      _imageDownloadURL4 =
                                                                          value;
                                                                    });
                                                                  },
                                                                );
                                                              },
                                                            );
                                                          },
                                                        );
                                                      },
                                                    );

                                                    final result =
                                                        await _apiService
                                                            .postBookData(
                                                      isbn: _isbnController.text
                                                              .trim()
                                                              .isEmpty
                                                          ? 'No ISBN'
                                                          : _isbnController
                                                              .text,
                                                      bookName:
                                                          _bookNameController
                                                              .text,
                                                      bookAuthor:
                                                          _bookAuthorController
                                                              .text,
                                                      bookPublisher:
                                                          _bookPublisherController
                                                              .text,
                                                      bookDescription:
                                                          _bookDescriptionController
                                                              .text,
                                                      bookOriginalPrice:
                                                          _bookOriginalPriceController
                                                              .text,
                                                      bookSellingPrice:
                                                          _bookSellingPriceController
                                                              .text,
                                                      bookCondition:
                                                          _bookCondition,
                                                      bookImage1:
                                                          _imageDownloadURL1,
                                                      bookImage2:
                                                          _imageDownloadURL2,
                                                      bookImage3:
                                                          _imageDownloadURL3,
                                                      bookImage4:
                                                          _imageDownloadURL4,
                                                      bookCurrency:
                                                          CurrencyManager()
                                                              .setCurrency(
                                                        location:
                                                            _currentLocation,
                                                      ),
                                                      bookImagesCollectionId:
                                                          _imagesCollectionsID,
                                                      bookLocation:
                                                          _currentLocation,
                                                    );
                                                    if (result == true) {
                                                      Navigator.pop(context);
                                                      Navigator
                                                          .pushReplacementNamed(
                                                              context,
                                                              '/profile');
                                                    }
                                                  },
                                                );
                                              } else {
                                                ToastManager(context).showToast(
                                                    message: StringConstants
                                                        .errorFieldsCompulsory);
                                              }
                                            } else {
                                              ToastManager(context).showToast(
                                                  message:
                                                      'Location Permission not granted.');
                                            }
                                          }
                                        },
                                      ),
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
                                  Icon(
                                    Icons.info_outlined,
                                    size: 25,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Book Info',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 17,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        ),
                                      ),
                                      Text(
                                        'Fill the basic book info',
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .outline,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              content: _bookInfo(),
                              isActive: _currentStep >= 0,
                              state: _currentStep >= 0
                                  ? StepState.complete
                                  : StepState.disabled,
                            ),
                            Step(
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.description_outlined,
                                    size: 25,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Description',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 17,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        ),
                                      ),
                                      Text(
                                        'Write the description of book',
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .outline,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              content: bookDescription(),
                              isActive: _currentStep >= 0,
                              state: _currentStep >= 1
                                  ? StepState.complete
                                  : StepState.disabled,
                            ),
                            Step(
                              title: Row(
                                children: [
                                  Icon(
                                    Icons.sell_outlined,
                                    size: 25,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Pricing',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 17,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        ),
                                      ),
                                      Text(
                                        'Write the price you want to sell the book at',
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .outline,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              content: bookPricing(),
                              isActive: _currentStep >= 0,
                              state: _currentStep >= 2
                                  ? StepState.complete
                                  : StepState.disabled,
                            ),
                            Step(
                              title: Row(
                                children: [
                                  Icon(
                                    Icons.rule_outlined,
                                    size: 25,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Book Condition',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 17,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        ),
                                      ),
                                      Text(
                                        'Select the condition of the book',
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .outline,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              content: bookCondition(),
                              isActive: _currentStep >= 0,
                              state: _currentStep >= 3
                                  ? StepState.complete
                                  : StepState.disabled,
                            ),
                            Step(
                              title: Row(
                                children: [
                                  Icon(
                                    Icons.image_outlined,
                                    size: 25,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Book Images',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 17,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        ),
                                      ),
                                      Text(
                                        'Upload the images of the book',
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .outline,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
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
          ),
        ),
      ),
    );
  }

  switchStepsType() {
    setState(() => _stepperType == StepperType.horizontal
        ? _stepperType = StepperType.vertical
        : _stepperType = StepperType.horizontal);
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

  Widget _bookInfo() {
    return Column(
      children: [
        Row(
          children: [
            Text(
              switchText,
              style: TextStyle(
                color: Theme.of(context).inputDecorationTheme.fillColor,
              ),
            ),
            Checkbox(
              value: _hasISBN,
              onChanged: (value) {
                setState(
                  () {
                    if (_hasISBN == true) {
                      _hasISBN = false;
                      switchText = 'Book dosen\'t have ISBN number';
                    } else {
                      _hasISBN = true;
                      switchText = 'Book has ISBN number';
                    }
                  },
                );
              },
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: InkWell(
            onTap: () {
              DialogsManager(context).showWhatIsIsbnDialog();
            },
            child: Text(
              'What is ISBN number?',
              textAlign: TextAlign.end,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Visibility(
          visible: _hasISBN,
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      style: GoogleFonts.ibmPlexMono(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Theme.of(context).inputDecorationTheme.fillColor,
                      ),
                      decoration: InputDecoration(
                          labelStyle: GoogleFonts.ibmPlexMono(
                            fontWeight: FontWeight.normal,
                          ),
                          hintStyle: GoogleFonts.ibmPlexMono(
                            fontWeight: FontWeight.normal,
                          ),
                          labelText: "ISBN",
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(),
                          ),
                          prefixIcon: const Icon(Icons.fingerprint)),
                      controller: _isbnController,
                      validator: (val) {
                        if (val!.isEmpty || val.characters.isEmpty) {
                          return "ISBN cannot be empty.";
                        } else {
                          if (val.length < 10 || val.length > 13) {
                            return "ISBN should be of 10 or"
                                " 13 digits";
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
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        TextFormField(
          style: TextStyle(
            color: Theme.of(context).inputDecorationTheme.fillColor,
          ),
          decoration: InputDecoration(
              labelText: "Book Name",
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(),
              ),
              prefixIcon: const Icon(Icons.menu_book)
              //fillColor: Colors.green
              ),
          controller: _bookNameController,
          validator: (val) {
            if (val!.characters.toString().trim().isEmpty) {
              return "Book name cannot be empty.";
            } else {
              if (val.characters.toString().trim().length < 2) {
                return "Book name is not valid.";
              } else {
                return null;
              }
            }
          },
          keyboardType: TextInputType.text,
        ),
        const SizedBox(
          height: 20,
        ),
        TextFormField(
          style: TextStyle(
            color: Theme.of(context).inputDecorationTheme.fillColor,
          ),
          decoration: InputDecoration(
              labelText: "Author",
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(),
              ),
              prefixIcon: const Icon(Icons.account_circle)
              //fillColor: Colors.green
              ),
          controller: _bookAuthorController,
          validator: (val) {
            if (val!.characters.toString().trim().isEmpty) {
              return "Author cannot be empty.";
            } else {
              if (val.characters.toString().trim().length < 2) {
                return "Author is not valid.";
              } else {
                return null;
              }
            }
          },
          keyboardType: TextInputType.text,
        ),
        const SizedBox(
          height: 20,
        ),
        TextFormField(
          style: TextStyle(
            color: Theme.of(context).inputDecorationTheme.fillColor,
          ),
          decoration: InputDecoration(
              labelText: "Publisher",
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(),
              ),
              prefixIcon: const Icon(Icons.public)
              //fillColor: Colors.green
              ),
          controller: _bookPublisherController,
          validator: (val) {
            if (val!.characters.toString().trim().isEmpty) {
              return "Publisher cannot be empty.";
            } else {
              if (val.characters.toString().trim().length < 2) {
                return "Publisher is not valid.";
              } else {
                return null;
              }
            }
          },
          keyboardType: TextInputType.text,
        ),
      ],
    );
  }

  Widget bookDescription() {
    return TextFormField(
      style: TextStyle(
        color: Theme.of(context).inputDecorationTheme.fillColor,
      ),
      decoration: InputDecoration(
        labelText: "Description",
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(),
        ),
      ),
      maxLines: null,
      controller: _bookDescriptionController,
      validator: (val) {
        if (val!.characters.toString().trim().isEmpty) {
          return "Description cannot be empty.";
        } else {
          if (val.characters.toString().trim().length < 10) {
            return "Description is not valid.";
          } else {
            return null;
          }
        }
      },
      keyboardType: TextInputType.multiline,
    );
  }

  Widget bookPricing() {
    return Container(
      height: 200,
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(
        top: 10,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: TextFormField(
              style: TextStyle(
                color: Theme.of(context).inputDecorationTheme.fillColor,
              ),
              decoration: InputDecoration(
                  labelText: "Original Price",
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(),
                  ),
                  prefixIcon: const Icon(Icons.sell)
                  //fillColor: Colors.green
                  ),
              controller: _bookOriginalPriceController,
              validator: (val) {
                if (val!.isEmpty || val.characters.isEmpty) {
                  return "Original Price cannot be empty.";
                } else {
                  if (val.isEmpty || val.characters.isEmpty) {
                    return "Original Price is not valid.";
                  } else {
                    return null;
                  }
                }
              },
              keyboardType: TextInputType.number,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: TextFormField(
              style: TextStyle(
                color: Theme.of(context).inputDecorationTheme.fillColor,
              ),
              decoration: InputDecoration(
                  labelText: "Selling Price",
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(),
                  ),
                  prefixIcon: const Icon(Icons.sell)
                  //fillColor: Colors.green
                  ),
              controller: _bookSellingPriceController,
              validator: (val) {
                if (val!.isEmpty || val.characters.isEmpty) {
                  return "Selling Price cannot be empty.";
                } else {
                  if (val.isEmpty || val.characters.isEmpty) {
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
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        TextFormField(
          style: TextStyle(
            color: Theme.of(context).inputDecorationTheme.fillColor,
          ),
          decoration: InputDecoration(
              labelText: "Book Name",
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(),
              ),
              prefixIcon: const Icon(Icons.menu_book)
              //fillColor: Colors.green
              ),
          controller: _bookNameController,
          validator: (val) {
            if (val!.isEmpty) {
              return "Book name cannot be empty.";
            } else {
              if (val.length < 5) {
                return "Book name is not valid.";
              } else {
                return null;
              }
            }
          },
          keyboardType: TextInputType.text,
        ),
        const SizedBox(
          height: 20,
        ),
        TextFormField(
          style: TextStyle(
            color: Theme.of(context).inputDecorationTheme.fillColor,
          ),
          decoration: InputDecoration(
              labelText: "Author",
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(),
              ),
              prefixIcon: const Icon(Icons.account_circle)
              //fillColor: Colors.green
              ),
          controller: _bookAuthorController,
          validator: (val) {
            if (val!.isEmpty) {
              return "Author cannot be empty.";
            } else {
              if (val.length < 5) {
                return "Author is not valid.";
              } else {
                return null;
              }
            }
          },
          keyboardType: TextInputType.text,
        ),
        const SizedBox(
          height: 20,
        ),
        TextFormField(
          style: TextStyle(
            color: Theme.of(context).inputDecorationTheme.fillColor,
          ),
          decoration: InputDecoration(
              labelText: "Publisher",
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(),
              ),
              prefixIcon: const Icon(Icons.public)
              //fillColor: Colors.green
              ),
          controller: _bookPublisherController,
          validator: (val) {
            if (val!.isEmpty) {
              return "Publisher cannot be empty.";
            } else {
              if (val.length < 5) {
                return "Publisher is not valid.";
              } else {
                return null;
              }
            }
          },
          keyboardType: TextInputType.text,
        ),
        const SizedBox(
          height: 10,
        ),
        TextFormField(
          style: TextStyle(
            color: Theme.of(context).inputDecorationTheme.fillColor,
          ),
          decoration: InputDecoration(
            labelText: "Description",
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(),
            ),
          ),
          maxLines: null,
          controller: _bookDescriptionController,
          validator: (val) {
            if (val!.isEmpty) {
              return "Description cannot be empty.";
            } else {
              if (val.length < 5) {
                return "Description is not valid.";
              } else {
                return null;
              }
            }
          },
          keyboardType: TextInputType.multiline,
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }

  Widget bookCondition() {
    return Container(
      padding: const EdgeInsets.only(
        top: 20,
      ),
      child: Column(
        children: [
          Container(
            height: 65,
            padding: const EdgeInsets.only(
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
                    color: Theme.of(context).inputDecorationTheme.fillColor,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                DropdownButton<String>(
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onBackground,
                      fontFamily: 'Poppins'),
                  borderRadius:
                      BorderRadius.circular(ValuesConstant.borderRadius),
                  alignment: AlignmentDirectional.topCenter,
                  items: StringConstants.listBookCondition
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                      ),
                    );
                  }).toList(),
                  hint: const Text(
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
            child: const SizedBox(
              height: 10,
            ),
          ),
          Visibility(
            visible: !_isBookConditionSelected,
            child: const Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: EdgeInsets.only(
                  left: 10,
                ),
                child: Text(
                  StringConstants.hintSelectBookCondition,
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
    return SizedBox(
      height: 450,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  Visibility(
                    visible: !_showBookImage1,
                    child: ImagePlaceholder(
                      onPressed: () async {
                        BottomSheetManager(context).imagePickerBottomSheet(
                            onCameraPressed: () async {
                          final pickedImage =
                              await ImageHandler(context).picImage(
                            source: ImageSource.camera,
                            imageURI: _imageUrl1,
                            aspectRatioX: 9,
                            aspectRatioY: 16,
                            cropStyle: CropStyle.rectangle,
                          );
                          setState(() {
                            _imageUrl1 = pickedImage;
                            _isImage1Selected = true;
                            _showBookImage1 = true;
                          });
                          Navigator.pop(context);
                        }, onGalleryPressed: () async {
                          final pickedImage =
                              await ImageHandler(context).picImage(
                            source: ImageSource.gallery,
                            imageURI: _imageUrl1,
                            aspectRatioX: 9,
                            aspectRatioY: 16,
                            cropStyle: CropStyle.rectangle,
                          );
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
              Column(
                children: [
                  Visibility(
                    visible: !_showBookImage2,
                    child: ImagePlaceholder(
                      onPressed: () async {
                        BottomSheetManager(context).imagePickerBottomSheet(
                            onCameraPressed: () async {
                          final pickedImage =
                              await ImageHandler(context).picImage(
                            source: ImageSource.camera,
                            imageURI: _imageUrl2,
                            aspectRatioX: 9,
                            aspectRatioY: 16,
                            cropStyle: CropStyle.rectangle,
                          );
                          setState(() {
                            _imageUrl2 = pickedImage;
                            _isImage2Selected = true;
                            _showBookImage2 = true;
                          });
                          Navigator.pop(context);
                        }, onGalleryPressed: () async {
                          final pickedImage =
                              await ImageHandler(context).picImage(
                            source: ImageSource.gallery,
                            imageURI: _imageUrl2,
                            aspectRatioX: 9,
                            aspectRatioY: 16,
                            cropStyle: CropStyle.rectangle,
                          );
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
                            builder: (BuildContext context) => ImageViewer(
                              imageURl: _imageUrl2,
                            ),
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
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  Visibility(
                    visible: !_showBookImage3,
                    child: ImagePlaceholder(
                      onPressed: () async {
                        BottomSheetManager(context).imagePickerBottomSheet(
                            onCameraPressed: () async {
                          final pickedImage =
                              await ImageHandler(context).picImage(
                            source: ImageSource.camera,
                            imageURI: _imageUrl3,
                            aspectRatioX: 9,
                            aspectRatioY: 16,
                            cropStyle: CropStyle.rectangle,
                          );
                          setState(() {
                            _imageUrl3 = pickedImage;
                            _isImage3Selected = true;
                            _showBookImage3 = true;
                          });
                          Navigator.pop(context);
                        }, onGalleryPressed: () async {
                          final pickedImage =
                              await ImageHandler(context).picImage(
                            source: ImageSource.gallery,
                            imageURI: _imageUrl3,
                            aspectRatioX: 9,
                            aspectRatioY: 16,
                            cropStyle: CropStyle.rectangle,
                          );
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
              Column(
                children: [
                  Visibility(
                    visible: !_showBookImage4,
                    child: ImagePlaceholder(
                      onPressed: () async {
                        BottomSheetManager(context).imagePickerBottomSheet(
                            onCameraPressed: () async {
                          final pickedImage =
                              await ImageHandler(context).picImage(
                            source: ImageSource.camera,
                            imageURI: _imageUrl4,
                            aspectRatioX: 9,
                            aspectRatioY: 16,
                            cropStyle: CropStyle.rectangle,
                          );
                          setState(() {
                            _imageUrl4 = pickedImage;
                            _isImage4Selected = true;
                            _showBookImage4 = true;
                          });
                          Navigator.pop(context);
                        }, onGalleryPressed: () async {
                          final pickedImage =
                              await ImageHandler(context).picImage(
                            source: ImageSource.gallery,
                            imageURI: _imageUrl4,
                            aspectRatioX: 9,
                            aspectRatioY: 16,
                            cropStyle: CropStyle.rectangle,
                          );
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
            ],
          )
        ],
      ),
    );
  }
}
