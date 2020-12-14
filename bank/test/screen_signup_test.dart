import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:bank/signup.dart';

void main() {

  group('Widgets Drawing', () {

  testWidgets('Visibility of Components', (WidgetTester tester) async {
    await tester.pumpWidget(SignUpApp());
	
	final fields = find.byType(TextFormField);
	final register_texts = find.text('Utwórz konto');
	final register_button = find.byType(TextButton);
	
	expect(fields,findsNWidgets(3));
	expect(register_texts,findsNWidgets(2));	
  });
	
  });
  
  group('Registration Attempts', () {

  testWidgets('No data provided', (WidgetTester tester) async {
    await tester.pumpWidget(SignUpApp());

	final send_button_finder = find.byType(TextButton);
	final TextButton send_button = tester.widget(send_button_finder);
	
	expect(send_button.onPressed,null);
  });

  testWidgets('Only username provided', (WidgetTester tester) async {
    await tester.pumpWidget(SignUpApp());
	
	final username_form = find.byType(TextFormField).at(0);
	await tester.enterText(username_form, "przykladowylogin");
	await tester.pumpAndSettle();

	final send_button_finder = find.byType(TextButton);
	final TextButton send_button = tester.widget(send_button_finder);
	
	expect(send_button.onPressed,null);
  });

  testWidgets('Only password provided', (WidgetTester tester) async {
    await tester.pumpWidget(SignUpApp());

	final password_form = find.byType(TextFormField).at(1);
	await tester.enterText(password_form, "przykladowehaslo");
	await tester.pumpAndSettle();

	final send_button_finder = find.byType(TextButton);
	final TextButton send_button = tester.widget(send_button_finder);
	
	expect(send_button.onPressed,null);
  });
  
  testWidgets('Only email provided', (WidgetTester tester) async {
    await tester.pumpWidget(SignUpApp());

	final email_form = find.byType(TextFormField).at(2);
	await tester.enterText(email_form, "przykladowyemail@gmail.com");
	await tester.pumpAndSettle();

	final send_button_finder = find.byType(TextButton);
	final TextButton send_button = tester.widget(send_button_finder);
	
	expect(send_button.onPressed,null);
  });

  testWidgets('Username and password provided', (WidgetTester tester) async {
    await tester.pumpWidget(SignUpApp());
	
	final username_form = find.byType(TextFormField).at(0);
	await tester.enterText(username_form, "przykladowylogin");
	await tester.pumpAndSettle();
	
	final password_form = find.byType(TextFormField).at(1);
	await tester.enterText(password_form, "przykladowehaslo");
	await tester.pumpAndSettle();

	final send_button_finder = find.byType(TextButton);
	final TextButton send_button = tester.widget(send_button_finder);
	
	expect(send_button.onPressed,null);
  });
  
  testWidgets('Username and email provided', (WidgetTester tester) async {
    await tester.pumpWidget(SignUpApp());
	
	final username_form = find.byType(TextFormField).at(0);
	await tester.enterText(username_form, "przykladowylogin");
	await tester.pumpAndSettle();
	
	final email_form = find.byType(TextFormField).at(2);
	await tester.enterText(email_form, "przykladowyemail@gmail.com");
	await tester.pumpAndSettle();

	final send_button_finder = find.byType(TextButton);
	final TextButton send_button = tester.widget(send_button_finder);
	
	expect(send_button.onPressed,null);
  });
  
  testWidgets('Password and email provided', (WidgetTester tester) async {
    await tester.pumpWidget(SignUpApp());
	
	final password_form = find.byType(TextFormField).at(1);
	await tester.enterText(password_form, "przykladowehaslo");
	await tester.pumpAndSettle();
	
	final email_form = find.byType(TextFormField).at(2);
	await tester.enterText(email_form, "przykladowyemail@gmail.com");
	await tester.pumpAndSettle();

	final send_button_finder = find.byType(TextButton);
	final TextButton send_button = tester.widget(send_button_finder);
	
	expect(send_button.onPressed,null);
  });
  
  testWidgets('Username, password and email provided', (WidgetTester tester) async {
    await tester.pumpWidget(SignUpApp());
	
	final username_form = find.byType(TextFormField).at(0);
	await tester.enterText(username_form, "przykladowylogin");
	await tester.pumpAndSettle();
	
	final password_form = find.byType(TextFormField).at(1);
	await tester.enterText(password_form, "przykladowehaslo");
	await tester.pumpAndSettle();
	
	final email_form = find.byType(TextFormField).at(2);
	await tester.enterText(email_form, "przykladowyemail@gmail.com");
	await tester.pumpAndSettle();

	final send_button_finder = find.byType(TextButton);
	final TextButton send_button = tester.widget(send_button_finder);
	
	expect(send_button.onPressed != null,true);
  });
 
  });

}
