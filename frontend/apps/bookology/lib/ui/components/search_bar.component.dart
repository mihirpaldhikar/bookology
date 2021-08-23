import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:bookology/constants/colors.constant.dart';
import 'package:bookology/constants/values.constants.dart';
import 'package:bookology/services/auth.service.dart';
import 'package:bookology/services/cache.service.dart';
import 'package:bookology/ui/components/account_dialog.component.dart';
import 'package:bookology/ui/screens/create.screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';

class SearchBar extends StatefulWidget {
  const SearchBar({
    Key? key,
  }) : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final cacheService = CacheService();

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
      child: Container(
        margin: EdgeInsets.only(
          top: 10,
          left: 10,
          right: 10,
        ),
        decoration: BoxDecoration(
          borderRadius:
              BorderRadius.circular(ValuesConstant.SECONDARY_BORDER_RADIUS),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(0.0, 1.0),
              blurRadius: 2.0,
            )
          ],
          color: ColorsConstant.APP_BAR_COLOR,
        ),
        padding: EdgeInsets.only(
          left: 5,
          right: 5,
          top: 2,
          bottom: 2,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(Icons.menu_outlined),
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft:
                                Radius.circular(ValuesConstant.BORDER_RADIUS),
                            topRight:
                                Radius.circular(ValuesConstant.BORDER_RADIUS),
                          ),
                        ),
                        height: 500,
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          children: [
                            Container(
                              width: 50,
                              height: 3,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(50),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AccountDialog(
                                    username:
                                        cacheService.getCurrentUserNameCache(),
                                    displayName: auth
                                        .currentUser()!
                                        .displayName
                                        .toString(),
                                    isVerified: cacheService
                                        .getCurrentIsVerifiedCache(),
                                    profileImageURL:
                                        auth.currentUser()!.photoURL.toString(),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    });
              },
            ),
            SizedBox(
              width: 5,
            ),
            Expanded(
              child: TypeAheadField(
                textFieldConfiguration: TextFieldConfiguration(
                  autofocus: false,
                  style: DefaultTextStyle.of(context).style.copyWith(
                        fontStyle: FontStyle.normal,
                      ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    hintText: 'Search',
                    hintStyle: TextStyle(
                      color: Colors.grey[500],
                    ),
                  ),
                ),
                suggestionsCallback: (pattern) {
                  return CitiesService.getSuggestions(pattern);
                },
                itemBuilder: (context, String suggestion) {
                  return Container(
                    padding: EdgeInsets.only(
                      top: 10,
                      left: 20,
                      right: 20,
                      bottom: 10,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white,
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.search_outlined),
                        SizedBox(
                          width: 20,
                        ),
                        AutoSizeText(
                          suggestion,
                          maxLines: 4,
                          softWrap: false,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Expanded(child: Container()),
                        Icon(
                          Icons.open_in_new_outlined,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  );
                },
                suggestionsBoxDecoration: SuggestionsBoxDecoration(
                  color: Colors.white,
                  clipBehavior: Clip.antiAlias,
                  borderRadius: BorderRadius.circular(15),
                  constraints: BoxConstraints(
                    maxHeight: 400,
                    maxWidth: MediaQuery.of(context).size.width * 0.96,
                    minWidth: MediaQuery.of(context).size.width * 0.96,
                  ),
                  offsetX: -60,
                  hasScrollbar: false,
                ),
                onSuggestionSelected: (suggestion) {
                  print('LOL');
                },
              ),
            ),
            Tooltip(
              message: 'Create new Book',
              child: SizedBox(
                width: 70,
                child: IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreateScreen(),
                      ),
                    );
                  },
                  icon: Container(
                    width: 40,
                    height: 40,
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: ColorsConstant.SECONDARY_COLOR,
                      borderRadius: BorderRadius.circular(
                          ValuesConstant.SECONDARY_BORDER_RADIUS),
                      border: Border.all(
                        color: Theme.of(context).accentColor,
                        width: 1,
                      ),
                    ),
                    child: Icon(
                      Icons.add,
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BackendService {
  static Future<List<Map<String, String>>> getSuggestions(String query) async {
    await Future.delayed(Duration(seconds: 1));

    return List.generate(3, (index) {
      return {
        'name': query + index.toString(),
        'price': Random().nextInt(100).toString()
      };
    });
  }
}

class CitiesService {
  static final List<String> cities = [
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

  static List<String> getSuggestions(String query) {
    List<String> matches = <String>[];
    matches.addAll(cities);

    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }
}
