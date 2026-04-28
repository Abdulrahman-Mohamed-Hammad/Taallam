import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter_svg/svg.dart';

import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';
import 'package:student_app/core/Auth/data/Model/model_auth.dart';
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

class ControllerAuth extends StatelessWidget {
  const ControllerAuth({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: KColors.backgroundCourse,
        body: ScrollConfiguration(
          behavior: const ScrollBehavior().copyWith(overscroll: false),

          child: SingleChildScrollView(
            child: Stack(
              children: [
                PositionedDirectional(
                  start: 40,
                  child: Lottie.asset(
                    context.locale.languageCode == 'ar'
                        ? Kicons.backgroundCircle
                        : Kicons.backgroundCircleEn,
                  ),
                ),
                Column(
                  children: [
                    CustomContainer(
                      horizontalPadding: 16,
                      verticalPadding: 0,
                      child: SafeArea(
                        bottom: false,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Gap(16),
                            CustomContainer(
                              color: KColors.primaryAlpha20,
                              verticalPadding: 10,
                              horizontalPadding: 16,
                              margin: const EdgeInsets.only(bottom: 15),
                              border: Border.all(
                                color: KColors.bordorGreen,
                                width: 1,
                              ),
                              borderRadius: 24,
                              child: Row(
                                spacing: 5,
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    radius: 4,
                                    backgroundColor: Color(0xFF5DD0C6),
                                  ),
                                  Text(
                                    LocaleKeys.sub_app_name.tr(),
                                    style: KFonts.bold13DarkGray,
                                  ),
                                ],
                              ),
                            ),

                            Row(),
                            Text(
                              LocaleKeys.welcome_message.tr(),
                              style: KFonts.black30.copyWith(
                                fontSize: context.locale.languageCode == "ar"
                                    ? 30
                                    : 28,
                              ),
                            ),
                            const Gap(5),
                            RichText(
                              text: TextSpan(
                                style: Theme.of(context).textTheme.bodyLarge
                                    ?.merge(
                                      KFonts.black30.copyWith(
                                        fontSize:
                                            context.locale.languageCode == "ar"
                                            ? 30
                                            : 28,
                                      ),
                                    ),
                                children: [
                                  TextSpan(text: "${LocaleKeys.start.tr()} "),
                                  TextSpan(
                                    text: "${LocaleKeys.your_journey.tr()} ",
                                    style: KFonts.black30.copyWith(
                                      fontSize:
                                          context.locale.languageCode == "ar"
                                          ? 30
                                          : 28,
                                      color: KColors.primary,
                                    ),
                                  ),
                                  TextSpan(text: LocaleKeys.educational.tr()),
                                ],
                              ),
                            ),
                            const Gap(10),
                            Text(
                              LocaleKeys.join_students_global.tr(),
                              style: KFonts.bold14Secoundery.copyWith(),
                            ),
                            const Gap(20),
                          ],
                        ),
                      ),
                    ),
                    ControllerAuthButton(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ControllerAuthButton extends StatefulWidget {
  const ControllerAuthButton({super.key});

  @override
  State<ControllerAuthButton> createState() => _ControllerAuthButtonState();
}

class _ControllerAuthButtonState extends State<ControllerAuthButton> {
  bool isLogin = true;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomContainer(
          horizontalPadding: 16,

          child: Row(
            children: [
              AuthTabButton(
                label: LocaleKeys.create_account.tr(),
                isActive: !isLogin, // isActive when isLogin is true
                onTap: () {
                  if (isLogin) setState(() => isLogin = false);
                },
              ),
              AuthTabButton(
                label: LocaleKeys.login.tr(),
                isActive: isLogin, // isActive when isLogin is false
                onTap: () {
                  if (!isLogin) setState(() => isLogin = true);
                },
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: isLogin
              ? BlocProvider(
                  create: (context) => AuthCubit(),
                  child: const Login(),
                )
              : BlocProvider(
                  create: (context) => AuthCubit(),
                  child: const Register(),
                ),
        ),
      ],
    );
  }
}

class AuthTabButton extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const AuthTabButton({
    super.key,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border(
              bottom: BorderSide(
                color: isActive ? KColors.primary : const Color(0xFFE0ECEA),
                width: 2,
              ),
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: KFonts.bold15.copyWith(
                color: isActive ? KColors.black : KColors.secondary,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    var cubit = context.read<AuthCubit>();

    return Form(
      key: cubit.formKey1,
      autovalidateMode: AutovalidateMode.onUserInteractionIfError,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
              LocaleKeys.error_invalid_auth.tr(),
            ),
          ),
          const Gap(12),
          Text(
            LocaleKeys.password.tr(),
            style: KFonts.bold18.copyWith(fontSize: 14),
          ),
          const Gap(10),
          CustomPasswordField(
            controller: cubit.passwordController,
            hint: LocaleKeys.password_hint.tr(),
          ),
          const Gap(12),

          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: GestureDetector(
              onTap: () {},
              child: GestureDetector(
                onTap: () => push(context, KRoutes.forgotPassword),
                child: Text(
                  LocaleKeys.forgot_password.tr(),
                  style: KFonts.bold13DarkGray.copyWith(color: KColors.primary),
                ),
              ),
            ),
          ),
          const Gap(25),
          BlocConsumer<AuthCubit, AuthState>(
            listenWhen: (previous, current) =>
                current is AuthSuccess || current is AuthError,
            listener: (context, state) {
              if (state is AuthSuccess) {
                go(context, KRoutes.courses);
              }
              if (state is AuthError) {
                if (state.errorCode == 0) go(context, KRoutes.verfication);
              }
            },

            builder: (context, state) {
              return Row(
                spacing: 10,
                children: [
                  Expanded(
                    child: CustomContainer(
                      onTap: state is! AuthLoading
                          ? () async {
                              await cubit.googleSignIn();
                            }
                          : null,
                      height: 60,
                      borderRadius: 20,
                      border: Border.all(color: KColors.bordorColor, width: 1),
                      color: KColors.white,
                      boxShadow: shadowBlack,
                      child: Center(
                        child: SvgPicture.asset(Kicons.google, width: 30),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: CustomContainer(
                      onTap: state is! AuthLoading
                          ? () async {
                              if (cubit.formKey1.currentState?.validate() ??
                                  false) {
                                await cubit.login(
                                  AuthRequestModel(
                                    email: cubit.emailController.text.trim(),
                                    password: cubit.passwordController.text
                                        .trim(),
                                  ),
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
                                LocaleKeys.login_button.tr(),
                                style: KFonts.bold14White.copyWith(
                                  fontSize: 16,
                                ),
                              )
                            : const LoadingWidget(
                                jsonIcon: Kicons.whiteloadingBook,
                              ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class Register extends StatelessWidget {
  const Register({super.key});

  @override
  Widget build(BuildContext context) {
    var cubit = context.read<AuthCubit>();

    return Form(
      key: cubit.formKey,
      autovalidateMode: AutovalidateMode.onUserInteractionIfError,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.full_name.tr(),
            style: KFonts.bold18.copyWith(fontSize: 14),
          ),
          const Gap(10),
          CustomTextField(
            controller: cubit.nameController,
            hint: LocaleKeys.full_name_hint.tr(),
            icon: Icons.person,
            textInputAction: TextInputAction.next,
            validator: (value) =>
                KRegex.validatorName(value, LocaleKeys.username_required.tr()),
          ),
          const Gap(12),
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
            validator: (value) => KRegex.validator(
              value,
              KRegex.email,
              LocaleKeys.email_invalid.tr(),
            ),
          ),
          const Gap(12),
          Text(
            LocaleKeys.password.tr(),
            style: KFonts.bold18.copyWith(fontSize: 14),
          ),
          const Gap(10),
          CustomPasswordField(
            controller: cubit.passwordController,
            hint: LocaleKeys.password_hint.tr(),
            validator: (value) => KRegex.validator(
              value,
              KRegex.passwordRegex,
              LocaleKeys.password_invalid.tr(),
            ),
          ),
          const Gap(25),
          BlocConsumer<AuthCubit, AuthState>(
            listenWhen: (previous, current) =>
                current is AuthSuccess || current is AuthError,
            listener: (context, state) {
              if (state is AuthSuccess) {
                push(context, KRoutes.verfication, extra: cubit);
              }
            },
            builder: (context, state) {
              return CustomContainer(
                onTap: state is! AuthLoading
                    ? () async {
                        if (cubit.formKey.currentState?.validate() ?? false) {
                          await cubit.register(
                            AuthRequestModel(
                              fullName: cubit.nameController.text,
                              email: cubit.emailController.text.trim(),
                              password: cubit.passwordController.text.trim(),
                            ),
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
                          LocaleKeys.create_account.tr(),
                          style: KFonts.bold14White.copyWith(fontSize: 16),
                          textAlign: TextAlign.center,
                        )
                      : const LoadingWidget(jsonIcon: Kicons.whiteloadingBook),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
