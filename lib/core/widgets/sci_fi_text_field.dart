import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/galactic_colors.dart';

class SciFiTextField extends StatefulWidget {
  const SciFiTextField({
    required this.label,
    required this.prefixIcon,
    super.key,
    this.isPassword = false,
    this.onChanged,
    this.controller,
    this.validator,
  });
  final String label;
  final IconData prefixIcon;
  final bool isPassword;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller; // Added controller support
  final String? Function(String?)? validator;

  @override
  State<SciFiTextField> createState() => _SciFiTextFieldState();
}

class _SciFiTextFieldState extends State<SciFiTextField> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return FocusScope(
      child: Focus(
        onFocusChange: (focus) => setState(() => _isFocused = focus),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: GalacticColors.deepNebula.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _isFocused
                  ? GalacticColors.etherealCyan
                  : GalacticColors.wormholeBlue.withValues(alpha: 0.5),
            ),
            boxShadow: _isFocused
                ? [
                    BoxShadow(
                      color: GalacticColors.etherealCyan.withValues(alpha: 0.2),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ]
                : [],
          ),
          child: TextFormField(
            controller: widget.controller,
            obscureText: widget.isPassword,
            onChanged: widget.onChanged,
            validator: widget.validator,
            style: GoogleFonts.exo2(color: Colors.white, fontSize: 14),
            decoration: InputDecoration(
              labelText: widget.label,
              labelStyle: GoogleFonts.orbitron(
                color:
                    _isFocused ? GalacticColors.etherealCyan : Colors.white54,
                fontSize: 12,
              ),
              prefixIcon: Icon(
                widget.prefixIcon,
                color:
                    _isFocused ? GalacticColors.etherealCyan : Colors.white54,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
