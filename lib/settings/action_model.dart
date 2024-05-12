class ActionModel {
  final String title;
  final String icon;
  final bool isMore;
  final bool darkMode;
  final void Function() ontap;

  ActionModel({
    required this.title,
    required this.icon,
    this.isMore = false,
    this.darkMode = false,
    required this.ontap,
  });
}
