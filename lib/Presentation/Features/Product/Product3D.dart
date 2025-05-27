import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
class ShoeViewer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[700], // Nền dễ nhìn hơn
      appBar: AppBar(
        title: const Text('3D Shoe Viewer'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Center(
        child: AspectRatio(
          aspectRatio: 1,
          child: _buildModelViewer(),
        ),
      ),
    );
  }
  Widget _buildModelViewer(){
    try {
      return ModelViewer(
        src: 'assets/images/used_new_balance_574_classic______free.glb',
        alt: "Mô hình giày 3D",
        ar: false,
        autoRotate: true,
        cameraControls: true,
        interactionPrompt: InteractionPrompt.auto,
        disableZoom: false,
        backgroundColor: Colors.transparent,
      );
    }
    catch(e){
      print(e.toString()+"loi tai sao nhi");
      return Container();
    }
  }

}
