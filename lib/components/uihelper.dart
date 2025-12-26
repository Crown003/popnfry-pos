// import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";


class Helper {
  static CustomTextField(TextEditingController controller, String text, IconData iconData, bool toHide) {
    return TextField(
      controller: controller,
      obscureText: toHide,
      decoration: InputDecoration(
          hintText: text,
          suffixIcon: Icon(iconData),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25)
          )
      ),
    );
  }

  static CustomButton(VoidCallback voidCallback,String text){
    return SizedBox(height: 50,width: 300,child: ElevatedButton(
        onPressed: (){voidCallback();},
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.redAccent,
        ),
        child: Text(text,style: TextStyle(color: Colors.white, fontSize: 20),
    )),);
  }

  static showAlert({
    required BuildContext context,
    required String title,
  }) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(title),
          actions: [
            TextButton(onPressed: (){
              Navigator.pop(context);
            }, child: Text("ok"))
          ],
        );
      },
    );
  }
}
