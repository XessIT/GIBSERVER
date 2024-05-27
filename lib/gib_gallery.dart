import 'dart:convert';
import 'package:flutter/material.dart';
import 'Non_exe_pages/non_exe_home.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'dart:typed_data';
import 'package:video_player/video_player.dart';



class GibGallery extends StatelessWidget {
  final String userType;
  final String? userID;
  const GibGallery({super.key,
    required this.userType,
    required this. userID,});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          // Appbar title
          title:  Text('GIB Gallery',style: Theme.of(context).textTheme.displayLarge,
          ),
          centerTitle: true,
          leading:IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) =>  NavigationBarNon(userType: '', userId: '',)));
              },
              icon: const Icon(Icons.arrow_back,color: Colors.white,)),
        ),
        body: PopScope(
          canPop: false,
          onPopInvoked: (didPop)  {
            Navigator.push(context, MaterialPageRoute(builder: (context) =>  NavigationBarNon(userType: '', userId: '',)));
          },
          child: Column(
            children: [
              Container(
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20), color: Colors.white),
                child: TabBar(

                  labelColor: Colors.black,
                  dividerColor: Colors.black,
                  // ignore: prefer_const_literals_to_create_immutables
                  tabs: [
                    Tab(
                      icon: Row(
                        children: [
                          Text("Images",),
                          SizedBox(width: 10,),

                          Icon(
                            Icons.photo_library,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                    Tab(
                      icon: Row(
                        children: [
                          Text("Videos",),
                          SizedBox(width: 10,),
                          Icon(
                            Icons.video_camera_back,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                  ],

                ),

              ),
              Container(
                height: 1100,
                child: Expanded(
                    child: TabBarView(children: [
                      ViewPhotosPage(),
                      ViewVideosPage(),
                    ]
                    )),
              )

            ],
          ),
        ),
      ),
    );
  }
}


class ViewPhotosPage extends StatefulWidget {
  const ViewPhotosPage({Key? key}) : super(key: key);

  @override
  State<ViewPhotosPage> createState() => _ViewPhotosPageState();
}

class _ViewPhotosPageState extends State<ViewPhotosPage> {
  List<Map<String, dynamic>> _imageGroups = [];
  Future<void> _fetchImages() async {
    final url = Uri.parse('http://mybudgetbook.in/GIBADMINAPI/gibimagefetch.php');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      List<dynamic> imageData = jsonDecode(response.body);
      setState(() {
        _imageGroups = imageData.map((data) {
          return {
            'event_name': data['event_name'],
            'selectedDate': data['selectedDate'],
            'imagepaths': data['imagepaths']
          };
        }).toList();
      });
    } else {
      print('Failed to fetch images.');
    }
  }
  @override
  void initState() {
    super.initState();
    _fetchImages();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: _imageGroups.length,
        itemBuilder: (context, index) {
          final group = _imageGroups[index];
          return Card(
            margin: EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Event Name- ${group['event_name']}',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          color: Colors.green, // Change the color here
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10.0),
                            bottomRight: Radius.circular(10.0),
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
                        child: Text(
                          'Date - ${group['selectedDate']}',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                    ],
                  ),
                  SizedBox(height: 8.0),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8.0, /// Space between columns
                      mainAxisSpacing: 15.0, /// Space between rows
                    ),
                    itemCount: group['imagepaths'].length,
                    itemBuilder: (context, imageIndex) {
                      final imagePath = group['imagepaths'][imageIndex];
                      return FutureBuilder(
                        future: http.get(Uri.parse('http://mybudgetbook.in/GIBADMINAPI/$imagePath')),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                            final imageResponse = snapshot.data as http.Response;
                            if (imageResponse.statusCode == 200) {
                              return Stack(
                                children: [
                                  Image.memory(
                                    Uint8List.fromList(imageResponse.bodyBytes),
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                  ),

                                ],
                              );
                            } else {
                              return Text('Error loading image');
                            }
                          } else if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else {
                            return Text('Error loading image');
                          }
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}



class ViewVideosPage extends StatefulWidget {
  const ViewVideosPage({Key? key}) : super(key: key);

  @override
  _ViewVideosPageState createState() => _ViewVideosPageState();
}

class _ViewVideosPageState extends State<ViewVideosPage> {
  List<Map<String, dynamic>> _groupedVideos = [];

  Future<void> _fetchVideos() async {
    final url = Uri.parse('http://mybudgetbook.in/GIBADMINAPI/gibvideosfetch.php');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        _groupedVideos = List<Map<String, dynamic>>.from(jsonDecode(response.body));
      });
    } else {
      print('Failed to fetch videos');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchVideos();
  }

  void _playVideo(String videoUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoPlayerScreen(videoUrl: videoUrl),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _groupedVideos.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _groupedVideos.length,
        itemBuilder: (context, index) {
          final group = _groupedVideos[index];
          final eventName = group['event_name'];
          final selectedDate = group['selectedDate'];
          final videos = group['videos'];

          return Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment:  MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Event Name: $eventName',),
                      Container(
                          decoration: const BoxDecoration(
                            color: Colors.green, // Change the color here
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10.0),
                              bottomRight: Radius.circular(10.0),
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
                          child: Text('Date: $selectedDate',)),

                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, // Number of columns in the grid
                      childAspectRatio: 16 / 9,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: videos.length,
                    itemBuilder: (context, videoIndex) {
                      final video = videos[videoIndex];
                      return GestureDetector(
                        onTap: () => _playVideo(video['videos_path']),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Image.network(
                                video['thumbnail_path'],
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              video['videos_name'],
                              style: TextStyle(fontSize: 14),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class VideoPlayerScreen extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerScreen({Key? key, required this.videoUrl}) : super(key: key);

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl);
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.setLooping(true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Player',style: Theme.of(context).textTheme.displayLarge,),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Center(
              child: AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _controller.value.isPlaying ? _controller.pause() : _controller.play();
          });
        },
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }
}