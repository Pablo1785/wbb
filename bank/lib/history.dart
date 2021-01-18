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
import 'subaccounts.dart';
import 'receivers.dart';
import 'security_events.dart';
import 'models.dart';
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
        transfer.source,
        transfer.target,
        transfer.amount,
        transfer.sendTime,
        transfer.confirmationTime,
        transfer.title,
        transfer.fee,
        transfer.transactionHash,
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
          '\n${transfer.source},${transfer.target},${transfer.amount},${transfer.sendTime},${transfer.confirmationTime},${transfer.title},${transfer.fee},${transfer.transactionHash}';

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
    _sort<String>((d) => d.sendTime, _sortColumnIndex, _sortAscending);
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
                      if ((_transferDataSource._subAccounts.any((subaccount) => subaccount.subAddress == _transfers[0].target))) { 
                        Scaffold.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Nie można powtórzyć operacji przychodzącej.'),
                          ),
                        );
                      } else {
                        final _previous = [
                          _transfers[0].title,
                          _transfers[0].amount,
                          _transfers[0].target
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
                    _sort<String>((d) => d.source, columnIndex, ascending),
              ),
              DataColumn(
                label: Text(_names[1]),
                onSort: (columnIndex, ascending) =>
                    _sort<String>((d) => d.target, columnIndex, ascending),
              ),
              DataColumn(
                label: Text(_names[2]),
                onSort: (columnIndex, ascending) =>
                    _sort<String>((d) => d.amount, columnIndex, ascending),
              ),
              DataColumn(
                label: Text(_names[3]),
                onSort: (columnIndex, ascending) =>
                    _sort<String>((d) => d.sendTime, columnIndex, ascending),
              ),
              DataColumn(
                label: Text(_names[4]),
                onSort: (columnIndex, ascending) =>
                    _sort<String>((d) => d.confirmationTime, columnIndex, ascending),
              ),
              DataColumn(
                label: Text(_names[5]),
                onSort: (columnIndex, ascending) =>
                    _sort<String>((d) => d.title, columnIndex, ascending),
              ),
              DataColumn(
                label: Text(_names[6]),
                onSort: (columnIndex, ascending) =>
                    _sort<String>((d) => d.fee, columnIndex, ascending),
              ),
              DataColumn(
                label: Text(_names[6]),
                onSort: (columnIndex, ascending) =>
                    _sort<String>((d) => d.transactionHash, columnIndex, ascending),
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
  _Transfer(this.source, this.target, this.amount, this.sendTime, this.confirmationTime,
      this.title, this.fee, this.transactionHash);
  final String source;
  final String target;
  final String amount;
  final String sendTime;
  final String confirmationTime;
  final String title;
  final String fee;
  final String transactionHash;


  bool selected = false;
}

class _TransferDataSource extends DataTableSource {
  _TransferDataSource(this.context) {
    _transfers = [];
    _transfers_filtered = _transfers;
	_getData();
  }

    void _getData() async {
    _transfers = List<_Transfer>.from(
        (await requestor.fetchTransactions()).map((transfer) =>
            _Transfer(transfer.source, transfer.target, transfer.amount, transfer.sendTime.toIso8601String(), transfer.confirmationTime != null? transfer.confirmationTime.toIso8601String() : "", transfer.title, transfer.fee, transfer.transactionHash != null ? transfer.transactionHash : "")));
	_transfers_filtered = _transfers;
	_subAccounts = await requestor.fetchSubaccounts();
    notifyListeners();
	}
  final BuildContext context;
  List<_Transfer> _transfers;
  List<_Transfer> _transfers_filtered;
  List<SubAccount> _subAccounts;

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
          .addAll(_transfers.where((u) => (_subAccounts.any((subaccount) => subaccount.subAddress == u.target))).toList());

    if (outcoming_selected)
      _transfers_filtered
          .addAll(_transfers.where((u) => (! _subAccounts.any((subaccount) => subaccount.subAddress == u.target))).toList());

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
        'Od',
		'Do',
		'Kwota',
		'Czas wysłania',
		'Czas zatwieredzenia',
		'Tytuł',
		'Fee',
		'Hash',

      ];

  int _selectedCount = 0;

  @override
  DataRow getRow(int index) {
    assert(index >= 0);
    if (index >= _transfers_filtered.length) return null;
    final transfer = _transfers_filtered[index];
    final text_color = ((_subAccounts.any((subaccount) => subaccount.subAddress == _transfers[0].target)))? Colors.green : Colors.red;
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
        DataCell(Text(transfer.source, style: TextStyle(color: text_color))),
        DataCell(Text(transfer.target, style: TextStyle(color: text_color))),
        DataCell(Text(transfer.amount, style: TextStyle(color: text_color))),
        DataCell(Text(transfer.sendTime, style: TextStyle(color: text_color))),
        DataCell(Text(transfer.confirmationTime, style: TextStyle(color: text_color))),
        DataCell(Text(transfer.title, style: TextStyle(color: text_color))),
        DataCell(Text(transfer.fee, style: TextStyle(color: text_color))),
	
        DataCell(
          IconButton(
              onPressed: () {
                js.context.callMethod('open', ['${transfer.transactionHash}']);
              },
              icon: Icon(Icons.outbond),
              tooltip: 'Zobacz transakcję na blockchainie'),
        ),
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
      deposit.account,
      deposit.interestRate,
      deposit.startDate,
      deposit.depositPeriod,
      deposit.capitalizationPeriod,
      deposit.lastCapitalization,
      deposit.title
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
          '\n${deposit.account},${deposit.interestRate},${deposit.startDate},${deposit.depositPeriod},${deposit.capitalizationPeriod},${deposit.lastCapitalization},${deposit.title}';
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
    _sort<String>((d) => d.startDate, _sortColumnIndex, _sortAscending);
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
                    _sort<String>((d) => d.account, columnIndex, ascending),
              ),
              DataColumn(
                label: Text(_names[1]),
                onSort: (columnIndex, ascending) =>
                    _sort<String>((d) => d.interestRate, columnIndex, ascending),
              ),
              DataColumn(
                label: Text(_names[2]),
                onSort: (columnIndex, ascending) =>
                    _sort<String>((d) => d.startDate, columnIndex, ascending),
              ),
              DataColumn(
                label: Text(_names[3]),
                onSort: (columnIndex, ascending) =>
                    _sort<String>((d) => d.depositPeriod, columnIndex, ascending),
              ),
              DataColumn(
                label: Text(_names[4]),
                onSort: (columnIndex, ascending) =>
                    _sort<String>((d) => d.capitalizationPeriod, columnIndex, ascending),
              ),
              DataColumn(
                label: Text(_names[5]),
                onSort: (columnIndex, ascending) =>
                    _sort<String>((d) => d.lastCapitalization, columnIndex, ascending),
              ),
              DataColumn(
                label: Text(_names[6]),
                onSort: (columnIndex, ascending) => _sort<String>(
                    (d) => d.title, columnIndex, ascending),
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
      this.account,
      this.interestRate,
      this.startDate,
      this.depositPeriod,
      this.capitalizationPeriod,
      this.lastCapitalization,
      this.title);
  final String account;
  final String interestRate;
  final String startDate;
  final String depositPeriod;
  final String capitalizationPeriod;
  final String lastCapitalization;
  final String title;

  bool selected = false;
}

class _DepositDataSource extends DataTableSource {
  _DepositDataSource(this.context) {
    _deposits = [];
	_getData();
  }

  void _getData() async {
	  	print(await requestor.fetchDeposits());
    _deposits = List<_Deposit>.from(
        (await requestor.fetchDeposits()).map((deposit) =>
            _Deposit(deposit.account.toString(),deposit.interestRate,deposit.startDate.toIso8601String(), deposit.depositPeriod,deposit.capitalizationPeriod != null? deposit.capitalizationPeriod : "",deposit.lastCapitalization != null? deposit.lastCapitalization.toIso8601String() : "",deposit.title)));
    notifyListeners();

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
        'Subkonto',
        'Oprocentowanie',
        'Początek',
        'Czas trwania',
        'Okres kapitalizacji',
        'Ostatnia kapitalizacja',
		'Tytuł',
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
        DataCell(Text(deposit.account, style: TextStyle(color: text_color))),
		DataCell(Text(deposit.interestRate, style: TextStyle(color: text_color))),
		DataCell(Text(deposit.startDate, style: TextStyle(color: text_color))),
		DataCell(Text(deposit.depositPeriod, style: TextStyle(color: text_color))),
		DataCell(Text(deposit.capitalizationPeriod, style: TextStyle(color: text_color))),
		DataCell(Text(deposit.lastCapitalization, style: TextStyle(color: text_color))),
		DataCell(Text(deposit.title, style: TextStyle(color: text_color))),

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
