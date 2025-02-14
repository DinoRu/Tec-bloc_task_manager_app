import 'package:flutter/material.dart';

class InstructionPageContent extends StatelessWidget {
  const InstructionPageContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Как использовать приложение",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          _buildInstructionItem(
            icon: Icons.add_circle_outline,
            title: "Добавление задачи",
            description: "Нажмите на кнопку '+ Добавить' для создания новой задачи.",
          ),
          _buildInstructionItem(
            icon: Icons.photo_camera,
            title: "Добавление фото",
            description: "Загрузите 5 фотографий, прежде чем выполнить задачу.",
          ),
          _buildInstructionItem(
            icon: Icons.sync,
            title: "Синхронизация данных",
            description: "Нажмите на 'Отправить', чтобы синхронизировать задачи с сервером.",
          ),
          _buildInstructionItem(
            icon: Icons.check_circle_outline,
            title: "Завершение задачи",
            description: "После выполнения задачи нажмите 'Выполнить' или 'Обновить'.",
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionItem({required IconData icon, required String title, required String description}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 28, color: Colors.blue),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(fontSize: 14, color: Colors.black87),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
