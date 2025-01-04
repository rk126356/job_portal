import 'package:flutter/material.dart';
import 'package:job_portal/const/url.dart';
import 'package:job_portal/controllers/basic/get_post_api.dart';
import 'package:job_portal/models/user/user_model.dart';
import 'package:provider/provider.dart';

import '../../providers/user_provider.dart';

Future<UserModel?> getUser(String id) async {
  final data = await postApi(url: '$userBaseUrl/fetch_user_details.php', body: {
    'user_id': id,
  });
  if (data != null) {
    return UserModel.fromJson(data['data']);
  }
  return null;
}

Future<UserModel?> reloadUser(BuildContext context, String id) async {
  final provider = Provider.of<UserProvider>(context, listen: false);
  UserModel? user = await getUser(id);
  if (user != null) {
    provider.setUserData(user);
    return user;
  }
  return null;
}
