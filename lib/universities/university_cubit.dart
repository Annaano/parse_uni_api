import 'dart:convert';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'university_state.dart';
import 'package:http/http.dart' as http;

class ApiCubit extends Cubit<ApiState> {
  ApiCubit() : super(const ApiState());

  fetchUniversities(String countryName) async {
    try {
      var serverURL = "http://universities.hipolabs.com/search";
      var token = countryName;
      var url = '$serverURL?country=$token';
      var response =
          await http.get(Uri.parse(url)).timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        var items = json.decode(response.body);
        emit(state.copyWith(
          universities: items,
          isLoading: false,
          internetConnection: true,
        ));
      } else {
        emit(state.copyWith(universities: [], isLoading: false));
      }
    } on SocketException {
      emit(state.copyWith(isLoading: false, internetConnection: false));
    }
  }
}
