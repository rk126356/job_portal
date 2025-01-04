import 'package:job_portal/const/url.dart';
import 'package:job_portal/controllers/basic/get_post_api.dart';
import 'package:job_portal/models/job/job_model.dart';
import 'package:job_portal/providers/user_provider.dart';

Future<List<JobModel>> getRecentJobs() async {
  final data = await getApi(url: '$userBaseUrl/fetch_recent_jobs.php');
  if (data != null) {
    List<dynamic> jobs = data['data'];
    return jobs.map((job) => JobModel.fromJson(job)).toList();
  }
  return [];
}

Future<List<JobModel>> getJobs() async {
  final data = await getApi(url: '$userBaseUrl/fetch_jobs.php');
  if (data != null) {
    List<dynamic> jobs = data['data'];
    return jobs.map((job) => JobModel.fromJson(job)).toList();
  }
  return [];
}

Future<List<JobModel>> getPostedJobs() async {
  final data =
      await postApi(url: '$providerBaseUrl/fetch_posted_jobs.php', body: {
    'user_id': globalUserId,
  });
  if (data != null) {
    List<dynamic> jobs = data['data'];
    return jobs.map((job) => JobModel.fromJson(job)).toList();
  }
  return [];
}

Future<List<JobModel>> getBookmarkedJobs() async {
  final data =
      await postApi(url: '$userBaseUrl/fetch_bookmarked_jobs.php', body: {
    'user_id': globalUserId,
  });
  if (data != null) {
    List<dynamic> jobs = data['data'];
    return jobs.map((job) => JobModel.fromJson(job)).toList();
  }
  return [];
}

Future<bool> addBookmark(String jobId) async {
  final data = await postApi(url: '$userBaseUrl/bookmark_job.php', body: {
    'job_id': jobId,
    'user_id': globalUserId,
  });
  if (data != null) {
    return data['success'];
  }
  return false;
}

Future<bool> removeBookmark(String bookmarkId) async {
  final data = await postApi(url: '$userBaseUrl/remove_bookmark.php', body: {
    'bookmark_id': bookmarkId,
    'user_id': globalUserId,
  });
  if (data != null) {
    return data['success'];
  }
  return false;
}
