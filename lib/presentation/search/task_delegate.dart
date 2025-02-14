import 'package:flutter/material.dart';
import 'package:tec_bloc/domain/tasks/entity/task_entity.dart';

class TaskSearchDelegate extends SearchDelegate {
  final List<TaskEntity> allTasks;

  TaskSearchDelegate({required this.allTasks});

  @override
  List<Widget>? buildActions(BuildContext context) {
    // Actions à droite (par ex. bouton pour effacer la recherche)
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null); // Ferme la recherche
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final filteredTasks = allTasks.where((task) {
      return task.workType!.toLowerCase().contains(query.toLowerCase()) ||
          task.workType!.toLowerCase().contains(query.toLowerCase());
    }).toList();

    if (filteredTasks.isEmpty) {
      return const Center(
        child: Text('Aucune tâche trouvée.'),
      );
    }

    return ListView.builder(
      itemCount: filteredTasks.length,
      itemBuilder: (context, index) {
        final task = filteredTasks[index];
        return ListTile(
          title: Text(task.workType!),
          subtitle: Text(task.workType!),
          onTap: () {
            // Action lors de la sélection d'une tâche
            close(context, task); // Ferme la recherche et retourne la tâche
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    
    final suggestedTasks = allTasks.where((task) {
      return task.dispatcher!.toLowerCase().startsWith(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: suggestedTasks.length,
      itemBuilder: (context, index) {
        final task = suggestedTasks[index];
        return ListTile(
          title: Text(task.dispatcher!),
          onTap: () {
            query = task.dispatcher!.toLowerCase(); // Met à jour la requête
            showResults(context); // Affiche les résultats
          },
        );
      },
    );
  }
}
