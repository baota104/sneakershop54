import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sneaker_shop/domains/model/CommentModel.dart';

class CommentListWidget extends StatefulWidget {
  final List<CommentModel> commments;
  const CommentListWidget({super.key, required this.commments});

  @override
  State<CommentListWidget> createState() => _CommentListWidgetState();
}

class _CommentListWidgetState extends State<CommentListWidget> {
  final int _commentsPerPage = 5;
  List<CommentModel> _allComments = [];
  int _visibleCommentsCount = 5;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Lọc chỉ các comment có isVisible == true
    _allComments = widget.commments.where((comment) => comment.ivisible == false).toList();
  }

  void _loadMore() {
    setState(() {
      _visibleCommentsCount += _commentsPerPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    final visibleComments = _allComments.take(_visibleCommentsCount).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Comments about us",
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: GoogleFonts.raleway().fontFamily
          ),
        ),
        const SizedBox(height: 10),
        if (visibleComments.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Text(
              "No comments available",
              style: TextStyle(color: Colors.grey),
            ),
          )
        else
          ...visibleComments.map((comment) => _buildCommentTile(comment)),
        const SizedBox(height: 10),
        if (_visibleCommentsCount < _allComments.length)
          Center(
            child: TextButton(
              onPressed: _loadMore,
              child: Text("Read more (${_allComments.length - _visibleCommentsCount} more)"),
            ),
          ),
      ],
    );
  }

  Widget _buildCommentTile(CommentModel comment) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(comment.avatarUrl),
        ),
        title: Text(comment.username),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(comment.content),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.star, color: Colors.amber, size: 16),
                Text(comment.rating.toStringAsFixed(1)),
              ],
            ),
            Text(
              _formatDate(comment.timestamp),
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }
}