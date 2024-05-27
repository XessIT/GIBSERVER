import 'package:flutter/material.dart';
import 'Non_exe_pages/non_exe_home.dart';
import 'guest_home.dart';
import 'home.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'dart:typed_data';
import 'package:video_player/video_player.dart';




class Achievements extends StatefulWidget {
  final String userType;
  final String? userID;
  const Achievements({super.key,
    required this.userType,
    required this. userID,});

  @override
  State<Achievements> createState() => _AchievementsState();
}

class _AchievementsState extends State<Achievements> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GiB Achievements',style: Theme.of(context).textTheme.displayLarge,),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            if (widget.userType == "Non-Executive") {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NavigationBarNon(
                    userType: widget.userType.toString(),
                    userId: widget.userID.toString(),
                  ),
                ),
              );
            }
            else if (widget.userType == "Guest") {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GuestHome(
                    userType: widget.userType.toString(),
                    userId: widget.userID.toString(),
                  ),
                ),
              );
            }
            else{
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NavigationBarExe(
                    userType: widget.userType.toString(),
                    userId: widget.userID.toString(),
                  ),
                ),
              );
            }
          },
          icon: const Icon(Icons.arrow_back,color: Colors.white,),
        ),

      ),
      body: AchievementGibGallery(),
    );
  }
}


class AchievementGibGallery extends StatefulWidget {
  const AchievementGibGallery({Key? key}) : super(key: key);

  @override
  State<AchievementGibGallery> createState() => _AchievementGibGalleryState();
}
class _AchievementGibGalleryState extends State<AchievementGibGallery> {


  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(

        body: Form(
          key: _formKey,
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
                      AchievementViewPhotosPage(),
                      AchievementViewVideosPage(),
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



class AchievementViewPhotosPage extends StatefulWidget {
  const AchievementViewPhotosPage({Key? key}) : super(key: key);

  @override
  State<AchievementViewPhotosPage> createState() => _AchievementViewPhotosPageState();
}
class _AchievementViewPhotosPageState extends State<AchievementViewPhotosPage> {
  List<Map<String, dynamic>> _imageGroups = [];

  Future<void> _fetchImages() async {
    final url = Uri.parse('http://mybudgetbook.in/GIBADMINAPI/gibachievementimagefetch.php');
    print('123$url');
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
                      Text(
                        'Date - ${group['selectedDate']}',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                    ],
                  ),
                  SizedBox(height: 8.0),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
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



class AchievementViewVideosPage extends StatefulWidget {
  const AchievementViewVideosPage({Key? key}) : super(key: key);

  @override
  _AchievementViewVideosPageState createState() => _AchievementViewVideosPageState();
}
class _AchievementViewVideosPageState extends State<AchievementViewVideosPage> {
  List<Map<String, dynamic>> _groupedVideos = [];

  Future<void> _fetchVideos() async {
    final url = Uri.parse('http://mybudgetbook.in/GIBADMINAPI/gibachievementvideosfetch.php');
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
        builder: (context) => AchievementVideoPlayerScreen(videoUrl: videoUrl),
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



class AchievementVideoPlayerScreen extends StatefulWidget {
  final String videoUrl;

  const AchievementVideoPlayerScreen({Key? key, required this.videoUrl}) : super(key: key);

  @override
  _AchievementVideoPlayerScreenState createState() => _AchievementVideoPlayerScreenState();
}
class _AchievementVideoPlayerScreenState extends State<AchievementVideoPlayerScreen> {
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
        centerTitle: true,
        title: Text('Video Player', style: Theme.of(context).textTheme.displayLarge,),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.navigate_before),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
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

