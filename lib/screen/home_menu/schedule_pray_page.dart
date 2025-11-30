import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todolist_app/cubit/prayer_cubit.dart';
import 'package:todolist_app/screen/widget/custom_widged.dart';

class SchedulePrayPage extends StatefulWidget {
  const SchedulePrayPage({super.key});

  @override
  State<SchedulePrayPage> createState() => _SchedulePrayPageState();
}

class _SchedulePrayPageState extends State<SchedulePrayPage> {
  String? selectedCountry;
  String? selectedCity;

  // final Map<String, List<String>> cityData = {
  //   "Indonesia": ["Jakarta", "Tegal", "Bandung", "Surabaya", "Yogyakarta"],
  //   "Malaysia": ["Kuala Lumpur", "Johor", "Penang"],
  //   "Saudi Arabia": ["Makkah", "Madinah", "Riyadh"],
  // };

  void fetchTimes() {
    if (selectedCity == null || selectedCountry == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Pilih negara dan kota dulu')));
      return;
    }

    context.read<PrayerCubit>().loadPrayerTimes(
      selectedCity!,
      selectedCountry!,
    );
  }

  // @override
  // void didChangeDependencies() {
  //   // TODO: implement didChangeDependencies
  //   super.didChangeDependencies();
  //   if (selectedCountry != null) {
  //     if (!cityData[selectedCountry]!.contains(selectedCity)) {
  //       selectedCity = null; // reset jika value lama tidak valid
  //     }
  //   }
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<PrayerCubit>().loadCountries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Jadwal Sholat')),
      body: Column(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  BlocBuilder<PrayerCubit, PrayerState>(
                    builder: (context, state) {
                      if (state is LocationLoaded) {
                        return DropdownButtonFormField<String>(
                          value: selectedCountry,
                          decoration: const InputDecoration(
                            labelText: "Pilih negara",
                            border: OutlineInputBorder(),
                          ),
                          items:
                              state.countries.entries.map((e) {
                                return DropdownMenuItem(
                                  value: e.key,
                                  child: Text(e.key),
                                );
                              }).toList(),
                          onChanged: (val) {
                            setState(() {
                              selectedCountry = val;
                              selectedCity = null; // reset kota
                            });

                            final country = selectedCountry ?? "Indonesia";
                            context.read<PrayerCubit>().loadCities(country);
                          },
                        );
                      }

                      return SizedBox();
                    },
                  ),
                  gap(16),
                  BlocBuilder<PrayerCubit, PrayerState>(
                    builder: (context, state) {
                      if (state is LocationLoaded) {
                        return DropdownButtonFormField<String>(
                          value: selectedCity,
                          decoration: const InputDecoration(
                            labelText: "Pilih kota",
                            border: OutlineInputBorder(),
                          ),
                          items:
                              state.cities.map((city) {
                                return DropdownMenuItem(
                                  value: city,
                                  child: Text(city),
                                );
                              }).toList(),
                          onChanged: (val) {
                            setState(
                              () => selectedCity = val, // reset kota
                            );
                          },
                        );
                      }
                      return SizedBox();
                    },
                  ),

                  gap(20),
                  BlocBuilder<PrayerCubit, PrayerState>(
                    builder: (context, state) {
                      if (state is LocationLoaded) {
                        return SizedBox(
                          height: 40,
                          child: ElevatedButton(
                            onPressed: fetchTimes,
                            child: const Text("Tampilkan Jadwal"),
                          ),
                        );
                      }

                      return SizedBox();
                    },
                  ),
                ],
              ),
            ),
          ),

          gap(16),
          Expanded(
            child: BlocBuilder<PrayerCubit, PrayerState>(
              builder: (context, state) {
                if (state is PrayerLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is PrayerError) {
                  return Center(child: Text(state.message));
                }

                if (state is PrayerLoaded) {
                  final t = state.times;

                  return ListView(
                    padding: EdgeInsets.all(16),
                    children: [
                      PrayerTile(title: "Shubuh", time: t.fajr),
                      PrayerTile(title: "Terbit", time: t.sunrise),
                      PrayerTile(title: "Dzuhur", time: t.dhuhur),
                      PrayerTile(title: "Ashar", time: t.ashar),
                      PrayerTile(title: "Magrib", time: t.maghrib),
                      PrayerTile(title: "Isya", time: t.isya),
                    ],
                  );
                }

                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class PrayerTile extends StatelessWidget {
  final String title;
  final String time;
  const PrayerTile({super.key, required this.title, required this.time});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(title, style: const TextStyle(fontSize: 18)),
        trailing: Text(time, style: const TextStyle(fontSize: 20)),
      ),
    );
  }
}
