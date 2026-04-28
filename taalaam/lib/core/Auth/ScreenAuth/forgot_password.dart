import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:student_app/core/Auth/data/cubit/cubit_auth.dart';
import 'package:student_app/core/Auth/data/cubit/state_auth.dart';
import 'package:student_app/core/Constant/constant_color.dart';
import 'package:student_app/core/Constant/constant_font.dart';
import 'package:student_app/core/Constant/constant_icons.dart';
import 'package:student_app/core/go_router.dart';
import 'package:student_app/core/screen/Courses%20Screen/courses.dart';
import 'package:student_app/core/screen/lessons.dart';
import 'package:student_app/core/widget/text_form_field_all.dart';
import 'package:student_app/generated/lib/generated/locale_keys.g.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
    var cubit = context.read<AuthCubit>();

    return Scaffold(
      backgroundColor: KColors.backgroundCourse,
      body: Form(
        key: cubit.formKey1,
        autovalidateMode: AutovalidateMode.onUserInteractionIfError,
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccess) {
              go(context, KRoutes.controllAuth);
            }
          },
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    LocaleKeys.forgot_password.tr(),
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const Gap(8),
                  Text(
                    LocaleKeys.enter_email_hint.tr(),
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const Gap(30),
                  Text(
                    LocaleKeys.email.tr(),
                    style: KFonts.bold18.copyWith(fontSize: 14),
                  ),
                  const Gap(10),
                  CustomTextField(
                    controller: cubit.emailController,
                    hint: "example.@gmail.com",
                    icon: Icons.email,
                    textInputAction: TextInputAction.next,
                    validator: (p0) => KRegex.validator(
                      p0,
                      KRegex.email,
                      LocaleKeys.email_invalid.tr(),
                    ),
                  ),
                  const Gap(30),
                  CustomContainer(
                    onTap: state is! AuthLoading
                        ? () async {
                            if (cubit.formKey1.currentState?.validate() ??
                                false) {
                              await cubit.sendPasswordResetEmail(
                                cubit.emailController.text,
                              );
                            }
                          }
                        : null,
                    borderRadius: 20,
                    useGradiunt: true,
                    height: 60,
                    boxShadow: shadowGreen,
                    child: Center(
                      child: state is! AuthLoading
                          ? Text(
                              LocaleKeys.send_code.tr(),
                              style: KFonts.bold14White.copyWith(fontSize: 16),
                            )
                          : const LoadingWidget(
                              jsonIcon: Kicons.whiteloadingBook,
                            ),
                    ),
                  ),
                  const Gap(10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        LocaleKeys.remember_password.tr(),
                        style: KFonts.bold13DarkGray.copyWith(
                          color: KColors.secondary,
                        ),
                      ),
                      const Gap(5),
                      GestureDetector(
                        onTap: () => push(context, KRoutes.controllAuth),
                        child: Text(
                          LocaleKeys.login.tr(),
                          style: KFonts.bold13DarkGray.copyWith(
                            color: KColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
