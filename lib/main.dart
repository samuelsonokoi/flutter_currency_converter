import 'package:currency_converter/widgets/drop_down.dart';
import 'package:flutter/material.dart';
import './services/api_client.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Currency Calculator',
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // Setting app main colors
  Color primaryColor = Color(0xFF212936);
  Color secondaryColor = Color(0xFF2849E5);

  // setting the variables
  List<String> currencies;
  String from;
  String to;

  // variable for exchange rate
  double rate;
  String result = '';

  // create an instance of the api client
  ApiClient apiClient = ApiClient();

  @override
  void initState() {
    super.initState();

    (() async {
      List<String> list = await apiClient.getCurrencies();
      setState(() {
        currencies = list;
      });
    })();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 200.0,
                child: Text(
                  'Currency Converter',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // set the text field
                      TextField(
                        onSubmitted: (value) async {
                          // call function to submit request
                          rate = await apiClient.getRate(
                              from, to, double.parse(value));
                          setState(() {
                            result = rate.toStringAsFixed(3);
                          });
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          labelText: 'Input value to convert',
                          labelStyle: TextStyle(
                            color: secondaryColor,
                            fontWeight: FontWeight.normal,
                            fontSize: 18.0,
                          ),
                        ),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 27.0,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.start,
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          customDropDown(
                            currencies,
                            from,
                            (val) => {
                              setState(() => {from = val})
                            },
                          ),
                          FloatingActionButton(
                            onPressed: () {
                              String temp = from;
                              setState(() {
                                from = to;
                                to = temp;
                              });
                            },
                            child: Icon(Icons.swap_horiz),
                            elevation: 0.0,
                            backgroundColor: secondaryColor,
                          ),
                          customDropDown(
                            currencies,
                            to,
                            (val) => {
                              setState(() {
                                to = val;
                              }),
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 50.0),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Column(children: [
                          Text(
                            "Result",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            result,
                            style: TextStyle(
                              color: secondaryColor,
                              fontSize: 36.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ]),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
