import 'package:flutter/material.dart';
import 'package:segimutiplataform/src/views/SaveLocation.dart';
import 'package:segimutiplataform/src/routes/AppRoutes.dart';


class MapView extends StatefulWidget {
  const MapView({Key? key}) : super(key: key);

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> with SingleTickerProviderStateMixin {
  final _searchController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _animation;

  bool _isMenuExpanded = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  void _toggleMenu() {
    setState(() {
      _isMenuExpanded = !_isMenuExpanded;
      if (_isMenuExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          _buildMapBackground(),

          _buildSearchBar(),

          _buildFloatingMenu(context),
        ],
      ),
    );
  }

  Widget _buildMapBackground() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.grey[300],
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.map, size: 50, color: Colors.grey),
            SizedBox(height: 10),
            Text(
              'AQUÍ VA EL MAPA DE GOOGLE GEI',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Positioned(
      top: 50,
      left: 20,
      right: 20,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Ubicación de destino',
            hintStyle: TextStyle(color: Colors.grey[600], fontSize: 16),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            suffixIcon: IconButton(
              icon: const Icon(Icons.search, color: Colors.grey),
              onPressed: () {
                //Implementar lógica de búsqueda
                print("Buscando: ${_searchController.text}");
              },
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildFloatingMenu(BuildContext context) {
    return Positioned(
      right: 20,
      bottom: 160,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [

          _buildAnimatedButton(
            icon: Icons.person,
            label: "Perfil",
            onPressed: (){
              Navigator.pushNamed(context, AppRoutes.login);
            }
          ),

          _buildAnimatedButton(
            icon: Icons.help,
            label: "Ayuda",
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.help);
            }
          ),

          _buildCircleButton(
            icon: _isMenuExpanded ? Icons.close : Icons.keyboard_arrow_up,
            backgroundColor: _isMenuExpanded ? Colors.grey[800] : const Color(0xFF2196F3),
            onPressed: _toggleMenu,
          ),
          const SizedBox(height: 15),

          _buildCircleButton(
            icon: Icons.bookmark,
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => SaveLocationDialog(
                  onSave: (String locationName) {
                    print('Ubicación guardada: $locationName');
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedButton({
    required IconData icon,
    required VoidCallback onPressed,
    String? label,
  }) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ScaleTransition(
          scale: _animation,
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: _buildCircleButton(
              icon: icon,
              onPressed: onPressed,
            ),
          ),
        );
      },
    );
  }

  Widget _buildCircleButton({
    required IconData icon,
    required VoidCallback onPressed,
    Color? backgroundColor,
    bool mini = false,
  }) {
    return Container(
      width: mini ? 50 : 60,
      height: mini ? 50 : 60,
      decoration: BoxDecoration(
        color: backgroundColor ?? const Color(0xFF2196F3),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.9),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white, size: mini ? 24 : 28),
        onPressed: onPressed,
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _animationController.dispose();
    super.dispose();
  }
}