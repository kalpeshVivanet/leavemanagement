import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:leave_management/model/leave_model.dart';

class Leavecard extends StatelessWidget {
  final LeaveModel leave;
  const Leavecard({super.key, required this.leave});

  @override
  Widget build(BuildContext context) {
    final dateformat = DateFormat('dd MMM YYYY');

    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text('${leave.reason}'),
        subtitle: Text(
            '${dateformat.format(leave.startDate)}-${dateformat.format(leave.endDate)}'),
        trailing: Text(
          leave.status,
          style: TextStyle(
              color: leave.status == 'Approved'
                  ? Colors.green
                  : leave.status == 'Rejected'
                      ? Colors.red
                      : Colors.orange,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
