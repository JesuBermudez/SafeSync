import 'package:get/get.dart';

class Support extends GetxController {
  var email = ''.obs;
  var subject = ''.obs;
  var message = ''.obs;

  dataEmail({required emailUser, required subjectUser, required messageUser}) {
    email.value = emailUser;
    subject.value = subjectUser;
    message.value = messageUser;
  }

  void clear() async {
    email.value = '';
    subject.value = '';
    message.value = '';
  }

  String get getEmail => email.value;
  String get getSubject => subject.value;
  String get getMessage => message.value;

  toJsonSupport() {
    return {
      'email': getEmail,
      'subject': getSubject,
      'message': getMessage,
    };
  }
}
