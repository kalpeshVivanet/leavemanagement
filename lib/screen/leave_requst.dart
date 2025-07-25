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
  String? _leaveType;

  late String userId;
  bool _hasInitializedUserId = false;

  // Leave type options
  final List<String> _leaveTypes = [
    'Sick Leave',
    'Casual Leave',
    'Annual Leave',
    'Emergency Leave',
    'Maternity Leave',
    'Paternity Leave',
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_hasInitializedUserId) {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

      if (args != null && args.containsKey('userId')) {
        userId = args['userId'] as String;
        
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            context.read<LeaveProvider>().fetchLeave(userId);
          }
        });
      } else {
        userId = '';
      
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
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
      DateTime? startDate;
      DateTime? endDate;


      if (leave.startDate is DateTime) {
        startDate = leave.startDate as DateTime;
      } else if (leave.startDate is String) {
        startDate = DateTime.tryParse(leave.startDate as String);
      }

      if (leave.endDate is DateTime) {
        endDate = leave.endDate as DateTime;
      } else if (leave.endDate is String) {
        endDate = DateTime.tryParse(leave.endDate as String);
      }

      if (startDate != null && endDate != null) {
        if (!date.isBefore(_atStartOfDay(startDate)) &&
            !date.isAfter(_atEndOfDay(endDate))) {
          return true;
        }
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

    if (_leaveType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select leave type'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final leave = LeaveModel(
      id: UniqueKey().toString(),
      userId: userId,
      reason: _reasonController.text.trim().isEmpty 
          ? 'No reason provided' 
          : _reasonController.text.trim(),
      leaveType: _leaveType,
      startDate: _selectedRange!.start,
      endDate: _selectedRange!.end,
      status: 'pending',
    );

    final leaveProvider = context.read<LeaveProvider>();

    try {
      bool success = await leaveProvider.applyLeave(leave, userId);
      if (mounted && success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Leave request submitted successfully'),
            backgroundColor: Colors.green,
          ),
        );
        setState(() {
          _selectedRange = null;
          _leaveType = null;
        });
        _reasonController.clear();
      } else if (mounted && !success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(leaveProvider.error ?? 'Failed to submit leave'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to submit leave: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Leave Request'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Consumer<LeaveProvider>(
        builder: (context, leaveProvider, _) {
          if (leaveProvider.error != null) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 64, color: Colors.red),
                    SizedBox(height: 16),
                    Text(
                      'Error loading data',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      leaveProvider.error!,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        leaveProvider.clearError();
                        leaveProvider.fetchLeave(userId);
                      },
                      child: Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: leaveProvider.isLoading
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('Loading leave data...'),
                      ],
                    ),
                  )
                : Form(
                    key: _formKey,
                    child: ListView(
                      children: [
                      
                        Card(
                          elevation: 2,
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Leave Type *',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey[800],
                                  ),
                                ),
                                SizedBox(height: 12),
                                DropdownButtonFormField<String>(
                                  value: _leaveType,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: 'Select leave type',
                                  ),
                                  items: _leaveTypes.map((String type) {
                                    return DropdownMenuItem<String>(
                                      value: type,
                                      child: Text(type),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _leaveType = newValue;
                                    });
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please select a leave type';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        
                        SizedBox(height: 16),

                       
                        Card(
                          elevation: 2,
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Leave Dates *',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey[800],
                                  ),
                                ),
                                SizedBox(height: 12),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    icon: Icon(Icons.calendar_today),
                                    label: Text(_selectedRange == null
                                        ? 'Select Leave Dates'
                                        : 'Change Dates'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      foregroundColor: Colors.white,
                                      padding: EdgeInsets.symmetric(vertical: 16),
                                    ),
                                    onPressed: () async {
                                      final picked = await showDateRangePicker(
                                        context: context,
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime.now()
                                            .add(const Duration(days: 365)),
                                       
                                      );
                                      if (picked != null) {
                                        
                                        bool hasBlockedDays = false;
                                        DateTime current = picked.start;
                                        
                                        while (current.isBefore(picked.end.add(Duration(days: 1)))) {
                                          if (_isDateBlocked(current, leaveProvider.leaveRequest)) {
                                            hasBlockedDays = true;
                                            break;
                                          }
                                          current = current.add(Duration(days: 1));
                                        }
                                        
                                        if (hasBlockedDays) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text('Selected date range contains already booked dates. Please choose different dates.'),
                                              backgroundColor: Colors.red,
                                            ),
                                          );
                                        } else {
                                          setState(() {
                                            _selectedRange = picked;
                                          });
                                        }
                                      }
                                    },
                                  ),
                                ),
                                if (_selectedRange != null)
                                  Container(
                                    margin: EdgeInsets.only(top: 12),
                                    padding: EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.blue[50],
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: Colors.blue[200]!),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(Icons.event, color: Colors.blue, size: 20),
                                        SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            'From: ${_selectedRange!.start.toLocal().toString().split(' ')[0]}\nTo: ${_selectedRange!.end.toLocal().toString().split(' ')[0]}',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: Colors.blue[800],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: 16),

                 
                        Card(
                          elevation: 2,
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Reason for Leave (Optional)',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey[800],
                                  ),
                                ),
                                SizedBox(height: 12),
                                TextFormField(
                                  controller: _reasonController,
                                  decoration: const InputDecoration(
                                    hintText: 'Optional: Provide additional details for your leave request',
                                    border: OutlineInputBorder(),
                                  ),
                                  maxLines: 4,
                                  validator: (value) {
                                   
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                 
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: leaveProvider.isLoading ? null : _submitLeave,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: leaveProvider.isLoading
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation(Colors.white),
                                    ),
                                  )
                                : const Text(
                                    'Submit Leave Request',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
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