import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:student_app/core/Constant/constant_color.dart';
import 'package:student_app/core/Constant/constant_font.dart';
import 'package:student_app/core/Constant/constant_icons.dart';
import 'package:student_app/core/data/cubit/cubit.dart';
import 'package:student_app/core/screen/Courses%20Screen/courses.dart';
import 'package:student_app/generated/lib/generated/locale_keys.g.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({super.key, required this.cubit});

  final StudentCubit cubit;

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      width: double.infinity,
      border: const Border(
        top: BorderSide(color: KColors.bordorColor, width: 1),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          currentIndex: cubit.currentIndexNavBAr,
          onTap: (value) => cubit.changeBottomNav(value),
          backgroundColor: Colors.white,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: KColors.primary,
          unselectedItemColor: KColors.secondary,
          selectedLabelStyle: KFonts.regular14,
          unselectedLabelStyle: KFonts.regular14,
          items: [
            BottomNavigationBarItem(
              icon: CustomContainerBottomNav(
                padding: 9,
                color: selectColorSubContainerBottomNavBar(
                  0,
                  cubit.currentIndexNavBAr,
                ),
                child: CustomSvgIMage(
                  icon: Kicons.book,
                  size: 26,
                  color: selectColorSubContainerIconBottomNavBar(
                    0,
                    cubit.currentIndexNavBAr,
                  ),
                ),
              ),
              label: LocaleKeys.my_courses.tr(),
            ),
            BottomNavigationBarItem(
              icon: CustomContainerBottomNav(
                padding: 10,
                color: selectColorSubContainerBottomNavBar(
                  1,
                  cubit.currentIndexNavBAr,
                ),
                child: CustomSvgIMage(
                  icon: Kicons.person,
                  size: 26,
                  color: selectColorSubContainerIconBottomNavBar(
                    1,
                    cubit.currentIndexNavBAr,
                  ),
                ),
              ),
              label: LocaleKeys.my_account.tr(),
            ),
          ],
        ),
      ),
    );
  }
}

Color selectColorSubContainerBottomNavBar(int index, int cubitIndex) {
  return index == cubitIndex ? KColors.lightGRayContainer : KColors.white;
}

Color selectColorSubContainerIconBottomNavBar(int index, int cubitIndex) {
  return index == cubitIndex ? KColors.primary : KColors.secondary;
}
