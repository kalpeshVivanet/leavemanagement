// lib/screens/leave_request_screen.dart
import 'package:flutter/material.dart';
import 'package:leave_management/model/leave_model.dart';
import 'package:leave_management/provider/leave_provider.dart';
import 'package:provider/provider.dart';


class LeaveRequestScreen extends StatefulWidget {
  const LeaveRequestScreen({Key? key}) : super(key: key);

  @override
  _LeaveRequestScreenState createState() => _LeaveRequestScreenState();
}

class _LeaveRequestScreenState extends State<LeaveRequestScreen> {
  DateTimeRange? _selectedRange;
  final _reasonController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  late String userId;
  bool _hasInitializedUserId = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_hasInitializedUserId) {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

      if (args != null && args.containsKey('userId')) {
        userId = args['userId'] as String;
        context.read<LeaveProvider>().fetchLeave(userId);
      } else {
        userId = '';
        // Handle error: no userId passed, show message and pop screen safely
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return; // <-- check if still mounted
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('User ID missing. Please login again.')),
          );
          Navigator.pop(context);
        });
      }
      _hasInitializedUserId = true;
    }
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  bool _isDateBlocked(DateTime date, List<LeaveModel> leaves) {
    for (final leave in leaves) {
      if (!date.isBefore(_atStartOfDay(leave.startDate)) &&
          !date.isAfter(_atEndOfDay(leave.endDate))) {
        return true;
      }
    }
    return false;
  }

  DateTime _atStartOfDay(DateTime dt) => DateTime(dt.year, dt.month, dt.day);
  DateTime _atEndOfDay(DateTime dt) =>
      DateTime(dt.year, dt.month, dt.day, 23, 59, 59);

  Future<void> _submitLeave() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedRange == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select leave dates'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final leave = LeaveModel(
      id: UniqueKey().toString(),
      userId: userId,
      reason: _reasonController.text.trim(),
      startDate: _selectedRange!.start,
      endDate: _selectedRange!.end,
      status: 'pending',
    );

    final leaveProvider = context.read<LeaveProvider>();

    try {
      await leaveProvider.applyLeave(leave, userId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Leave request submitted successfully'),
            backgroundColor: Colors.green,
          ),
        );
        setState(() {
          _selectedRange = null;
        });
        _reasonController.clear();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to submit leave: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Leave Request')),
      body: Consumer<LeaveProvider>(
        builder: (context, leaveProvider, _) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: leaveProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : Form(
                    key: _formKey,
                    child: ListView(
                      children: [
                        ElevatedButton(
                          child: const Text('Select Leave Dates'),
                          onPressed: () async {
                            final picked = await showDateRangePicker(
                              context: context,
                              firstDate: DateTime.now(),
                              lastDate:
                                  DateTime.now().add(const Duration(days: 365)),
                              selectableDayPredicate:
                                  (day, rangeStart, rangeEnd) {
                                return !_isDateBlocked(
                                    day, leaveProvider.leaveRequest);
                              },
                            );
                            if (picked != null) {
                              setState(() {
                                _selectedRange = picked;
                              });
                            }
                          },
                        ),
                        if (_selectedRange != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 12.0),
                            child: Text(
                              'Selected Range:\n${_selectedRange!.start.toLocal().toString().split(' ')[0]} to ${_selectedRange!.end.toLocal().toString().split(' ')[0]}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _reasonController,
                          decoration: const InputDecoration(
                            labelText: 'Reason for leave',
                            border: OutlineInputBorder(),
                          ),
                          maxLines: 3,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter a reason';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 30),
                        ElevatedButton(
                          onPressed:
                              leaveProvider.isLoading ? null : _submitLeave,
                          child: leaveProvider.isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor:
                                        AlwaysStoppedAnimation(Colors.white),
                                  ),
                                )
                              : const Text('Submit Leave'),
                        ),
                      ],
                    ),
                  ),
          );
        },
      ),
    );
  }
}