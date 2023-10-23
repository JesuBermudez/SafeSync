import 'package:flutter/material.dart';
import 'package:get/get.dart';

createUserName({bool show = true, required TextEditingController controller}) {
  return show
      ? Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(240, 250, 255, 255),
            borderRadius: BorderRadius.circular(15.0),
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(176, 217, 255, 1),
                blurRadius: 30.0,
                spreadRadius: 0.1,
                offset: Offset(0, 12),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0)),
                enabledBorder: const OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromRGBO(200, 235, 255, 1)),
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 20.0),
                hintText: 'Usuario...',
                hintStyle:
                    const TextStyle(color: Color.fromRGBO(176, 199, 212, 1))),
            onChanged: (text) {
              // ignore: avoid_print
              print(text);
            },
          ),
        )
      : const SizedBox();
}

createPasword({required TextEditingController controller}) {
  var isPasswordVisible = false.obs;

  return Obx(() {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(240, 250, 255, 255),
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(176, 217, 255, 1),
            blurRadius: 30.0,
            spreadRadius: 0.1,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
          enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromRGBO(200, 235, 255, 1)),
              borderRadius: BorderRadius.all(Radius.circular(15))),
          hintText: 'Contraseña...',
          hintStyle: const TextStyle(color: Color.fromRGBO(176, 199, 212, 1)),
          // icon: const Icon(Icons.password_outlined),
          suffixIcon: IconButton(
            padding: const EdgeInsets.only(right: 15),
            icon: isPasswordVisible.value
                ? const Icon(Icons.visibility_off)
                : const Icon(Icons.visibility),
            onPressed: () {
              isPasswordVisible.toggle();
            },
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        ),
        obscureText: !isPasswordVisible.value,
      ),
    );
  });
}

createEmail({required TextEditingController controller}) {
  var sufix = "".obs;

  return Obx(
    () {
      return Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(240, 250, 255, 255),
            borderRadius: BorderRadius.circular(15.0),
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(176, 217, 255, 1),
                blurRadius: 30.0,
                spreadRadius: 0.1,
                offset: Offset(0, 12),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromRGBO(200, 235, 255, 1),
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                hintText: 'Correo...',
                hintStyle:
                    const TextStyle(color: Color.fromRGBO(176, 199, 212, 1)),
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 20.0),
                suffixText: sufix.value == "" ? null : sufix.value),
            keyboardType: TextInputType.emailAddress,
            onChanged: (value) {
              sufix.value = controller.text.contains("@") ? "" : "@example.com";
            },
          ));
    },
  );
}

createSubject({required TextEditingController controller}) {
  return TextField(
    controller: controller,
    decoration: const InputDecoration(border: UnderlineInputBorder()),
  );
}

createTextArea({required TextEditingController controller}) {
  return TextField(
    controller: controller,
    maxLines: 6,
    minLines: 4,
    keyboardType: TextInputType.multiline,
    decoration: const InputDecoration(border: UnderlineInputBorder()),
  );
}

createSendEmail({required TextEditingController controller}) {
  return TextField(
    controller: controller,
    decoration: const InputDecoration(border: UnderlineInputBorder()),
    keyboardType: TextInputType.emailAddress,
    keyboardAppearance: Brightness.dark,
  );
}
