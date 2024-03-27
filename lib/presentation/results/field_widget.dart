import 'package:flutter/material.dart';

import '../../models/data_model.dart';

Widget buildField(
  BuildContext context,
  DataModel data,
  List<Point> shortestPath,
) {
  return ListView.builder(
    shrinkWrap: true,
    itemCount: data.field.length,
    itemBuilder: (
      context,
      rowIndex,
    ) {
      final row = data.field[rowIndex];
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: row.split('').asMap().entries.map((
          entry,
        ) {
          final columnIndex = entry.key;
          final cell = entry.value;
          final point = Point(columnIndex, rowIndex);
          final color = _getCellColor(cell, point, shortestPath);

          return Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              color: color,
            ),
            child: Center(
              child: Text(
                '(${point.x}.${point.y})',
                style: TextStyle(
                  fontSize: 12,
                  color: color == Colors.black ? Colors.white : Colors.black,
                ),
              ),
            ),
          );
        }).toList(),
      );
    },
  );
}

Color _getCellColor(String cell, Point point, List<Point> shortestPath) {
  if (cell == 'X') {
    return Colors.black; // Заблокована комірка
  } else if (shortestPath.isNotEmpty && point == shortestPath.first) {
    return const Color(0xFF64FFDA); // Початкова комірка
  } else if (shortestPath.isNotEmpty && point == shortestPath.last) {
    return const Color(0xFF009688); // Кінцева комірка
  } else if (shortestPath.isNotEmpty && shortestPath.contains(point)) {
    return const Color(0xFF4CAF50); // Комірка найкоротшого шляху
  } else {
    return Colors.white; // Порожня комірка
  }
}

// Функція для знаходження найкоротшого шляху
List<Point> findShortestPath(DataModel data) {
  final start = Point(data.start['x']!, data.start['y']!);
  final end = Point(data.end['x']!, data.end['y']!);
  final queue = <Point>[start];
  final visited = <Point, Point>{start: start};

  while (queue.isNotEmpty) {
    final current = queue.removeAt(0);
    if (current == end) {
      return _buildPath(current, visited);
    }

    for (final dir in _directions) {
      final next = Point(current.x + dir.x, current.y + dir.y);
      if (_isValidPoint(next, data) && !visited.containsKey(next)) {
        visited[next] = current;
        queue.add(next);
      }
    }
  }

  return [];
}

bool _isValidPoint(Point point, DataModel data) {
  final fieldLength = data.field.length;
  if (point.x < 0 || point.x >= data.field[0].length) return false;
  if (point.y < 0 || point.y >= fieldLength) return false;
  return data.field[point.y as int][point.x as int] != 'X';
}

List<Point> _buildPath(Point end, Map<Point, Point> visited) {
  var path = <Point>[end];
  var current = end;
  while (visited[current] != current) {
    current = visited[current]!;
    path.add(current);
  }
  path = path.reversed.toList();
  return path;
}

class Point<T extends num> {
  final T x;
  final T y;

  const Point(this.x, this.y);

  @override
  bool operator ==(other) {
    return other is Point && other.x == x && other.y == y;
  }

  @override
  int get hashCode => x.hashCode ^ y.hashCode;

  @override
  String toString() {
    return '($x, $y)';
  }
}

// Список напрямків руху
final _directions = [
  const Point(0, -1), // верх
  const Point(0, 1), // низ
  const Point(-1, 0), // ліво
  const Point(1, 0), // право
  const Point(-1, -1), // верх-ліво
  const Point(1, -1), // верх-право
  const Point(-1, 1), // низ-ліво
  const Point(1, 1), // низ-право
];
Widget buildShortestPaths(List<List<Point>> shortestPaths) {
  return Column(
    children: [
      const Text(
        'Results:',
        style: TextStyle(fontSize: 20),
      ),
      Column(
        children: shortestPaths.asMap().entries.map((entry) {
          int index = entry.key + 1;
          List<Point> path = entry.value;
          var pathString =
              path.map((point) => '(${point.x}.${point.y})').join(' -> ');
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              '$index Field: $pathString',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
          );
        }).toList(),
      ),
    ],
  );
}
