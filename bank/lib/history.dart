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
import 'contact.dart';
import 'globals.dart';

void main() => runApp(HistoryApp());

class HistoryApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wirtualny Bank Bitcoinów',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        brightness: light_theme ? Brightness.light : Brightness.dark,
      ),
      routes: {
        '/': (context) => HistoryPage(),
        '/main': (context) => MainApp(),
        '/settings': (context) => SettingsApp(),
        '/loggedin': (context) => LoggedInApp(),
        '/transfer': (context) => TransferApp(),
        '/deposit': (context) => DepositApp(),
        '/history': (context) => HistoryApp(),
        '/contact': (context) => ContactApp(),
      },
      localizationsDelegates: [GlobalMaterialLocalizations.delegate],
      supportedLocales: [
        const Locale('pl'),
      ],
    );
  }
}

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
        //extendBodyBehindAppBar: true,
        appBar: PreferredSize(
          preferredSize: Size(screenSize.width, 1000),
          child: Menu(),
        ),
        body: FormHistory());
  }
}

class FormHistory extends StatefulWidget {
  @override
  _FormHistoryState createState() => _FormHistoryState();
}

class _FormHistoryState extends State<FormHistory> {
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
                                    'Historia przelewów',
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
                                  child: TransferDataTable(),
                                ),
                                Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 50, 0, 20),
                                  child: Text(
                                    'Historia lokat',
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
                                  child: DepositDataTable(),
                                ),
                              ])))),
        ),
      ),
    );
  }
}

class TransferDataTable extends StatefulWidget {
  const TransferDataTable();

  @override
  _TransferDataTableState createState() => _TransferDataTableState();
}

class _TransferDataTableState extends State<TransferDataTable> {
  int _rowsPerPage = 5;
  int _sortColumnIndex = -1;
  //int _sortColumnIndex = 3; // indicator should be turned off initially, it is related to a bug in flutter
  //https://stackoverflow.com/questions/51293492/confusion-over-datatables-sort-direction-arrows

  bool _sortAscending = false;
  var _sortField;
  _TransferDataSource _transferDataSource;
  var _names; // names of columns

  bool incoming_selected = true;
  bool outcoming_selected = true;

  void _sort<T>(
    Comparable<T> Function(_Transfer d) getField,
    int columnIndex,
    bool ascending,
  ) {
    _transferDataSource._sort<T>(getField, ascending);

    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
      _sortField = getField;
    });
  }

  void _sort_previous() {
    _transferDataSource._sort(_sortField, _sortAscending);
  }

  void _filter() {
    _transferDataSource._filter(incoming_selected, outcoming_selected);
  }

  int _get_selected_count() {
    return _transferDataSource.selectedRowCount;
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

    final _transfers = _transferDataSource.get_selected();
    final List<List<String>> _transfersStrings = new List();
    _transfersStrings.add(_names);

    for (final transfer in _transfers)
      _transfersStrings.add([
        transfer.title,
        transfer.amount.toString(),
        transfer.balance.toString(),
        transfer.timestamp,
        transfer.id.toString(),
        transfer.tracking,
        transfer.address
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
            pw.Text("Historia transakcji",
                style:
                    pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
            pw.Image(pw.ImageProxy(imageE)),
            pw.Table.fromTextArray(
                context: context,
                headerAlignment: pw.Alignment.center,
                data: _transfersStrings),
          ]);
        }));

    return pdf.save();
  }

  Uint8List generate_csv() {
    final _transfers = _transferDataSource.get_selected();

    String result = "";

    for (final name in _names) result += '${name},';

    result = result.substring(0, result.length - 1); // remove trailing ,

    for (final transfer in _transfers)
      result +=
          '\n${transfer.title},${transfer.amount},${transfer.balance},${transfer.timestamp},${transfer.id},${transfer.tracking},${transfer.address}';

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
      ..download = 'historia_transakcji.csv';
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
    _transferDataSource = _TransferDataSource(context);
    _names = _transferDataSource.get_names();
    _sort<String>((d) => d.timestamp, _sortColumnIndex, _sortAscending);
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          PaginatedDataTable(
            header: Row(children: [
              Text('Historia przelewów'),
              SizedBox(
                width: 50,
              ),
              FilterChip(
                label: Text('Przychodzące'),
                selected: incoming_selected,
                onSelected: (bool value) {
                  setState(() {
                    incoming_selected = value;
                    _filter();
                    _sort_previous();
                  });
                },
              ),
              SizedBox(
                width: 50,
              ),
              FilterChip(
                label: Text('Wychodzące'),
                selected: outcoming_selected,
                onSelected: (bool value) {
                  setState(() {
                    outcoming_selected = value;
                    _filter();
                    _sort_previous();
                  });
                },
              ),
            ]),
            actions: [
              IconButton(
                  onPressed: () {
                    if (_get_selected_count() != 1)
                      Scaffold.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'Należy wybrać dokładnie jeden przelew do powtórzenia.'),
                        ),
                      );

                    if (_get_selected_count() == 1) {
                      final _transfers = _transferDataSource.get_selected();
                      if (_transfers[0].amount >= 0) {
                        Scaffold.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Nie można powtórzyć operacji przychodzącej.'),
                          ),
                        );
                      } else {
                        final _previous = [
                          _transfers[0].title,
                          _transfers[0].amount.toString(),
                          _transfers[0].address
                        ];
                        Navigator.of(context)
                            .pushNamed('/transfer', arguments: _previous);
                      }
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
                              'Należy najpierw wybrać przelewy do eksportu.'),
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
                              'Należy najpierw wybrać przelewy do eksportu.'),
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
                numeric: true,
                onSort: (columnIndex, ascending) =>
                    _sort<num>((d) => d.amount, columnIndex, ascending),
              ),
              DataColumn(
                label: Text(_names[2]),
                numeric: true,
                onSort: (columnIndex, ascending) =>
                    _sort<num>((d) => d.balance, columnIndex, ascending),
              ),
              DataColumn(
                label: Text(_names[3]),
                numeric: true,
                onSort: (columnIndex, ascending) =>
                    _sort<String>((d) => d.timestamp, columnIndex, ascending),
              ),
              DataColumn(
                label: Text(_names[4]),
                numeric: true,
                onSort: (columnIndex, ascending) =>
                    _sort<num>((d) => d.id, columnIndex, ascending),
              ),
              DataColumn(
                label: Text(_names[5]),
                onSort: (columnIndex, ascending) =>
                    _sort<String>((d) => d.tracking, columnIndex, ascending),
              ),
              DataColumn(
                label: Text(_names[6]),
                onSort: (columnIndex, ascending) =>
                    _sort<String>((d) => d.address, columnIndex, ascending),
              ),
            ],
            source: _transferDataSource,
          ),
        ],
      ),
    );
  }
}

class _Transfer {
  _Transfer(this.title, this.amount, this.balance, this.timestamp, this.id,
      this.tracking, this.address);
  final String title;
  final double amount;
  final double balance;
  final String timestamp;
  final int id;
  final String tracking;
  final String address;

  bool selected = false;
}

class _TransferDataSource extends DataTableSource {
  _TransferDataSource(this.context) {
    _transfers = <_Transfer>[
      _Transfer(
        'Pizza z szynką i pieczarkami',
        -7,
        118.5,
        "2021-14-11",
        4,
        "https://www.blockchain.com/btc/tx/172a8d141cb0861166b2eb766e6444544c267797b71939226802721ab2684df6",
        '1836NGficqz5cSHWdd1qcEuqaEmFAHJRwC',
      ),
      _Transfer(
        'Transfer',
        -30,
        125.5,
        "2021-14-09",
        3,
        "https://www.blockchain.com/btc/tx/172a8d141cb0861166b2eb766e6444544c267797b71939226802721ab2684df6",
        'kolega@wp.pl',
      ),
      _Transfer(
        'Pizza z szynką i pieczarkami',
        -7,
        155.5,
        "2021-14-05",
        2,
        "https://www.blockchain.com/btc/tx/172a8d141cb0861166b2eb766e6444544c267797b71939226802721ab2684df6",
        '1836NGficqz5cSHWdd1qcEuqaEmFAHJRwC',
      ),
      _Transfer(
        'Transfer środków',
        3.5,
        162.5,
        "2021-14-02",
        1,
        "https://www.blockchain.com/btc/tx/172a8d141cb0861166b2eb766e6444544c267797b71939226802721ab2684df6",
        '135ZNGficqz5cSHWdd1qcEuqaEmFAHJRwC',
      ),
      _Transfer(
        'Zasilenie',
        159,
        159,
        "2021-14-01",
        0,
        "https://www.blockchain.com/btc/tx/172a8d141cb0861166b2eb766e6444544c267797b71939226802721ab2684df6",
        '135ZNGficqz5cSHWdd1qcEuqaEmFAHJRwC',
      ),
    ];
    _transfers_filtered = _transfers;
  }

  final BuildContext context;
  List<_Transfer> _transfers;
  List<_Transfer> _transfers_filtered;

  void _sort<T>(Comparable<T> Function(_Transfer d) getField, bool ascending) {
    _transfers_filtered.sort((a, b) {
      final aValue = getField(a);
      final bValue = getField(b);
      return ascending
          ? Comparable.compare(aValue, bValue)
          : Comparable.compare(bValue, aValue);
    });
    notifyListeners();
  }

  void _filter(bool incoming_selected, bool outcoming_selected) {
    _transfers_filtered = new List();

    if (incoming_selected)
      _transfers_filtered
          .addAll(_transfers.where((u) => (u.amount >= 0)).toList());

    if (outcoming_selected)
      _transfers_filtered
          .addAll(_transfers.where((u) => (u.amount < 0)).toList());

    notifyListeners();
  }

  List<_Transfer> get_selected() {
    List<_Transfer> result = new List();

    for (final transfer in _transfers_filtered) {
      if (transfer.selected == true) result.add(transfer);
    }

    return result;
  }

  List<String> get_names() => [
        'Tytuł',
        'Kwota',
        'Saldo po operacji',
        'Data zlecenia',
        'ID',
        'Tracking',
        'Adres'
      ];

  int _selectedCount = 0;

  @override
  DataRow getRow(int index) {
    assert(index >= 0);
    if (index >= _transfers_filtered.length) return null;
    final transfer = _transfers_filtered[index];
    final text_color = transfer.amount >= 0 ? Colors.green : Colors.red;
    return DataRow.byIndex(
      index: index,
      selected: transfer.selected,
      onSelectChanged: (value) {
        if (transfer.selected != value) {
          _selectedCount += value ? 1 : -1;
          assert(_selectedCount >= 0);
          transfer.selected = value;
          notifyListeners();
        }
      },
      cells: [
        DataCell(Text(transfer.title, style: TextStyle(color: text_color))),
        DataCell(Text(transfer.amount.toString(),
            style: TextStyle(color: text_color))),
        DataCell(Text(transfer.balance.toString(),
            style: TextStyle(color: text_color))),
        DataCell(Text(transfer.timestamp, style: TextStyle(color: text_color))),
        DataCell(
            Text(transfer.id.toString(), style: TextStyle(color: text_color))),
        DataCell(
          IconButton(
              onPressed: () {
                js.context.callMethod('open', ['${transfer.tracking}']);
              },
              icon: Icon(Icons.outbond),
              tooltip: 'Zobacz transakcję na blockchainie'),
        ),
        DataCell(Text(transfer.address, style: TextStyle(color: text_color))),
      ],
    );
  }

  @override
  int get rowCount => _transfers_filtered.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => _selectedCount;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

class DepositDataTable extends StatefulWidget {
  const DepositDataTable();

  @override
  _DepositDataTableState createState() => _DepositDataTableState();
}

class _DepositDataTableState extends State<DepositDataTable> {
  int _rowsPerPage = 5;
  int _sortColumnIndex = -1;
  //int _sortColumnIndex = 3; // indicator should be turned off initially, it is related to a bug in flutter
  //https://stackoverflow.com/questions/51293492/confusion-over-datatables-sort-direction-arrows

  bool _sortAscending = false;
  var _sortField;
  _DepositDataSource _depositDataSource;
  var _names; // names of columns

  void _sort<T>(
    Comparable<T> Function(_Deposit d) getField,
    int columnIndex,
    bool ascending,
  ) {
    _depositDataSource._sort<T>(getField, ascending);

    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
      _sortField = getField;
    });
  }

  void _sort_previous() {
    _depositDataSource._sort(_sortField, _sortAscending);
  }

  int _get_selected_count() {
    return _depositDataSource.selectedRowCount;
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

    final _deposits = _depositDataSource.get_selected();
    final List<List<String>> _depositsStrings = new List();
    _depositsStrings.add(_names);

    for (final deposit in _deposits)
      _depositsStrings.add([
        deposit.title,
        deposit.amount.toString(),
        deposit.id.toString(),
        deposit.interest_rate.toString(),
        deposit.account,
        deposit.start_date,
        deposit.deposit_period,
        deposit.capitalization_period,
        deposit.last_capitalization
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
            pw.Text("Historia lokat",
                style:
                    pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
            pw.Image(pw.ImageProxy(imageE)),
            pw.Table.fromTextArray(
                context: context,
                headerAlignment: pw.Alignment.center,
                data: _depositsStrings),
          ]);
        }));

    return pdf.save();
  }

  Uint8List generate_csv() {
    final _deposits = _depositDataSource.get_selected();

    String result = "";

    for (final name in _names) result += '${name},';

    result = result.substring(0, result.length - 1); // remove trailing ,

    for (final deposit in _deposits)
      result +=
          '\n${deposit.title},${deposit.amount},${deposit.id},${deposit.interest_rate},${deposit.account},${deposit.start_date},${deposit.deposit_period},${deposit.capitalization_period},${deposit.last_capitalization}';

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
      ..download = 'historia_lokat.csv';
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
    _depositDataSource = _DepositDataSource(context);
    _names = _depositDataSource.get_names();
    _sort<String>((d) => d.start_date, _sortColumnIndex, _sortAscending);
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          PaginatedDataTable(
            header: Row(children: [
              Text('Historia lokat'),
              SizedBox(
                width: 50,
              ),
            ]),
            actions: [
              IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/deposit');
                  },
                  icon: Icon(Icons.settings_backup_restore),
                  tooltip: 'Utwórz nową'),
              IconButton(
                  onPressed: () {
                    if (_get_selected_count() != 1)
                      Scaffold.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'Należy wybrać dokładnie jedną lokatę do zamknięcia.'),
                        ),
                      );

                    if (_get_selected_count() == 1) showPopup(context);
                  },
                  icon: Icon(Icons.cancel),
                  tooltip: 'Zamknij lokatę'),
              IconButton(
                  onPressed: () {
                    if (_get_selected_count() == 0)
                      Scaffold.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'Należy najpierw wybrać lokaty do eksportu.'),
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
                              'Należy najpierw wybrać lokaty do eksportu.'),
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
                numeric: true,
                onSort: (columnIndex, ascending) =>
                    _sort<num>((d) => d.amount, columnIndex, ascending),
              ),
              DataColumn(
                label: Text(_names[2]),
                numeric: true,
                onSort: (columnIndex, ascending) =>
                    _sort<num>((d) => d.id, columnIndex, ascending),
              ),
              DataColumn(
                label: Text(_names[3]),
                numeric: true,
                onSort: (columnIndex, ascending) =>
                    _sort<num>((d) => d.interest_rate, columnIndex, ascending),
              ),
              DataColumn(
                label: Text(_names[4]),
                onSort: (columnIndex, ascending) =>
                    _sort<String>((d) => d.account, columnIndex, ascending),
              ),
              DataColumn(
                label: Text(_names[5]),
                onSort: (columnIndex, ascending) =>
                    _sort<String>((d) => d.start_date, columnIndex, ascending),
              ),
              DataColumn(
                label: Text(_names[6]),
                onSort: (columnIndex, ascending) => _sort<String>(
                    (d) => d.deposit_period, columnIndex, ascending),
              ),
              DataColumn(
                label: Text(_names[7]),
                onSort: (columnIndex, ascending) => _sort<String>(
                    (d) => d.capitalization_period, columnIndex, ascending),
              ),
              DataColumn(
                label: Text(_names[8]),
                onSort: (columnIndex, ascending) => _sort<String>(
                    (d) => d.last_capitalization, columnIndex, ascending),
              ),
            ],
            source: _depositDataSource,
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
                      child: Text('Czy na pewno chcesz zamknąć lokatę?',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Operacja ta spowoduje utratę odsetek.',
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
                                  // usunac lokate
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
                      child: Text('Rezultat',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: SelectableText('Miejsce na rezultat',
                          style: TextStyle(fontSize: 14)),
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
}

class _Deposit {
  _Deposit(
      this.title,
      this.amount,
      this.id,
      this.interest_rate,
      this.account,
      this.start_date,
      this.deposit_period,
      this.capitalization_period,
      this.last_capitalization);
  final String title;
  final double amount;
  final int id;
  final double interest_rate;
  final String account;
  final String start_date;
  final String deposit_period;
  final String capitalization_period;
  final String last_capitalization;

  bool selected = false;
}

class _DepositDataSource extends DataTableSource {
  _DepositDataSource(this.context) {
    _deposits = <_Deposit>[
      _Deposit('Lokata A', 7.14, 0, 2.8, 'Glowne', '2021-12-01', '3 dni',
          '1 dzien', '2021-14-01'),
      _Deposit('Lokata B', 7.14, 0, 2.8, 'Nowe konto', '2021-12-01', '3 dni',
          '1 dzien', '2021-14-01'),
      _Deposit('Lokata C', 7.14, 0, 2.8, 'Konto na specjalne okazje',
          '2021-12-01', '3 dni', '1 dzien', '2021-14-01'),
      _Deposit('Lokata D', 7.14, 0, 2.8, 'Glowne', '2021-12-01', '3 dni',
          '1 dzien', '2021-14-01'),
      _Deposit('Lokata E', 7.14, 0, 2.8, 'Glowne', '2021-12-01', '3 dni',
          '1 dzien', '2021-14-01'),
    ];
  }

  final BuildContext context;
  List<_Deposit> _deposits;

  void _sort<T>(Comparable<T> Function(_Deposit d) getField, bool ascending) {
    _deposits.sort((a, b) {
      final aValue = getField(a);
      final bValue = getField(b);
      return ascending
          ? Comparable.compare(aValue, bValue)
          : Comparable.compare(bValue, aValue);
    });
    notifyListeners();
  }

  List<_Deposit> get_selected() {
    List<_Deposit> result = new List();

    for (final deposit in _deposits) {
      if (deposit.selected == true) result.add(deposit);
    }

    return result;
  }

  List<String> get_names() => [
        'Tytuł',
        'Kwota',
        'Id',
        'Oprocentowanie',
        'Konto',
        'Początek',
        'Czas trwania',
        'Okres kapitalizacji',
        'Ostatnia kapitalizacja'
      ];

  int _selectedCount = 0;

  @override
  DataRow getRow(int index) {
    assert(index >= 0);
    if (index >= _deposits.length) return null;
    final deposit = _deposits[index];
    final text_color = Colors.black;
    return DataRow.byIndex(
      index: index,
      selected: deposit.selected,
      onSelectChanged: (value) {
        if (deposit.selected != value) {
          _selectedCount += value ? 1 : -1;
          assert(_selectedCount >= 0);
          deposit.selected = value;
          notifyListeners();
        }
      },
      cells: [
        DataCell(Text(deposit.title, style: TextStyle(color: text_color))),
        DataCell(Text(deposit.amount.toString(),
            style: TextStyle(color: text_color))),
        DataCell(
            Text(deposit.id.toString(), style: TextStyle(color: text_color))),
        DataCell(Text(deposit.interest_rate.toString(),
            style: TextStyle(color: text_color))),
        DataCell(Text(deposit.account, style: TextStyle(color: text_color))),
        DataCell(Text(deposit.start_date, style: TextStyle(color: text_color))),
        DataCell(
            Text(deposit.deposit_period, style: TextStyle(color: text_color))),
        DataCell(Text(deposit.capitalization_period,
            style: TextStyle(color: text_color))),
        DataCell(Text(deposit.last_capitalization,
            style: TextStyle(color: text_color))),
      ],
    );
  }

  @override
  int get rowCount => _deposits.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => _selectedCount;
}
