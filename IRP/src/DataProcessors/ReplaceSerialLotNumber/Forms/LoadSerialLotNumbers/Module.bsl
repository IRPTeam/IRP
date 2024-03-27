
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	_areaSerialLotNumber = ThisObject.TableDoc.Area(1, 1, 1, 1);
	_areaSerialLotNumber.Text = "Serial lot number";
	_areaSerialLotNumber.BackColor = New Color(153, 204, 255);
	_areaSerialLotNumber.ColumnWidth = 20;
	
	_areaRef = ThisObject.TableDoc.Area(1, 2, 1, 2);
	_areaRef.Text = "Ref";
	_areaRef.BackColor = New Color(204, 255, 204);
	_areaRef.ColumnWidth = 20;
	
	ThisObject.TableDoc.FixedTop = 1;
EndProcedure

&AtClient
Procedure FindSerialLotNumbers(Command)
	FindSerialLotNumbersAtServer();
EndProcedure

&AtServer
Procedure FindSerialLotNumbersAtServer()
	_valueTable = New ValueTable();
	_valueTable.Columns.Add("LineNumber", New TypeDescription("Number"));
	_valueTable.Columns.Add("SerialLotNumber", New TypeDescription("String"));
	
	For _row = 2 To ThisObject.TableDoc.TableHeight Do
		_newRow = _valueTable.Add();
		_newRow.SerialLotNumber = TrimAll(ThisObject.TableDoc.Area(_row, 1, _row, 1).Text);
		_newRow.LineNumber = _row;
	EndDo;
	
	_query = New Query();
	_query.Text = 
	"SELECT
	|	tmp.LineNumber,
	|	CAST(tmp.SerialLotNumber AS STRING(50)) AS SerialLotNumber
	|INTO tmp
	|FROM
	|	&SerialLotNumbers AS tmp
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	tmp.LineNumber,
	|	tmp.SerialLotNumber,
	|	SerialLotNumbers.Ref
	|FROM
	|	tmp AS tmp
	|		LEFT JOIN Catalog.SerialLotNumbers AS SerialLotNumbers
	|		ON tmp.SerialLotNumber = SerialLotNumbers.Description
	|		AND NOT SerialLotNumbers.DeletionMark
	|
	|ORDER BY
	|	tmp.LineNumber";
	_query.SetParameter("SerialLotNumbers", _valueTable);
	_querySelection = _query.Execute().Select();
	
	ThisObject.SerialLotNumbers.Clear();
	
	While _querySelection.Next() Do
		ThisObject.TableDoc.Area(_querySelection.LineNumber, 1, _querySelection.LineNumber, 1).Text 
			= TrimAll(_querySelection.SerialLotNumber);
		
		_areaRef = ThisObject.TableDoc.Area(_querySelection.LineNumber, 2, _querySelection.LineNumber, 2);
		If Not ValueIsFilled(_querySelection.Ref) Then
			_areaRef.BackColor = WebColors.Red;
		Else
			_areaRef.BackColor = WebColors.White;
			ThisObject.SerialLotNumbers.Add(_querySelection.Ref);
		EndIf;
			
		_areaRef.Text = String(_querySelection.Ref);
	EndDo;
EndProcedure

&AtClient
Procedure Ok(Command)
	Close(New Structure("ArrayOfSerialLotNumbers", ThisObject.SerialLotNumbers.UnloadValues()));
EndProcedure

&AtClient
Procedure Cancel(Command)
	Close(Undefined);
EndProcedure

