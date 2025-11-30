import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todolist_app/model/prayer_time_model.dart';
import 'package:todolist_app/service/prayer_service.dart';

class PrayerCubit extends Cubit<PrayerState> {
  final PrayerService _service;
  PrayerCubit(this._service) : super(PrayerInitial());
  Map<String, String> countryMap = {};

  Future<void> loadPrayerTimes(String city, String country) async {
    emit(PrayerLoading());
    try {
      final data = await _service.getPrayerTimes(city, country);
      emit(PrayerLoaded(data));
    } catch (e) {
      emit(PrayerError(e.toString()));
    }
  }

  Future<void> loadCountries() async {
    emit(PrayerTimesLoading());
    try {
      countryMap = await _service.getCountries();
      emit(LocationLoaded(countries: countryMap, cities: []));
    } catch (e) {
      emit(PrayerError(e.toString()));
    }
  }

  Future<void> loadCities(String countryCode) async {
    emit(PrayerTimesLoading());
    try {
      final cities = await _service.getCities(countryCode);
      emit(LocationLoaded(countries: countryMap, cities: cities));
    } catch (e) {
      emit(PrayerError(e.toString()));
    }
  }
}

abstract class PrayerState {}

class PrayerInitial extends PrayerState {}

class LocationLoaded extends PrayerState {
  final Map<String, String> countries;
  final List<String> cities;

  LocationLoaded({required this.countries, required this.cities});
}

class PrayerLoading extends PrayerState {}

class PrayerLoaded extends PrayerState {
  final PrayerTimeModel times;
  PrayerLoaded(this.times);
}

class PrayerError extends PrayerState {
  final String message;
  PrayerError(this.message);
}

class PrayerTimesLoading extends PrayerState {}
