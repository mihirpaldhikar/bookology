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
  static const String APP_NAME = 'Bookology';
  static const String APP_SLOGAN = 'Find the books nearby.';
  static const String APP_UPDATE_AVAILABLE = 'An App update is available.';
  static const String APP_COPYRIGHT = 'Copyright \u00a9 2021 Mihir Paldhikar';
  static const String APP_NOTICE =
      'No Part of the APP should be COPIED, MODIFIED, REDISTRIBUTED without the '
      'written agreement/license from the author MIHIR PALDHIKAR. \nBy doing any '
      'of the things written above is STRICTLY PROHIBITED and a Legal Offence. '
      '\nLegal Action Will be taken without any Prior Notice.';

  // Urls
  static const String APP_PRIVACY_POLICY_URL =
      'https://bookology.tech/privacy-policy';

  // Words Constants
  static const String DELETE = 'Delete';
  static const String CLOSE = 'Close';
  static const String LOGOUT = 'Logout';
  static const String SIGN_UP = 'Sign Up';
  static const String LOGIN = 'Login';
  static const String SUPPORT = 'Logout';
  static const String SEARCH = 'Search';
  static const String CONTACT_US = 'Contact Us';
  static const String OK = 'OK';
  static const String BY = 'By';
  static const String PRICE = 'Price';
  static const String YOU_SAVE = 'You Save';
  static const String ENQUIRE = 'Enquire';
  static const String ADD_TO_WISHLIST = 'Add to Wish list';
  static const String BOOK_LOCATION = 'Book Location';
  static const String DESCRIPTION = 'Description';
  static const String BOOK_DETAILS = 'Book Details';
  static const String VIEW_PROFILE = 'View Profile';
  static const String ISBN = 'ISBN';
  static const String BOOK_NAME = 'Book Name';
  static const String SELLING_PRICE = 'Selling Price';
  static const String ORIGINAL_PRICE = 'Original Price';
  static const String AUTHOR = 'Author';
  static const String UPLOAD = 'Upload';
  static const String PUBLISHER = 'Publisher';
  static const String BOOK_CONDITION = 'Book Condition';
  static const String UPLOADER_DETAILS = 'Uploader Details';
  static const String USERNAME = 'Username';
  static const String NAME = 'Name';
  static const String CAMERA = 'Camera';
  static const String FILE = 'File';
  static const String UPLOADED_ON = 'Uploaded On';
  static const String UPDATE = 'Update';
  static const String POWERED_BY_FLUTTER = 'Powered By Flutter';
  static const String PRIVACY_POLICY = 'Privacy Policy';
  static const String CHECK_FOR_UPDATED = 'Check for Updates';
  static const String SEND_FEEDBACK = 'Send Feedback';

  // Title Constants
  static const String TITLE_CONFIRMATION = 'Confirmation';

  // Navigation Constants
  static const String NAVIGATION_HOME = 'Home';
  static const String NAVIGATION_NOTIFICATIONS = 'Notifications';
  static const String NAVIGATION_PROFILE = 'Profile';
  static const String NAVIGATION_DISCUSSIONS = 'Discussions';
  static const String NAVIGATION_SEARCH = 'Search';

  // Hints Constants
  static const String HINT_CREATE_NEW_BOOK = 'Create new Book';
  static const String HINT_CREATE_NEW_ACCOUNT =
      'Create new Don\'t have an account?';
  static const String HINT_CONTINUE_WITH_GOOGLE = 'Continue With Google';
  static const String HINT_EDIT_BOOK = 'Edit Book';
  static const String HINT_DELETE_BOOK = 'Delete Book';
  static const String HINT_MORE_OPTIONS = 'More Options';
  static const String HINT_CONNECTION_SECURED = 'Connection is Secured';
  static const String HINT_SHARE_BOOK = 'Share this book';
  static const String HINT_REPORT_BOOK = 'Report this book';

  // Dialog Constants
  static const String DIALOG_DELETING = 'Deleting...';
  static const String DIALOG_UPLOADING = 'Uploading...';

  // List Constants
  static const List<String> CITIES = [
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
  static const List<String> BOOKS_CATEGORIES = [
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
  static const List<String> SELECT_BOOKS_CATEGORIES = [
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
  static const Map<String, String> CURRENCIES = {
    'INR': '₹',
    'USD': '\$',
  };

  // Overflow Menu Constants
  static const Set<String> MENU_DELETE_DISCUSSION = {
    'Delete Discussions',
  };
}
