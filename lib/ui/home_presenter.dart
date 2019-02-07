import 'package:flutter/widgets.dart';
import 'package:flutter_tic_tac_toe/storage/game_info_repository.dart';

class HomePresenter {

  GameInfoRepository repository;

  HomePresenter() {
    repository = GameInfoRepository.getInstance();
  }

  Stream buildVictoriesStream() {
    return repository.getVictoryStream();
  }

  /// Gets a victory count from a stream snapshot.
  int getVictoryCountFromStream(AsyncSnapshot snapshot) {
    return repository.getVictoryCount(snapshot);
  }

}