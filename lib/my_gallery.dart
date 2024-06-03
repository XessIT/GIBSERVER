import 'dart:io';
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:gipapp/video_player.dart';
import 'package:http_parser/http_parser.dart';

import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'home.dart';
import 'dart:typed_data';
import 'package:video_player/video_player.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:chewie/chewie.dart';

class MyGallery extends StatefulWidget {
  final String? userId;
  final String? userType;
  const MyGallery({super.key, required this.userId, required this.userType});

  @override
  State<MyGallery> createState() => _MyGalleryState();
}

class _MyGalleryState extends State<MyGallery> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          // Appbar title
          title: Text('My Gallery', style: Theme.of(context).textTheme.displayLarge),

        //  centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.white),
          leading: IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) =>  NavigationBarExe(userType: widget.userType, userId: widget.userId,)));
              },
              icon: const Icon(Icons.navigate_before)),
        ),
        body: PopScope(
          child: Column(
            children:   [
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
                    Gallery(userId: widget.userId,),
                    Video(userId: widget.userId),
                  ],
                ),

              ),
            ],
          ),
        ),
      ),
    );
  }
}


class Gallery extends StatefulWidget {
  final String? userId;

  Gallery({required this.userId});

  @override
  _GalleryState createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  final ImagePicker _imagePicker = ImagePicker();
  List<String> _imageUrlsList = [];
  List<Map<String, dynamic>> _imageDataList = [];

  Future<void> _pickAndUploadImage(ImageSource source) async {
    final pickedImage = await _imagePicker.pickImage(
      source: source,
      imageQuality: 10,
      maxHeight: 1000,
      maxWidth: 1000,
    );

    if (pickedImage != null) {
      final bytes = await pickedImage.readAsBytes();
      await _uploadImage(bytes);
    }
  }

  Future<void> _uploadImage(Uint8List imageBytes) async {
    final url =
        'http://mybudgetbook.in/GIBAPI/mygallery.php?userId=${widget.userId}';

    final response = await http.post(
      Uri.parse(url),
      body: {
        'image': base64Encode(imageBytes),
      },
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final imageUrl = responseData['image_url']; // Assuming server returns the URL

      print('Image uploaded successfully.');

      setState(() {
        _imageUrlsList.add(imageUrl);
      });

      // Refresh the gallery after successful upload
      _fetchImages();
    } else {
      print('Failed to upload image.');
    }
  }

  Future<void> _fetchImages() async {
    final url =
        'http://mybudgetbook.in/GIBAPI/mygalleryfetch.php?userId=${widget.userId}';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      List<dynamic> imageData = jsonDecode(response.body);

      _imageUrlsList.clear();
      _imageDataList.clear();

      for (var data in imageData) {
        final imageUrl = 'http://mybudgetbook.in/GIBAPI/${data['image_path']}';
        setState(() {
          _imageUrlsList.add(imageUrl);
          _imageDataList.add(data);
        });
      }
    } else {
      print('Failed to fetch images.');
    }
  }

  Future<void> _deleteImage(int imageIndex) async {
    String imageId = _imageDataList[imageIndex]['id'];
    final url =
        'http://mybudgetbook.in/GIBAPI/deleteImage.php?image_id=$imageId';
    print('url: $url');

    final response = await http.delete(Uri.parse(url));

    if (response.statusCode == 200) {
      print('Image deleted successfully.');
      setState(() {
        _imageUrlsList.removeAt(imageIndex);
        _imageDataList.removeAt(imageIndex);
      });
    } else {
      print('Failed to delete image.');
    }
  }

  Future<void> _showDeleteConfirmationDialog(int imageIndex) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Image'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to delete this image?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                _deleteImage(imageIndex);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchImages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        onPressed: () async {
          if (_imageUrlsList.length < 5) {
            showModalBottomSheet(
                context: context,
                builder: (ctx) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: const Icon(Icons.photo_library),
                        title: const Text("From Gallery"),
                        onTap: () async {
                          Navigator.pop(ctx);
                          await _pickAndUploadImage(ImageSource.gallery);
                        },
                      ),
                    ],
                  );
                });
          } else {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Upload Limit Reached'),
                  content: Text('You already have 5 images uploaded.'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('OK'),
                    ),
                  ],
                );
              },
            );
          }
        },
        child: const Icon(Icons.add),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10.0,
          crossAxisSpacing: 10.0,
        ),
        itemCount: _imageUrlsList.length,
        itemBuilder: (BuildContext context, i) {
          return Stack(
            children: [
              CachedNetworkImage(
                imageUrl: _imageUrlsList[i],
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
                fit: BoxFit.cover,
              ),
              Positioned(
                top: 5,
                right: 5,
                child: IconButton(
                  icon: Icon(Icons.cancel),
                  onPressed: () {
                    _showDeleteConfirmationDialog(i);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}


class Video extends StatefulWidget {
  final String? userId;
  const Video({super.key, required this.userId});

  @override
  State<Video> createState() => _VideoState();
}
class _VideoState extends State<Video> {
  final ImagePicker _picker = ImagePicker();
  List<dynamic> _videos = [];
  List<String> _thumbnails = [];

  @override
  void initState() {
    super.initState();
    _fetchVideos();
  }

  Future<void> _pickAndUploadVideo() async {
    final XFile? pickedVideo = await _picker.pickVideo(source: ImageSource.gallery);

    if (pickedVideo != null) {
      final Uint8List videoBytes = await pickedVideo.readAsBytes();
      final String videoName = pickedVideo.name; // Get the actual video name

      if (videoBytes.length > 10 * 1024 * 1024) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('File Too Large'),
              content: Text('The selected file exceeds the maximum size limit of 10MB.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
        return;
      }

      final url = 'http://mybudgetbook.in/GIBAPI/videos.php?userId=${widget.userId}';

      var request = http.MultipartRequest(
        'POST',
        Uri.parse(url),
      );
      request.files.add(
        http.MultipartFile.fromBytes(
          'video',
          videoBytes,
          filename: videoName, // Use the actual video name
          contentType: MediaType('video', 'mp4'),
        ),
      );

      var response = await request.send();
      if (response.statusCode == 200) {
        print('Video uploaded successfully.');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Video uploaded successfully.')),
        );
      } else {
        print('Failed to upload video.');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload video.')),
        );
      }
    }
  }
  Future<void> _fetchVideos() async {
    final url =
        'https://mybudgetbook.in/GIBAPI/fetchvideos.php?userId=${widget.userId}';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      setState(() {
        _videos = jsonDecode(response.body);
        _thumbnails = List<String>.filled(_videos.length, ''); // Initialize thumbnails list

        // Fetch thumbnails for each video
        for (int i = 0; i < _videos.length; i++) {
         // _fetchThumbnail(i);
        }
      });
    } else {
      // Handle error
      print('Failed to fetch videos');
    }
  }

/*  Future<void> _fetchThumbnail(int index) async {
    final videoPath = _videos[index]['video_path'];
    final thumbnailUrl = 'http://mybudgetbook.in/GIBAPI/thumbnail_$videoPath.jpg';

    final response = await http.get(Uri.parse(thumbnailUrl));
    if (response.statusCode == 200) {
      setState(() {
        _thumbnails[index] = thumbnailUrl;
      });
    } else {
      // Handle error
      print('Failed to fetch thumbnail for video: $videoPath');
    }
  }*/


  Future<void> _deleteVideo(int videoIndex) async {
    int videoId = _videos[videoIndex]['id'];
    final url =
        'http://mybudgetbook.in/GIBAPI/deletevideos.php?video_id=$videoId';

    final response = await http.delete(Uri.parse(url));

    if (response.statusCode == 200) {
      print('Video deleted successfully.');
      setState(() {
        _videos.removeAt(videoIndex);
      });
    } else {
      print('Failed to delete video.');
    }
  }

  Future<void> _showDeleteConfirmationDialog(int videoIndex) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Video'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to delete this video?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                _deleteVideo(videoIndex);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () async {
          // Check if there is already a video stored
          if (_videos.isEmpty) {
            // Allow picking and uploading a video
            showModalBottomSheet(
                context: context,
                builder: (ctx) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: const Icon(Icons.storage),
                        title: const Text("From Gallery"),
                        onTap: _pickAndUploadVideo,
                      )
                    ],
                  );
                });
          } else {
            // Show error message if a video is already stored
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Video Already Stored'),
                  content: Text('You already have a video stored.'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('OK'),
                    ),
                  ],
                );
              },
            );
          }
        },
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: _videos.length,
        itemBuilder: (context, index) {
          final videoId = _videos[index]['id'];
          final video_name = _videos[index]['video_name'];
          final videoPath = _videos[index]['video_path'];
          final thumbnail = _thumbnails[index];

          return ListTile(
            title: Text(video_name),
            leading: Container(
              width: 50, // Adjust the width as needed
              child: Image(image: AssetImage('assets/Video Player.png'))),
            onTap: () {
              // Navigate to VideoPlayerScreen when the name is clicked
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VideoPlayerScreen(videoPath: videoPath),
                ),
              );
            },
            trailing: IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                _showDeleteConfirmationDialog(index);
              },
            ),
          );
        },
      ),
    );
  }
}

class VideoPlayerScreen extends StatelessWidget {
  final String videoPath;

  const VideoPlayerScreen({Key? key, required this.videoPath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Player'),
      ),
      body: Center(
        child: AspectRatio(
          aspectRatio:
              16 / 9, // Adjust aspect ratio as per your video dimensions
          child: VideoPlayerWidget(videoUrl: videoPath),
        ),
      ),
    );
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerWidget({Key? key, required this.videoUrl}) : super(key: key);

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  bool _isPlaying = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  Future<void> _initializeVideoPlayer() async {
    try {
      _controller = VideoPlayerController.network(widget.videoUrl);

      await _controller.initialize();

      setState(() {
        _isPlaying = true;
      });
    } catch (error) {
      setState(() {
        _errorMessage = 'Error initializing video player: $error';
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_errorMessage != null) {
      return Text(_errorMessage!);
    }

    if (!_isPlaying) {
      return CircularProgressIndicator();
    }

    return AspectRatio(
      aspectRatio: _controller.value.aspectRatio,
      child: VideoPlayer(_controller),
    );
  }
}

