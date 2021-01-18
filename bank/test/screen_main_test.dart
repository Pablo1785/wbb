import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:bank/main.dart';

void main() {

  group('Widgets Drawing', () {

  testWidgets('Visibility of Text', (WidgetTester tester) async {
  tester.binding.window.physicalSizeTestValue = Size(1920, 1080);
  tester.binding.window.devicePixelRatioTestValue = 1.0;
    await tester.pumpWidget(MainApp());
	
	final login = find.text('Zaloguj się');
	final register = find.text('Zarejestruj się');
	final title = find.text('WBB');
	
    expect(login, findsOneWidget);
	expect(register, findsOneWidget);
	expect(title, findsOneWidget);
  });
	
  });
  
  group('Navigation', () {

  testWidgets('Go to sign-in page', (WidgetTester tester) async {
	await tester.pumpWidget(MainApp());
	
	expect(find.text("Zaloguj"), findsNothing);
	
	await tester.tap(find.text("Zaloguj się"));
	await tester.pumpAndSettle();

    expect(find.text("Zaloguj"), findsOneWidget);
  });

  testWidgets('Go to sign-up page', (WidgetTester tester) async {
	await tester.pumpWidget(MainApp());
	
	expect(find.text("Utwórz konto"), findsNothing);
	
	await tester.tap(find.text("Zarejestruj się"));
	await tester.pumpAndSettle();

    expect(find.text("Utwórz konto"), findsWidgets);
  });  
  
  });

}
