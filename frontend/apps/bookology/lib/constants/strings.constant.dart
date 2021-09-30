/*
 * Copyright 2021 Mihir Paldhikar
 *
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the "Software"),
 *  to deal in the Software without restriction, including without limitation the rights
 *  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
 *  the Software, and to permit persons to whom the Software is furnished to do so,
 *  subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 *  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
 *  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR
 *  ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
 *  CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
 *  WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

class StringConstants {
  // App Constants
  static const String appName = 'Bookology';
  static const String appSlogan = 'Find the books nearby.';
  static const String appUpdateAvailable = 'An App update is available.';
  static const String appCopyright = 'Copyright \u00a9 2021 Mihir Paldhikar';

  // Urls Constants
  static const String urlPrivacyPolicy =
      'https://bookology.tech/privacy-policy';

  // Words Constants
  static const String wordDelete = 'Delete';
  static const String wordClose = 'Close';
  static const String wordLogout = 'Logout';
  static const String wordSignUp = 'Sign Up';
  static const String wordLogin = 'Login';
  static const String wordSupport = 'Support';
  static const String wordSearch = 'Search';
  static const String wordDone = 'Done';
  static const String wordContactUs = 'Contact Us';
  static const String wordOk = 'OK';
  static const String wordBy = 'By';
  static const String wordPrice = 'Price';
  static const String wordYouSave = 'You Save';
  static const String wordEnquire = 'Enquire';
  static const String wordAddToWishList = 'Add to Wish list';
  static const String wordBookLocation = 'Book Location';
  static const String wordDescription = 'Description';
  static const String wordBookDetails = 'Book Details';
  static const String wordViewProfile = 'View Profile';
  static const String wordIsbn = 'ISBN';
  static const String wordBookName = 'Book Name';
  static const String wordSellingPrice = 'Selling Price';
  static const String wordOriginalPrice = 'Original Price';
  static const String wordAuthor = 'Author';
  static const String wordUpload = 'Upload';
  static const String wordPublisher = 'Publisher';
  static const String wordBookCondition = 'Book Condition';
  static const String wordUploadDetails = 'Uploader Details';
  static const String wordUsername = 'Username';
  static const String wordName = 'Name';
  static const String wordCamera = 'Camera';
  static const String wordFile = 'File';
  static const String wordUploadedOn = 'Uploaded On';
  static const String wordUpdate = 'Update';
  static const String wordPoweredByFlutter = 'Powered By Flutter';
  static const String wordPrivacyPolicy = 'Privacy Policy';
  static const String wordCheckForUpdates = 'Check for Updates';
  static const String wordSendFeedback = 'Send Feedback';
  static const String wordAdvertisement = 'Advertisement';
  static const String wordNoDiscussions = 'No Discussions';
  static const String wordYou = 'You';

  // Navigation Constants
  static const String navigationHome = 'Home';
  static const String navigationNotifications = 'Notifications';
  static const String navigationProfile = 'Profile';
  static const String navigationDiscussions = 'Discussions';
  static const String navigationSearch = 'Search';
  static const String navigationConfirmation = 'Confirmation';
  static const String navigationEditProfile = 'Edit Profile';
  static const String navigationCompleteProfile = 'Complete Profile';

  // Hints Constants
  static const String hintCreateNewBook = 'Create new Book';
  static const String hintCreateNewAccount =
      'Create new Don\'t have an account?';
  static const String hintContinueWithGoogle = 'Continue With Google';
  static const String hintEditBook = 'Edit Book';
  static const String hintDeleteBook = 'Delete Book';
  static const String hintMoreOptions = 'More Options';
  static const String hintConnectionSecured = 'Connection is Secured';
  static const String hintShareBook = 'Share this book';
  static const String hintReportBook = 'Report this book';
  static const String hintSelectBookCondition = 'Please Select book Condition';

  // Error Constant
  static const String errorLoadingNotifications =
      'A problem occurred while loading the notifications';
  static const String errorUploadAllImages = 'Please Upload all Images';
  static const String errorOccurred = 'An error occurred.';

  // Dialog Constants
  static const String dialogDeleting = 'Deleting...';
  static const String dialogUploading = 'Uploading...';
  static const String dialogUpdating = 'Updating...';

  // Sentences Constants
  static const String sentenceEmptyDiscussion =
      'To Start a discussion, request book uploader to allow enquiry of the book.';
  static const String sentenceAppNotice =
      'No Part of the APP should be COPIED, MODIFIED, REDISTRIBUTED without the '
      'written agreement/license from the author MIHIR PALDHIKAR. \nBy doing any '
      'of the things written above is STRICTLY PROHIBITED and a Legal Offence. '
      '\nLegal Action Will be taken without any Prior Notice.';

  // List Constants

  static const List<String> listBookCondition = [
    'Select',
    'New',
    'Excellent',
    'Okay',
    'Bad',
  ];
  static const List<String> listCities = [
    'Beirut',
    'Damascus',
    'San Fransisco',
    'Rome',
    'Los Angeles',
    'Madrid',
    'Bali',
    'Barcelona',
    'Paris',
    'Bucharest',
    'New York City',
    'Philadelphia',
    'Sydney',
  ];
  static const List<String> listBookCategories = [
    'All',
    'Education & References',
    'Comics',
    'Science Fiction',
    'Novels',
    'Biography',
    'History',
    'Kids',
    'Mysteries',
  ];
  static const List<String> listSelectBookCategories = [
    'Education & References',
    'Comics',
    'Science Fiction',
    'Novels',
    'Biography',
    'History',
    'Kids',
    'Mysteries',
  ];

  // Map Constants
  static const Map<String, String> mapCurrencies = {
    'INR': '₹',
    'USD': '\$',
  };

  // Overflow Menu Constants
  static const Set<String> menuDeleteDiscussion = {
    'Delete Discussions',
  };
}
