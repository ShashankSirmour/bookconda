import 'package:book/util/color/hex_code.dart';
import "package:flutter/material.dart";

GlobalKey<FormState> _formKey = GlobalKey<FormState>();

String searchText;

class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: FractionalOffset(0.0, 0.4),
                end: FractionalOffset(0.9, 0.7),
                // Add one stop for each color. Stops should increase from 0 to 1
                stops: [0.1, 0.9],
                colors: [HexColor("#ECE9E6"), HexColor("#FFFFFF")],
              ),
            ),
            child: SizedBox(
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Center(
              child: ListView(
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                children: <Widget>[
                  Center(
                    child: Icon(
                      Icons.search,
                      size: 120,
                    ),
                  ),
                  headlinesWidget(),
                  buildForm(),
                  searchButtonWidget(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Form buildForm() {
    return Form(
      key: _formKey,
      child: searchTextFieldWidget(),
    );
  }
}

Widget searchTextFieldWidget() {
  return Container(
    margin: EdgeInsets.only(left: 16.0, right: 32.0, top: 32.0),
    decoration: BoxDecoration(
      boxShadow: [
        BoxShadow(
            color: Colors.black12,
            blurRadius: 15,
            spreadRadius: 0,
            offset: Offset(0.0, 16.0)),
      ],
      borderRadius: new BorderRadius.circular(12.0),
      gradient: LinearGradient(
        begin: FractionalOffset(0.0, 0.4),
        end: FractionalOffset(0.9, 0.7),
        stops: [0.2, 0.9],
        colors: [
          HexColor("#CFDEF3").withOpacity(0.8),
          HexColor("#E0EAFC").withOpacity(0.8),
        ],
      ),
    ),
    child: TextFormField(
      keyboardType: TextInputType.text,
      cursorColor: Colors.black,
      style: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 16.0,
      ),
      decoration: InputDecoration(
        suffixIcon: Icon(
          Icons.edit,
          color: Colors.black,
          size: 30.0,
        ),
        contentPadding: EdgeInsets.fromLTRB(40.0, 30.0, 10.0, 10.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide.none,
        ),
        hintText: 'Search...',
        hintStyle: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 16.0,
        ),
      ),
      onSaved: (String s) {
        searchText = s;
      },
    ),
  );
}

Widget headlinesWidget() {
  return Container(
      margin: EdgeInsets.only(top: 22.0, bottom: 22.0),
      child: Center(
        child: Text(
          'SEARCH HERE',
          textAlign: TextAlign.left,
          style: TextStyle(
            letterSpacing: 3,
            fontSize: 20.0,
            fontFamily: 'orbitron',
            fontWeight: FontWeight.bold,
          ),
        ),
      ));
}

Widget searchButtonWidget(BuildContext context) {
  return Container(
    margin: EdgeInsets.only(left: 32.0, top: 32.0),
    child: Row(
      children: <Widget>[
        InkWell(
          onTap: () {
            _formKey.currentState.save();
            if (searchText.length > 3)
              Navigator.pushNamed(context, '/search/' + searchText);
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 36.0, vertical: 16.0),
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: Colors.black12,
                      blurRadius: 15,
                      spreadRadius: 0,
                      offset: Offset(0.0, 32.0)),
                ],
                borderRadius: new BorderRadius.circular(36.0),
                gradient:
                    LinearGradient(begin: FractionalOffset.centerLeft, stops: [
                  0.2,
                  1
                ], colors: [
                  Color(0xff000000),
                  Color(0xff434343),
                ])),
            child: Text(
              'SEARCH',
              style: TextStyle(
                color: Color(0xffF1EA94),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

final TextStyle hintAndValueStyle = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.bold,
  fontSize: 16.0,
);
