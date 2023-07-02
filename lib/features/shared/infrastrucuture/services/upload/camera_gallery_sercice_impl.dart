import 'package:image_picker/image_picker.dart';

import 'camera_galley_service.dart';

class CameraGalleryServiceImpl extends CameraGalleyService {
  final ImagePicker _picker = ImagePicker();

  @override
  Future<String?> selectPhto() async {
    final XFile? photo = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (photo == null) return null;

    return photo.path;
  }

  @override
  Future<String?> takePhone() async {
    final XFile? photo = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
      preferredCameraDevice: CameraDevice.rear,
    );

    if (photo == null) return null;

    return photo.path;
  }
}
