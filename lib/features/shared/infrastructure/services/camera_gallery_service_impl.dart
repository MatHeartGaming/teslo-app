import 'package:image_picker/image_picker.dart';
import 'package:logger/web.dart';
import 'package:teslo_shop/features/shared/infrastructure/services/camera_gallery_service.dart';

class CameraGalleryServiceImplementation implements CameraGalleryService {
  final ImagePicker _picker = ImagePicker();
  final _logger = Logger();

  @override
  Future<String?> selectPhoto() async {
    final XFile? photo =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (photo == null) return null;
    _logger.i('We got an image at ${photo.path}');
    return photo.path;
  }

  @override
  Future<String?> takePhoto() async {
    final XFile? photo =
        await _picker.pickImage(source: ImageSource.camera, imageQuality: 80);
    if (photo == null) return null;
    _logger.i('We got an image at ${photo.path}');
    return photo.path;
  }
}
