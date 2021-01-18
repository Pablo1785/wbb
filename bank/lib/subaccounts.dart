import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:js' as js;
import 'package:email_validator/email_validator.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:universal_html/html.dart' as html;
import 'package:flutter/services.dart';
import 'dart:typed_data';
import 'dart:convert';
import 'main.dart';
import 'logged_in.dart';
import 'settings.dart';
import 'transfer.dart';
import 'deposit.dart';
import 'history.dart';
import 'receivers.dart';
import 'security_events.dart';
import 'contact.dart';
import 'globals.dart';

import 'models.dart';

void main() => runApp(SubaccountsApp());

class SubaccountsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wirtualny Bank Bitcoinów',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        brightness: light_theme ? Brightness.light : Brightness.dark,
      ),
      routes: {
        '/': (context) => SubaccountsPage(),
        '/main': (context) => MainApp(),
        '/settings': (context) => SettingsApp(),
        '/loggedin': (context) => LoggedInApp(),
        '/transfer': (context) => TransferApp(),
        '/deposit': (context) => DepositApp(),
        '/history': (context) => HistoryApp(),
        '/contact': (context) => ContactApp(),
        '/subaccounts': (context) => SubaccountsApp(),
        '/receivers': (context) => ReceiversApp(),
        '/securityevents': (context) => SecurityEventsApp(),
      },
      localizationsDelegates: [GlobalMaterialLocalizations.delegate],
      supportedLocales: [
        const Locale('pl'),
      ],
    );
  }
}

class SubaccountsPage extends StatefulWidget {
  @override
  _SubaccountsPageState createState() => _SubaccountsPageState();
}

class _SubaccountsPageState extends State<SubaccountsPage> {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
        //extendBodyBehindAppBar: true,
        appBar: PreferredSize(
          preferredSize: Size(screenSize.width, 1000),
          child: Menu(),
        ),
        body: FormSubaccounts());
  }
}

class FormSubaccounts extends StatefulWidget {
  @override
  _FormSubaccountsState createState() => _FormSubaccountsState();
}

class _FormSubaccountsState extends State<FormSubaccounts> {
  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: SingleChildScrollView(
        child: Card(
          elevation: 2,
          margin: EdgeInsets.fromLTRB(64, 50, 64, 64),
          child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 16.0),
                  child: Builder(
                      builder: (context) => Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 50, 0, 20),
                                  child: Text(
                                    'Zarządzanie kontami',
                                    style: TextStyle(
                                      fontSize: 24,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'HelveticaNeue',
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 500,
                                  child: SubaccountsDataTable(),
                                ),
                              ])))),
        ),
      ),
    );
  }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

class SubaccountsDataTable extends StatefulWidget {
  const SubaccountsDataTable();

  @override
  _SubaccountsDataTableState createState() => _SubaccountsDataTableState();
}

class _SubaccountsDataTableState extends State<SubaccountsDataTable> {
  int _rowsPerPage = 5;
  int _sortColumnIndex = -1;
  //int _sortColumnIndex = 3; // indicator should be turned off initially, it is related to a bug in flutter
  //https://stackoverflow.com/questions/51293492/confusion-over-datatables-sort-direction-arrows

  bool _sortAscending = false;
  var _sortField;
  _SubaccountsDataSource _subaccountsDataSource;
  var _names; // names of columns
  var _newAccName;

  Future<SubAccount> _subaccountCreationResult;

  void _sort<T>(
    Comparable<T> Function(_Subaccounts d) getField,
    int columnIndex,
    bool ascending,
  ) {
    _subaccountsDataSource._sort<T>(getField, ascending);

    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
      _sortField = getField;
    });
  }

  void _sort_previous() {
    _subaccountsDataSource._sort(_sortField, _sortAscending);
  }

  int _get_selected_count() {
    return _subaccountsDataSource.selectedRowCount;
  }

  Future<Uint8List> generate_pdf() async {
    var pdf_theme = pw.ThemeData.withFont(
      // have to load custom font to support polish characters
      base: pw.Font.ttf(await rootBundle.load("fonts/OpenSans-Regular.ttf")),
      bold: pw.Font.ttf(await rootBundle.load("fonts/OpenSans-Bold.ttf")),
      italic: pw.Font.ttf(await rootBundle.load("fonts/OpenSans-Italic.ttf")),
      boldItalic:
          pw.Font.ttf(await rootBundle.load("fonts/OpenSans-Bolditalic.ttf")),
    );

    final pdf = pw.Document(theme: pdf_theme);

    final image = await rootBundle.load("images/logo_small.png");

    final _subaccountss = _subaccountsDataSource.get_selected();
    final List<List<String>> _subaccountssStrings = new List();
    _subaccountssStrings.add(_names);

    for (final subaccounts in _subaccountss)
      _subaccountssStrings.add([
        subaccounts.subAddress,
        subaccounts.balance,
        subaccounts.currency,
      ]);

    final imageE = PdfImage.file(
      pdf.document,
      bytes: image.buffer.asUint8List(),
    );

    pdf.addPage(pw.Page(
        pageFormat: PdfPageFormat(double.infinity, double.infinity,
            marginAll: 2.0 * PdfPageFormat.cm),
        build: (pw.Context context) {
          return pw.Column(children: [
            pw.Text("Lista kont",
                style:
                    pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
            pw.Image(pw.ImageProxy(imageE)),
            pw.Table.fromTextArray(
                context: context,
                headerAlignment: pw.Alignment.center,
                data: _subaccountssStrings),
          ]);
        }));

    return pdf.save();
  }

  Uint8List generate_csv() {
    final _subaccountss = _subaccountsDataSource.get_selected();

    String result = "";

    for (final name in _names) result += '${name},';

    result = result.substring(0, result.length - 1); // remove trailing ,

    for (final subaccounts in _subaccountss)
      result +=
          '\n${subaccounts.subAddress},${subaccounts.balance},${subaccounts.currency}';

    return utf8.encode(result);
  }

  void show_pdf(Uint8List bytes) {
    final blob = html.Blob([bytes], 'application/pdf');

    final url = html.Url.createObjectUrlFromBlob(blob);
    html.window.open(url, "_blank");
  }

  void export_to_pdf() async {
    Uint8List bytes = await generate_pdf();
    show_pdf(bytes);
  }

  void show_csv(Uint8List bytes) {
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.document.createElement('a') as html.AnchorElement
      ..href = url
      ..style.display = 'none'
      ..download = 'lista_subkont.csv';
    html.document.body.children.add(anchor);

    anchor.click();

    html.document.body.children.remove(anchor);
    html.Url.revokeObjectUrl(url);
  }

  void export_to_csv() {
    Uint8List bytes = generate_csv();
    show_csv(bytes);
  }

  @override
  void initState() {
    _subaccountsDataSource = _SubaccountsDataSource(context);
    _names = _subaccountsDataSource.get_names();
    _sort<String>((d) => d.subAddress, _sortColumnIndex, _sortAscending);
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          PaginatedDataTable(
            header: Row(children: [
              Text('Zarządzanie kontami'),
              SizedBox(
                width: 50,
              ),
            ]),
            actions: [
              IconButton(
                  onPressed: () {
                    showPopupCreate(context);
                  },
                  icon: Icon(Icons.create),
                  tooltip: 'Utwórz nowe'),
              IconButton(
                  onPressed: () {
                    if (_get_selected_count() != 1)
                      Scaffold.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'Należy wybrać dokładnie jedno konto do zamknięcia.'),
                        ),
                      );

                    if (_get_selected_count() == 1) showPopup(context);
                  },
                  icon: Icon(Icons.cancel),
                  tooltip: 'Zamknij konto'),
              IconButton(
                  onPressed: () {
                    if (_get_selected_count() == 0)
                      Scaffold.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'Należy najpierw wybrać konta do eksportu.'),
                        ),
                      );
                    else {
                      export_to_csv();
                      Scaffold.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Trwa generowanie CSV.'),
                        ),
                      );
                    }
                  },
                  icon: Icon(Icons.assignment_returned),
                  tooltip: 'Eksport do CSV'),
              IconButton(
                  onPressed: () {
                    if (_get_selected_count() == 0)
                      Scaffold.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'Należy najpierw wybrać konta do eksportu.'),
                        ),
                      );
                    else {
                      export_to_pdf();
                      Scaffold.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Trwa generowanie PDF.'),
                        ),
                      );
                    }
                  },
                  icon: Icon(Icons.save_alt),
                  tooltip: 'Eksport do PDF'),
            ],
            rowsPerPage: _rowsPerPage,
            availableRowsPerPage: [
              _rowsPerPage,
              _rowsPerPage * 2,
              _rowsPerPage * 5,
              _rowsPerPage * 10
            ],
            onRowsPerPageChanged: (value) {
              setState(() {
                _rowsPerPage = value;
              });
            },
            sortColumnIndex: _sortColumnIndex == -1 ? null : _sortColumnIndex,
            //_sortColumnIndex, // has to be turned_off initially, related to a bug
            sortAscending: _sortAscending,
            columns: [
              DataColumn(
                label: Text(_names[0]),
                onSort: (columnIndex, ascending) =>
                    _sort<String>((d) => d.subAddress, columnIndex, ascending),
              ),
              DataColumn(
                label: Text(_names[1]),
                onSort: (columnIndex, ascending) =>
                    _sort<String>((d) => d.balance, columnIndex, ascending),
              ),
              DataColumn(
                label: Text(_names[2]),
                onSort: (columnIndex, ascending) =>
                    _sort<String>((d) => d.currency, columnIndex, ascending),
              ),
            ],
            source: _subaccountsDataSource,
          ),
        ],
      ),
    );
  }

  void showPopup(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Stack(
              overflow: Overflow.visible,
              children: <Widget>[
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Czy na pewno chcesz zamknąć konto?',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Potwierdź operację poniżej.',
                          style: TextStyle(fontSize: 14)),
                    ),
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              RaisedButton(
                                child: Text("Potwierdź"),
                                color: Colors.red,
                                onPressed: () {
                                  Navigator.of(context).pop();

                                  // usunac podkonto
                                  print(
                                      'removing subaccount: ${_subaccountsDataSource.get_selected()[0].subAddress}');

                                  showPopup2(context);
                                },
                              ),
                              RaisedButton(
                                child: Text("Anuluj"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ]))
                  ],
                ),
              ],
            ),
          );
        });
  }

  void showPopup2(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Stack(
              overflow: Overflow.visible,
              children: <Widget>[
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Tworzenie konta...',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: FutureBuilder(
                        future: _subaccountCreationResult,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return SelectableText(
                              "Utworzono konto ${snapshot.data.sub_address}",
                              textAlign: TextAlign.left,
                              style: GoogleFonts.montserrat(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            );
                          } else if (snapshot.hasError) {
                            return SelectableText(
                              "Wystąpił błąd tworzenia konta",
                              textAlign: TextAlign.left,
                              style: GoogleFonts.montserrat(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                backgroundColor: Colors.redAccent,
                              ),
                            );
                          }
                          return LinearProgressIndicator();
                        },
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              RaisedButton(
                                child: Text("Zamknij okno"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ]))
                  ],
                ),
              ],
            ),
          );
        });
  }

  void showPopupCreate(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Stack(
              overflow: Overflow.visible,
              children: <Widget>[
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Założyć nowe konto?',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                RaisedButton(
                                  child: Text("Potwierdź"),
                                  color: Colors.red,
                                  onPressed: () {
                                    if (_formKey.currentState.validate()) {
                                      _formKey.currentState.save();
                                      
                                      setState(() {
                                        _subaccountCreationResult = requestor.createSubaccount();
                                      });
                                      Navigator.of(context).pop();
                                    }
                                  },
                                ),
                                RaisedButton(
                                  child: Text("Anuluj"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ]))
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }
}

class _Subaccounts {
  _Subaccounts(
      this.owner,
      this.balance,
      this.currency,
      this.subAddress,
	  );
	final String owner;
	final String balance;
	final String currency;
	final String subAddress;

  bool selected = false;
}

class _SubaccountsDataSource extends DataTableSource {
  _SubaccountsDataSource(this.context) {
    _subaccountss = [];
	
	_getData();
  }

  final BuildContext context;
  List<_Subaccounts> _subaccountss;
  
    void _getData() async {
    _subaccountss = List<_Subaccounts>.from(
        (await requestor.fetchSubaccounts()).map((subaccount) =>
            _Subaccounts(subaccount.owner, subaccount.balance, "BTC", subaccount.subAddress)));
    notifyListeners();
  }

  void _sort<T>(
      Comparable<T> Function(_Subaccounts d) getField, bool ascending) {
    _subaccountss.sort((a, b) {
      final aValue = getField(a);
      final bValue = getField(b);
      return ascending
          ? Comparable.compare(aValue, bValue)
          : Comparable.compare(bValue, aValue);
    });
    notifyListeners();
  }

  List<_Subaccounts> get_selected() {
    List<_Subaccounts> result = new List();

    for (final subaccounts in _subaccountss) {
      if (subaccounts.selected == true) result.add(subaccounts);
    }

    return result;
  }

  List<String> get_names() => [
        'Adres',
        'Saldo',
        'Waluta',
      ];

  int _selectedCount = 0;

  @override
  DataRow getRow(int index) {
    assert(index >= 0);
    if (index >= _subaccountss.length) return null;
    final subaccounts = _subaccountss[index];
    final text_color = Colors.black;
    return DataRow.byIndex(
      index: index,
      selected: subaccounts.selected,
      onSelectChanged: (value) {
        if (subaccounts.selected != value) {
          _selectedCount += value ? 1 : -1;
          assert(_selectedCount >= 0);
          subaccounts.selected = value;
          notifyListeners();
        }
      },
      cells: [
        DataCell(Text(subaccounts.subAddress,
            style: TextStyle(color: text_color))),
        DataCell(Text(subaccounts.balance,
            style: TextStyle(color: text_color))),
        DataCell(Text(subaccounts.currency,
            style: TextStyle(color: text_color))),
      ],
    );
  }

  @override
  int get rowCount => _subaccountss.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => _selectedCount;
}
