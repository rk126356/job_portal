extension StringExtension on String {
  String toCapitalize() {
    if (isEmpty) {
      return this;
    }
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }

  String capitalizeWords() {
    return split(' ').map((word) => word.toCapitalize()).join(' ');
  }
}
