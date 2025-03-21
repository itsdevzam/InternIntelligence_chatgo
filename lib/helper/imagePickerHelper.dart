

import 'package:chatgo/utils/utils.dart';
import 'package:image_picker/image_picker.dart';

class imagePickerHelper{


  Future<String?> pickImage(ImageSource source) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: source);
    try{
      utils.customPrint('Selected image: ${image?.path}');
    }catch(e){
      utils.customPrint('Selected image: $e');
    }
    return image?.path ?? null;
  }

}