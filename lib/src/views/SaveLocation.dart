import 'package:flutter/material.dart';

void showSaveLocationDialog(BuildContext context, Function(String) onSave) {
  showDialog(
    context: context,
    builder: (context) => SaveLocationDialog(onSave: onSave),
  );
}

class SaveLocationDialog extends StatefulWidget {
  final Function(String) onSave;

  const SaveLocationDialog({
    Key? key,
    required this.onSave,
  }) : super(key: key);

  @override
  State<SaveLocationDialog> createState() => _SaveLocationDialogState();
}

class _SaveLocationDialogState extends State<SaveLocationDialog> {
  final _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 300,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF64B5F6), Color(0xFF2196F3)],
          ),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTitle(),
            const SizedBox(height: 25),
            _buildInputField(),
            const SizedBox(height: 30),
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return const Text(
      'UBICACIÓN',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.white,
        fontSize: 22,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.5,
        fontFamily: "gill-sans",
      ),
    );
  }

  Widget _buildInputField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 5, bottom: 10),
          child: Text(
            'Nombre de la ubicación:',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF90CAF9),
            borderRadius: BorderRadius.circular(15),
          ),
          child: TextField(
            controller: _nameController,
            style: const TextStyle(fontSize: 16, color: Colors.white),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              hintText: 'Ejemplo: Casa, Trabajo',
              hintStyle: TextStyle(color: Colors.white70, fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        _buildDialogButton(
          color: const Color(0xFFD32F2F),
          icon: Icons.close,
          onTap: () => Navigator.pop(context),
        ),

        const SizedBox(width: 15),

        _buildDialogButton(
          color: const Color(0xFF4CAF50),
          icon: Icons.check,
          onTap: () => _handleSave(context),
        ),
      ],
    );
  }

  void _handleSave(BuildContext context) {
    if (_nameController.text.isNotEmpty) {
      widget.onSave(_nameController.text);
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor ingresa un nombre'),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Widget _buildDialogButton({
    required Color color,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: Container(
        height: 55,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(15),
            onTap: onTap,
            child: Center(
              child: Icon(icon, color: Colors.white, size: 35),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}