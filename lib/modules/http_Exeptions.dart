class httpExeption{
  final String message;
  httpExeption(this.message);
  @override
  String toString() {
    return message;
    // return super.toString();
  }
}