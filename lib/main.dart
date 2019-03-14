import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tech_test/data/gif_repository.dart';
import 'package:tech_test/data/remote/ds_remote_gif.dart';
import 'package:tech_test/entities.dart';
import 'package:tech_test/errors.dart';
import 'package:tuple/tuple.dart';

import 'screens/gifs_search_vm.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState(
        GifsViewModel(
          GifRepository(
            GifRemoteDs(),
          ),
        ),
      );
}

class _MyHomePageState extends State<MyHomePage> {
  Icon icon = new Icon(
    Icons.search,
    color: Colors.white,
  );

  Widget appBarTitle = new Text(
    "Search",
    style: new TextStyle(color: Colors.white),
  );

  final ScrollController scrollController = new ScrollController();
  bool loading = false;
  Timer _timer;

  final TextEditingController _controller = new TextEditingController();

  GifsViewModel _gifsViewModel;
  StreamController<Tuple2<bool, List<Gif>>> _streamController;

  _MyHomePageState(this._gifsViewModel);

  @override
  void initState() {
    super.initState();
    _streamController ??= StreamController.broadcast();
    _gifsViewModel.initVm(_streamController);
  }

  @override
  void dispose() {
    super.dispose();
    _streamController.close();
    _streamController = null;

    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _createGifsGrid(),
    );
  }

  Widget _createGifsGrid() {
    return StreamBuilder<Tuple2<bool, List<Gif>>>(
        stream: _gifsViewModel.gifsStream,
        builder: (context, data) {

          if (data.hasData) {
            loading = false;
            if (scrollController.hasClients &&
                data.data.item1 &&
                scrollController.offset > 0) {
              scrollController.animateTo(0,
                  duration: Duration(seconds: 1), curve: Curves.linear);
            }
            final gifs = data.data.item2;

            return Padding(
              padding: EdgeInsets.only(left: 8, right: 8),
              child: NotificationListener(
                onNotification: _onNotification,
                child: GridView.builder(
                  cacheExtent: 20,
                  controller: scrollController,
                  itemCount: gifs.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  itemBuilder: (context, position) {
                    final gif = gifs[position];
                    if (gif.images == null ||
                        gif.images.previewGif == null ||
                        gif.images.previewGif.url == null ||
                        gif.images.previewGif.url.isEmpty) {
                      return Center(
                        child: Text("No gif preview available"),
                      );
                    }
                    return FadeInImage.assetNetwork(
                        placeholder: "assets/images/spinner.gif",
                        image: gifs[position].images.previewGif.url);
                  },
                ),
              ),
            );
          } else {
            return Text("No data");
          }
        });
  }

  bool _onNotification(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification) {
      if (scrollController.position.maxScrollExtent > scrollController.offset &&
          scrollController.position.maxScrollExtent - scrollController.offset <=
              PAGE_OFFSET) {
        if (!loading) {
          loading = true;
          _gifsViewModel.newGifsPage();
        }
      }
    } else if (notification is OverscrollNotification &&
        notification.metrics.axisDirection == AxisDirection.down) {
      if (!loading) {
        loading = true;
        _gifsViewModel.newGifsPage();
      }
    }
    return true;
  }

  Widget _buildAppBar(BuildContext context) {
    return new AppBar(centerTitle: true, title: appBarTitle, actions: <Widget>[
      IconButton(
        icon: icon,
        onPressed: () {
          setState(() {
            if (this.icon.icon == Icons.search) {
              _handleSearchStart();
            } else {
              _handleSearchEnd();
            }
          });
        },
      ),
    ]);
  }

  _handleSearchStart() {
    this.icon = new Icon(
      Icons.close,
      color: Colors.white,
    );
    this.appBarTitle = new TextField(
      controller: _controller,
      style: new TextStyle(
        color: Colors.white,
      ),
      decoration: new InputDecoration(
          prefixIcon: new Icon(Icons.search, color: Colors.white),
          hintText: "Search...",
          hintStyle: new TextStyle(color: Colors.white)),
      onChanged: (s) {
        _timer?.cancel();
        _timer = Timer(Duration(milliseconds: 300),
            () => {_gifsViewModel.newGifsQuery(s)});
      },
    );
  }

  _handleSearchEnd() {
    setState(() {
      this.icon = new Icon(
        Icons.search,
        color: Colors.white,
      );
      this.appBarTitle = new Text(
        "Search",
        style: new TextStyle(color: Colors.white),
      );
      _controller.clear();
    });
  }
}
