import 'package:flutter/material.dart';
import 'package:rentycars_nour/services/api.dart'; // Make sure ApiServices is correctly imported

class ReviewPage extends StatefulWidget {
  final String postId;

  const ReviewPage({Key? key, required this.postId}) : super(key: key);

  @override
  _ReviewPageState createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  late ApiServices apiServices;
  late Future<List<Map<String, dynamic>>> comments;

  // Form fields
  final TextEditingController _reviewController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    apiServices = ApiServices();
    comments = apiServices.getComments(widget.postId); // Fetch comments for the specific postId
  }

  Future<void> _submitReview() async {
    final String name = _nameController.text;
    final String email = _emailController.text;
    final String body = _reviewController.text;

    if (name.isEmpty || email.isEmpty || body.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please fill in all the fields'),
      ));
      return;
    }

    try {
      await apiServices.addComment(widget.postId, name, email, body);
      // Refresh the comments after submitting the review
      setState(() {
        comments = apiServices.getComments(widget.postId); // Refresh comments
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Review submitted successfully'),
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to submit review'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reviews'),
      ),
      body: Column(
        children: [
          // Review Form
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Add a Review", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: "Your Name"),
                ),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: "Your Email"),
                ),
                TextField(
                  controller: _reviewController,
                  maxLines: 4,
                  decoration: InputDecoration(labelText: "Your Review"),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _submitReview,
                  child: Text('Submit Review'),
                ),
              ],
            ),
          ),
          // Displaying comments
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: comments,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No reviews yet.'));
                } else {
                  final reviews = snapshot.data!;
                  return ListView.builder(
                    itemCount: reviews.length,
                    itemBuilder: (context, index) {
                      final review = reviews[index];
                      return ListTile(
                        title: Text(review['name']),
                        subtitle: Text(review['body']),
                        leading: Icon(Icons.comment),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
