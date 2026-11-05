class Drink {
  final String id, name, emoji, tagline, flavor;
  final List<String> moods, tasks, ingredients, steps;
  final bool caffeinated, alcoholic;
  const Drink({required this.id, required this.name, required this.emoji,
    required this.tagline, required this.flavor, required this.moods,
    required this.tasks, required this.ingredients, required this.steps,
    required this.caffeinated, required this.alcoholic});
}
