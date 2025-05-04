class StartupName {
  final String name;
  final bool isFavorite;

  StartupName({
    required this.name,
    this.isFavorite = false,
  });

  StartupName copyWith({
    String? name,
    bool? isFavorite,
  }) {
    return StartupName(
      name: name ?? this.name,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}