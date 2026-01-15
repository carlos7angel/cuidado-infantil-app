import 'package:get/get.dart';
import 'package:cuidado_infantil/Intro/models/infographic_model.dart';

class OnBoardingController extends GetxController {

  List<Infographic> _infographicList = [];
  List<Infographic> get infographicList => _infographicList;

  int _currentPage = 0;
  int get currentPage => _currentPage;

  @override
  void onInit() {
    _infographicList = [
      Infographic(
        1, 
        'assets/images/onboarding_1.png',
        'Cuidado infantil a un clic de distancia',
        'Registra el día a día de niñas y niños de manera ágil, organizada y segura. Información siempre en tu mano.'
      ),
      Infographic(
        2, 
        'assets/images/onboarding_2.png',
        'Cuidar, Registrar, Mejorar', 
        'Monitorea y evalúa las áreas de nutrición y desarrollo de los niños con información precisa.'
      ),
      Infographic(
          3,
          'assets/images/onboarding_3.png',
          'Ayudamos en tu crecimiento',
          'Promovemos un ambiente de cuidado y respeto entre todos, que ayuda a tu crecimiento.'
      ),
    ];
    super.onInit();
  }

  void setPage(int page) {
    _currentPage = page;
    update();
  }

}