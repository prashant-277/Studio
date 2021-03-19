import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../constants.dart';
import '../courses_store.dart';
import '../models/book.dart';
import '../models/course.dart';
import 'edit_book_screen.dart';

class BooksScreen extends StatefulWidget {
  static String id = 'courses_screen';
  final CoursesStore store;
  const BooksScreen(this.store);

  @override
  _BooksScreenState createState() => _BooksScreenState();
}

class _BooksScreenState extends State<BooksScreen>
    with SingleTickerProviderStateMixin {

  int _currentIndex = 0;

  @override
  void initState() {
    widget.store.loadBooks(widget.store.course.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: IconThemeData(color: kDarkBlue),
          centerTitle: true,
          elevation: 0,
          title: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Text(
              'My books',
              style: TextStyle(
                color: kDarkBlue
              ),
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(34.0),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
              child: Center(
                child:
                Text(widget.store.course.name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: kDarkBlue.withAlpha(200)
                  ),
                ),
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
          backgroundColor: kPrimaryColor,
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(
                builder: (context) => EditBookScreen(widget.store, widget.store.course, null)
            ));
          },
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: BookItemsView(widget.store, widget.store.course),
          ),
        )
    );
  }
}

class BookItemsView extends StatelessWidget {
  const BookItemsView(this.store, this.course);

  final CoursesStore store;
  final Course course;

  @override
  Widget build(BuildContext context) => Observer(builder: (_) {
    return ModalProgressHUD(
      color: kLightGrey,
      child: resultWidget(context, store.books),
      inAsyncCall: store.isBooksLoading,
    );
  });

  resultWidget(BuildContext context, List<Book> items) {

    if (!store.isBooksLoading && items.length == 0) {
      return Column(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'No books yet, let\'s start with the first one!',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Image(
              image: AssetImage('assets/images/book.png'),
            ),
          ),
          Expanded(
            child: Container(),
          )
        ],
      );
    }

    return ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: items.length,
        itemBuilder: (_, index) {
          final item = items[index];
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(10),
                      blurRadius: 20.0, // has the effect of softening the shadow
                      spreadRadius: 10.0, // has the effect of extending the shadow
                      offset: Offset(
                        0.0, // horizontal, move right 10
                        0.0, // vertical, move down 10
                      ),
                    )
                  ]
              ),
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
              margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                trailing: PopupMenuButton<int>(
                  offset: Offset(0, 90),
                  elevation: 20,
                  onSelected: (int) {
                    if(int == kActionEdit) {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) => EditBookScreen(store, course, item)
                      )
                      );
                    }
                    if(int == kActionDelete) {
                      showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: Text(item.title),
                            content: Text('Do you really want to delete this book?'),
                            actions: <Widget>[
                              FlatButton(
                                onPressed: () async {
                                  Navigator.maybePop(context);
                                  await store.deleteBook(item.id);
                                  store.loadBooks(course.id);
                                },
                                child: Text('Delete'),
                                textColor: Colors.red,
                              ),
                              FlatButton(
                                child: Text('No'),
                                onPressed: () async {
                                  Navigator.maybePop(context);
                                },
                              )
                            ],
                          ));
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: kActionEdit,
                      child: Text(
                        "Edit book",
                        style: TextStyle(
                          color: kDarkGrey,
                        ),
                      ),
                    ),
                    PopupMenuItem(
                      value: kActionDelete,
                      child: Text(
                        "Delete book",
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                  child: Icon(Icons.more_vert),
                ),
                title: Container(
                  child: Text(
                    item.title,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
