import 'package:hookup4u/Screens/cardpage/card_pictures.dart';
import 'package:hookup4u/restapi/restapi.dart';

class CardPictureViewModel{
  CardPicturesState state;

  CardPictureViewModel(this.state){
    getActivity();
  }

  List list;
  getActivity() async {
    list = await RestApi.getActivity();
    if(list==null){
      state.onEnd = true;
    }
    state.setState(() {});
  }
}