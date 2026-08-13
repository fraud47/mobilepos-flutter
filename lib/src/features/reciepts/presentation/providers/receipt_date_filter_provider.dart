import 'package:flutter_riverpod/flutter_riverpod.dart';

class DateFilterState {
  final DateTime fromDate;
  final DateTime toDate;

  const DateFilterState({
    required this.fromDate,
    required this.toDate,
  });

  DateFilterState copyWith({DateTime? fromDate, DateTime? toDate}) {
    return DateFilterState(
      fromDate: fromDate ?? this.fromDate,
      toDate: toDate ?? this.toDate,
    );
  }
}

class DateFilterNotifier extends StateNotifier<DateFilterState> {
  DateFilterNotifier()
      : super(DateFilterState(
          // Default: from the start of the current month to today
          fromDate: DateTime(DateTime.now().year, DateTime.now().month, 1),
          toDate: DateTime(
            DateTime.now().year,
            DateTime.now().month,
            DateTime.now().day,
            23,
            59,
            59,
          ),
        ));

  void setFromDate(DateTime date) {
    // Ensure fromDate is not after toDate
    final newFrom = DateTime(date.year, date.month, date.day);
    final currentTo = state.toDate;
    state = state.copyWith(
      fromDate: newFrom,
      toDate: newFrom.isAfter(currentTo) ? newFrom : currentTo,
    );
  }

  void setToDate(DateTime date) {
    final newTo = DateTime(date.year, date.month, date.day, 23, 59, 59);
    state = state.copyWith(toDate: newTo);
  }

  void reset() {
    state = DateFilterState(
      fromDate: DateTime(DateTime.now().year, DateTime.now().month, 1),
      toDate: DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        23,
        59,
        59,
      ),
    );
  }
}

final dateFilterProvider =
    StateNotifierProvider<DateFilterNotifier, DateFilterState>(
  (ref) => DateFilterNotifier(),
);
