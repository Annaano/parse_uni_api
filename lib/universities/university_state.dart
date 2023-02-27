class ApiState {
  final bool isLoading;
  final bool internetConnection;
  final List universities;
  const ApiState({
    this.isLoading = true,
    this.internetConnection = false,
    this.universities = const [],
  });

  ApiState copyWith({
    bool? isLoading,
    bool? internetConnection,
    List? universities,
  }) {
    return ApiState(
      isLoading: isLoading ?? this.isLoading,
      internetConnection: internetConnection ?? this.internetConnection,
      universities: universities ?? this.universities,
    );
  }
}
