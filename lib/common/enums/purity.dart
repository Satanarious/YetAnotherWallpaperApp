enum PurityType {
  general,
  sketchy,
  adult,
}

class Purity {
  static PurityType fromString(String purityString) {
    switch (purityString) {
      case 'general':
        return PurityType.general;
      case 'sketchy':
        return PurityType.sketchy;
      case 'nsfw':
        return PurityType.adult;
      default:
        return PurityType.general;
    }
  }

  static PurityType fromBool(bool purityBool) {
    switch (purityBool) {
      case true:
        return PurityType.adult;
      case false:
        return PurityType.general;
    }
  }
}
