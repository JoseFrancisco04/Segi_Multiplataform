import 'package:flutter/material.dart';
import 'package:segimutiplataform/src/models/Ubication.dart';
import 'package:segimutiplataform/src/controllers/GeocodeController.dart';
import 'package:segimutiplataform/src/controllers/UbicationsControllers.dart';
import 'package:segimutiplataform/src/routes/AppRoutes.dart';
import 'package:segimutiplataform/src/views/SaveLocation.dart';
import 'package:segimutiplataform/src/views/NavigationMap.dart';
import 'package:segimutiplataform/src/utils/DataBaseSegi.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:google_navigation_flutter/google_navigation_flutter.dart';

/*
EQUIPO:

Jose Francisco Hernandez Fernando
Jesus Orlando Garrido Cruz
Alan Sanchez Garrido
Guadalupe Cruz Hernandez

 */

class MainMap extends StatefulWidget {
  const MainMap({Key? key}) : super(key: key);

  @override
  State<MainMap> createState() => _MainMapState();
}

class _MainMapState extends State<MainMap> with SingleTickerProviderStateMixin {
  final _searchController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _animation;

  late GoogleMapViewController _mapController;
  late LatLng _myLocation;
  final Color BLUE_BUTTONS = Color(0xFF2196F3);

  bool _isMenuExpanded = false;

  String _userEmail = "SESSION ERROR";

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
    _solicitarPermisosDeUbicacion();
    _getUserEmail();
  }

  Future<void> _getUserEmail() async {
    try{
      Map<String, dynamic>? data = await DatabaseHelper().getSession();
      if(data != null){
        _userEmail = data['email'].toString();
      }
    }catch(err){
      _userEmail = "SESSION ERROR";
      debugPrint("Session error ${err.toString()}");
    }
  }

  Future<void> _solicitarPermisosDeUbicacion() async {
    var status = await Permission.locationWhenInUse.status;
    if (!status.isGranted) {
      status = await Permission.locationWhenInUse.request();
    }
    if (!status.isGranted) {
      debugPrint("Permiso de ubicación denegado por el usuario");
    }
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
      floatingActionButton: _floatingActionButton(),
    );
  }

  Widget _buildMapBackground() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.grey[300],
      child: GoogleMapsMapView(
        onViewCreated: _onViewCreated,
        initialZoomControlsEnabled: false,
        initialCameraPosition: CameraPosition(
          target: LatLng(latitude: 20.1738, longitude: -98.0549),
        ),
        //initialCameraPosition: CameraPosition(target: LatLng(latitude: 90, longitude: 90)),
        onMapLongClicked: _onMapLongClicked,
      ),
    );
  }

  void _onViewCreated(GoogleMapViewController controller) {
    _mapController = controller;
    _mapController.setMyLocationEnabled(true);
    _printMarkers();
  }

  void _printMarkers() {
    UbicationsControllers.getUbications(_userEmail).then((ubications) {
      List<MarkerOptions> markers = [];
      for (int i = 0; i < ubications.length; i++) {
        markers.add(MarkerOptions(position: ubications[i]));
      }
      _mapController.addMarkers(markers);
    });
  }

  void _onMapLongClicked(LatLng latlng) {
    _printMarkers();
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
          onSubmitted: _onSubmit,
          decoration: InputDecoration(
            hintText: 'Ubicación de destino',
            hintStyle: TextStyle(color: Colors.grey[600], fontSize: 16),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 15,
            ),
            suffixIcon: IconButton(
              icon: const Icon(Icons.search, color: Colors.grey),
              onPressed: () {
                _onSubmit("");
              },
            ),
          ),
        ),
      ),
    );
  }

  void _onSubmit(String textInput) {
    GeocodeController.getLatLng(textInput)
        .then((res) {
          if (res != null) {
            _messageSB("Iniciando navegación...");
            _navigationInit(res);
          } else {
            _messageSB("Destino no encontrado :(");
          }
        })
        .catchError((error) {
          debugPrint("Geocode ${error.toString()}");
        });
    _searchController.clear();
    _searchController.clearComposing();
  }

  void _messageSB(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: Duration(seconds: 3)),
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
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.login);
            },
          ),

          _buildAnimatedButton(
            icon: Icons.help,
            label: "Ayuda",
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.help);
            },
          ),

          _buildCircleButton(
            icon: _isMenuExpanded ? Icons.close : Icons.keyboard_arrow_up,
            backgroundColor: _isMenuExpanded ? Colors.grey[800] : BLUE_BUTTONS,
            onPressed: _toggleMenu,
          ),
          const SizedBox(height: 15),

          _buildCircleButton(
            icon: Icons.bookmark,
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => SaveLocationDialog(onSave: _onSave),
              );
            },
          ),
        ],
      ),
    );
  }

  _onSave(String locationName) {
    if(_userEmail != "SESSION ERROR"){
      _saveUbication(
        _userEmail,
        locationName,
        _myLocation.latitude,
        _myLocation.longitude,
      );
    }else{
      _messageSB("Inicie Sesión para continuar");
    }
  }

  _saveUbication(String userEmail, String address, double lat, double lng) {
    UbicationsControllers.saveUbication(
      Ubication(
        coordinates: Coordinates(lat: lat, lng: lng),
        address: address,
        userEmail: userEmail,
      ),
    );
  }

  Widget _floatingActionButton() {
    return FloatingActionButton(
      onPressed: _centerOnMyLocation,
      backgroundColor: BLUE_BUTTONS,
      child: Icon(Icons.my_location, color: Colors.white),
    );
  }

  void _centerOnMyLocation() {
    _mapController
        .getMyLocation()
        .then((location) {
          _myLocation = location!;
          _mapController.moveCamera(CameraUpdate.newLatLngZoom(location, 17.0));
        })
        .catchError((onError) {
          debugPrint("NoooOooOO $onError");
        });
  }

  void _navigationInit(LatLng latlng) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) => NavigationMap(destino: latlng),
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
            child: _buildCircleButton(icon: icon, onPressed: onPressed),
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
        color: backgroundColor ?? BLUE_BUTTONS,
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
