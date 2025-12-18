import 'package:flutter/material.dart';
import 'package:segimutiplataform/src/controllers/RegisterController.dart';
// Asumiendo que crearás este archivo, si no, puedes poner la clase al final de este mismo archivo
import 'package:segimutiplataform/src/views/widgets/CustomTextField.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _nameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  final RegisterController _registerController = RegisterController();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2196F3),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(context),
              const SizedBox(height: 80),

              _buildFormSection(),

              const SizedBox(height: 15),

              _buildSaveButton(),

              _buildFooterImage(),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            style: IconButton.styleFrom(
              backgroundColor: Colors.black,
              padding: const EdgeInsets.all(12),
            ),
            onPressed: () {
               Navigator.pop(context);
            },
          ),

          const SizedBox(width: 90),

          Stack(
            children: [
              Text(
                'Registro',
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1
                ),
              ),
            ],

          ),
        ],
      ),
    );
  }

  Widget _buildFormSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF64B5F6),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          CustomTextField(
            controller: _nameController,
            icon: Icons.person,
            label: 'Nombre',
          ),
          const SizedBox(height: 15),
          CustomTextField(
            controller: _lastNameController,
            icon: Icons.person_outline,
            label: 'Apellidos',
          ),
          const SizedBox(height: 15),
          CustomTextField(
            controller: _emailController,
            icon: Icons.email,
            label: 'Correo',
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 15),
          CustomTextField(
            controller: _passwordController,
            icon: Icons.vpn_key,
            label: 'Contraseña',
            isPassword: true,
            obscureText: _obscurePassword,
            onToggleVisibility: () => setState(() => _obscurePassword = !_obscurePassword),
          ),
          const SizedBox(height: 15),
          CustomTextField(
            controller: _confirmController,
            icon: Icons.lock,
            label: 'Confirma la contraseña',
            isPassword: true,
            obscureText: _obscureConfirm,
            onToggleVisibility: () => setState(() => _obscureConfirm = !_obscureConfirm),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        width: double.infinity,
        height: 60,
        child: ElevatedButton(
          onPressed: () async {
            String resultado = await _registerController.procesarRegistro(
                name: _nameController.text,
                lastname: _lastNameController.text,
                email: _emailController.text,
                password: _passwordController.text,
                confirmPassword: _confirmController.text
            );

            if(resultado == "SUCCESS"){
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Usuario Registrado Existosamente'),
                    backgroundColor: Colors.green,
                    duration: Duration(seconds: 2),
                  )
              );
              Navigator.pop(context);
            }else{
              ScaffoldMessenger.of(context).showSnackBar(
                   SnackBar(
                    content: Text(resultado),
                     backgroundColor: Colors.red,
                     duration: const Duration(seconds: 2),
                  )
              );

            }

          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black87,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            elevation: 5,
          ),
          child: const Text(
            'Guardar',
            style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildFooterImage() {
    return SizedBox(
      height: 180,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 25,
            right: 250,
            child: SizedBox(
              width: 150,
              height: 150,
              child: Image.asset('assets/images/feli 2.png', fit: BoxFit.contain),
            ),
          ),

          Positioned(
            right: 50,
            bottom: 20,
            top: 25,
            child: Container(
              decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
              child: IconButton(
                icon: const Icon(Icons.edit, color: Colors.black),
                onPressed: () {},
              ),
            ),
          ),
        ],
      ),
    );
  }
}