import 'package:flutter_riverpod/flutter_riverpod.dart';

final unitOfMeasureFormProvider =
NotifierProvider<
    UnitOfMeasureFormNotifier,
    UnitOfMeasureFormState
>(
  UnitOfMeasureFormNotifier.new,
);

class UnitOfMeasureFormState {
  const UnitOfMeasureFormState({
    this.name = '',
    this.abbreviation = '',
    this.isActive = true,
    this.isLoading = false,
    this.errorMessage,
  });

  final String name;
  final String abbreviation;
  final bool isActive;
  final bool isLoading;
  final String? errorMessage;

  UnitOfMeasureFormState copyWith({
    String? name,
    String? abbreviation,
    bool? isActive,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return UnitOfMeasureFormState(
      name: name ?? this.name,
      abbreviation:
      abbreviation ?? this.abbreviation,
      isActive:
      isActive ?? this.isActive,
      isLoading:
      isLoading ?? this.isLoading,
      errorMessage: clearError
          ? null
          : errorMessage ?? this.errorMessage,
    );
  }
}

class UnitOfMeasureFormNotifier
    extends Notifier<UnitOfMeasureFormState> {
  @override
  UnitOfMeasureFormState build() {
    return const UnitOfMeasureFormState();
  }

  void setName(String value) {
    state = state.copyWith(
      name: value,
      clearError: true,
    );
  }

  void setAbbreviation(String value) {
    state = state.copyWith(
      abbreviation: value,
      clearError: true,
    );
  }

  void setIsActive(bool value) {
    state = state.copyWith(
      isActive: value,
    );
  }

  void setLoading(bool value) {
    state = state.copyWith(
      isLoading: value,
    );
  }

  void setError(String message) {
    state = state.copyWith(
      errorMessage: message,
      isLoading: false,
    );
  }

  void reset() {
    state = const UnitOfMeasureFormState();
  }
}