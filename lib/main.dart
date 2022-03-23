import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
            child: HomeWidget(),
        ),
      ),
    );
  }
}

class HomeWidget extends StatelessWidget {
  const HomeWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Flexible(
          child: Container(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Is it Moscow?', style: TextStyle(fontSize: 32)),
              Text('Russia'),
            ],
          )),
        ),
        Flexible(
            flex: 4,
            child: SizedBox.expand(
              child: Container(
                  child: Padding(
                padding: const EdgeInsets.all(40.0),
                child: Card(
                    elevation: 10.0,
                    child: Container(
                      width: 300,
                      height: 300,
                      child: Image(
                        image: NetworkImage('https://images.unsplash.com/photo-1547448415-e9f5b28e570d'),
                      ),
                    )),
              )),
            )),
        Flexible(
          child: Container(
            child: Center(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkResponse(
                      child: Text(
                        'No',
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      onTap: () {},
                    ),
                    InkResponse(
                      child: Text(
                        'Yes',
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      onTap: () {},
                    ),
                  ]),
            ),
          ),
        )
      ],
    );
  }
}
