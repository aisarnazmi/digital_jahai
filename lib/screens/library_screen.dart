import 'package:flutter/material.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({Key? key}) : super(key: key);

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}



class _LibraryScreenState extends State<LibraryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.indigo[800],
        ),
        child: Column(
          
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 80, 30, 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const <Widget>[
                  Text(
                    'Digital Language Repository',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Jahai  ~  Malay',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40)),
                    color: Colors.grey[50],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(30, 25, 30, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Jahai Term',
                            // errorText: 'Error message',
                            border: OutlineInputBorder(
                               borderRadius: const BorderRadius.all(Radius.circular(15.0)),
                            ),
                            // suffixIcon: Icon(
                            //   Icons.error,
                            // ),
                          ),
                        ),
                        SizedBox(height: 25.0),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Malay Term',
                            // errorText: 'Error message',
                            border: OutlineInputBorder(
                               borderRadius: const BorderRadius.all(Radius.circular(15.0)),
                            ),
                            // suffixIcon: Icon(
                            //   Icons.error,
                            // ),
                          ),
                        ),
                        SizedBox(height: 25.0),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'English Term',
                            // errorText: 'Error message',
                            border: OutlineInputBorder(
                               borderRadius: const BorderRadius.all(Radius.circular(15.0)),
                            ),
                            // suffixIcon: Icon(
                            //   Icons.error,
                            // ),
                          ),
                        ),
                        SizedBox(height: 25.0),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Category',
                            // errorText: 'Error message',
                            border: OutlineInputBorder(
                               borderRadius: const BorderRadius.all(Radius.circular(15.0)),
                            ),
                            // suffixIcon: Icon(
                            //   Icons.error,
                            // ),
                          ),
                        ),
                        SizedBox(height: 25.0),
                        TextFormField(
                          minLines: 4,
                          maxLines: 4,
                          decoration: InputDecoration(
                            labelText: 'Description',
                            border: OutlineInputBorder(
                               borderRadius: const BorderRadius.all(Radius.circular(15.0)),
                            ),
                            // suffixIcon: Icon(
                            //   Icons.error,
                            // ),
                          ),
                        ),
                        SizedBox(height: 25.0),
                      ],
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}


