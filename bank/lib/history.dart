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
import 'main.dart';
import 'logged_in.dart';
import 'settings.dart';
import 'transfer.dart';
import 'contact.dart';
import 'globals.dart';

void main() => runApp(DepositApp());

class DepositApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wirtualny Bank Bitcoinów',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        brightness: light_theme ? Brightness.light : Brightness.dark,
      ),
      routes: {
        '/': (context) => DepositPage(),
        '/main': (context) => MainApp(),
        '/settings': (context) => SettingsApp(),
        '/loggedin': (context) => LoggedInApp(),
        '/transfer': (context) => TransferApp(),
        '/deposit': (context) => DepositApp(),
        '/contact': (context) => ContactApp(),
      },
      localizationsDelegates: [GlobalMaterialLocalizations.delegate],
      supportedLocales: [
        const Locale('pl'),
      ],
    );
  }
}

class DepositPage extends StatefulWidget {
  @override
  _DepositPageState createState() => _DepositPageState();
}

class _DepositPageState extends State<DepositPage> {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
        //extendBodyBehindAppBar: true,
        appBar: PreferredSize(
          preferredSize: Size(screenSize.width, 1000),
          child: Menu(),
        ),
        body: FormDeposit());
  }
}

class Deposit {
  static const String Amount = 'amount';
  static const String Title = 'title';
  static const String Account = 'account';
  static const String TimeStamp = 'start_date';
  static const String Id = 'id';

  var account_names = ["Główne", "Dodatkowe", "Dodatkowe2"];
  int choice = 1;

  var data = new Map();

  Map D1 = {
    "interest_rate": '3,2%',
    "deposit_period": '3 dni',
    "capitalization_period": '1 dzień',
  };

  Map D2 = {
    "interest_rate": '3,8%',
    "deposit_period": '6 dni',
    "capitalization_period": '1 dzień',
  };

  Map D3 = {
    "interest_rate": '4,2%',
    "deposit_period": '14 dni',
    "capitalization_period": '1 dzień',
  };

  var deposit_options = new List();

  Deposit() {
    read();
  }

  // read data from backend and fill the map
  read() {
    print('reading available deposit options from backend');
    deposit_options.add(D1);
    deposit_options.add(D2);
    deposit_options.add(D3);

    for (var i = 0; i < deposit_options.length; i++) {
      print(deposit_options[i]);
    }
  }

  // send data to backend
  send() {
    print('sending deposit data to backend');
    data.forEach((k, v) => print('${k}: ${v}'));
  }
}

class FormDeposit extends StatefulWidget {
  @override
  _FormDepositState createState() => _FormDepositState();
}

class _FormDepositState extends State<FormDeposit> {
  final _formKey = GlobalKey<FormState>();
  final _deposit = Deposit();
  var txtDate = TextEditingController();
  var txtTime = TextEditingController();
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

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
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
              child: Builder(
                  builder: (context) => Form(
                      key: _formKey,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Container(
                              padding: const EdgeInsets.fromLTRB(0, 50, 0, 20),
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
							//DataTableDemo(),
                            Container(
                              padding: const EdgeInsets.fromLTRB(0, 50, 0, 20),
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
							//DataTableDemo(),
                          ])))),
        ),
      ),
    ));
  }

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 10)),
      locale: const Locale("pl", "PL"),
    );
    if (picked != null) {
      selectedDate = picked;
      txtDate.text =
          "${selectedDate.year.toString()}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}";
    }
  }

  _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null) {
      selectedTime = picked;
      txtTime.text = selectedTime.format(context);
    }
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
                      child: Text('Czy na pewno chcesz utworzyć lokatę?',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                          'Jeżeli wybrano termin w przyszłości, pamiętaj aby zapewnić wystarczające środki.',
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
                                  _deposit.data[Deposit.Id] = _deposit.choice;
                                  _deposit.send();
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

class TransferDataTable extends StatefulWidget {
  const TransferDataTable();

  @override
  _TransferDataTableState createState() => _TransferDataTableState();
}

class _TransferDataTableState extends State<TransferDataTable>{
  int _rowsPerPage = 5;
  int _sortColumnIndex = -1;
  //int _sortColumnIndex = 3;
  bool _sortAscending = false;
  var _sortField;
  _TransferDataSource _transferDataSource;
  
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

  void _sort_previous()
  {
    _transferDataSource._sort(_sortField, _sortAscending);
  }
  
  void _filter()
  {
	  _transferDataSource._filter(incoming_selected, outcoming_selected);
  }
  
  int _get_selected_count()
  {
	  return _transferDataSource.selectedRowCount;
  }
  
  Future<Uint8List> generate_pdf() async{

	  var pdf_theme = pw.ThemeData.withFont( // have to load custom font to support polish characters
  base: pw.Font.ttf(await rootBundle.load("fonts/OpenSans-Regular.ttf")),
  bold: pw.Font.ttf(await rootBundle.load("fonts/OpenSans-Bold.ttf")),
  italic: pw.Font.ttf(await rootBundle.load("fonts/OpenSans-Italic.ttf")),
  boldItalic: pw.Font.ttf(await rootBundle.load("fonts/OpenSans-Bolditalic.ttf")),  
);

	  	  final pdf = pw.Document(theme: pdf_theme);
		  
			final image = await rootBundle.load("images/logo_small.png");
  
  final _transfers = _transferDataSource.get_selected();
  final List<List<String>> _transfersStrings = new List();
  _transfersStrings.add(['Tytuł', 'Kwota', 'Saldo po operacji', 'Data zlecenia', 'ID', 'Tracking', 'Adres']);
  
  for(final transfer in _transfers)
	  _transfersStrings.add([transfer.title, transfer.amount.toString(), transfer.balance.toString(), transfer.timestamp, transfer.id.toString(), transfer.tracking, transfer.address]);
  
final imageE = PdfImage.file(
  pdf.document,
  bytes: image.buffer.asUint8List(),
);

pdf.addPage(pw.Page(
      pageFormat: PdfPageFormat(double.infinity, double.infinity, marginAll: 2.0 * PdfPageFormat.cm),
      build: (pw.Context context) {
        return pw.Column(children:[
		  
		  
		  pw.Text("Historia transakcji", style: pw.TextStyle(
                              fontSize: 20, fontWeight: pw.FontWeight.bold)),
pw.Image(pw.ImageProxy(imageE)),
							  pw.Table.fromTextArray(context: context, headerAlignment: pw.Alignment.center,data:
							  _transfersStrings
							  ),
							  ]);

      }));
	  
	  return pdf.save();

  }
  
  void show_pdf(Uint8List bytes)
  {
    final blob = html.Blob([bytes], 'application/pdf');
	
	                final url = html.Url.createObjectUrlFromBlob(blob);
                html.window.open(url, "_blank");	  
  }
  
  void export_to_pdf() async{
	  
		Uint8List bytes = await generate_pdf();
		show_pdf(bytes);
  }
  
  @override
  void initState() {
	  _transferDataSource = _TransferDataSource(context);
	  _sort<String>((d) => d.timestamp, _sortColumnIndex, _sortAscending);
  }

  @override
  Widget build(BuildContext context) {

    return Scrollbar(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            PaginatedDataTable(
              header: Row(children:[
			  Text('Historia przelewów'),
			  				  SizedBox(
                    width: 50,
                  ),
			  FilterChip(
              label: Text('Przychodzące'),
              selected: incoming_selected,
              onSelected: (bool value) {    setState(() {incoming_selected = value; _filter(); _sort_previous();});},
            ),
							  SizedBox(
                    width: 50,
                  ),
			  FilterChip(
              label: Text('Wychodzące'),
              selected: outcoming_selected,
              onSelected: (bool value) {setState(() {outcoming_selected = value; _filter(); _sort_previous();});},
            ),
			  ]
			  ),
			  actions: [
			  
			  IconButton(
			  onPressed: () {
				  
				  if (_get_selected_count() != 1)
					  Scaffold.of(context).showSnackBar(SnackBar(content: Text('Należy wybrać dokładnie jeden przelew do powtórzenia.'),),);
				  // else powtórz przelew

			  },
			  icon: Icon(Icons.settings_backup_restore),
			  tooltip: 'Wykonaj ponownie'
			  ),

			  IconButton(
			  onPressed: () {
				  
				  	if (_get_selected_count() == 0)
					  Scaffold.of(context).showSnackBar(SnackBar(content: Text('Należy najpierw wybrać przelewy do eksportu.'),),);
				  else
					  Scaffold.of(context).showSnackBar(SnackBar(content: Text('Pomyślnie wygenerowano CSV.'),),);
				  
			  },
			  icon: Icon(Icons.assignment_returned),
			  tooltip: 'Eksport do CSV'
			  ),
			  
			  IconButton(
			  onPressed: () {
				  
				 if (_get_selected_count() == 0)
					  Scaffold.of(context).showSnackBar(SnackBar(content: Text('Należy najpierw wybrać przelewy do eksportu.'),),);
				  else
				  {
					  export_to_pdf();
					  Scaffold.of(context).showSnackBar(SnackBar(content: Text('Trwa generowanie PDF.'),),);					  
				  }

				  
			  },
			  icon: Icon(Icons.save_alt),
			  tooltip: 'Eksport do PDF'
			  ),
			  
			  ],
              rowsPerPage: _rowsPerPage,
			  availableRowsPerPage: [_rowsPerPage, _rowsPerPage*2,_rowsPerPage*5,_rowsPerPage*10],
              onRowsPerPageChanged: (value) {
                setState(() {
                  _rowsPerPage = value;
                });
              },
              sortColumnIndex:
                  _sortColumnIndex == -1 ? null : _sortColumnIndex,
				  //_sortColumnIndex,
              sortAscending: _sortAscending,
              columns: [
                DataColumn(
                  label: Text('Tytuł'),
                  onSort: (columnIndex, ascending) =>
                      _sort<String>((d) => d.title, columnIndex, ascending),
                ),
                DataColumn(
                  label: Text('Kwota'),
                  numeric: true,
                  onSort: (columnIndex, ascending) =>
                      _sort<num>((d) => d.amount, columnIndex, ascending),
                ),
                DataColumn(
                  label: Text('Saldo po operacji'),
                  numeric: true,
                  onSort: (columnIndex, ascending) =>
                      _sort<num>((d) => d.balance, columnIndex, ascending),
                ),
                DataColumn(
                  label: Text('Data zlecenia'),
                  numeric: true,
                  onSort: (columnIndex, ascending) =>
                      _sort<String>((d) => d.timestamp, columnIndex, ascending),
                ),
				DataColumn(
                  label: Text('ID'),
                  numeric: true,
                  onSort: (columnIndex, ascending) =>
                      _sort<num>((d) => d.id, columnIndex, ascending),
                ),
                DataColumn(
                  label: Text('Tracking'),
                  onSort: (columnIndex, ascending) =>
                      _sort<String>((d) => d.tracking, columnIndex, ascending),
                ),
                DataColumn(
                  label: Text('Adres'),
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
  _Transfer(this.title, this.amount, this.balance, this.timestamp,
      this.id, this.tracking, this.address);
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
  
  
  void _filter(bool incoming_selected, bool outcoming_selected){
	  _transfers_filtered = new List();
	  
	  if (incoming_selected)
		_transfers_filtered.addAll(_transfers.where((u) => (u.amount >= 0)).toList());

	  if (outcoming_selected)
		_transfers_filtered.addAll(_transfers.where((u) => (u.amount < 0)).toList());	

	   notifyListeners();
      }
	  
	List<_Transfer> get_selected(){
		List<_Transfer> result = new List();
		
		for(final transfer in _transfers_filtered)
		{
			if (transfer.selected == true)
				result.add(transfer);
		}
		
		return result;
	}

  int _selectedCount = 0;

  @override
  DataRow getRow(int index) {
    assert(index >= 0);
    if (index >= _transfers_filtered.length) return null;
    final transfer = _transfers_filtered[index];
	final text_color = transfer.amount >=0 ? Colors.green : Colors.red;
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
        DataCell(Text(transfer.amount.toString(), style: TextStyle(color: text_color))),
        DataCell(Text(transfer.balance.toString(), style: TextStyle(color: text_color))),
        DataCell(Text(transfer.timestamp, style: TextStyle(color: text_color))),
        DataCell(Text(transfer.id.toString(), style: TextStyle(color: text_color))),
        DataCell(			  IconButton(
			  onPressed: () {
				  js.context.callMethod('open', ['${transfer.tracking}']);

			  },
			  icon: Icon(Icons.outbond),
			  tooltip: 'Zobacz transakcję na blockchainie'
			  ),
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
