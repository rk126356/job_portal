import 'package:job_portal/const/url.dart';
import 'package:job_portal/controllers/basic/get_post_api.dart';

import '../../models/basic/category_model.dart';

Future<List<CategoryModel>> getCategories() async {
  final data = await getApi(url: '$providerBaseUrl/fetch_job_categories.php');
  if (data != null) {
    List<dynamic> categoriesData = data['data'];
    return categoriesData.map((data) => CategoryModel.fromJson(data)).toList();
  }
  return [];
}
