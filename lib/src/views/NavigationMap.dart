import 'package:flutter/material.dart';
import 'package:google_navigation_flutter/google_navigation_flutter.dart';

class NavigationMap extends StatefulWidget {
  final LatLng destino; // El Punto B

  const NavigationMap({Key? key, required this.destino}) : super(key: key);

  @override
  State<NavigationMap> createState() => _NavigationMapState();
}

class _NavigationMapState extends State<NavigationMap> {
  // Variable para saber si la vista está lista
  bool _isNavigationReady = false;

  @override
  void initState() {
    super.initState();
    _iniciarSesionDeNavegacion();
  }

  // Lógica de inicio (asíncrona)
  Future<void> _iniciarSesionDeNavegacion() async {
    // 1. Inicializar la sesión. Esto prepara el SDK.
    await GoogleMapsNavigator.initializeNavigationSession();

    // 2. Configurar el "Punto B".
    // Nota: Si no especificas el origen, el SDK usa por defecto la ubicación actual del usuario (Punto A).
    final dest = NavigationWaypoint.withLatLngTarget(
      target: widget.destino,
      title: "Destino Seleccionado", // Útil para lectores de pantalla
    );

    // 3. Establecer el destino en el navegador
    await GoogleMapsNavigator.setDestinations(
      Destinations(
        waypoints: [dest],
        displayOptions: NavigationDisplayOptions(
          showTrafficLights: true,
          showStopSigns: true,
        ),
        routingOptions: RoutingOptions(
          travelMode: NavigationTravelMode.walking,
        ),
      ),
    );

    // 4. Iniciar la guía (comienza a hablar y dar instrucciones)
    await GoogleMapsNavigator.startGuidance();

    // 5. Opcional: Simular ruta si estás probando en emulador
    // await GoogleMapsNavigator.simulator.simulateLocationsAlongExistingRoute();

    if (mounted) {
      setState(() {
        _isNavigationReady = true;
      });
    }
  }

  @override
  void dispose() {
    // IMPORTANTE: Limpiar la sesión al salir para liberar memoria y parar el GPS
    GoogleMapsNavigator.cleanup();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Guiando a destino..."),
        backgroundColor: Colors.blueGrey,
      ),
      body: !_isNavigationReady
          ? const Center(child: CircularProgressIndicator()) // Cargando...
          : GoogleMapsNavigationView(
              onViewCreated: (GoogleNavigationViewController controller) {
                // El controlador se crea, la navegación ya está corriendo por detrás
                // gracias a startGuidance() que llamamos en initState.

                // Opcional: Configurar la cámara para que siga al usuario
                controller.setMyLocationEnabled(true);
                //controller.setCameraFollowsLocation(true);
              },
            ),
    );
  }
}
