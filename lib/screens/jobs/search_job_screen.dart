import 'package:flutter/material.dart';
import 'package:job_portal/const/url.dart';
import 'package:job_portal/models/job/job_model.dart';
import 'package:job_portal/widgets/job_box_widget.dart';
import 'package:job_portal/controllers/basic/get_post_api.dart';

class SearchJobScreen extends StatefulWidget {
  const SearchJobScreen({super.key});

  @override
  State<SearchJobScreen> createState() => _SearchJobScreenState();
}

class _SearchJobScreenState extends State<SearchJobScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<JobModel> _searchResults = [];
  bool _isLoading = false;

  void _performSearch(String query) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await postApi(
        url: '$userBaseUrl/search_job.php',
        body: {'job_name': query},
        shouldPrint: true,
      );

      if (response != null) {
        _searchResults = (response['data'] as List)
            .map((jobData) => JobModel.fromJson(jobData))
            .toList();
      } else {
        _searchResults = [];
      }
    } catch (e) {
      print('Exception occurred: $e');
      _searchResults = [];
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.blue.shade800,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Search Jobs',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildSearchBar(),
          ),
          Expanded(
            child: _isLoading
                ? _buildLoadingIndicator()
                : _searchResults.isEmpty
                    ? _buildEmptyState()
                    : _buildSearchResults(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    return ListView.builder(
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: JobBoxWidget(job: _searchResults[index]),
        );
      },
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      autofocus: true,
      decoration: InputDecoration(
        hintText: 'Search for jobs...',
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 0),
      ),
      onChanged: _performSearch,
      onSubmitted: _performSearch,
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 20),
          Text(
            'Searching for jobs...',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 20),
          Text(
            'No results found',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Try different keywords or filters',
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
