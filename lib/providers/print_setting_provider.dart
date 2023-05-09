import 'package:flutter/cupertino.dart';

class PrintSettingProvider extends ChangeNotifier {
  resetToDefault() {
    numberOfCopies = 1;
    isColored = true;
    numberOfPages = 0;
    checkedPages = [];
    paperSize = "ShortBP";
  }

  double coloredCostPerPage = 5.0;
  double monoCostPerPage = 2.0;

  double amount = 0;

  int numberOfCopies = 1;
  incrementCopies() {
    numberOfCopies++;
    notifyListeners();
  }

  decrementCopies() {
    if (numberOfCopies > 1) {
      numberOfCopies--;
      notifyListeners();
    }
  }

  int numberOfPages = 0;
  List<bool> checkedPages = [];
  toggleCheckedPages(int index, bool val) {
    checkedPages[index] = val;
    computeAmount();
    notifyListeners();
  }

  isCheckAllPages() {
    int pageToPrintCount = 0;
    for (bool page in checkedPages) {
      if (page) {
        pageToPrintCount++;
      }
    }
    return pageToPrintCount == numberOfPages;
  }

  checkAllPages() {
    for (int i = 0; i < checkedPages.length; i++) {
      checkedPages[i] = true;
    }
    notifyListeners();
  }

  List<int> pagesToPrint = [];
  updateNumberOfPages(int val) {
    numberOfPages = val;
    notifyListeners();
  }

  bool isColored = true;
  updateIsColored(bool val) {
    isColored = val;
    notifyListeners();
  }

  String paperSize = "ShortBP";

  computeAmount() {
    int pageToPrintCount = 0;
    for (bool page in checkedPages) {
      if (page) {
        pageToPrintCount++;
      }
    }
    amount = numberOfCopies *
        ((isColored ? coloredCostPerPage : monoCostPerPage) * pageToPrintCount);
  }

  updateAmount() {
    computeAmount();
    notifyListeners();
  }
}
