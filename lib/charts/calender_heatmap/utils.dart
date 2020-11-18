leapYear(int year) {
  bool leapYear = false;
  bool leap = ((year % 100 == 0) && (year % 400 != 0));

  if (leap == true) {
    leapYear = false;
  } else if (year % 4 == 0) {
    leapYear = true;
  }

  return leapYear;
}

daysInMonth(int year, int month) {
  List<int> monthLength = List(12);

  monthLength[0] = 31;
  monthLength[2] = 31;
  monthLength[4] = 31;
  monthLength[6] = 31;
  monthLength[7] = 31;
  monthLength[9] = 31;
  monthLength[11] = 31;
  monthLength[3] = 30;
  monthLength[8] = 30;
  monthLength[5] = 30;
  monthLength[10] = 30;

  if (leapYear(year) == true) {
    monthLength[1] = 29;
  } else {
    monthLength[1] = 28;
  }

  return monthLength[month - 1];
}

yearLength(int year) {
  int yearLength = 0;

  for (int counter = 1; counter < year; counter++) {
    if (counter >= 4) {
      if (leapYear(counter) == true)
        yearLength += 366;
      else
        yearLength += 365;
    } else
      yearLength += 365;
  }
  return yearLength;
}

lastDayOfMonth(int year, int month) {
  return DateTime(year, month + 1, 0);
}

firstDayOfMonth(int year, int month) {
  return DateTime(year, month, 1).day;
}
