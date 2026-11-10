import 'package:flutter/material.dart';

import '../models/destination.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({super.key, required this.destination});
  final Destination destination;
  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  DateTime date = DateTime.now();
  int guests = 1;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Book now')),
    body: SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 620),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(22, 16, 22, 28),
            children: [
              Text(
                widget.destination.name,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                widget.destination.location,
                style: const TextStyle(color: Color(0xff779087)),
              ),
              const SizedBox(height: 28),
              const Text(
                'Choose your date',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 10),
              ListTile(
                tileColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                leading: const Icon(Icons.calendar_month),
                title: Text('${date.day}/${date.month}/${date.year}'),
                trailing: const Icon(Icons.chevron_right),
                onTap: _selectDate,
              ),
              const SizedBox(height: 24),
              const Text(
                'Guests',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () =>
                        setState(() => guests = guests > 1 ? guests - 1 : 1),
                    icon: const Icon(Icons.remove_circle_outline),
                  ),
                  Text(
                    '$guests',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  IconButton(
                    onPressed: () => setState(() => guests++),
                    icon: const Icon(Icons.add_circle_outline),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              FilledButton(
                onPressed: _confirmBooking,
                child: const Text('Confirm booking'),
              ),
            ],
          ),
        ),
      ),
    ),
  );
  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDate: date,
    );
    if (picked != null && mounted) setState(() => date = picked);
  }

  void _confirmBooking() => showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Booking requested'),
      content: Text('We saved your request for ${widget.destination.name}.'),
      actions: [
        TextButton(
          onPressed: () =>
              Navigator.popUntil(context, (route) => route.isFirst),
          child: const Text('Done'),
        ),
      ],
    ),
  );
}
