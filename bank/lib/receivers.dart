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
import 'subaccounts.dart';
import 'security_events.dart';
import 'contact.dart';
import 'globals.dart';

void main() => runApp(ReceiversApp());

class ReceiversApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wirtualny Bank Bitcoinów',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        brightness: light_theme ? Brightness.light : Brightness.dark,
      ),
      routes: {
        '/': (context) => ReceiversPage(),
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

class ReceiversPage extends StatefulWidget {
  @override
  _ReceiversPageState createState() => _ReceiversPageState();
}

class _ReceiversPageState extends State<ReceiversPage> {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
        //extendBodyBehindAppBar: true,
        appBar: PreferredSize(
          preferredSize: Size(screenSize.width, 1000),
          child: Menu(),
        ),
        body: FormReceivers());
  }
}

class FormReceivers extends StatefulWidget {
  @override
  _FormReceiversState createState() => _FormReceiversState();
}

class _FormReceiversState extends State<FormReceivers> {
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
                                    'Lista odbiorców',
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
                                  child: ReceiversDataTable(),
                                ),
                              ])))),
        ),
      ),
    );
  }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

class ReceiversDataTable extends StatefulWidget {
  const ReceiversDataTable();

  @override
  _ReceiversDataTableState createState() => _ReceiversDataTableState();
}

class _ReceiversDataTableState extends State<ReceiversDataTable> {
  int _rowsPerPage = 5;
  int _sortColumnIndex = -1;
  //int _sortColumnIndex = 3; // indicator should be turned off initially, it is related to a bug in flutter
  //https://stackoverflow.com/questions/51293492/confusion-over-datatables-sort-direction-arrows

  bool _sortAscending = true;
  var _sortField;
  _ReceiversDataSource _receiversDataSource;
  var _names; // names of columns

  void _sort<T>(
    Comparable<T> Function(_Receivers d) getField,
    int columnIndex,
    bool ascending,
  ) {
    _receiversDataSource._sort<T>(getField, ascending);

    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
      _sortField = getField;
    });
  }

  void _sort_previous() {
    _receiversDataSource._sort(_sortField, _sortAscending);
  }

  int _get_selected_count() {
    return _receiversDataSource.selectedRowCount;
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

    final _receiverss = _receiversDataSource.get_selected();
    final List<List<String>> _receiverssStrings = new List();
    _receiverssStrings.add(_names);

    for (final receivers in _receiverss)
      _receiverssStrings.add([
        receivers.title,
        receivers.address,
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
            pw.Text("Lista odbiorców",
                style:
                    pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
            pw.Image(pw.ImageProxy(imageE)),
            pw.Table.fromTextArray(
                context: context,
                headerAlignment: pw.Alignment.center,
                data: _receiverssStrings),
          ]);
        }));

    return pdf.save();
  }

  Uint8List generate_csv() {
    final _receiverss = _receiversDataSource.get_selected();

    String result = "";

    for (final name in _names) result += '${name},';

    result = result.substring(0, result.length - 1); // remove trailing ,

    for (final receivers in _receiverss)
      result += '\n${receivers.title},${receivers.address}';

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
      ..download = 'lista_odbiorcow.csv';
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
    _receiversDataSource = _ReceiversDataSource(context);
    _names = _receiversDataSource.get_names();
    _sort<String>((d) => d.title, _sortColumnIndex, _sortAscending);
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          PaginatedDataTable(
            header: Row(children: [
              Text('Lista odbiorców'),
              SizedBox(
                width: 50,
              ),
            ]),
            actions: [
              IconButton(
                  onPressed: () {
                    if (_get_selected_count() != 1)
                      Scaffold.of(context).showSnackBar(
                        SnackBar(
                          content:
                              Text('Należy wybrać dokładnie jednego odbiorcę.'),
                        ),
                      );

                    if (_get_selected_count() == 1) {
                      final _receivers = _receiversDataSource.get_selected();
                      final _previous = [
                        _receivers[0].title,
                        null, // amount
                        _receivers[0].address,
                      ];
                      Navigator.of(context)
                          .pushNamed('/transfer', arguments: _previous);
                    }
                  },
                  icon: Icon(Icons.settings_backup_restore),
                  tooltip: 'Wykonaj ponownie'),
              IconButton(
                  onPressed: () {
                    if (_get_selected_count() == 0)
                      Scaffold.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'Należy najpierw wybrać odbiorców do eksportu.'),
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
                              'Należy najpierw wybrać odbiorców do eksportu.'),
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
                    _sort<String>((d) => d.title, columnIndex, ascending),
              ),
              DataColumn(
                label: Text(_names[1]),
                onSort: (columnIndex, ascending) =>
                    _sort<String>((d) => d.address, columnIndex, ascending),
              ),
            ],
            source: _receiversDataSource,
          ),
        ],
      ),
    );
  }
}

class _Receivers {
  _Receivers(
    this.title,
    this.address,
  );
  final String title;
  final String address;

  bool selected = false;
}

class _ReceiversDataSource extends DataTableSource {
  _ReceiversDataSource(this.context) {
    _receiverss = <_Receivers>[
      _Receivers('Kontrahent 2', '1836NGficqz5cSHWdd1qcEuqaEmFAHJRwC'),
      _Receivers('Kontrahent 1', 'kolega@wp.pl'),
    ];
  }

  final BuildContext context;
  List<_Receivers> _receiverss;

  void _sort<T>(Comparable<T> Function(_Receivers d) getField, bool ascending) {
    _receiverss.sort((a, b) {
      final aValue = getField(a);
      final bValue = getField(b);
      return ascending
          ? Comparable.compare(aValue, bValue)
          : Comparable.compare(bValue, aValue);
    });
    notifyListeners();
  }

  List<_Receivers> get_selected() {
    List<_Receivers> result = new List();

    for (final receivers in _receiverss) {
      if (receivers.selected == true) result.add(receivers);
    }

    return result;
  }

  List<String> get_names() => [
        'Tytuł',
        'Adres',
      ];

  int _selectedCount = 0;

  @override
  DataRow getRow(int index) {
    assert(index >= 0);
    if (index >= _receiverss.length) return null;
    final receivers = _receiverss[index];
    final text_color = Colors.black;
    return DataRow.byIndex(
      index: index,
      selected: receivers.selected,
      onSelectChanged: (value) {
        if (receivers.selected != value) {
          _selectedCount += value ? 1 : -1;
          assert(_selectedCount >= 0);
          receivers.selected = value;
          notifyListeners();
        }
      },
      cells: [
        DataCell(Text(receivers.title, style: TextStyle(color: text_color))),
        DataCell(Text(receivers.address, style: TextStyle(color: text_color))),
      ],
    );
  }

  @override
  int get rowCount => _receiverss.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => _selectedCount;
}
