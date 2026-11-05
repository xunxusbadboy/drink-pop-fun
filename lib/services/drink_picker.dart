import 'dart:math';
import '../models/drink.dart';

class DrinkPicker {
  final Random random;
  DrinkPicker({Random? random}) : random = random ?? Random();
  Drink pick(List<Drink> catalog, String mood, String task, {String? excludeId, bool caffeineFree = false}) {
    final eligible = catalog.where((d) => !caffeineFree || !d.caffeinated).toList();
    if (eligible.isEmpty) { throw StateError('No eligible drinks'); }
    int score(Drink d) => (d.moods.contains(mood) ? 2 : 0) + (d.tasks.contains(task) ? 2 : 0);
    final best = eligible.map(score).reduce(max);
    var pool = eligible.where((d) => score(d) == best).toList();
    if (pool.length > 1 && excludeId != null) {
      final alternatives = pool.where((d) => d.id != excludeId).toList();
      if (alternatives.isNotEmpty) pool = alternatives;
    }
    return pool[random.nextInt(pool.length)];
  }
}
