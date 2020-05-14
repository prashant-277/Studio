import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:studio/courses_store.dart';
import 'package:studio/models/book.dart';
import 'package:studio/models/course.dart';
import 'package:studio/widgets/drawer.dart';

import '../constants.dart';
import 'edit_book_screen.dart';

class BooksScreen extends StatefulWidget {
  static String id = 'courses_screen';
  final CoursesStore store;
  final Course course;
  const BooksScreen(this.store, this.course);

  @override
  _BooksScreenState createState() => _BooksScreenState();
}

class _BooksScreenState extends State<BooksScreen>
    with SingleTickerProviderStateMixin {

  int _currentIndex = 0;

  @override
  void initState() {
    widget.store.loadBooks(widget.course.id);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: kLightGrey,
        appBar: AppBar(
          iconTheme: IconThemeData(color: kDarkBlue),
          centerTitle: true,
          elevation: 0,
          title: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Text(
              'My courses',
            ),
          ),
        ),
        drawer: MainDrawer(widget.store),
        floatingActionButton: FloatingActionButton(
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
          backgroundColor: kPrimaryColor,
          onPressed: () {
            Navigator.pushNamed(context, EditBookScreen.id);
          },
        ),
        body: BooksView(widget.store)
    );
  }
}

class BooksView extends StatefulWidget {

  final CoursesStore store;
  BooksView(this.store);

  @override
  _BooksViewState createState() => _BooksViewState();
}

class _BooksViewState extends State<BooksView> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: BookItemsView(widget.store),
          )
        ],
      ),
    );
  }
}


class BookItemsView extends StatelessWidget {
  const BookItemsView(this.store);

  final CoursesStore store;

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
                'No courses yet, let\'s start with the first one!',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          ),
          Image(
            image: AssetImage('assets/images/study.png'),
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
                onTap: () {

                },

                trailing: const Icon(
                  Icons.chevron_right,
                  color: kDarkBlue,
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
