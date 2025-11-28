import 'package:flutter/material.dart';
import 'package:app/models/product_entry.dart';
import 'package:app/widgets/left_drawer.dart';
import 'package:app/widgets/product_entry_card.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:app/screens/product_detail.dart';
import 'package:app/consts/consts.dart';
import 'package:app/consts/urls.dart';

class NewsEntryListPage extends StatefulWidget {
  const NewsEntryListPage({super.key});

  @override
  State<NewsEntryListPage> createState() => _NewsEntryListPageState();
}

class _NewsEntryListPageState extends State<NewsEntryListPage> {
  bool _showMyProductsOnly = false;
  String currentUserName = "";

  Future<List<NewsEntry>> fetchNews(CookieRequest request) async {
    // We always fetch ALL data from the existing endpoint
    // ignore: unused_local_variable
    final response = await request.get(Urls.baseUrl+'/json/');
    currentUserName = username_state;
    
    // Decode response to json format
    var data = response;
    
    // Convert json data to NewsEntry objects
    List<NewsEntry> listNews = [];
    for (var d in data) {
      if (d != null) {
        listNews.add(NewsEntry.fromJson(d));
      }
    }
    return listNews;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Entry List'),
      ),
      drawer: const LeftDrawer(),
      body: Column(
        children: [
          // 3. The Filter Toggle (Button)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Filter: My Products",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Switch(
                  value: _showMyProductsOnly,
                  activeColor: const Color(0xff59A5D8),
                  onChanged: (bool value) {
                    setState(() {
                      _showMyProductsOnly = value;
                    });
                  },
                ),
              ],
            ),
          ),
          
          // 4. The Data List
          Expanded(
            child: FutureBuilder(
              future: fetchNews(request),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.data == null) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  if (!snapshot.hasData) {
                    return const Column(
                      children: [
                        Text(
                          'There are no products yet.',
                          style: TextStyle(fontSize: 20, color: Color(0xff59A5D8)),
                        ),
                        SizedBox(height: 8),
                      ],
                    );
                  } else {
                    // 5. Apply the Filter Logic Here
                    List<NewsEntry> allProducts = snapshot.data!;
                    List<NewsEntry> displayedProducts;

                    if (_showMyProductsOnly) {
                      // Filter the list locally based on the seller field
                      displayedProducts = allProducts
                          .where((entry) => entry.seller == currentUserName)
                          .toList();
                    } else {
                      // Show everything
                      displayedProducts = allProducts;
                    }

                    if (displayedProducts.isEmpty && _showMyProductsOnly) {
                      return const Center(
                        child: Text("You have no products created."),
                      );
                    }

                    return ListView.builder(
                      itemCount: displayedProducts.length,
                      itemBuilder: (_, index) => NewsEntryCard(
                        product: displayedProducts[index],
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NewsDetailPage(
                                product: displayedProducts[index],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}