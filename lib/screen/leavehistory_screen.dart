import 'package:flutter/material.dart';
import 'package:leave_management/provider/auth_provider.dart';
import 'package:leave_management/provider/leave_provider.dart';
import 'package:leave_management/screen/leavecard.dart';
import 'package:provider/provider.dart';

class LeavehistoryScreen extends StatefulWidget {
  const LeavehistoryScreen({super.key});

  @override
  State<LeavehistoryScreen> createState() => _LeavehistoryScreenState();
}

class _LeavehistoryScreenState extends State<LeavehistoryScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final leaveProvider = Provider.of<LeaveProvider>(context, listen: false);

      if (authProvider.user != null) {
        leaveProvider.fetchLeave(authProvider.user!.uid);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<LeaveProvider>(
        builder: (context, leaveProvider, child) {
          if (leaveProvider.isLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (leaveProvider.leaveRequest.isEmpty) {
            return Center(
              child: Text("NO leave found"),
            );
          }
          return Column(
            children: [
              Container(
                child: Row(
                  children: [
                    Expanded(child: Text('Date')),
                    Expanded(child: Text("Type")),
                    Expanded(child: Text('status'))
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: leaveProvider.leaveRequest.length,
                  itemBuilder: (context,index){
                return Leavecard(leave: leaveProvider.leaveRequest[index]);
              }))
            ],
          );
        },
      ),
    );
  }
}
