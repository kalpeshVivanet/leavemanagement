import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:leave_management/model/leave_model.dart';

class Leavecard extends StatelessWidget {
  final LeaveModel leave;
  const Leavecard({super.key, required this.leave});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 4),
      child: Container(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
  
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _formatDateRange(),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
       
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    leave.leaveType ?? 'General Leave',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.blue[700],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (leave.reason != null && leave.reason!.isNotEmpty)
                    Text(
                      leave.reason!,
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey[600],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
         
            Expanded(
              flex: 1,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getStatusColor(),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _getStatusDisplayText(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDateRange() {
    try {
      final dateFormat = DateFormat('dd MMM');
      

      if (leave.startDate.year == leave.endDate.year && 
          leave.startDate.month == leave.endDate.month && 
          leave.startDate.day == leave.endDate.day) {
        return dateFormat.format(leave.startDate);
      } else {
   
        if (leave.startDate.year == leave.endDate.year) {
          return '${dateFormat.format(leave.startDate)} - ${dateFormat.format(leave.endDate)}';
        } else {

          final dateFormatWithYear = DateFormat('dd MMM yy');
          return '${dateFormatWithYear.format(leave.startDate)} - ${dateFormatWithYear.format(leave.endDate)}';
        }
      }
    } catch (e) {
      print('Error formatting date: $e');
      return 'Invalid date';
    }
  }

  Color _getStatusColor() {
    switch (leave.status.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'pending':
      default:
        return Colors.orange;
    }
  }

  String _getStatusDisplayText() {
    if (leave.status.isEmpty) return 'Pending';
    return leave.status[0].toUpperCase() + leave.status.substring(1).toLowerCase();
  }
}