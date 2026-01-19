enum FileType {
  jpeg,
  jpg,
  webp,
  png,
  gif,
  invalid,
}

class File {
  static FileType fromString(String fileTypeString) {
    switch (fileTypeString) {
      case 'image/jpeg':
        return FileType.jpeg;
      case 'image/jpg':
        return FileType.jpg;
      case 'image/webp':
        return FileType.webp;
      case 'image/png':
        return FileType.png;
      case 'image/gif':
        return FileType.gif;
      default:
        return FileType.invalid;
    }
  }
}
