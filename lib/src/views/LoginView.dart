import 'package:flutter/material.dart';
import 'package:segimutiplataform/src/controllers/LoginController.dart';
import 'package:segimutiplataform/src/utils/DataBaseSegi.dart';
import 'package:segimutiplataform/src/views/RegisterView.dart';
import 'package:segimutiplataform/src/routes/AppRoutes.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final LoginController _loginController = LoginController();
  bool _sesionActiva = false;

  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2196F3),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildHeader(context),

                      const SizedBox(height: 10),

                      _buildIllustrationSection(),

                      const SizedBox(height: 20),

                      _buildLoginForm(),

                      const SizedBox(height: 10),

                      _buildFooterActions(context),
                      
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: const BoxDecoration(
            color: Colors.black,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        const SizedBox(width: 60),

        Stack(
          alignment: const Alignment(0, 0.5),
          children: [
            Image.asset(
              "assets/images/Rectangle 8.png",
              height: 110,
              width: 130,
              fit: BoxFit.contain,
            ),
            const Text(
              'Segi!',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                fontFamily: "LuckiestGuy",
                color: Colors.white,
                letterSpacing: 1,
              ),
            ),
          ],
        ),

        const SizedBox(width: 60),

        Container(
          width: 50,
          height: 50,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(Icons.exit_to_app_sharp, color: Colors.black),
            onPressed: () async{
              bool exitSesion = await _loginController.cerrarSesion();
              if(exitSesion){
                setState(() {
                  _sesionActiva = false;
                  _emailController.clear();
                  _passwordController.clear();
                });
                Navigator.pushNamedAndRemoveUntil(context, AppRoutes.map,(Route<dynamic> route)=>false);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Sesion Cerrada"),
                    backgroundColor: Colors.green,
                    duration: Duration(seconds: 2),
                  ),
                );
              }else{
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Ocurrio un error Intentanlo más tarde"),
                    backgroundColor: Colors.red,
                    duration: Duration(seconds: 1),
                  ),
                );
              }
            },
          ),
        ),

      ],
    );
  }



  Widget _buildIllustrationSection() {
    return SizedBox(
      height: 180,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  Colors.white.withOpacity(1.0),
                  Colors.yellow.withOpacity(0.2),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          Positioned(
            top: 25,
            child: SizedBox(
              width: 150,
              height: 150,
              child: Image.asset(
                'assets/images/SEGINUEVO 1.png',
                height: 110,
                width: 130,
                fit: BoxFit.contain,
              ),
            ),
          ),
          Positioned(
            top: 25,
            right: 3,
            child: SizedBox(
              height: 60,
              width: 60,
              child: Image.asset(
                'assets/images/ubicacion 1.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginForm() {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        children: [
          const Text(
            'BIENVENIDO',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: "gill-sans",
              color: Colors.white,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 20),


          _buildLabeledTextField(
            label: 'Ingresa tu correo:',
            controller: _emailController,
            enabled: !_sesionActiva,
            keyboardType: TextInputType.emailAddress,
          ),

          const SizedBox(height: 15),

          _buildLabeledTextField(
            label: 'Ingresa tu contraseña:',
            controller: _passwordController,
            isPassword: true,
            obscureText: _obscurePassword,
            enabled: !_sesionActiva,
            onToggleVisibility: () {
              setState(() {
                _obscurePassword = !_obscurePassword;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFooterActions(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {

          },
          child: const Text(
            '¿Olvidaste tu contraseña?',
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              decoration: TextDecoration.underline,
              fontFamily: "roboto",
            ),
          ),
        ),
        const SizedBox(height: 15),
        // Botón Ingresar
        SizedBox(
          width: double.infinity,
          height: 60,
          child: ElevatedButton(
            onPressed:_sesionActiva ? null: () async {
              bool exitoso = await _loginController.manejadorSesion(
                  _emailController.text.trim(),
                  _passwordController.text
              );

              if (exitoso){
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Sesion Iniciada"),
                    backgroundColor: Colors.green,
                    duration: Duration(seconds: 1),
                  ),
                );
                Navigator.pushNamedAndRemoveUntil(context, AppRoutes.map,(Route<dynamic> route)=>false);
              }else{
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Correo o contraseña Incorrectos"),
                    backgroundColor: Colors.red,
                    duration: Duration(seconds: 1),
                  ),
                );

              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black87,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 5,
            ),
            child: const Text(
              'Ingresar',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),

        const SizedBox(height: 15),

        // Link Registro
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '¿No estas registrado? ',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 17,
                fontFamily: "roboto",
              ),
            ),
            GestureDetector(
              onTap: _sesionActiva ? null : () {
                Navigator.pushNamed(context, AppRoutes.register);
              },
              child: const Text(
                'Regístrate',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                  fontFamily: "roboto",
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLabeledTextField({
    required String label,
    required TextEditingController controller,
    bool isPassword = false,
    bool obscureText = false,
    TextInputType? keyboardType,
    VoidCallback? onToggleVisibility,
    bool enabled = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: "arial",
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(enabled ? 0.3: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextField(
            controller: controller,
            enabled: enabled,
            obscureText: isPassword ? obscureText : false,
            keyboardType: keyboardType,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 15,
              ),
              hintStyle: const TextStyle(color: Colors.white54),
              suffixIcon: isPassword && enabled
                  ? IconButton(
                icon: Icon(
                  obscureText ? Icons.visibility_off : Icons.visibility,
                  color: Colors.white,
                ),
                onPressed: onToggleVisibility,
              )
                  : null,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _checarSesionGuardada()async{
    final dbHelper = DatabaseHelper();
    final session = await dbHelper.getSession();

    if(session != null && session['email'] != null){
      setState(() {
        _emailController.text = session['email'];
        _sesionActiva = true;
      });

    }

  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void initState(){
    super.initState();
    _checarSesionGuardada();


  }
}