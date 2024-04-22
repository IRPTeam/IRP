
&After("OnCreateAtServerListForm")
Procedure Unit_OnCreateAtServerListForm(Form, Cancel, StandardProcessing) Export
	NewColumn = Form.Items.Add("List" + "PaymentStatusUnit", Type("FormField"), Form.Items.List);
	NewColumn.Title = "PaymentStatusUnit";
	NewColumn.DataPath = "List" + "." + "PaymentStatus";
	NewColumn.Visible = True;

EndProcedure

