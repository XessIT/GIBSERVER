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

          centerTitle: true,
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
                    Gallery(userId: widget.userId),
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

  const Gallery({super.key, required this.userId});

  @override
  State<Gallery> createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  Uint8List? _imageBytes;
  final ImagePicker _imagePicker = ImagePicker();
  List<Uint8List> _imageBytesList = [];
  List<Map<String, dynamic>> _imageDataList = [];
  List<bool> _isSelectedList = [];

  Future<void> _pickAndUploadImage(ImageSource source) async {
    final pickedImages = await _imagePicker.pickMultiImage(
      imageQuality: 100,
      maxHeight: 1000,
      maxWidth: 1000,
    );

    if (pickedImages != null) {
      for (var pickedImage in pickedImages) {
        final bytes = await pickedImage.readAsBytes();
        setState(() {
          _imageBytesList.add(bytes);
        });
        await _uploadImage(bytes);
      }
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
      print('Image uploaded successfully.');
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

      _imageBytesList.clear();
      _imageDataList.clear();

      for (var data in imageData) {
        final imageUrl = 'http://mybudgetbook.in/GIBAPI/${data['image_path']}';
        final imageResponse = await http.get(Uri.parse(imageUrl));
        if (imageResponse.statusCode == 200) {
          Uint8List imageBytes = imageResponse.bodyBytes;
          setState(() {
            _imageBytesList.add(imageBytes);
            _imageDataList.add(data);
          });
        }
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
        _imageBytesList.removeAt(imageIndex);
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
        onPressed: () async {
          if (_imageBytesList.length < 5) {
            showModalBottomSheet(
                context: context,
                builder: (ctx) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: const Icon(Icons.camera_alt),
                        title: const Text("With Camera"),
                        onTap: () async {
                          final pickedImage = await _imagePicker.pickImage(
                            source: ImageSource.camera,
                          );

                          if (pickedImage != null) {
                            final bytes = await pickedImage.readAsBytes();

                            setState(() {
                              _imageBytes = bytes;
                            });

                            await _uploadImage(_imageBytes!);
                          }
                        },
                      ),
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
        itemCount: _imageBytesList.length,
        itemBuilder: (BuildContext context, i) {
          return Stack(
            children: [
              Image.memory(
                _imageBytesList[i],
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
    final XFile? pickedVideo =
        await _picker.pickVideo(source: ImageSource.gallery);

    if (pickedVideo != null) {
      final Uint8List videoBytes = await pickedVideo.readAsBytes();
      if (videoBytes.length > 10 * 1024 * 1024) {
        // File size exceeds the limit, show an alert
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('File Too Large'),
              content: Text(
                  'The selected file exceeds the maximum size limit of 10MB.'),
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

      print('videoBytes: $videoBytes');
      final url =
          'http://mybudgetbook.in/GIBAPI/videos.php?userId=${widget.userId}';

      print('url: $url');
      // Make HTTP request to upload video file to server

      var request = http.MultipartRequest(
        'POST',
        Uri.parse(url),
      );
      request.files.add(
        http.MultipartFile.fromBytes(
          'video',
          videoBytes,
          filename:
              'video.mp4', // Provide a filename with the appropriate extension
          contentType: MediaType('video',
              'mp4'), // Adjust the content type as per your video format
        ),
      );

      var response = await request.send();
      if (response.statusCode == 200) {
        // Video uploaded successfully
        print('Video uploaded successfully.');
        // Optionally, you can show a success message to the user
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Video uploaded successfully.')),
        );
      } else {
        // Failed to upload video
        print('Failed to upload video.');
        // Optionally, you can show an error message to the user
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload video.')),
        );
      }
    }
  }

  Future<void> _fetchVideos() async {
    final url =
        'http://mybudgetbook.in/GIBAPI/fetchvideos.php?userId=${widget.userId}';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      setState(() {
        _videos = jsonDecode(response.body);
        // Fetch thumbnails for each video
        _thumbnails = List<String>.filled(_videos.length, '');
        for (int i = 0; i < _videos.length; i++) {
          _fetchThumbnail(i);
        }
      });
    } else {
      // Handle error
      print('Failed to fetch videos');
    }
  }

  Future<void> _fetchThumbnail(int index) async {
    final videoPath = _videos[index]['video_path'];
    final url =
        'http://mybudgetbook.in/GIBAPI/videosmp4.php?video_path=' + videoPath;

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      setState(() {
        _thumbnails[index] = response.body;
      });
    } else {
      // Handle error
      print('Failed to fetch thumbnail for video at index $index');
    }
  }

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
              child: thumbnail.isNotEmpty
                  ? Image.network(thumbnail)
                  : CircularProgressIndicator(), // Show a loading indicator if thumbnail is being fetched
            ),
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

      if (mounted) {
        setState(() {
          _isPlaying = true;
        });
      }
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
