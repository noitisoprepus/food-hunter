import 'package:flutter/material.dart';
import 'package:food_hunter/pages/preservation.dart';

class FoodPage extends StatefulWidget {
  final String itemKey;
  final Map<String, dynamic> itemData;

  const FoodPage({Key? key, required this.itemKey, required this.itemData}) : super(key: key);

  @override
  _FoodPageState createState() => _FoodPageState();
}

class _FoodPageState extends State<FoodPage> {
  final List<String> informationEntries = [
    'Picture 1',
    'Picture 2',
    'Picture 3',
    // Add more information entries here
  ];

  int selectedInformationIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    _pageController.addListener(() {
      setState(() {
        selectedInformationIndex = _pageController.page?.round() ?? 0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    Map<String, dynamic> foodData = widget.itemData;
    Map<String, dynamic> nutrients = foodData['nutrients'] as Map<String, dynamic>;
    nutrients.remove('src');

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: SizedBox(
                  height: 220,
                  child: PageView.builder(
                    controller: _pageController,
                    scrollDirection: Axis.horizontal,
                    itemCount: informationEntries.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Row(
                        children: [
                          Hero(
                            tag: widget.itemKey,
                            child: Container(
                              width: screenWidth,
                              decoration: const BoxDecoration(
                                  color: Colors.blue),
                              child: Material(
                                type: MaterialType.transparency,
                                child: Center(
                                  child: Text(
                                    informationEntries[index],
                                    style: const TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
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
                    foodData['name'],
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    )
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    foodData['binomial'],
                    style: const TextStyle(
                      fontSize: 20,
                      fontStyle: FontStyle.italic,
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
                    'PRESERVATION METHODS',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                    ),
                  )
                )
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 160,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  itemBuilder: (BuildContext context, int index) {
      
                    bool isFirst = index == 0;
                    bool isLast = index == 4; // Change accordingly
      
                    return Row(
                      children: [
                        SizedBox(width: isFirst ? 16.0 : 8.0),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PreservationPage(itemKey: widget.itemKey, itemData: widget.itemData),
                              ),
                            );
                          },
                          child: Hero(
                            tag: 'method$index',
                            child: Container(
                              width: 120,
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  'Method $index',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: isLast ? 16.0 : 8.0),
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
                    'HEALTH BENEFITS',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                    ),
                  )
                )
              ),
              const SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Nutrient')),
                      DataColumn(label: Text('Amount')),
                    ],
                    rows: [
                      for (var nutrientEntry in nutrients.entries)
                        buildDataRow(nutrientEntry.key, nutrientEntry.value.toString()),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  DataRow buildDataRow(String nutrient, String amount) {
    return DataRow(
      cells: [
        DataCell(Text(nutrient)),
        DataCell(Text(amount)),
      ],
    );
  }
}
