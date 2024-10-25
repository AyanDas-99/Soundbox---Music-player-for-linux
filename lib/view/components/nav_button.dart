import 'package:flutter/material.dart';

class NavButton extends StatefulWidget {
  const NavButton({
    super.key,
    required this.text,
    required this.onPress,
    required this.selected,
    required this.icon,
  });
  final String text;
  final VoidCallback onPress;
  final bool selected;
  final Icon icon;

  @override
  State<NavButton> createState() => _NavButtonState();
}

class _NavButtonState extends State<NavButton> {
  Color backgroundColor = Colors.transparent;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) {
        setState(() {
          backgroundColor = Colors.blueGrey.shade900;
        });
        print('entered..');
      },
      onExit: (event) {
        setState(() {
          backgroundColor = Colors.transparent;
        });
        print('exited..');
      },
      child: AnimatedContainer(
        margin: const EdgeInsets.all(10),
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
        color: widget.selected ? Colors.blue : backgroundColor,
        borderRadius: BorderRadius.circular(20)
        ),
        child: ListTile(
          leading: widget.icon,
          title: Text(widget.text),
          textColor: Colors.white,
          iconColor: Colors.white,
          onTap: widget.onPress,
        ),
      ),
    );
  }
}
