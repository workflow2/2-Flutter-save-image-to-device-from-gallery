import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';

import 'dart:io';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '2 - Save image from Gallery',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: '2 - Save image from Gallery'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  // * The variable that will contain our shown image
  File image;

  @override
  void initState() {
    super.initState();

    // * We use then cause async await isn't aviable inside initState as I know
    // * We get the Application directory
    _getAppDir.then( (appDirPath) {

      // * We retrieve the image from our Application Path
      File foundImage = File('$appDirPath/test.jpg');

      // * We check that the image exists, if not will break
      // * We use then cause it returns a Future
      foundImage.exists().then((fileExist){

        // * If file doesn't exist we exit
        if(!fileExist) return;
        
        // * Otherwise we update the state to show our image        
        setState(() => image = foundImage);

      });

    });
    
  }

  get _getAppDir async {

    // * We get the current Application Directory "/data/user/0/com.example.saveimage/app_flutter" in this case
    final appDir = await getApplicationDocumentsDirectory();

    // * We return the path property, it's a String
    return appDir.path;

  }

  void _uploadImage() async {

    // * We call the ImagePicker, it'll give us back an instance
    ImagePicker picker = ImagePicker();

    // * We call the getImage method and pass as source the ImageSource.gallery 
    // * to get the image from the gallery (the alternative is  ImageSource.camera to get the image from the camera)
    PickedFile pickedImage = await picker.getImage(source: ImageSource.gallery);

    // * We pass to the File class the path of our picked image so he can create a reference to that file
    File originalImage = File(pickedImage.path);

    // * We update the image variable with setState so we can see the image in our screen
    setState(() => image = originalImage );

    // * We get our Application Directory it will give us something like "/data/user/0/com.example.saveimage/app_flutter"
    String appDirPath = await _getAppDir;

    // * We copy the previously referenced file to the our application directory with the new name test.jpg
    // * I left the name simple just to leave the tutorial the most easy possible
    await originalImage.copy('$appDirPath/test.jpg');
    
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: image != null ? Image.file(image) : null
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _uploadImage,
        tooltip: 'Increment',
        child: Icon(Icons.image),
      ),
    );
  }
}
