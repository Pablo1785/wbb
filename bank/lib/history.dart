import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:email_validator/email_validator.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
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
                              child: DataTableDemo(),
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

class DataTableDemo2 extends StatelessWidget {
  Widget build(BuildContext context) {
    return ListView(
        padding: const EdgeInsets.all(16),
        children: [
          PaginatedDataTable(
            header: Text('Header Text'),
            rowsPerPage: 4,
            columns: [
              DataColumn(label: Text('Header A')),
              DataColumn(label: Text('Header B')),
              DataColumn(label: Text('Header C')),
              DataColumn(label: Text('Header D')),
			  DataColumn(label: Text('Header E')),
            ],
            source: _DataSource(context),
          ),
        ],
      );
  }
}

class _Row {
  _Row(
    this.valueA,
    this.valueB,
    this.valueC,
    this.valueD,
	this.valueE,
  );

  final String valueA;
  final String valueB;
  final String valueC;
  final int valueD;
  final int valueE;

  bool selected = false;
}

class _DataSource extends DataTableSource {
  _DataSource(this.context) {
    _rows = <_Row>[
      _Row('Cell A1', 'CellB1', 'CellC1', 1, 1),
      _Row('Cell A2', 'CellB2', 'CellC2', 2, 3),
      _Row('Cell A3', 'CellB3', 'CellC3', 3, 7),
      _Row('Cell A4', 'CellB4', 'CellC4', 4, 9),
    ];
  }

  final BuildContext context;
  List<_Row> _rows;

  int _selectedCount = 0;

  @override
  DataRow getRow(int index) {
    assert(index >= 0);
    if (index >= _rows.length) return null;
    final row = _rows[index];
    return DataRow.byIndex(
      index: index,
      selected: row.selected,
      onSelectChanged: (value) {
        if (row.selected != value) {
          _selectedCount += value ? 1 : -1;
          assert(_selectedCount >= 0);
          row.selected = value;
          notifyListeners();
        }
      },
      cells: [
        DataCell(Text(row.valueA)),
        DataCell(Text(row.valueB)),
        DataCell(Text(row.valueC)),
        DataCell(Text(row.valueD.toString())),
		DataCell(Text(row.valueE.toString())),
      ],
    );
  }

  @override
  int get rowCount => _rows.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => _selectedCount;
}

class DataTableDemo extends StatefulWidget {
  const DataTableDemo();

  @override
  _DataTableDemoState createState() => _DataTableDemoState();
}

class _DataTableDemoState extends State<DataTableDemo> with RestorationMixin {
  final RestorableInt _rowsPerPage =
      RestorableInt(PaginatedDataTable.defaultRowsPerPage);
  final RestorableInt _sortColumnIndex = RestorableInt(-1);
  final RestorableBool _sortAscending = RestorableBool(true);
  _DessertDataSource _dessertsDataSource;
  
  	bool incoming_selected = true;
	bool outcoming_selected = true;

  @override
  String get restorationId => 'data_table_demo';

  @override
  void restoreState(RestorationBucket oldBucket, bool initialRestore) {
    registerForRestoration(_rowsPerPage, 'rows_per_page');
    registerForRestoration(_sortColumnIndex, 'sort_column_index');
    registerForRestoration(_sortAscending, 'sort_ascending');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _dessertsDataSource ??= _DessertDataSource(context);
  }

  void _sort<T>(
    Comparable<T> Function(_Dessert d) getField,
    int columnIndex,
    bool ascending,
  ) {
    _dessertsDataSource._sort<T>(getField, ascending);
    setState(() {
      // [RestorableBool]'s value cannot be null, so -1 is used as a placeholder
      // to represent `null` in [DataTable]s.
      if (columnIndex == null) {
        _sortColumnIndex.value = -1;
      } else {
        _sortColumnIndex.value = columnIndex;
      }
      _sortAscending.value = ascending;
    });
  }
  
  void _show()
  {
	  _dessertsDataSource._show(incoming_selected, outcoming_selected);
  }

  @override
  Widget build(BuildContext context) {
    // Need to call sort on build to ensure that the data values are correctly
    // sorted on state restoration.
    _sort<num>((d) => d.calories, _sortColumnIndex.value, _sortAscending.value);
	_show();


    return Scrollbar(
        child: ListView(
          restorationId: 'data_table_list_view',
          padding: const EdgeInsets.all(16),
          children: [
            PaginatedDataTable(
              header: Row(children:[
			  Text('Tytul2'),
			  				  SizedBox(
                    width: 50,
                  ),
			  FilterChip(
              label: Text('Przychodzące'),
              selected: incoming_selected,
              onSelected: (bool value) {    setState(() {incoming_selected = value;});
			  _show();},
            ),
							  SizedBox(
                    width: 50,
                  ),
			  FilterChip(
              label: Text('Wychodzące'),
              selected: outcoming_selected,
              onSelected: (bool value) {setState(() {outcoming_selected = value;});},
            ),
			  ]
			  ),
              rowsPerPage: _rowsPerPage.value,
              onRowsPerPageChanged: (value) {
                setState(() {
                  _rowsPerPage.value = value;
                });
              },
              // RestorableBool's value cannot be null, so -1 is used as a
              // placeholder to represent `null` in [DataTable]s.
              sortColumnIndex:
                  _sortColumnIndex.value == -1 ? null : _sortColumnIndex.value,
              sortAscending: _sortAscending.value,
              onSelectAll: _dessertsDataSource._selectAll,
              columns: [
                DataColumn(
                  label: Text('deser'),
                  onSort: (columnIndex, ascending) =>
                      _sort<String>((d) => d.name, columnIndex, ascending),
                ),
                DataColumn(
                  label: Text('kalorie'),
                  numeric: true,
                  onSort: (columnIndex, ascending) =>
                      _sort<num>((d) => d.calories, columnIndex, ascending),
                ),
                DataColumn(
                  label: Text('tluszcz'),
                  numeric: true,
                  onSort: (columnIndex, ascending) =>
                      _sort<num>((d) => d.fat, columnIndex, ascending),
                ),
                DataColumn(
                  label: Text('carbs'),
                  numeric: true,
                  onSort: (columnIndex, ascending) =>
                      _sort<num>((d) => d.carbs, columnIndex, ascending),
                ),
                DataColumn(
                  label: Text('proteins'),
                  numeric: true,
                  onSort: (columnIndex, ascending) =>
                      _sort<num>((d) => d.protein, columnIndex, ascending),
                ),
                DataColumn(
                  label: Text('sodium'),
                  numeric: true,
                  onSort: (columnIndex, ascending) =>
                      _sort<num>((d) => d.sodium, columnIndex, ascending),
                ),
                DataColumn(
                  label: Text('calcium'),
                  numeric: true,
                  onSort: (columnIndex, ascending) =>
                      _sort<num>((d) => d.calcium, columnIndex, ascending),
                ),
                DataColumn(
                  label: Text('iron'),
                  numeric: true,
                  onSort: (columnIndex, ascending) =>
                      _sort<num>((d) => d.iron, columnIndex, ascending),
                ),
              ],
              source: _dessertsDataSource,
            ),
          ],
        ),
      );
  }
}

class _Dessert {
  _Dessert(this.name, this.calories, this.fat, this.carbs, this.protein,
      this.sodium, this.calcium, this.iron);
  final String name;
  final int calories;
  final double fat;
  final int carbs;
  final double protein;
  final int sodium;
  final int calcium;
  final int iron;

  bool selected = false;
}

class _DessertDataSource extends DataTableSource {
  _DessertDataSource(this.context) {
    _desserts = <_Dessert>[
      _Dessert(
        'jogurt',
        159,
        6.0,
        24,
        4.0,
        87,
        14,
        1,
      ),
      _Dessert(
        'jogurt',
        237,
        9.0,
        37,
        4.3,
        129,
        8,
        1,
      ),
      _Dessert(
        'jogurt',
        262,
        16.0,
        24,
        6.0,
        337,
        6,
        7,
      ),
      _Dessert(
        'jogurt',
        305,
        3.7,
        67,
        4.3,
        413,
        3,
        8,
      ),
    ];
	
	    _all = <_Dessert>[
      _Dessert(
        'jogurt',
        159,
        6.0,
        24,
        4.0,
        87,
        14,
        1,
      ),
      _Dessert(
        'jogurt',
        237,
        9.0,
        37,
        4.3,
        129,
        8,
        1,
      ),
      _Dessert(
        'jogurt',
        262,
        16.0,
        24,
        6.0,
        337,
        6,
        7,
      ),
      _Dessert(
        'jogurt',
        305,
        3.7,
        67,
        4.3,
        413,
        3,
        8,
      ),
    ];
  }

  final BuildContext context;
  List<_Dessert> _desserts;
  List<_Dessert> _all;

  void _sort<T>(Comparable<T> Function(_Dessert d) getField, bool ascending) {
    _desserts.sort((a, b) {
      final aValue = getField(a);
      final bValue = getField(b);
      return ascending
          ? Comparable.compare(aValue, bValue)
          : Comparable.compare(bValue, aValue);
    });
    notifyListeners();
  }
  
  void _show(bool incoming_selected, bool outcoming_selected){
	  if (incoming_selected)
		_desserts = _all.where((u) => (u.iron > 5)).toList();
	  else
		_desserts = _all;
	   notifyListeners();
      }

  int _selectedCount = 0;

  @override
  DataRow getRow(int index) {
    assert(index >= 0);
    if (index >= _desserts.length) return null;
    final dessert = _desserts[index];
    return DataRow.byIndex(
      index: index,
      selected: dessert.selected,
      onSelectChanged: (value) {
        if (dessert.selected != value) {
          _selectedCount += value ? 1 : -1;
          assert(_selectedCount >= 0);
          dessert.selected = value;
          notifyListeners();
        }
      },
      cells: [
        DataCell(Text(dessert.name)),
        DataCell(Text('${dessert.calories}')),
        DataCell(Text(dessert.fat.toStringAsFixed(1))),
        DataCell(Text('${dessert.carbs}')),
        DataCell(Text(dessert.protein.toStringAsFixed(1))),
        DataCell(Text('${dessert.sodium}')),
        DataCell(Text('${(dessert.calcium / 100)}')),
        DataCell(Text('${(dessert.iron / 100)}')),
      ],
    );
  }

  @override
  int get rowCount => _desserts.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => _selectedCount;

  void _selectAll(bool checked) {
    for (final dessert in _desserts) {
      dessert.selected = checked;
    }
    _selectedCount = checked ? _desserts.length : 0;
    notifyListeners();
  }
}





class DropDownList extends StatefulWidget {
  DropDownList({
    this.deposit,
  });

  final Deposit deposit;

  @override
  _DropDownListState createState() => _DropDownListState(deposit: deposit);
}

class _DropDownListState extends State<DropDownList> {
  String dropdownValue;

  _DropDownListState({
    this.deposit,
  });

  final Deposit deposit;

  @override
  Widget build(BuildContext context) {
    dropdownValue = deposit.account_names[0];

    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: 'Z Konta',
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelStyle: TextStyle(
          fontSize: 24,
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontFamily: 'HelveticaNeue',
        ),
      ),
      validator: (value) {
        if (value.isEmpty) {
          return 'Proszę wybrać poprawne konto.';
        }
      },
      onSaved: (val) => setState(() => deposit.data[Deposit.Account] = val),
      value: dropdownValue,
      icon: Icon(Icons.arrow_downward),
      iconSize: 24,
      onChanged: (String newValue) {
        setState(() {
          dropdownValue = newValue;
        });
      },
      items:
          deposit.account_names.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}

class DepositButtons extends StatefulWidget {
  DepositButtons({Key key, this.deposit}) : super(key: key);

  final Deposit deposit;

  @override
  _DepositButtonsState createState() => _DepositButtonsState(deposit: deposit);
}

class _DepositButtonsState extends State<DepositButtons> {
  _DepositButtonsState({this.deposit});

  final Deposit deposit;

  @override
  Widget build(BuildContext context) {
    return Row(children: fillRow());
  }

  List<Widget> fillRow() {
    List<Widget> options = new List();

    for (var i = 0; i < deposit.deposit_options.length; i++) {
      options.add(Container(
          height: 80,
          // margin: EdgeInsets.only(left: 200, right: 200),
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
          child: RaisedButton(
              color: deposit.choice == i
                  ? Colors.blue
                  : Theme.of(context).buttonColor,
              onPressed: () {
                setState(() => deposit.choice = i);
              },
              child: Text(
                '${deposit.deposit_options[i]["interest_rate"]} (czas: ${deposit.deposit_options[i]["deposit_period"]}) (kapitalizacja: ${deposit.deposit_options[i]["capitalization_period"]})',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'HelveticaNeue',
                ),
              ))));
    }

    return options;
  }
}
