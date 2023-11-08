import 'package:flutter/material.dart';
import 'package:food_hunter/themes/color_scheme.dart';
import 'package:url_launcher/link.dart';

class PreservationPage extends StatefulWidget {
  final String itemKey;
  final String preservationKey;
  final Map<String, dynamic> preservationData;

  const PreservationPage({Key? key, required this.itemKey, required this.preservationKey, required this.preservationData}) : super(key: key);

  @override
  _PreservationPageState createState() => _PreservationPageState();
}

class _PreservationPageState extends State<PreservationPage> {

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    Map<String, dynamic> preservationInfo = widget.preservationData[widget.preservationKey];
    List<String> ingredients = List<String>.from(preservationInfo['ingredients']);
    List<String> instructions = List<String>.from(preservationInfo['process']);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'PRESERVATION INFO'
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                constraints: const BoxConstraints(
                  maxHeight: 500
                ),
                child: Hero(
                  tag: '${widget.itemKey}_${widget.preservationKey}',
                  child: Material(
                    elevation: 10,
                    child: Image(
                      image: AssetImage('assets/pics/foods/preservation/${widget.itemKey}_${widget.preservationKey}.jpg'),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    preservationInfo['name'],
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: FHColorScheme.secondaryColor
                    )
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    preservationInfo['description'],
                    textAlign: TextAlign.justify,
                    style: const TextStyle(
                      fontSize: 18,
                    )
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                    'INGREDIENTS',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: FHColorScheme.secondaryColor
                    ),
                  )
                )
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: ingredients.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        const Icon(
                          Icons.brightness_1,
                          size: 8,
                          color: FHColorScheme.primaryColor,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            ingredients[index],
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                    'INSTRUCTIONS',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: FHColorScheme.secondaryColor
                    ),
                  )
                )
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: instructions.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          '${index + 1}.',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: FHColorScheme.primaryColor
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            instructions[index],
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      const Text(
                        'REFERENCES: ',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: FHColorScheme.secondaryColor,
                        ),
                      ),
                      Link(
                        uri: Uri.parse(preservationInfo['src']),
                        builder: (context, followLink) {
                          return InkWell(
                            onTap: followLink,
                            child: const Text(
                              'Link',
                              style: TextStyle(
                                fontSize: 18,
                                color: FHColorScheme.primaryColor,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          );
                        },
                      ),
                    ]
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
