

&AtClient
Procedure LoadSettings(Command)
	Settings = HardwareClient.GetDefaultSettings(Object.EquipmentType);
	
	For Each Param In Settings Do
		Row = Object.ConnectParameters.Add();
		Row.Name = Param.Key;
		Row.Value = Param.Value;
	EndDo;
	
EndProcedure

&AtClient
Procedure Test(Command)
	ОчиститьСообщения();

	ТолькоПросмотр = Истина;
	КоманднаяПанель.Доступность = Ложь;
	
	ВходныеПараметры  = Неопределено;
	ПараметрыУстройства = New Structure;
	
	For Each Row In Object.ConnectParameters Do
		ПараметрыУстройства.Insert("P_" + Row.Name, Row.Value);
	EndDo;
	
	Оповещение = Новый ОписаниеОповещения("ТестУстройстваЗавершение", ЭтотОбъект);
	HardwareClient.BeginStartAdditionalComand(Оповещение, "CheckHealth", ВходныеПараметры, Object.Ref, ПараметрыУстройства);

EndProcedure

&НаКлиенте
Процедура ТестУстройстваЗавершение(РезультатВыполнения, Параметры) Экспорт
	
	ТолькоПросмотр = Ложь;
	КоманднаяПанель.Доступность = Истина;
	ВыходныеПараметры = РезультатВыполнения.ВыходныеПараметры;
	
	Если ТипЗнч(ВыходныеПараметры) = Тип("Массив") Тогда
		
		Если ВыходныеПараметры.Количество() >= 2 Тогда
			Status(ВыходныеПараметры[1], , , PictureLib.Stop);
		КонецЕсли;

	КонецЕсли;
	
КонецПроцедуры

