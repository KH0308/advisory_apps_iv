import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/database_service.dart';

class ListController extends GetxController {
  var listData = [].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var picString = ''.obs;

  @override
  void onInit() {
    fetchData();
    fetchPicFB();
    super.onInit();
  }

  Future<void> fetchPicFB() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String pic = prefs.getString('picFB') ?? '';

    picString.value = pic;
  }

  Future<void> fetchData() async {
    errorMessage.value = '';
    try {
      isLoading(true);
      await Future.delayed(const Duration(milliseconds: 500), () async {
        var fetchedNovels = await DatabaseService().fetchListData();
        if (fetchedNovels['status']['code'] == 200) {
          listData.value = fetchedNovels['listing'];
          isLoading.value = false;
        } else if (fetchedNovels['listing'] == []) {
          listData.value = [];
          isLoading.value = false;
        } else {
          errorMessage.value = 'Invalid Token';
          isLoading.value = false;
        }
      });
    } catch (e) {
      errorMessage.value = 'Failed to load novels: $e';
      debugPrint(errorMessage.value);
    } finally {
      isLoading(false);
      debugPrint('Final loading state ${isLoading.value}');
    }
  }
}
