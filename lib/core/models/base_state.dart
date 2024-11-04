enum StateStatus {
  initial,
  loading,
  success,
  error,
}

class BaseState {
  final StateStatus status;
  final String? errorMessage;
  final bool isLoading;

  const BaseState({
    this.status = StateStatus.initial,
    this.errorMessage,
    this.isLoading = false,
  });

  BaseState copyWith({
    StateStatus? status,
    String? errorMessage,
    bool? isLoading,
  }) {
    return BaseState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      isLoading: isLoading ?? this.isLoading,
    );
  }
} 