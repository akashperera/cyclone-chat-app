import 'package:cyclone/app/modules/chat_page/controllers/chat_page_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ImageView extends StatelessWidget {
  final imageFile;

  const ImageView({Key? key, required this.imageFile}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Obx(() {
        if (Get.find<ChatPageController>().isUploading.value) {
          return FloatingActionButton(
            onPressed: () {},
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
            backgroundColor: Color.fromARGB(255, 33, 58, 243),
          );
        }
        return FloatingActionButton.extended(
          onPressed: () {
            Get.find<ChatPageController>()
                .uploadToFirebaseStorage(file: imageFile!);
          },
          label: Text('Send Image'),
          icon: Icon(Icons.send),
          backgroundColor: Color.fromARGB(255, 33, 58, 243),
        );
      }),
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              child: Image.file(imageFile,
                  fit: BoxFit.contain, width: Get.width, height: Get.height),
            ),
            Positioned(
              top: 0,
              left: 0,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(Icons.arrow_back),
                    ),
                  ),
                ),
              ),
            ),
            // send button
          ],
        ),
      ),
    );
  }
}
