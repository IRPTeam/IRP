
&AtServer
Procedure REP_OnCreateAtServerAfter(Cancel, StandardProcessing)
    IRPTE_CreateBtn("add_picture");
	IRPTE_CreateBtn("update_slider");
	IRPTE_CreateBtn("addImagesFromGallery");
	IRPTE_CreateBtn("remove_picture");
	
	 // Добавляем новый реквизит в форму
    ДобавляемыеРеквизиты = Новый Массив;
    Реквизит = Новый РеквизитФормы("getCurrentSlideId", Новый ОписаниеТипов("Строка"), , "getCurrentSlideId", Истина);
    ДобавляемыеРеквизиты.Добавить(Реквизит);
    ИзменитьРеквизиты(ДобавляемыеРеквизиты);
   
    //Добавляем новое поле ввода на форму
    Элемент = ЭтаФорма.Элементы.Добавить("getCurrentSlideId", Тип("ПолеФормы"), ЭтаФорма);
    Элемент.Вид = ВидПоляФормы.ПолеВвода;
    Элемент.ПутьКДанным = "getCurrentSlideId";
	 
EndProcedure

&AtServer
Procedure IRPTE_CreateBtn(Name)
	//Добавляем новую команду
	Btn = ЭтаФорма.Команды.Добавить(Name);
	Btn.Действие = Name;
	Btn.Заголовок = Name;
	
	//Добавляем новую кнопку
	Itm = ЭтаФорма.Элементы.Добавить(Name, Тип("КнопкаФормы"), ЭтаФорма);
	Itm.Вид = ВидКнопкиФормы.ОбычнаяКнопка;
	Itm.ИмяКоманды = Name;
EndProcedure

&НаКлиенте
Процедура add_picture()
	IRPTE_send_to_1C("{""value"":""add_picture""}");
КонецПроцедуры

&НаКлиенте
Процедура update_slider()
	IRPTE_send_to_1C("{""value"":""update_slider""}");
КонецПроцедуры

&НаКлиенте
Процедура addImagesFromGallery()
	IRPTE_send_to_1C("{""value"":""addImagesFromGallery""}");
КонецПроцедуры

&НаКлиенте
Процедура remove_picture()
	IRPTE_send_to_1C("{""value"":""remove_picture"", ""id"":""" + ThisObject.getCurrentSlideId + """}");
КонецПроцедуры

&НаКлиенте
Procedure IRPTE_send_to_1C(Text)
	HTMLWindowPictures = PictureViewerClient.InfoDocumentComplete(Items.PictureViewHTML);
	HTMLWindowPictures.send_to_1C("call1C", Text);
EndProcedure
 
