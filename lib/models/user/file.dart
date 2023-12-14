class Files {
  String nameFile = "";
  String date = "";
  double size = 0;

  Files(Map<String, dynamic> json) {
    nameFile = json["nameFile"];
    date = json["Date"];
    size = json["size"].toDouble();
  }
}
