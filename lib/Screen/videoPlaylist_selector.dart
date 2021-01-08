import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:navigator_transitions_route/navigator_transitions_route.dart';
import 'package:school_app/Screen/constants.dart';
import 'package:school_app/Screen/main_menu.dart';
import 'package:school_app/Screen/player.dart';
import 'constants.dart';
import 'package:school_ui_toolkit/school_ui_toolkit.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class VideoPlaylistSelector extends StatefulWidget {
  @override
  _VideoPlaylistSelectorState createState() => _VideoPlaylistSelectorState();
}

class _VideoPlaylistSelectorState extends State<VideoPlaylistSelector> {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light
          .copyWith(systemNavigationBarColor: kBackGroundColor),
      child: WillPopScope(
        onWillPop: () async {
          NavigatorTransitionsRoute(
            context: context,
            child: MainMenuPage(),
            animation: AnimationType.slideRightToLeft,
            duration: Duration(milliseconds: 300),
          );
          return true;
        },
        child: Scaffold(
          backgroundColor: kBackGroundColor,
          body: Column(
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    SizedBox(
                      width: width,
                      height: kAppBarTopMargin,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          child: Icon(
                            Icons.arrow_back_ios,
                            size: kAppBarIconSize,
                            color: Colors.white,
                          ),
                          onTap: () {
                            setState(() {
                              NavigatorTransitionsRoute(
                                context: context,
                                child: MainMenuPage(),
                                animation: AnimationType.slideRightToLeft,
                                duration: Duration(milliseconds: 300),
                              );
                            });
                          },
                        ),
                        Text(
                          "Zoom Vid",
                          style: GoogleFonts.fredokaOne(
                            fontSize: kAppBarFontSize,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                        SizedBox(),
                        SizedBox()
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 4,
                child: Container(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class VideoPlaylist extends StatefulWidget {
  @override
  _VideoPlaylistState createState() => _VideoPlaylistState();
}

class _VideoPlaylistState extends State<VideoPlaylist> {
  var dataVid = [];
  var yt = YoutubeExplode();
  Future<void> getItemsList() async {
    var playlist = await yt.playlists.get('PL6wJWURYUK0I2b_KLTislSlvfRh1yfhGy');
    await for (var video in yt.playlists.getVideos(playlist.id)) {
      var videoTitle = video.title;
      var videoThumb = video.thumbnails.highResUrl;
      var videoUrl = video.url;
      var templateMap = {
        'title': videoTitle.toString(),
        'thumb': videoThumb.toString(),
        'url': videoUrl.toString()
      };
      dataVid.add(templateMap);
    }
    setState(() {});
  }

  void initState() {
    super.initState();
    getItemsList();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
      context,
      designSize: Size(414.0, 896.0),
    );
    return Scaffold(
        body: ListView.builder(
            itemCount: dataVid.length,
            itemBuilder: (BuildContext ctx, int index) {
              return Padding(
                  padding: const EdgeInsets.all(9.0),
                  child: FeaturedVideoCard(
                    thumbnailURL: dataVid[index]['thumb'],
                    title: dataVid[index]['title'],
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => YoutubePlayerPage(
                                dataVid[index]['url'],
                                dataVid[index]['title'])),
                      );
                    },
                  ));
            }));
  }
}
