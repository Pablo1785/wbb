import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:bank/signin.dart';

void main() {

  group('Widgets Drawing', () {

  testWidgets('Visibility of Components', (WidgetTester tester) async {
    await tester.pumpWidget(SignInApp());
	
	final fields = find.byType(TextFormField);
	final login = find.text('Zaloguj się');
	final login_button = find.text('Zaloguj');
	
	expect(fields,findsNWidgets(2));
    expect(login, findsOneWidget);
	expect(login_button, findsOneWidget);
  });
	
  });
  
  group('Login Attempts', () {

  testWidgets('No data provided', (WidgetTester tester) async {
    await tester.pumpWidget(SignInApp());

	final send_button_finder = find.byType(TextButton);
	final TextButton send_button = tester.widget(send_button_finder);
	
	expect(send_button.onPressed,null);
  });

  testWidgets('Only username provided', (WidgetTester tester) async {
    await tester.pumpWidget(SignInApp());
	
	final username_form = find.byType(TextFormField).at(0);
	await tester.enterText(username_form, "przykladowylogin");
	await tester.pumpAndSettle();

	final send_button_finder = find.byType(TextButton);
	final TextButton send_button = tester.widget(send_button_finder);
	
	expect(send_button.onPressed,null);
  });

  testWidgets('Only password provided', (WidgetTester tester) async {
    await tester.pumpWidget(SignInApp());

	final password_form = find.byType(TextFormField).at(1);
	await tester.enterText(password_form, "przykladowehaslo");
	await tester.pumpAndSettle();

	final send_button_finder = find.byType(TextButton);
	final TextButton send_button = tester.widget(send_button_finder);
	
	expect(send_button.onPressed,null);
  });

  testWidgets('Username and password provided', (WidgetTester tester) async {
    await tester.pumpWidget(SignInApp());
	
	final username_form = find.byType(TextFormField).at(0);
	await tester.enterText(username_form, "przykladowylogin");
	await tester.pumpAndSettle();
	
	final password_form = find.byType(TextFormField).at(1);
	await tester.enterText(password_form, "przykladowehaslo");
	await tester.pumpAndSettle();

	final send_button_finder = find.byType(TextButton);
	final TextButton send_button = tester.widget(send_button_finder);
	
	expect(send_button.onPressed != null,true);
  });
 
  });

}
