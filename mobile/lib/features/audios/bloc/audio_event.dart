/// Classe abstraite pour tous les événements liés aux audios
abstract class AudioEvent {}

/// Événement pour charger tous les audios depuis l'API
class LoadAudiosEvent extends AudioEvent {}
