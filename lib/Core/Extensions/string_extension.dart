extension StringExtension on String {
  String capitalize() {
    if(this != "") {
      return "${this[0].toUpperCase()}${this.substring(1)}";
    }else{
      return "";
    }
  }
}

extension CapExtension on String {
  String get inCaps => '${this[0].toUpperCase()}${this.substring(1)}';
  String get allInCaps => this.toUpperCase();
  String get capitalizeFirstofEach => this.split(" ").map((str) => str.capitalize).join(" ");
}

extension StringExtensions on String {
  bool containsIgnoreCase(String secondString) => this.toLowerCase().contains(secondString.toLowerCase());

//bool isNotBlank() => this != null && this.isNotEmpty;
}