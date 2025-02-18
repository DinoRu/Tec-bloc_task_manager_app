import 'package:flutter/material.dart';
import 'package:tec_bloc/core/constants/app_colors.dart';

BottomNavigationBar appBottomNav(currentIndex, onItemTapped) {
  return BottomNavigationBar(
    selectedItemColor: AppColors.kPrimaryColor,
    unselectedItemColor: AppColors.kGrey1,
    currentIndex: currentIndex,
    onTap: onItemTapped,
    type: BottomNavigationBarType.fixed,
    showSelectedLabels: true,
    showUnselectedLabels: true,
    backgroundColor: AppColors.background,
    elevation: 2,
    items: [
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'Главная'
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.list),
        label: 'Планного задач'
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.check_circle_outline),
        label: 'Завершенные'
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.person_outline_sharp),
        label: 'Профиль'
      ),
    ]
  );
}