import 'package:flutter/widgets.dart';
import 'package:flutter_tic_tac_toe/storage/victory_repository.dart';

class HomePresenter {

  VictoryRepository repository;

  HomePresenter() {
    repository = VictoryRepository.getInstance();
  }

  Stream buildVictoriesStream() {
    return repository.getVictoryStream();
  }

  int getVictoryCount(AsyncSnapshot snapshot) {
    return repository.getVictoryCount(snapshot);
  }

}