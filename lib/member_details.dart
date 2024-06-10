import 'package:flutter/material.dart';
import 'package:gipapp/video_player.dart';


class Details extends StatefulWidget {

  Details(this.itemId, {Key? key}) : super(key: key){}

  String itemId;

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  late Map data;

  String? email ="";

  String? mobile="";

  //bool isVisible;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: const Center(child: Text('Member Details')),
            centerTitle: true,
          ),
          body: Column(
                    children: [
                      TabBar(
                          isScrollable: true,
                          labelColor: Colors.green,
                          unselectedLabelColor: Colors.black,
                          tabs: [
                            Tab(text: 'Personal',),
                            Tab(text: 'Business',),
                            InkWell(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (context) => GalleryTab(itemId: widget.itemId,)));
                                },
                                child: Tab(text: "Gallery",))
                          ]),
                      Expanded(
                        child: TabBarView(
                          children: [
                            SingleChildScrollView(
                              child: Center(
                                child: Column(
                                  children: [
                                    SizedBox(
                                        width: double.infinity,
                                        height: 300,
                                        child: Image.network('${data['Image']}', fit: BoxFit.cover,)),

                                    ExpansionTile(
                                      leading: const Icon(Icons.info),
                                      title: const Text(
                                          'Basic Information'),
                                      children: [
                                        Row(
                                          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                             Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  30, 0, 0, 0),
                                              child: Text('Name',style: Theme.of(context).textTheme.bodySmall),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.fromLTRB(
                                                  90, 0, 0, 0),
                                              child: Text(
                                                  '${data['First Name']}',style: Theme.of(context).textTheme.bodySmall),
                                            )
                                          ],
                                        ),
                                        const Divider(),
                                        Row(
                                          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children:  [
                                             Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  30, 0, 0, 0),
                                              child: Text('District',style: Theme.of(context).textTheme.bodySmall),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.fromLTRB(
                                                  85, 0, 0, 0),
                                              child: Text('${data['District']}',style: Theme.of(context).textTheme.bodySmall),
                                            )
                                          ],
                                        ),
                                        const Divider(),
                                        Row(
                                          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                             Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  30, 0, 0, 0),
                                              child: Text('Chapter',style: Theme.of(context).textTheme.bodySmall),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.fromLTRB(
                                                  79, 0, 0, 0),
                                              child: Text('${data['Chapter']}',style: Theme.of(context).textTheme.bodySmall),
                                            )
                                          ],
                                        ),
                                        const Divider(),
                                        Row(
                                          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                             Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  30, 0, 0, 0),
                                              child: Text('Native',style: Theme.of(context).textTheme.bodySmall),
                                            ),
                                            Padding(
                                              padding:  EdgeInsets.fromLTRB(
                                                  90, 0, 0, 0),
                                              child: Text('${data['Location']}',style: Theme.of(context).textTheme.bodySmall),
                                            )
                                          ],
                                        ),
                                        const Divider(),
                                        Row(
                                          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                             Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  30, 0, 0, 0),
                                              child: Text('DOB',style: Theme.of(context).textTheme.bodySmall),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  105, 0, 0, 0),
                                              child: Text('${data['Date of Birth']}',style: Theme.of(context).textTheme.bodySmall),
                                            )
                                          ],
                                        ),
                                        const Divider(),
                                        Row(
                                          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                             Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  30, 0, 0, 0),
                                              child: Text('Koottam',style: Theme.of(context).textTheme.bodySmall),
                                            ),
                                            Padding(
                                              padding:  EdgeInsets.fromLTRB(
                                                  75, 0, 0, 0),
                                              child: Text('${data['Koottam']}',style: Theme.of(context).textTheme.bodySmall),
                                            )
                                          ],
                                        ),
                                        const Divider(),
                                        Row(
                                          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                             Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  30, 0, 0, 0),
                                              child: Text('Kovil',style: Theme.of(context).textTheme.bodySmall),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  100, 0, 0, 0),
                                              child: Text(
                                                  '${data['Kovil']}',style: Theme.of(context).textTheme.bodySmall),
                                            )
                                          ],
                                        ),
                                        const Divider(),
                                        Row(
                                          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                             Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  30, 0, 0, 0),
                                              child: Text('Member',style: Theme.of(context).textTheme.bodySmall),
                                            ),
                                            Padding(
                                              padding:  EdgeInsets.fromLTRB(
                                                  75, 0, 0, 0),
                                              child: Text('${data['Member Type']}',style: Theme.of(context).textTheme.bodySmall),
                                            )
                                          ],
                                        ),
                                        const Divider(),
                                        Row(
                                          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                                    Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  30, 0, 0, 0),
                                              child: Text('Blood Group',style: Theme.of(context).textTheme.bodySmall),
                                            ),
                                            Padding(
                                              padding:  EdgeInsets.fromLTRB(
                                                  50, 0, 0, 0),
                                              child: Text('${data['Blood Group']}',style: Theme.of(context).textTheme.bodySmall),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                    //if(data["Marital Status"] == "Unmarried"},
                                    Visibility(
                                      child: ExpansionTile(
                                        leading: const Icon(Icons.group),
                                        title: const Text('Dependents'),
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment
                                                .start,
                                            children: [
                                               Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    30, 0, 0, 0),
                                                child: Text('Spouse Name',style: Theme.of(context).textTheme.bodySmall),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    110, 0, 0, 0),
                                                child: Text('${data['Spouse Name']}',style: Theme.of(context).textTheme.bodySmall),
                                              )
                                            ],
                                          ),
                                          const Divider(),
                                          Row(
                                            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                               Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    30, 0, 0, 0),
                                                child: Text('WAD',style: Theme.of(context).textTheme.bodySmall),
                                              ),
                                              Padding(
                                                padding:  EdgeInsets.fromLTRB(
                                                    175, 0, 0, 0),
                                                child: Text('${data['Wedding Anniversary Date']}',style: Theme.of(context).textTheme.bodySmall),
                                              )
                                            ],
                                          ),
                                          const Divider(),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment
                                                .start,
                                            children:  [
                                               Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    30, 0, 0, 0),
                                                child: Text('Spouse Native',style: Theme.of(context).textTheme.bodySmall),
                                              ),
                                              Padding(
                                                padding:const EdgeInsets.fromLTRB(
                                                    108, 0, 0, 0),
                                                child: Text('${data['Spouse Native']}',style: Theme.of(context).textTheme.bodySmall),
                                              )
                                            ],
                                          ),
                                          const Divider(),
                                          Row(
                                            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    30, 0, 0, 0),
                                                child: Text('Spouse Blood Group',style: Theme.of(context).textTheme.bodySmall),
                                              ),
                                              Padding(
                                                padding:  EdgeInsets.fromLTRB(
                                                    67, 0, 0, 0),
                                                child: Text('${data['Spouse Blood Group']}',style: Theme.of(context).textTheme.bodySmall),
                                              )
                                            ],
                                          ),
                                          const Divider(),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children:  [
                                               Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    30, 0, 0, 0),
                                                child: Text(
                                                    'Spouse Father Koottam',style: Theme.of(context).textTheme.bodySmall),
                                              ),
                                              Padding(
                                                padding:  EdgeInsets.fromLTRB(
                                                    42, 0, 0, 0),
                                                child: Text('${data['Spouse Father Koottam']}',style: Theme.of(context).textTheme.bodySmall),
                                              )

                                            ],),
                                          const Divider(),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children:  [
                                               Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    30, 0, 0, 0),
                                                child: Text(
                                                    'Spouse Father Kovil',style: Theme.of(context).textTheme.bodySmall),
                                              ),
                                              Padding(
                                                padding:  EdgeInsets.fromLTRB(
                                                    70, 0, 0, 0),
                                                child: Text(
                                                    '${data['Spouse Father Kovil']}',style: Theme.of(context).textTheme.bodySmall),
                                              )

                                            ],),
                                        ],),
                                    ),

                                    ExpansionTile(
                                      leading: const Icon(Icons.call),
                                      title: const Text('Contact'),
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                             Padding(
                                              padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                                              child: Text('Mobile Number',style: Theme.of(context).textTheme.bodySmall),
                                            ),
                                            Padding(
                                              padding:  EdgeInsets.fromLTRB(70, 0, 0, 0),
                                              child: Text('${data['Mobile']}',style: Theme.of(context).textTheme.bodySmall),
                                            )

                                          ],),
                                        const SizedBox(height: 10,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                             Padding(
                                              padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                                              child: Text('Email',style: Theme.of(context).textTheme.bodySmall),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.fromLTRB(145, 0, 0, 0),
                                              child: Text('${data['Email']}',style: Theme.of(context).textTheme.bodySmall),
                                            )

                                          ],),
                                      ],),

                                    ExpansionTile(
                                      leading: const Icon(
                                          Icons.cast_for_education),
                                      title: const Text(
                                          'Education Details'),
                                      children: [
                                        Row(
                                          children: [
                                            const Padding(
                                              padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                                              child: Text('Education'),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 30),
                                              child: Text("${data["Education"]}"),)
                                          ],
                                        )
                                      ],
                                    ),
                                    ExpansionTile(
                                      leading: const Icon(Icons.man),
                                      title: const Text('Past Experience'),
                                      children: [
                                        Row(
                                          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.fromLTRB(
                                                  30, 0, 0, 0),
                                              child: Text(
                                                  '${data['Past Experience']}'),
                                            ),
                                            /* const Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  90, 0, 0, 0),
                                              child: Text(
                                                  'Network Admin\nAssistant Professor'),
                                            )*/
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // Personal(),
                            BusinessTab(widget.itemId),
                          ],
                        ),
                      ),
                    ],
                  )
        ));
  }
}



class BusinessTab extends StatelessWidget {
  BusinessTab(this.itemId,{Key? key}) : super(key: key){}

  String? service ="";
  String? cname ="";
  String? keyword ="";
  String itemId="";
  late Map data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
                  child: Center(
                    child: Column(
                      children: [
                        SizedBox(
                            width: double.infinity,
                            height: 300,
                            child: Image.network('${data['Business Image']}', fit: BoxFit.cover,)),
                        ExpansionTile(
                          leading: const Icon(Icons.info),
                          title: const Text('Basic Information'),
                          children: [
                            const SizedBox(height: 10,),
                            Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                                  child: Text('Company Name'),
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(90, 0, 0, 0),
                                  child: Text('${data['Company Name']}'),
                                )
                              ],
                            ),
                            const Divider(color: Colors.grey,),
                            SizedBox(
                              height: 50,
                              child: Row(
                                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: const [
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                                    child: Text('Business Keywords'),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(65, 0, 0, 0),
                                    child: Text(
                                      'Software, Website,\n Mobile Application',
                                      textAlign: TextAlign.justify,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 3,),
                                  )
                                ],
                              ),
                            ),
                            const Divider(color: Colors.grey,),
                            SizedBox(
                              height: 50,
                              child: Row(
                                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children:  [
                                  const Padding(
                                    padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                                    child: Text('Business Type'),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        150, 0, 0, 0),
                                    child: Text('${data['Business Type']}',
                                      textAlign: TextAlign.justify,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 3,),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        ExpansionTile(
                          leading: const Icon(Icons.contacts),
                          title: const Text('Contact'),
                          children: [
                            SizedBox(
                              height: 100,
                              child: Row(
                                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children:  [
                                  const Padding(
                                    padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                                    child: Align(
                                        alignment: Alignment.topLeft,
                                        child: Text('Contact')),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        140, 0, 0, 0),
                                    child: Text(
                                      '${data['Company Address']}',
                                      textAlign: TextAlign.justify,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        ExpansionTile(
                          leading: const Icon(Icons.call),
                          title: const Text('Company History'),
                          children: [
                            Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                                  child: Text('Website/Brochure'),
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(90, 0, 0, 0),
                                  child: Text('${data['Website']}'),
                                )
                              ],
                            ),
                            const Divider(color: Colors.grey,),
                            Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                                  child: Text(
                                      'Year of Business\nEstablished'),
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(90, 0, 0, 0),
                                  child: Text('${data['Year']}'),
                                )
                              ],
                            ),
                          ],
                        ),
                        /*const ExpansionTile(
                            leading: Icon(Icons.photo),
                            title: Text('Gallery')),*/
                      ],
                    ),
                  ),
                )
    );
  }
}

class GalleryTab extends StatefulWidget {
  final String itemId;
  const GalleryTab({Key? key, required this.itemId}) : super(key: key);

  @override
  State<GalleryTab> createState() => _GalleryTabState();
}

class _GalleryTabState extends State<GalleryTab> {
  @override
  void initState() {
    id = widget.itemId;
    super.initState();
  }
  String id = "";
  playvideo(String vurl) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => VideoApp(url: vurl)));
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            title: const Text("Gallery"),
            centerTitle: true,
          ),
          body: Center(
            child: Column(
              children: [
                const TabBar(
                    isScrollable: true,
                    labelColor: Colors.green,
                    unselectedLabelColor: Colors.black,
                    tabs: [
                      Tab(text: 'Image',),
                      Tab(text: 'Video',),
                    ]),
                Expanded(
                  child: TabBarView(
                    children: [
                      GridView.builder(
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 5.0,
                                    mainAxisSpacing: 5.0,
                                  ),
                                  itemCount: 10,
                                  itemBuilder: (context, index) {
                                   // String docID = streamSnapshot.data!.docs[index].id;
                                    Map thisitem = [index] as Map;
                                    return Column(
                                      children: [
                                        const SizedBox(height: 30,),
                                        InkWell(
                                          onTap: () {
                                            //  Navigator.push(context, MaterialPageRoute(
                                            //    builder: (context) => ViewGalleryImage(thisitem['id'])));
                                          },
                                          child: SizedBox(
                                              width: 100,
                                              height: 100,
                                              child: Image.network('${thisitem['Images']}', fit: BoxFit.cover,)),

                                        ),
                                        // Text(urlDownload),
                                      ],
                                    );
                                  }
                              ),
                      GridView.builder(
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 5.0,
                                    mainAxisSpacing: 5.0,
                                  ),
                                  itemCount: 10,
                                  itemBuilder: (context, index) {
                                   // String docID = streamSnapshot.data!.docs[index].id;
                                    Map thisitem = [index] as Map;
                                    return Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Column(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              playvideo(thisitem["Video"]);
                                            },
                                            child: SizedBox(
                                              height: 100,
                                              width: 100,
                                              child: Image.network(thisitem["Video Image"]),
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  }
                              )
                    ],
                  ),
                ),

              ],
            ),
          )
        /*FutureBuilder<DocumentSnapshot>(
            future: _futureData,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasError) {
                return Center(
                    child: Text('Some error occurred ${snapshot.error}'));
              }
              if (snapshot.hasData) {
                QuerySnapshot<Object?>? querySnapshot = snapshot.data;
                List<QueryDocumentSnapshot> documents = querySnapshot!.docs;
                List<Map> items = documents.map((e) => {
                  "id": e.id,
                  "Images": e['Images'],
                }).toList();
                //Get the data
               /* DocumentSnapshot documentSnapshot = snapshot.data;
                data = documentSnapshot.data() as Map;*/
                return
                  GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 5.0,
                        mainAxisSpacing: 5.0,
                      ),
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        String docID = snapshot.data!.docs[index].id;
                        Map thisitem = data[index];
                        return Column(
                          children: [
                            const SizedBox(height: 30,),
                            InkWell(
                              onTap: () {
                               /* Navigator.push(context, MaterialPageRoute(
                                    builder: (context) => ViewGalleryImage(thisitem['id'])));*/
                              },
                              child: SizedBox(
                                  width: 100,
                                  height: 100,
                                  child: Image.network('${thisitem['Images']}', fit: BoxFit.cover,)),

                            ),
                            // Text(urlDownload),
                          ],
                        );
                      }
                  );
              }
              return const CircularProgressIndicator();
            }
        ),*/
      ),
    );
  }
}

