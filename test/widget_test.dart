import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:minicap/main.dart';

void main() {
  testWidgets('app loads with admin login form', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Barangay Appointment Scheduling System'), findsOneWidget);
    expect(find.text('Admin Login'), findsOneWidget);
    expect(find.text('Sign in to manage appointments'), findsOneWidget);
  });

  testWidgets('edit appointment form shows update and delete actions', (WidgetTester tester) async {
    final appointment = Appointment(
      id: 99,
      residentName: 'Alice Gates',
      service: 'Barangay Clearance',
      date: '2026-10-20',
      time: '09:00 AM',
      status: 'Pending',
      isApiProvided: false,
    );

    await tester.pumpWidget(MaterialApp(home: BookingFormScreen(appointment: appointment)));

    expect(find.text('Edit appointment'), findsOneWidget);
    expect(find.text('Save changes'), findsOneWidget);
    expect(find.text('Delete appointment'), findsOneWidget);
  });
}
