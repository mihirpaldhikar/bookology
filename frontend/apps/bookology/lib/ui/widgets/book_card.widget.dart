import 'package:auto_size_text/auto_size_text.dart';
import 'package:bookology/constants/colors.constant.dart';
import 'package:bookology/constants/values.constants.dart';
import 'package:bookology/ui/widgets/outlined_button.widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class BookCard extends StatefulWidget {
  final String bookID;
  final String bookName;
  final String bookAuthor;
  final String originalPrice;
  final String sellingPrice;
  final String coverImageURL;
  final VoidCallback onClicked;

  const BookCard({
    Key? key,
    required this.bookID,
    required this.bookName,
    required this.originalPrice,
    required this.sellingPrice,
    required this.coverImageURL,
    required this.bookAuthor,
    required this.onClicked,
  }) : super(key: key);

  @override
  _BookCardState createState() => _BookCardState();
}

class _BookCardState extends State<BookCard> {
  @override
  Widget build(BuildContext context) {
    int saving =
        int.parse(widget.originalPrice) - int.parse(widget.sellingPrice);
    return Hero(
      tag: widget.bookID,
      child: Material(
        color: Colors.white,
        child: GestureDetector(
          onTap: widget.onClicked,
          child: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.only(
                top: 10,
                bottom: 10,
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: Colors.grey,
                    width: 1,
                  ),
                  color: Colors.white),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      imageUrl: this.widget.coverImageURL,
                      placeholder: (context, url) => Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.grey,
                          ),
                          strokeWidth: 2,
                        ),
                      ),
                      fit: BoxFit.fill,
                      height: MediaQuery.of(context).size.height * 0.26,
                      width: 150,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Spacer(),
                            Container(
                              padding: EdgeInsets.all(3),
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
                                Icons.more_vert_outlined,
                              ),
                            ),
                          ],
                        ),
                        AutoSizeText(
                          this.widget.bookName,
                          maxLines: 4,
                          softWrap: false,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        AutoSizeText(
                          'By ${this.widget.bookAuthor}',
                          maxLines: 4,
                          softWrap: false,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 13,
                              color: Colors.grey[600]),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            AutoSizeText(
                              'Price:',
                              maxLines: 4,
                              softWrap: false,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            AutoSizeText(
                              this.widget.sellingPrice,
                              maxLines: 4,
                              softWrap: false,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            AutoSizeText(
                              this.widget.originalPrice,
                              maxLines: 4,
                              softWrap: false,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 15,
                                  decoration: TextDecoration.lineThrough,
                                  color: Colors.grey),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        AutoSizeText(
                          'You Save ${saving.toString()}',
                          maxLines: 4,
                          softWrap: false,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: Colors.green,
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.04,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: OutLinedButton(
                            child: Center(
                              child: Text(
                                'View',
                              ),
                            ),
                            outlineColor: Theme.of(context).accentColor,
                            backgroundColor: ColorsConstant.SECONDARY_COLOR,
                            onPressed: widget.onClicked,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              )),
        ),
      ),
    );
  }
}
