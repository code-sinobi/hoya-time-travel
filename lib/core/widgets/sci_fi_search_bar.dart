import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/era_theme.dart';

class SciFiSearchBar extends StatefulWidget {
  final ValueChanged<String>? onChanged;
  final String hintText;

  const SciFiSearchBar({
    super.key,
    this.onChanged,
    this.hintText = 'Search the archives...',
  });

  @override
  State<SciFiSearchBar> createState() => _SciFiSearchBarState();
}

class _SciFiSearchBarState extends State<SciFiSearchBar> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() => _isFocused = _focusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: MythicColors.deepIndigo.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _isFocused
              ? MythicColors.fluxCyan
              : MythicColors.bronze.withValues(alpha: 0.3),
          width: _isFocused ? 1.5 : 1,
        ),
        boxShadow: _isFocused
            ? [
                BoxShadow(
                  color: MythicColors.fluxCyan.withValues(alpha: 0.3),
                  blurRadius: 12,
                  spreadRadius: 1,
                ),
              ]
            : [],
      ),
      child: TextField(
        focusNode: _focusNode,
        onChanged: widget.onChanged,
        style: GoogleFonts.exo2(color: Colors.white, fontSize: 16),
        cursorColor: MythicColors.fluxCyan,
        decoration: InputDecoration(
          prefixIcon:
              Icon(
                    Icons.search,
                    color: _isFocused
                        ? MythicColors.fluxCyan
                        : MythicColors.stoneGray,
                  )
                  .animate(target: _isFocused ? 1 : 0)
                  .scale(
                    begin: const Offset(1, 1),
                    end: const Offset(1.2, 1.2),
                  ),
          hintText: widget.hintText,
          hintStyle: GoogleFonts.exo2(
            color: MythicColors.stoneGray,
            fontSize: 16,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
          suffixIcon: _isFocused
              ? IconButton(
                  icon: const Icon(Icons.clear, color: MythicColors.stoneGray),
                  onPressed: () {
                    // Logic to clear controller would go here if we extracted controller
                  },
                )
              : null,
        ),
      ),
    );
  }
}
