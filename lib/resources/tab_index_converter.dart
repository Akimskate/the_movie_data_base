class TabIndexConverter {
  static int convertToTabIndex(String selectedTab) {
    switch (selectedTab) {
      case 'Movies':
        return 1;
      case 'TV Shows':
        return 2;
      default:
        return 0;
    }
  }
}
